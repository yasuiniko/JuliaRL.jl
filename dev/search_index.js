var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#JuliaRL.jl-Documentation-1",
    "page": "Home",
    "title": "JuliaRL.jl Documentation",
    "category": "section",
    "text": ""
},

{
    "location": "index.html#Environments-1",
    "page": "Home",
    "title": "Environments",
    "category": "section",
    "text": ""
},

{
    "location": "docs/environments.html#JuliaRL.AbstractEnvironment",
    "page": "Environments",
    "title": "JuliaRL.AbstractEnvironment",
    "category": "type",
    "text": "Represents an abstract environment for reinforcement learning agents. Has several functions that need to be implemented to work\n\n\n\n\n\n"
},

{
    "location": "docs/environments.html#JuliaRL.start!-Tuple{AbstractEnvironment}",
    "page": "Environments",
    "title": "JuliaRL.start!",
    "category": "method",
    "text": "start!(env::AbstractEnvironment; rng::AbstractRNG, kwargs...)\n\nFunction to start the passed environment env.\n\n\n\n\n\n"
},

{
    "location": "docs/environments.html#JuliaRL.start-Tuple{AbstractEnvironment}",
    "page": "Environments",
    "title": "JuliaRL.start",
    "category": "method",
    "text": "start(env::AbstractEnvironment; rng::AbstractRNG, kwargs...)\n\nFunction to retrieve a started environment struct without effecting the current environment struct. Returns an environment of the same type.\n\n\n\n\n\n"
},

{
    "location": "docs/environments.html#JuliaRL.step!-Tuple{AbstractEnvironment,Any}",
    "page": "Environments",
    "title": "JuliaRL.step!",
    "category": "method",
    "text": "step!(env::AbstractEnvironment, action; rng::AbstractRNG, kwargs...)\n\nUpdate the state of the passed environment env based on the underlying dynamics and the action. \n\n\n\n\n\n"
},

{
    "location": "docs/environments.html#JuliaRL.step-Tuple{AbstractEnvironment,Any}",
    "page": "Environments",
    "title": "JuliaRL.step",
    "category": "method",
    "text": "step!(env::AbstractEnvironment, action; rng::AbstractRNG, kwargs...)\n\nUpdate the state of the environment based on the underlying dynamics and the action.\n\n\n\n\n\n"
},

{
    "location": "docs/environments.html#JuliaRL.reset!-Tuple{AbstractEnvironment}",
    "page": "Environments",
    "title": "JuliaRL.reset!",
    "category": "method",
    "text": "reset!(env::AbstractEnvironment; rng::AbstractRNG, kwargs...)\n\nReset the environment to initial conditions based on the random number generator.\n\n\n\n\n\n"
},

{
    "location": "docs/environments.html#JuliaRL.environment_step!-Tuple{AbstractEnvironment,Any}",
    "page": "Environments",
    "title": "JuliaRL.environment_step!",
    "category": "method",
    "text": "environment_step!(env::AbstractEnvironment, action; rng::AbstractRNG, kwargs...)\n\nUpdate the state of the environment based on the underlying dynamics and the action. This is not used directly, but through the step function.\n\n\n\n\n\n"
},

{
    "location": "docs/environments.html#JuliaRL.get_reward-Tuple{AbstractEnvironment}",
    "page": "Environments",
    "title": "JuliaRL.get_reward",
    "category": "method",
    "text": "get_reward(env::AbstractEnvironment)\n\nRetrieve reward for the current state of the environment.\n\n\n\n\n\n"
},

{
    "location": "docs/environments.html#JuliaRL.is_terminal-Tuple{AbstractEnvironment}",
    "page": "Environments",
    "title": "JuliaRL.is_terminal",
    "category": "method",
    "text": "is_terminal(env::AbstractEnvironment)\n\nCheck if the environment is in a terminal state\n\n\n\n\n\n"
},

{
    "location": "docs/environments.html#JuliaRL.get_state-Tuple{AbstractEnvironment}",
    "page": "Environments",
    "title": "JuliaRL.get_state",
    "category": "method",
    "text": "get_state(env::AbstractEnvironment)\n\nRetrieve the current state of the environment\n\n\n\n\n\n"
},

{
    "location": "docs/environments.html#JuliaRL.get_actions-Tuple{AbstractEnvironment}",
    "page": "Environments",
    "title": "JuliaRL.get_actions",
    "category": "method",
    "text": "get_actions(env::AbstractEnvironment)\n\nReturns the set of actions available to take.\n\n\n\n\n\n"
},

{
    "location": "docs/environments.html#",
    "page": "Environments",
    "title": "Environments",
    "category": "page",
    "text": "CurrentModule = JuliaRLAbstractEnvironment\nstart!(env::AbstractEnvironment; rng::AbstractRNG, kwargs...)\nstart(env::AbstractEnvironment; rng::AbstractRNG, kwargs...)\nstep!(env::AbstractEnvironment, action; rng::AbstractRNG, kwargs...)\nstep(env::AbstractEnvironment, action; rng::AbstractRNG, kwargs...)The above functions take advantage of the following interface.JuliaRL.reset!(env::AbstractEnvironment; rng::AbstractRNG, kwargs...)\nJuliaRL.environment_step!(env::AbstractEnvironment, action; rng::AbstractRNG, kwargs...)\nJuliaRL.get_reward(env::AbstractEnvironment)\nJuliaRL.is_terminal(env::AbstractEnvironment)\nJuliaRL.get_state(env::AbstractEnvironment)\nJuliaRL.get_actions(env::AbstractEnvironment)To dig into the dynamics of the environment while running, we can also implement two interfaces for visualization.JuliaRL.Base.show(io::IO, env::AbstractEnvironment)\nJuliaRL.render(env::AbstractEnvironment, args...; kwargs...)"
},

{
    "location": "docs/agents.html#",
    "page": "Agents",
    "title": "Agents",
    "category": "page",
    "text": ""
},

{
    "location": "docs/agents.html#Agents-1",
    "page": "Agents",
    "title": "Agents",
    "category": "section",
    "text": "TBD"
},

]}
