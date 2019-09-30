
import ..FeatureCreators
import ..Learning

import ..FeatureCreators: AbstractFeatureCreator, create_features, feature_size
import ..Learning.LinearRL: AbstractQFunction, update!, Optimizer, LearningUpdate, feature_type, TransitionModel, RewardModel, AbstractVFunction, update_priority!
import ..AbstractQPolicy
import ..get

using Random
using LinearAlgebra
using DataStructures

""" Implements Dyna with Prioritized Sweeping McMahan Gordon 2005
"""
mutable struct LinearDynaAgent{VT<:AbstractVFunction, TM<:Vector{TransitionModel}, RM<:Vector{RewardModel}, SC<:Learning.AbstractSearchControl, FC<:AbstractFeatureCreator, P<:AbstractQPolicy, T<:Number} <: AbstractAgent
    V::VT
    F::TM
    b::RM
    pq::SC
    fc::FC
    π::P
    γ::Float64
    lu::LearningUpdate
    ϕ_t::Vector{T}
    ϕ_tp1::Vector{T}
    action::Int64
    p::Integer
    LinearDynaAgent(V::VT, F::TM, b::RM, pq::SC, fc::FC, π::P, γ::Float64, lu::LearningUpdate, p::Integer=5) where{T<:Number, VT<:AbstractVFunction, TM<:Vector{TransitionModel}, RM<:Vector{RewardModel}, SC<:Learning.AbstractSearchControl, FC<:AbstractFeatureCreator, P<:AbstractQPolicy} =
        new{VT, TM, RM, SC, FC, P, feature_type(V)}(V, F, b, pq, fc, π, γ, lu, zeros(feature_type(V), fc.num_active_features), zeros(feature_type(V), fc.num_active_features), 0, p)
end

function get_action(agent::LinearDynaAgent, ϕ; rng=Random.GLOBAL_RNG)
    values = zeros(length(agent.π.actions))
    @inbounds @simd for a in agent.π.actions
        values[a] = agent.b(ϕ, a) + agent.γ * dot(agent.V.weights, agent.F(ϕ, a))
    end

    get(agent.π, values; rng=rng)
end

function start!(agent::LinearDynaAgent, env_s_tp1; rng=Random.GLOBAL_RNG, kwargs...)
    agent.ϕ_t .= create_features(agent.fc, env_s_tp1)
    agent.action = get_action(agent, agent.ϕ_t; rng=rng)

    return agent.action
end

function step!(agent::LinearDynaAgent, env_s_tp1, r, terminal; rng=Random.GLOBAL_RNG, kwargs...)

    agent.ϕ_tp1 .= create_features(agent.fc, env_s_tp1)
    a = agent.action = get_action(agent, agent.ϕ_t; rng=rng)

    δ = update!(agent.V,
                agent.lu,
                agent.ϕ_t,
                agent.ϕ_tp1,
                r,
                agent.γ,
                1.0,
                terminal)
    update!(agent.F[a], agent.ϕ_t, agent.ϕ_tp1)
    update!(agent.b[a], r, agent.ϕ_t)

    # TODO: make search control more general
    update!(agent.pq, δ, agent.ϕ_t)
    plan!(agent)

    agent.ϕ_t .= agent.ϕ_tp1
    return agent.action
end

planhelp(agent, j, a) = (agent.b[a].w[j]
                         + agent.γ * dot(agent.V.weights,
                                         view(agent.F[a].w, :, j)))


function plan!(agent::LinearDynaAgent)
    # do up to agent.p * num_features iterations of planning
    for _ in 1:agent.p

        # make sure queue has i
        if !isempty(agent.pq.queue)
            i = dequeue!(agent.pq.queue)

            # loop through j that lead to i
            @inbounds for j in 1:feature_size(agent.fc)
                if any([agent.F[a].w[i, j] != 0 for a in agent.π.actions])

                    δ = (maximum(map(a->planhelp(agent, j, a), agent.π.actions))
                         - agent.V.weights[j])

                    agent.V.weights[j] += agent.lu.α * δ
                    update_priority!(agent.pq.queue, j, abs(δ))
                end
            end
        end
    end
end


function TileCoderDynaAgent(opt::LearningUpdate,
                            num_actions::Integer,
                            tiles_per_dim::Vector{<:Integer},
                            bounds_per_dim::Matrix{<:Real},
                            num_tilings::Integer,
                            γ::Float64,
                            policy::AbstractQPolicy,
                            num_planning_steps::Integer)

    fc = FeatureCreators.HashlessTileCoder(tiles_per_dim,
                                           bounds_per_dim,
                                           num_tilings)
    num_features_per_action = fc.num_features
    V = Learning.LinearRL.SparseVFunction(num_features_per_action)
    F = [Learning.LinearRL.TransitionModel(zeros(Float64,
                                                 num_features_per_action,
                                                 num_features_per_action),
                                           opt.α)
         for _ in 1:num_actions]
    b = [Learning.LinearRL.RewardModel(zeros(Float64, num_features_per_action),
                                       opt.α)
         for _ in 1:num_actions]
    pq = Learning.LinearRL.PrioritizedSweeping()

    return Agent.LinearDynaAgent(V, F, b, pq, fc, policy, γ, opt, num_planning_steps)
end
