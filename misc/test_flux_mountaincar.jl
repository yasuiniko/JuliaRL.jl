using Flux
using Flux.Tracker
using Flux: @epochs

using JuliaRL

import JuliaRL.start!, JuliaRL.step!

TileCoder = JuliaRL.FeatureCreators.TileCoder
# using JuliaRL.Environments
using Random
using LinearAlgebra
using ProgressMeter

function test_flux()

    W = param(rand(2, 5))
    b = param(rand(2))

    predict(x) = W*x .+ b
    loss(x, y) = Flux.mse(predict(x), y)

    W_opt = rand(2,5)
    b_opt = rand(2)

    get_opt(x) = W_opt*x .+ b_opt .+ 0.001*randn(length(size(x)) == 1 ? 2 : (2, size(x)[2]))

    X = [rand(5) for i = 1:1000]
    Y = [get_opt(X[i]) for i = 1:1000]
    data = zip(X, Y)

    train_X = rand(5, 100)
    train_Y = get_opt(train_X)

    evalcb() = @show(loss(train_X, train_Y))

    @epochs 10 Flux.train!(loss, data, ADAM([W, b], 0.001), cb = Flux.throttle(evalcb, 5))

end



function mountain_car_test_flux(α=0.5/8, ϵ=0.1, tilings=32, tiles=2)

    ## Inefficient version of tilecoded q-learning

    ϵ = 0.1
    α = 0.5/tilings

    feat_size = (tilings*(tiles+1)^2)*3
    weights = param(zeros((tilings*(tiles+1)^2)*3))
    iht = TileCoder.IHT(tilings*(tiles+1)^2)

    Q(ϕ) = weights'*ϕ
    function make_feats(t, action)
        feats = zeros(feat_size)
        feats[t .+ ((tilings*(tiles+1)^2)*action + 1)] .= 1
        return feats
    end

    watkins_q_target(t, r) = r + maximum([Q(make_feats(t, a)) for a = 0:2])
    get_action(t) = findmax([Q(make_feats(t, a)) for a = 0:2])[2] - 1
    loss(ϕ, y) = Flux.mse(Q(ϕ), y)

    optimizer = Descent(α)
    env = MountainCar(Random.GLOBAL_RNG)
    # env_ns = MountainCar
    cumulative_reward_array = zeros(Int64, 1000)
    @showprogress 0.1 "Episode: " for episode = 1:1000
        terminal = false
        num_steps = 0
        cumulative_reward = 0
        start!(env)
        action = 0

        t = TileCoder.tiles!(iht, 8, normalized_state(env).*4)
        # println(weights)
        while !terminal

            action = get_action(t)
            # println(action)
            ϕ = make_feats(t, action)
            # println([Q(make_feats(t, a)).data for a = 0:2])
            if rand() < ϵ
                action = rand(0:2)
            end

            state, reward, terminal = step!(env, action)
            t_prime = TileCoder.tiles!(iht, tilings, normalized_state(env).*tiles)
            target = watkins_q_target(t_prime, reward).data

            Flux.train!(loss, [weights], [(ϕ, target)], optimizer)

            num_steps += 1
            cumulative_reward += reward

            t = copy(t_prime)
        end
        cumulative_reward_array[episode] = cumulative_reward
        # println("Episode: $episode, Steps: $num_steps, Reward: $cumulative_reward")
    end
    return cumulative_reward_array
end
