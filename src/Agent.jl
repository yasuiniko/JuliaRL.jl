module Agent

export AbstractAgent, start!, step!, get_action

abstract type AbstractAgent end

function start!(agent::AbstractAgent, env_s_tp1; rng=Random.GLOBAL_RNG, kwargs...)
    throw("Implement start! function for agent $(typeof(agent))")
end

function step!(agent::AbstractAgent, env_s_tp1, r, terminal; rng=Random.GLOBAL_RNG, kwargs...)
    throw("Implement step! function for agent $(typeof(agent))")
end

function get_action(agent::AbstractAgent, state)
    throw("Implement get Action for agent")
end

export LinearQAgent
include("agents/LinearQLearning.jl")
# abstract type AbstractAgent end

# function get_probability(agent::AbstractAgent, state, action)
#     throw("Implement get Action for agent")
# end

end




