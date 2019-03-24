# using Flux
using Pkg

Pkg.activate(".")


using JuliaRL

# using JuliaRL.LinearRL
# using JuliaRL.Environments
using Random
using ProgressMeter

# import JuliaRL.step!, JuliaRL.start!

# TileCoder = JuliaRL.FeatureCreators.TileCoder

function test_run(α=0.5/8, ϵ=0.1, γ=1.0, tilings=32, tiles=2; n_episodes=1000, seed=1002349)

    ϵ = 0.1
    α = 0.5/tilings
    size_env_state = 2
    num_actions = 3

    opt = LinearRL.WatkinsQ(α)
    fc = FeatureCreators.TileCoder(tilings, tiles, size_env_state; wrap=false, wrapwidths=0.0)
    num_features_per_action = (tilings*(tiles+1)^size_env_state)
    num_features = num_features_per_action*num_actions
    Q = LinearRL.SparseQFunction(
        num_features,
        num_features_per_action,
        num_actions)
    agent = Agent.LinearQAgent(Q, fc, EpsilonGreedyQPolicy(ϵ, 1:3), γ, opt)

    rng = Random.MersenneTwister(seed)

    env = MountainCar(rng)
    cumulative_reward_array = zeros(Int64, n_episodes)
    @showprogress 0.1 "Episode: " for episode = 1:n_episodes
    # for episode = 1:n_episodes

        terminal = false
        num_steps = 0
        cumulative_reward = 0
        _, state = start!(env; rng=rng)
        action = Agent.start!(agent, state)
        while !terminal

            _, state_prime, reward, terminal = step!(env, action-1)

            action = Agent.step!(agent, state_prime, reward, terminal)

            num_steps += 1
            cumulative_reward += reward

        end
        cumulative_reward_array[episode] = cumulative_reward
    end
    return cumulative_reward_array
end
