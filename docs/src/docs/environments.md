
```@meta
CurrentModule = JuliaRL
```

```@docs
AbstractEnvironment
start!(env::AbstractEnvironment; rng::AbstractRNG, kwargs...)
start(env::AbstractEnvironment; rng::AbstractRNG, kwargs...)
step!(env::AbstractEnvironment, action; rng::AbstractRNG, kwargs...)
step(env::AbstractEnvironment, action; rng::AbstractRNG, kwargs...)
```

The above functions take advantage of the following interface.

```@docs
JuliaRL.reset!(env::AbstractEnvironment; rng::AbstractRNG, kwargs...)
JuliaRL.environment_step!(env::AbstractEnvironment, action; rng::AbstractRNG, kwargs...)
JuliaRL.get_reward(env::AbstractEnvironment)
JuliaRL.is_terminal(env::AbstractEnvironment)
JuliaRL.get_state(env::AbstractEnvironment)
JuliaRL.get_actions(env::AbstractEnvironment)
```



To dig into the dynamics of the environment while running, we can also implement two interfaces for visualization.

```@docs
JuliaRL.Base.show(io::IO, env::AbstractEnvironment)
JuliaRL.render(env::AbstractEnvironment, args...; kwargs...)
```

