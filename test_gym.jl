using OpenAIGym
using Flux






function test_gym()

    env = GymEnv(:BipedalWalker, :v2)
    for i ∈ 1:20
        T = 0
        R = run_episode(env, RandomPolicy()) do (s, a, r, s′)
            println(render(env))
            println(s)
            T += 1
        end
        @info("Episode $i finished after $T steps. Total reward: $R")
    end
end
