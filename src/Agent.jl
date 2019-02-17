

abstract type AbstractAgent end

function get_action(agent::AbstractAgent, state)
    throw("Implement get Action for agent")
end


