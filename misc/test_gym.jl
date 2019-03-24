# using OpenAIGym
# import OpenAIGym
using Flux
using JuliaRL
using Random
import LearnBase.IntervalSet

# rand(rng, int_set::)
Base.rand(rng::AbstractRNG, s::IntervalSet{T}) where T <: AbstractVector = Float64[rand(rng) * (s.hi[i] - s.lo[i]) + s.lo[i] for i=1:length(s)]

function test_gym(num_episodes, num_steps, to_render::Bool=false)

    rng = MersenneTwister(1)
    env = GymEnv(:BipedalWalker, :v2; seed=1)
    println(typeof(env))
    for i ∈ 1:num_episodes
        T = 0
        R = 0.0
        action_set = get_actions(env)
        st = start!(env)
        for i in 1:num_steps
            action = rand(rng, action_set)
            step!(env, action)
            if to_render
                render(env)
            end
            R += get_reward(env)
            T += 1
        end

        @info("Episode $i finished after $T steps. Total reward: $R")
    end

    # You can explicitly close the connection for the python environment here. But will be taken care of by the garbage collector eventually.
    close(env)

end
