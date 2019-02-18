using Distributed
using Random
# using ProgressMeter
# using ArgParse

const IN_SLURM = "SLURM_JOBID" in keys(ENV)
IN_SLURM && using ClusterManagers


# @everywhere using JuliaRL

ARGS_KWARGS = [
    Dict(:ARGS=>(0.5/8, 0.1, 1.0, 32, 8), :KWARGS=>Dict([:n_episodes=>1000])),
    Dict(:ARGS=>(0.5/2, 0.1, 1.0, 32, 2), :KWARGS=>Dict([:n_episodes=>1000]))
]

function parallel_experiment_runs_args_episodic(experiment_file, args_kwargs_list, n_runs=10; exp_func_name=:run)

    if IN_SLURM
        pids = addprocs(SlurmManager(parse(Int, ENV["SLURM_NTASKS"])), )
        print("\n")
    else
        pids = addprocs(5)
    end

    res_dict = Dict{Int64, Any}()

    @everywhere global exp_file=$experiment_file

    @everywhere include(exp_file)

    exp_func = getfield(Main, Symbol(exp_func_name))
    futures = Array{Array{Future,1}, 1}()
    for (args_kwargs_idx, args_kwargs) in enumerate(args_kwargs_list)

        experiment(r) = exp_func(args_kwargs[:ARGS]...; seed=1002349+r, args_kwargs[:KWARGS]...)

        in_futures = Array{Future,1}()

        for run in 1:n_runs
            append!(in_futures, [@spawn experiment(run)])
        end

        results = zeros(n_runs, args_kwargs[:KWARGS][:n_episodes])

        append!(futures, [in_futures])

        res_dict[args_kwargs_idx] = Dict([
            "args"=>args_kwargs,
            "results"=>results
        ])

    end

    for (args_kwargs_idx, args_kwargs) in enumerate(args_kwargs_list)
        for run in 1:n_runs
            res_dict[args_kwargs_idx]["results"] = fetch(futures[args_kwargs_idx][run])
        end
    end

    return res_dict
end

function parallel_experiment(experiment_file, args_kwargs_list, id, n_runs=10)
    
end

function experiment(experiment_file, arg_file, id, r=1)
    
end

