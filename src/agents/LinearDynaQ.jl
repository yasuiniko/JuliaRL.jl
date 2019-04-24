
import ..FeatureCreators
import ..Learning

import ..FeatureCreators: AbstractFeatureCreator, create_features, feature_size
import ..Learning.LinearRL: AbstractQFunction, update!, Optimizer, LearningUpdate, feature_type
import ..AbstractQPolicy
import ..get

using Random
using LinearAlgebra

mutable struct LinearDynaQAgent{QT<:AbstractQFunction, TM<:Array{AbstractModel}, RM<:Array{AbstractModel}, FC<:AbstractFeatureCreator, P<:AbstractQPolicy, T<:Number} <: AbstractAgent
    Q::QT
    F::TM
    b::RM
    fc::FC
    π::P
    γ::Float64
    lu::LearningUpdate
    ϕ_t::Array{T, 1}
    ϕ_tp1::Array{T, 1}
    action::Int64
    LinearDynaQAgent(Q::QT, F::TM, b::RM, fc::FC, π::P, γ::Float64, lu::LearningUpdate) where{T<:Number, QT<:AbstractQFunction, TM<:Array{AbstractModel}, RM<:Array{AbstractModel}, FC<:AbstractFeatureCreator, P<:AbstractQPolicy} =
        new{QT, TM, RM, FC, P, feature_type(Q)}(Q, F, b, fc, π, γ, lu, zeros(feature_type(Q), feature_size(fc)), zeros(feature_type(Q), feature_size(fc)), 0)
end

get_action(agent::LinearDynaQAgent, ϕ; rng=Random.GLOBAL_RNG) = get(agent.π, [dot(agent.b[a], ϕ) + agent.γ .* dot(agent.Q.weights, agent.F[a] * ϕ) for a in agent.π.actions]; rng=rng)

function start!(agent::LinearDynaQAgent, env_s_tp1; rng=Random.GLOBAL_RNG, kwargs...)

    agent.ϕ_t .= create_features(agent.fc, env_s_tp1)
    agent.action = get_action(agent, agent.ϕ_t; rng=rng)

    return agent.action
end

function step!(agent::LinearDynaQAgent, env_s_tp1, r, terminal; rng=Random.GLOBAL_RNG, kwargs...)

    agent.ϕ_tp1 .= create_features(agent.fc, env_s_tp1)
    a = agent.action = get_action(agent, agent.ϕ_t; rng=rng)

    update!(
        agent.Q,
        agent.lu,
        agent.ϕ_t,
        agent.ϕ_tp1,
        r,
        agent.γ,
        1.0,
        terminal,
        agent.action)
    update!(agent.F[a], x_t, x_tp1)
    update!(agent.b[a], r, x_t)

    # planning Update with Prioritized sweeping

    agent.ϕ_t .= agent.ϕ_tp1
    return agent.action
end


function TileCoderAgent(opt::LearningUpdate,
                        size_env_state::Integer,
                        num_actions::Integer,
                        tilings::Integer,
                        tiles::Integer,
                        γ::Float64,
                        policy::AbstractQPolicy)

    fc = FeatureCreators.TileCoder(tilings, tiles, size_env_state; wrap=false, wrapwidths=0.0)
    num_features_per_action = (tilings*(tiles+1)^size_env_state)
    num_features = num_features_per_action*num_actions
    Q = Learning.LinearRL.ActionSparseQFunction(
        num_features_per_action,
        num_actions)
    return Agent.LinearQAgent(Q, fc, policy, γ, opt)
end
