using Distributed
using Random

# @everywhere using JuliaRL
@everywhere include("test_tilecoder_mountaincar.jl")

function run_mountain_car_parallel(n_runs=10, n_episodes=10000)

    experiment(run) = mountain_car_test(0.5/8, 0.1, 1.0, 32, 8; n_episodes=n_episodes, seed=1002349+run)

    futures = Array{Future, 1}()

    for run in 1:n_runs
        append!(futures, [@spawn experiment(run)])
    end

    results = zeros(n_runs, n_episodes)

    @showprogress 1.0 "Run Fetched: " for run in 1:n_runs
        results[run, :] .= fetch(futures[run])
    end

    return results

end

