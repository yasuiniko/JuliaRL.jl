

import ..FeatureCreators: AbstractFeatureCreator, create_features, feature_size
import ..LinearRL: AbstractQFunction, update!, Optimizer, feature_type
import ..AbstractQPolicy
import ..get

using Random

mutable struct LinearQAgent{QT<:AbstractQFunction, FC<:AbstractFeatureCreator, P<:AbstractQPolicy, T<:Number} <: AbstractAgent
    Q::QT
    fc::FC
    π::P
    γ::Float64
    lu::Optimizer
    ϕ_t::Array{T, 1}
    ϕ_tp1::Array{T, 1}
    action::Int64
    LinearQAgent(Q::QT, fc::FC, π::P, γ::Float64, lu::Optimizer) where{T<:Number, QT<:AbstractQFunction, FC<:AbstractFeatureCreator, P<:AbstractQPolicy} =
        new{QT, FC, P, feature_type(Q)}(Q, fc, π, γ, lu, zeros(feature_type(Q), feature_size(fc)), zeros(feature_type(Q), feature_size(fc)), 0)
end

get_action(agent::LinearQAgent, ϕ; rng=Random.GLOBAL_RNG) = get(agent.π, [agent.Q(ϕ, a) for a = agent.π.actions]; rng=rng)

function start!(agent::LinearQAgent, env_s_tp1; rng=Random.GLOBAL_RNG, kwargs...)
    # agent.ϕ_t .= TileCoder.tiles!(
    #     agent.iht,
    #     agent.tilings,
    #     env_s_tp1.*agent.tiles)
    # println(length(create_features(agent.fc, env_s_tp1)), " ", length(agent.ϕ_t))
    # println()
    agent.ϕ_t .= create_features(agent.fc, env_s_tp1)

    agent.action = get_action(agent, agent.ϕ_t; rng=rng)
    # if rand(rng) < agent.ϵ
    #     agent.action = rand(1:3)
    # end
    return agent.action
end

function step!(agent::LinearQAgent, env_s_tp1, r, terminal; rng=Random.GLOBAL_RNG, kwargs...)
    # agent.ϕ_tp1 .= TileCoder.tiles!(
    #     agent.iht,
    #     agent.tilings,
    #     env_s_tp1.*agent.tiles)

    agent.ϕ_tp1 .= create_features(agent.fc, env_s_tp1)
    # println(agent.ϕ_t)

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

    agent.ϕ_t .= agent.ϕ_tp1
    # println(agent.ϕ_t)
    agent.action = get_action(agent, agent.ϕ_t; rng=rng)

    return agent.action

end




# mutable struct TileCoderAgent <: AbstractAgent
#     Q::SparseQFunction
#     opt::Optimizer
#     fc::FeatureCreators.TileCoder
#     # iht::TileCoder.IHT
#     # tilings::Integer
#     # tiles::Integer
#     actions::AbstractArray
#     action::Integer
#     γ::Float64
#     policy::AbstractQPolicy
#     ϕ_t::Array{Int64, 1}
#     ϕ_tp1::Array{Int64, 1}
#     function TileCoderAgent(opt::Optimizer, size_env_state::Integer, num_actions::Integer, tilings::Integer, tiles::Integer, γ::Float64, policy::AbstractQPolicy)

#         num_features_per_action = (tilings*(tiles+1)^size_env_state)
#         num_features = num_features_per_action*num_actions
#         fc = FeatureCreators.TileCoder(tilings, tiles, size_env_state; wrap=false, wrapwidths=0.0)
#         Q = SparseQFunction(
#             num_features,
#             num_features_per_action,
#             num_actions)
#         # opt = WatkinsQ(α)
#         actions = 1:3
#         return new(Q, opt, fc, actions, -1, γ, policy, zeros(Int64, tilings), zeros(Int64, tilings))
#     end
# end

# get_action(agent::TileCoderAgent, ϕ; rng=Random.GLOBAL_RNG) = get_action(agent.policy, [agent.Q(ϕ, a) for a = agent.actions]; rng=rng)

# function start!(agent::TileCoderAgent, env_s_tp1; rng=Random.GLOBAL_RNG, kwargs...)
#     # agent.ϕ_t .= TileCoder.tiles!(
#     #     agent.iht,
#     #     agent.tilings,
#     #     env_s_tp1.*agent.tiles)
#     agent.ϕ_t .= FeatureCreators.create_features(agent.fc, env_s_tp1)

#     agent.action = get_action(agent, agent.ϕ_t; rng=rng)
#     # if rand(rng) < agent.ϵ
#     #     agent.action = rand(1:3)
#     # end
#     return agent.action
# end

# function step!(agent::TileCoderAgent, env_s_tp1, r, terminal; rng=Random.GLOBAL_RNG, kwargs...)
#     # agent.ϕ_tp1 .= TileCoder.tiles!(
#     #     agent.iht,
#     #     agent.tilings,
#     #     env_s_tp1.*agent.tiles)

#     agent.ϕ_tp1 .= FeatureCreators.create_features(agent.fc, env_s_tp1)
#     # println(agent.ϕ_t)

#     LinearRL.update!(
#         agent.Q,
#         agent.opt,
#         agent.ϕ_t,
#         agent.ϕ_tp1,
#         r,
#         agent.γ,
#         1.0,
#         terminal,
#         agent.action)

#     agent.ϕ_t .= agent.ϕ_tp1
#     # println(agent.ϕ_t)
#     agent.action = get_action(agent, agent.ϕ_t; rng=rng)
#     # println(agent.ϕ_t)
#     # println([agent.Q(agent.ϕ_t, a) for a = agent.actions])
#     # println(agent.Q)
#     # if rand() < agent.ϵ
#     #     agent.action = rand(rng, 1:3)
#     # end

#     return agent.action

# end



