

# module MountainCar

using Random

module MountainCarConst
const vel_limit = (-0.07, 0.07)
const pos_limit = (-1.2, 0.5)
const pos_initial_range = (-0.6, 0.4)
end

mutable struct MountainCar <: AbstractEnvironment
    pos::Float64
    vel::Float64
    MountainCar() = new(0.0, 0.0)
    MountainCar(rng::AbstractRNG) = new((rand(rng)*(MountainCarConst.pos_initial_range[2]
                                                    - MountainCarConst.pos_initial_range[1])
                                         + MountainCarConst.pos_initial_range[1]),
                                        0)
end

function start!(env::MountainCar; rng = Random.GLOBAL_RNG, kwargs...)
    env.pos = (rand(rng)*(MountainCarConst.pos_initial_range[2]
                          - MountainCarConst.pos_initial_range[1])
               + MountainCarConst.pos_initial_range[1])
    env.vel = 0
end

function start(env::MountainCar; rng = Random.GLOBAL_RNG, kwargs...)
    return typeof(env)(rng)
end

function step!(env::MountainCar, action::Int64; rng = Random.GLOBAL_RNG, kwargs...) # -> agent_state, reward, terminal
    # println(clamp(agent_state.vel + action*0.001 - 0.0025*cos(3*agent_state.pos), vel_limit...))
    env.vel = clamp(env.vel + (action - 1)*0.001 - 0.0025*cos(3*env.pos), MountainCarConst.vel_limit...)
    env.pos = clamp(env.pos + env.vel, MountainCarConst.pos_limit...)
    return env, get_reward(env), is_terminal(env)
end

function step(env::MountainCar, action::Int64; rng = Random.GLOBAL_RNG, kwargs...)
    new_env = copy(env)
    return step!(new_env, action; kwargs...)
end

function get_reward(env::MountainCar) # -> determines if the agent_state is terminal
    if env.pos >= MountainCarConst.pos_limit[2]
        return 0
    end
    return -1
end

function is_terminal(env::MountainCar) # -> determines if the agent_state is terminal
    return env.pos >= MountainCarConst.pos_limit[2]
end

function normalized_state(env::MountainCar)
    pos_limit = MountainCarConst.pos_limit
    vel_limit = MountainCarConst.vel_limit
    return [(env.pos - pos_limit[1])/(pos_limit[2] - pos_limit[1]), (env.vel - vel_limit[1])/(vel_limit[2] - vel_limit[1])]
end


