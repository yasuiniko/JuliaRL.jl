# using OpenAIGym
# import OpenAIGym
using Flux
using JuliaRL

function test_gym(num_episodes, num_steps, to_render::Bool=false)

    env = GymEnv(:BipedalWalker, :v2)
    println(typeof(env))
    for i ∈ 1:num_episodes
        T = 0
        R = 0.0
        action_set = get_actions(env)
        
        println(action_set)
        st = start!(env)
        for i in 1:num_steps
            action = rand(action_set)
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
    # close(env)

end
