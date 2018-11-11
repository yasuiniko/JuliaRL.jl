module JuliaRL

greet() = print("Hello Reinforcement Learning Julia!")

export TileCoder

include("TileCoder.jl")
include("Environments.jl")

# include("Replay.jl")

end # module
