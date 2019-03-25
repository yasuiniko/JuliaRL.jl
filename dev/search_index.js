var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#JuliaRL.jl-Documentation-WIP-1",
    "page": "Home",
    "title": "JuliaRL.jl Documentation - WIP",
    "category": "section",
    "text": "Current Working example: misc/testlinearqagentmountaincar.jlMore examples and explanations to come"
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
    "location": "docs/environments.html#JuliaRL.render-Tuple{AbstractEnvironment,Vararg{Any,N} where N}",
    "page": "Environments",
    "title": "JuliaRL.render",
    "category": "method",
    "text": "render(env::AbstractEnvironment, args...; kwargs...)\n\nRender the environment. (WIP, only works with Gym currently.)\n\n\n\n\n\n"
},

{
    "location": "docs/environments.html#",
    "page": "Environments",
    "title": "Environments",
    "category": "page",
    "text": "CurrentModule = JuliaRLAbstractEnvironment\nstart!(env::AbstractEnvironment; rng::AbstractRNG, kwargs...)\nstart(env::AbstractEnvironment; rng::AbstractRNG, kwargs...)\nstep!(env::AbstractEnvironment, action; rng::AbstractRNG, kwargs...)\nstep(env::AbstractEnvironment, action; rng::AbstractRNG, kwargs...)The above functions take advantage of the following interface.JuliaRL.reset!(env::AbstractEnvironment; rng::AbstractRNG, kwargs...)\nJuliaRL.environment_step!(env::AbstractEnvironment, action; rng::AbstractRNG, kwargs...)\nJuliaRL.get_reward(env::AbstractEnvironment)\nJuliaRL.is_terminal(env::AbstractEnvironment)\nJuliaRL.get_state(env::AbstractEnvironment)\nJuliaRL.get_actions(env::AbstractEnvironment)To dig into the dynamics of the environment while running, we can also implement two interfaces for visualization.JuliaRL.render(env::AbstractEnvironment, args...; kwargs...)"
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

{
    "location": "docs/learning.html#",
    "page": "Learning",
    "title": "Learning",
    "category": "page",
    "text": ""
},

{
    "location": "docs/learning.html#Learning-1",
    "page": "Learning",
    "title": "Learning",
    "category": "section",
    "text": ""
},

{
    "location": "docs/learning.html#JuliaRL.Learning.AbstractValueFunction",
    "page": "Learning",
    "title": "JuliaRL.Learning.AbstractValueFunction",
    "category": "type",
    "text": "AbstractValueFunctionn\n\nAbstract type definition for a value function\n\n\n\n\n\n"
},

{
    "location": "docs/learning.html#JuliaRL.Learning.AbstractVFunction",
    "page": "Learning",
    "title": "JuliaRL.Learning.AbstractVFunction",
    "category": "type",
    "text": "AbstractVFunction\n\nAbstract type definition for a state value function\n\n\n\n\n\n"
},

{
    "location": "docs/learning.html#JuliaRL.Learning.AbstractQFunction",
    "page": "Learning",
    "title": "JuliaRL.Learning.AbstractQFunction",
    "category": "type",
    "text": "AbstractQFunction\n\nAbstract type definition for a state-action value function\n\n\n\n\n\n"
},

{
    "location": "docs/learning.html#JuliaRL.Learning.update!",
    "page": "Learning",
    "title": "JuliaRL.Learning.update!",
    "category": "function",
    "text": "update!(value::ValueFunction, opt::Optimizer, ρ, s_t, s_tp1, reward, γ, terminal)\n\nArguments:\n\nvalue::ValueFunction: opt::Optimizer: ρ: Importance sampling ratios (Array of Floats) s_t: States at time t s_tp1: States at time t + 1 reward: cumulant or reward for value function γ: discount factor terminal: Determining termination of the episode (if applicable).\n\n\n\n\n\nupdate!(value::ValueFunction, opt::Optimizer, ρ, s_t, s_tp1, reward, γ, terminal)\n\nArguments:\n\nvalue::ValueFunction: opt::Optimizer: ρ: Importance sampling ratios (Array of Floats) s_t: States at time t s_tp1: States at time t + 1 reward: cumulant or reward for value function γ: discount factor terminal: Determining termination of the episode (if applicable). a_t: Action at time t a_tp1: Action at time t + 1 target_policy: Action at time t\n\n\n\n\n\n"
},

{
    "location": "docs/learning.html#Abstract-API-1",
    "page": "Learning",
    "title": "Abstract API",
    "category": "section",
    "text": "Learning.AbstractValueFunction\nLearning.AbstractVFunction\nLearning.AbstractQFunctionLearning.update!"
},

{
    "location": "docs/learning.html#JuliaRL.Learning.LinearRL.VFunction",
    "page": "Learning",
    "title": "JuliaRL.Learning.LinearRL.VFunction",
    "category": "type",
    "text": "VFunction(num_features)\n\nA structure hosting the weights for a linear value function. Used for Linear function approximation.\n\n\n\n\n\n"
},

{
    "location": "docs/learning.html#JuliaRL.Learning.LinearRL.SparseVFunction",
    "page": "Learning",
    "title": "JuliaRL.Learning.LinearRL.SparseVFunction",
    "category": "type",
    "text": "SparseVFunction(num_features)\n\nA structure for when the feature vector is known to be sparse, and handed to the agent as a list of indices. Significantly faster than a normal value function in this special case.\n\n\n\n\n\n"
},

{
    "location": "docs/learning.html#JuliaRL.Learning.LinearRL.QFunction",
    "page": "Learning",
    "title": "JuliaRL.Learning.LinearRL.QFunction",
    "category": "type",
    "text": "QFunction(num_features, num_features_per_action, num_actions)\n\nLinear QFunction. Assumes no sparsity, and an array of floats for a feature vector.\n\n\n\n\n\n"
},

{
    "location": "docs/learning.html#JuliaRL.Learning.LinearRL.SparseQFunction",
    "page": "Learning",
    "title": "JuliaRL.Learning.LinearRL.SparseQFunction",
    "category": "type",
    "text": "SparseQFunction(num_features, num_features_per_action, num_actions)\n\nQFunction assuming sparsity.\n\n\n\n\n\n"
},

{
    "location": "docs/learning.html#JuliaRL.Learning.LinearRL.TD",
    "page": "Learning",
    "title": "JuliaRL.Learning.LinearRL.TD",
    "category": "type",
    "text": "TD(α)\n\nOnline Temporal Difference Learning.\n\n\n\n\n\n"
},

{
    "location": "docs/learning.html#JuliaRL.Learning.LinearRL.TDLambda",
    "page": "Learning",
    "title": "JuliaRL.Learning.LinearRL.TDLambda",
    "category": "type",
    "text": "TDLambda(α, λ)\n\nOnline Temporal Difference Learning with eligibility traces.\n\n\n\n\n\n"
},

{
    "location": "docs/learning.html#JuliaRL.Learning.LinearRL.WatkinsQ",
    "page": "Learning",
    "title": "JuliaRL.Learning.LinearRL.WatkinsQ",
    "category": "type",
    "text": "WatkinsQ(α)\n\nQ Learning as defined by Watkins\n\n\n\n\n\n"
},

{
    "location": "docs/learning.html#LinearRL-1",
    "page": "Learning",
    "title": "LinearRL",
    "category": "section",
    "text": "Learning.LinearRL.VFunction\nLearning.LinearRL.SparseVFunction\nLearning.LinearRL.QFunction\nLearning.LinearRL.SparseQFunctionCurrently implemented algorithmsLearning.LinearRL.TD\nLearning.LinearRL.TDLambda\nLearning.LinearRL.WatkinsQ"
},

{
    "location": "docs/feature_creators.html#",
    "page": "Feature Creators",
    "title": "Feature Creators",
    "category": "page",
    "text": ""
},

{
    "location": "docs/feature_creators.html#Feature-Creators-1",
    "page": "Feature Creators",
    "title": "Feature Creators",
    "category": "section",
    "text": ""
},

{
    "location": "docs/feature_creators.html#Abstract-API-1",
    "page": "Feature Creators",
    "title": "Abstract API",
    "category": "section",
    "text": "JuliaRL.FeatureCreators.AbstractFeatureCreator\nJuliaRL.FeatureCreators.create_features\nJuliaRL.FeatureCreators.feature_size"
},

{
    "location": "docs/feature_creators.html#JuliaRL.FeatureCreators.TileCoder",
    "page": "Feature Creators",
    "title": "JuliaRL.FeatureCreators.TileCoder",
    "category": "type",
    "text": "TileCoder(num_tilings, num_tiles, num_features, num_ints)\n\nTile coder for coding all features together.\n\n\n\n\n\n"
},

{
    "location": "docs/feature_creators.html#TileCoder-1",
    "page": "Feature Creators",
    "title": "TileCoder",
    "category": "section",
    "text": "FeatureCreators.TileCoder"
},

]}
