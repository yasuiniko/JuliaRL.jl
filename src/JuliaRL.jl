module JuliaRL

greet() = print("Hello Reinforcement Learning Julia!")

export FeatureCreators
include("FeatureCreators.jl")

export LinearRL, TabularRL
include("LinearRL.jl")
include("TabularRL.jl")


export ExperienceReplay, WeightedExperienceReplay, size, getindex, add!

include("Replay.jl")


export AbstractEnvironment, start, start!, step!, step, get_reward, get_state, is_terminal, get_actions, render

abstract type AbstractEnvironment end

function start(env::AbstractEnvironment; rng=Random.GLOBAL_RNG, kwargs...)
    new_env = copy(env)
    return start!(new_env; rng=rng, kwargs...)
end

function start!(env::AbstractEnvironment; rng=Random.GLOBAL_RNG, kwargs...)
    reset!(env; rng=rng, kwargs...)
    return env, get_state(env)
end

function step(env::AbstractEnvironment, action; rng = Random.GLOBAL_RNG, kwargs...)
    new_env = copy(env)
    return step!(new_env, action; kwargs...)
end

function step!(env::AbstractEnvironment, action; rng = Random.GLOBAL_RNG, kwargs...) # -> env, state, reward, terminal
    environment_step!(env, action; rng=rng, kwargs...)
    return env, get_state(env), get_reward(env), is_terminal(env)
end

function reset!(env::AbstractEnvironment; rng = Random.GLOBAL_RNG, kwargs...)
    throw("Implement reset! for environment $(typeof(env))")
end

function environment_step!(env::AbstractEnvironment, action; rng=Random.GLOBAL_RNG, kwargs...)
    throw("Implement environment_step for environment $(typeof(env))")
end

function get_reward(env::AbstractEnvironment) # -> determines if the agent_state is terminal
    throw("Implement get_reward for environment $(typeof(env))")
end

function is_terminal(env::AbstractEnvironment) # -> determines if the agent_state is terminal
    throw("Implement is_terminal for environment $(typeof(env))")
end

function get_state(env::AbstractEnvironment) # -> determines if the agent_state is terminal
    throw("Implement normalized_state for environment $(typeof(env))")
end

function get_actions(env::AbstractEnvironment)
    return Set()
end

function Base.show(io::IO, env::AbstractEnvironment)
  println("Implement Base.show for environment $(typeof(env))")
end

function render(env::AbstractEnvironment, args...; kwargs...)
    println("Render not implemented for environment $(typeof(env))")
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
