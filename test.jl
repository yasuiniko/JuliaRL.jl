using Flux

using JuliaRL
using JuliaRL.Environments
using Random

function mountain_car_test()

    ϵ = 0.1
    α = 0.5/8
    weights = zeros(256*3)
    iht = TileCoder.IHT(128)

    Q(ϕ, action) = sum(weights[ϕ .+ (128*action + 1)])
    # loss(ϕ, target) = (target - Q(ϕ)).^2
    watkins_q_target(ϕ, r) = r + maximum([Q(ϕ, a) for a = 0:2])
    get_action(ϕ) = findmax([Q(ϕ, a) for a = 0:2])[2]

    env_ns = MountainCar

    for episode = 1:500
        terminal = false
        num_steps = 0
        cumulative_reward = 0
        state = env_ns.start()
        ϕ = TileCoder.tiles!(iht, 8, env_ns.normalized_features(state).*4)
        while !terminal
            # println(weights[ϕ .+ (128*0 + 1)])
            action = get_action(ϕ)

            if rand() < ϵ
                action = rand(0:2)
            end
            # println(action)
            state, reward, terminal = env_ns.step!(state, action)
            ϕ_prime = TileCoder.tiles!(iht, 8, env_ns.normalized_features(state).*4)
            target = watkins_q_target(ϕ_prime, reward)
            # println(target - predict(ϕ, action))
            weights[ϕ .+ (128*action + 1)] .+= α*(target - Q(ϕ, action))
            # println(env_ns.normalized_features(state))
            num_steps += 1
            cumulative_reward += reward
            ϕ = copy(ϕ_prime)
        end
        println("Episode: $episode, Steps: $num_steps, Reward: $cumulative_reward")
    end

end
