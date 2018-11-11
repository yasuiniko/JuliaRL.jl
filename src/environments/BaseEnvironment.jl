module BaseEnvironment


mutable struct State
end

function start(;rng = Random.GLOBAL_RNG)
end

function step!(agent_state::State, action; kwargs...) # -> agent_state, reward, terminal
end

function step(state::State, action; kwargs...)
end

function get_reward(state) # -> determines if the agent_state is terminal
end

function is_terminal(state) # -> determines if the agent_state is terminal
end


end
