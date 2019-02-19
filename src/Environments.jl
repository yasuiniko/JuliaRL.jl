# module Environments

# import JuliaRL.AbstractEnvironment, JuliaRL.start, JuliaRL.step!, JuliaRL.step, JuliaRL.get_reward, JuliaRL.is_terminal, JuliaRL.normalized_state

export MountainCar, GymEnv

include("environments/MountainCar.jl")
include("environments/Gym.jl")


# end
