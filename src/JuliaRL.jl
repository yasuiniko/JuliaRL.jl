module JuliaRL

greet() = print("Hello Reinforcement Learning Julia!")

export FeatureCreators

include("FeatureCreators.jl")

export LinearRL, TabularRL
include("LinearRL.jl")
include("TabularRL.jl")

export AbstractEnvironment, start, step!, step, get_reward, is_terminal, Environments, normalized_state

abstract type AbstractEnvironment end

function start(env::AbstractEnvironment; rng=Random.GLOBAL_RNG, kwargs...)
    throw("Implement Start for environment $(typeof(env))")
end

function start!(env::AbstractEnvironment; rng=Random.GLOBAL_RNG, kwargs...)
    throw("Implement Start for environment $(typeof(env))")
end

function step!(env::AbstractEnvironment, action; rng = Random.GLOBAL_RNG, kwargs...) # -> agent_state, reward, terminal
    throw("Implement Step! for environment $(typeof(env))")
end

function step(env::AbstractEnvironment, action; rng = Random.GLOBAL_RNG, kwargs...)
    throw("Implement Step for environment $(typeof(env))")
end

function get_reward(env::AbstractEnvironment) # -> determines if the agent_state is terminal
    throw("Implement get_reward for environment $(typeof(env))")
end

function is_terminal(env::AbstractEnvironment) # -> determines if the agent_state is terminal
    throw("Implement is_terminal for environment $(typeof(env))")
end

function normalized_state(env::AbstractEnvironment) # -> determines if the agent_state is terminal
    throw("Implement normalized_state for environment $(typeof(env))")
end

include("Environments.jl")

export AbstractState

abstract type AbstractState end

export AbstractPolicy

abstract type AbstractPolicy end


export AbstractAgent

abstract type AbstractAgent end

function start!(agent::AbstractAgent, env_s_tp1; rng=Random.GLOBAL_RNG, kwargs...)
    throw("Implement start! function for agent $(typeof(agent))")
end

function step!(agent::AbstractAgent, env_s_tp1, r, terminal; rng=Random.GLOBAL_RNG, kwargs...)
    throw("Implement step! function for agent $(typeof(agent))")
end


# include("Replay.jl")

end # module
