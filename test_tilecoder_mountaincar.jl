# using Flux
using Pkg

Pkg.activate(".")


using JuliaRL
using JuliaRL.LinearRL
# using JuliaRL.Environments
using Random
using ProgressMeter

import JuliaRL.step!, JuliaRL.start!

# TileCoder = JuliaRL.FeatureCreators.TileCoder

abstract type AbstractQPolicy <: AbstractPolicy end

mutable struct EpsilonGreedyQPolicy <: AbstractQPolicy
    ϵ::Float64
    actions::AbstractArray
end

function get_action(policy::AbstractQPolicy, values::AbstractArray; rng=Random.GLOBAL_RNG)
    action = findmax(values)[2]
    if rand(rng) < policy.ϵ
        action = rand(rng, policy.actions)
    end
    return action
end

mutable struct TileCoderAgent <: AbstractAgent
    Q::SparseQFunction
    opt::Optimizer
    fc::FeatureCreators.TileCoder
    # iht::TileCoder.IHT
    # tilings::Integer
    # tiles::Integer
    actions::AbstractArray
    action::Integer
    γ::Float64
    policy::AbstractQPolicy
    ϕ_t::Array{Int64, 1}
    ϕ_tp1::Array{Int64, 1}
    function TileCoderAgent(opt::Optimizer, size_env_state::Integer, num_actions::Integer, tilings::Integer, tiles::Integer, γ::Float64, policy::AbstractQPolicy)

        num_features_per_action = (tilings*(tiles+1)^size_env_state)
        num_features = num_features_per_action*num_actions
        fc = FeatureCreators.TileCoder(tilings, tiles, size_env_state; wrap=false, wrapwidths=0.0)
        Q = SparseQFunction(
            num_features,
            num_features_per_action,
            num_actions)
        # opt = WatkinsQ(α)
        actions = 1:3
        return new(Q, opt, fc, actions, -1, γ, policy, zeros(Int64, tilings), zeros(Int64, tilings))
    end
end

get_action(agent::TileCoderAgent, ϕ; rng=Random.GLOBAL_RNG) = get_action(agent.policy, [agent.Q(ϕ, a) for a = agent.actions]; rng=rng)

function start!(agent::TileCoderAgent, env_s_tp1; rng=Random.GLOBAL_RNG, kwargs...)
    # agent.ϕ_t .= TileCoder.tiles!(
    #     agent.iht,
    #     agent.tilings,
    #     env_s_tp1.*agent.tiles)
    agent.ϕ_t .= FeatureCreators.create_features(agent.fc, env_s_tp1)

    agent.action = get_action(agent, agent.ϕ_t; rng=rng)
    # if rand(rng) < agent.ϵ
    #     agent.action = rand(1:3)
    # end
    return agent.action
end

function step!(agent::TileCoderAgent, env_s_tp1, r, terminal; rng=Random.GLOBAL_RNG, kwargs...)
    # agent.ϕ_tp1 .= TileCoder.tiles!(
    #     agent.iht,
    #     agent.tilings,
    #     env_s_tp1.*agent.tiles)

    agent.ϕ_tp1 .= FeatureCreators.create_features(agent.fc, env_s_tp1)
    # println(agent.ϕ_t)

    LinearRL.update!(
        agent.Q,
        agent.opt,
        agent.ϕ_t,
        agent.ϕ_tp1,
        r,
        agent.γ,
        1.0,
        terminal,
        agent.action)

    agent.ϕ_t .= agent.ϕ_tp1
    # println(agent.ϕ_t)
    agent.action = get_action(agent, agent.ϕ_t; rng=rng)
    # println(agent.ϕ_t)
    # println([agent.Q(agent.ϕ_t, a) for a = agent.actions])
    # println(agent.Q)
    # if rand() < agent.ϵ
    #     agent.action = rand(rng, 1:3)
    # end

    return agent.action

end


function run(α=0.5/8, ϵ=0.1, γ=1.0, tilings=32, tiles=2; n_episodes=1000, seed=1002349)

    ϵ = 0.1
    α = 0.5/tilings
    # weights = zeros((tilings*(tiles+1)^2)*3)
    # ag = TileCoderAgent(SparseQFunction((tilings*(tiles+1)^2)*3, ((tilings*(tiles+1)^2)), 3),
    #                     TileCoder.IHT(tilings*(tiles+1)^2),
    #                     1:3)
    opt = WatkinsQ(α)
    agent = TileCoderAgent(opt, 2, 3, tilings, tiles, γ, EpsilonGreedyQPolicy(ϵ, 1:3))

    rng = Random.MersenneTwister(seed)

    env = MountainCar(rng)
    cumulative_reward_array = zeros(Int64, n_episodes)
    # @showprogress 0.1 "Episode: " for episode = 1:n_episodes
    for episode = 1:n_episodes
        # println(episode)
        terminal = false
        num_steps = 0
        cumulative_reward = 0
        _, state = start!(env; rng=rng)
        # env = MountainCar(rng)
        # state = normalized_state(env)
        action = start!(agent, state)
        while !terminal

            _, state_prime, reward, terminal = step!(env, action-1)

            # state_prime = normalized_state(env)

            action = step!(agent, state_prime, reward, terminal)
            # println(action)

            num_steps += 1
            cumulative_reward += reward

        end
        cumulative_reward_array[episode] = cumulative_reward
        # println("Episode: $episode, Steps: $num_steps, Reward: $cumulative_reward")
    end
    return cumulative_reward_array
end
