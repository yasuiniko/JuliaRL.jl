module JuliaRL

greet() = print("Hello Reinforcement Learning Julia!")

export FeatureCreators
include("FeatureCreators.jl")

export LinearRL, TabularRL
include("LinearRL.jl")
include("TabularRL.jl")

export AbstractEnvironment, start, step!, step, get_reward, is_terminal, Environments, normalized_state

abstract type AbstractEnvironment end

function start(env::AbstractEnvironment; rng = Random.GLOBAL_RNG)
    throw("Implement Start")
end

function step!(env::AbstractEnvironment, action; kwargs...) # -> agent_state, reward, terminal
    throw("Implement Step!")
end

function step(env::AbstractEnvironment, action; kwargs...)
    throw("Implement Step")
end

function get_reward(env::AbstractEnvironment) # -> determines if the agent_state is terminal
    throw("Implement get_reward")
end

function is_terminal(env::AbstractEnvironment) # -> determines if the agent_state is terminal
    throw("Implement is_terminal")
end

function normalized_state(env::AbstractEnvironment) # -> determines if the agent_state is terminal
    throw("Implement normalized_state")
end

include("Environments.jl")

abstract type AbstractPolicy end



abstract type AbstractAgent end



# include("Replay.jl")

end # module
