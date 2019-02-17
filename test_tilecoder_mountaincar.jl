# using Flux
using Pkg

Pkg.activate(".")


using JuliaRL
using JuliaRL.LinearRL
using JuliaRL.Environments
using Random
using ProgressMeter

TileCoder = JuliaRL.FeatureCreators.TileCoder


# mutable struct Q_sparse
#     weights::Array{Float64}
#     actions::AbstractArray
#     features_per_action::Integer
# end

# (q::Q_sparse)(ϕ, action) = sum(q.weights[ϕ .+ (q.features_per_action*(action-1) + 1)])
# (q::Q_sparse)(ϕ) = [q(ϕ,action) for action in q.actions]

mutable struct TileCoderAgent
    Q::SparseQFunction
    iht::TileCoder.IHT
    actions::AbstractArray
end

get_action(agent::TileCoderAgent, ϕ) = findmax([agent.Q(ϕ, a) for a = agent.actions])[2]
# watkins_q_target(q::Q_sparse, ϕ, r) = r + maximum([q(ϕ, a) for a = q.actions])

# function step!(agent::TileCoderAgent, state, r)
#     ϕ
# end


function mountain_car_test(α=0.5/8, ϵ=0.1, γ=1.0, tilings=32, tiles=2; n_episodes=1000, seed=1002349)

    ϵ = 0.1
    α = 0.5/tilings
    # weights = zeros((tilings*(tiles+1)^2)*3)
    ag = TileCoderAgent(SparseQFunction((tilings*(tiles+1)^2)*3, ((tilings*(tiles+1)^2)), 3),
                        TileCoder.IHT(tilings*(tiles+1)^2),
                        1:3)

    opt = WatkinsQ(α)

    rng = Random.MersenneTwister(seed)

    env = MountainCar(rng)
    cumulative_reward_array = zeros(Int64, n_episodes)
    # @showprogress 0.1 "Episode: " for episode = 1:n_episodes
    for episode = 1:n_episodes
        terminal = false
        num_steps = 0
        cumulative_reward = 0
        start(env; rng=rng)
        env = MountainCar(rng)
        state = normalized_state(env)
        ϕ = TileCoder.tiles!(ag.iht, tilings, state.*tiles)

        while !terminal

            action = get_action(ag, ϕ)
            # println(action)
            # println(ag.Q)
            if rand() < ϵ
                action = rand(1:3)
            end

            env, reward, terminal = step!(env, action-1)

            ϕ_prime = TileCoder.tiles!(ag.iht, tilings, normalized_state(env).*tiles)
            state_prime = normalized_state(env)
            # target = watkins_q_target(ag.Q, ϕ_prime, reward)
            # ag.Q.weights[ϕ .+ ((tilings*(tiles+1)^2)*(action-1) + 1)] .+= α*(target - ag.Q(ϕ, action))
            # println("Update before")
            LinearRL.update!(ag.Q, opt, ϕ, ϕ_prime, reward, γ, 1, terminal, action)
            # println("Update after")
            num_steps += 1
            cumulative_reward += reward
            ϕ = copy(ϕ_prime)
            state = copy(state_prime)
        end
        cumulative_reward_array[episode] = cumulative_reward
        # println("Episode: $episode, Steps: $num_steps, Reward: $cumulative_reward")
    end
    return cumulative_reward_array
end
