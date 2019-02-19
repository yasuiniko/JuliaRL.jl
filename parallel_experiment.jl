using Distributed
using Random
using Revise
# using ProgressMeter
# using ArgParse

const IN_SLURM = "SLURM_JOBID" in keys(ENV)
IN_SLURM && using ClusterManagers


# @everywhere using JuliaRL

ARGS_KWARGS = [
    Dict(:ARGS=>(0.5/8, 0.1, 1.0, 32, 8), :KWARGS=>Dict([:n_episodes=>1000])),
    Dict(:ARGS=>(0.5/4, 0.1, 1.0, 32, 4), :KWARGS=>Dict([:n_episodes=>1000])),
    Dict(:ARGS=>(0.5/2, 0.1, 1.0, 32, 2), :KWARGS=>Dict([:n_episodes=>1000])),
    Dict(:ARGS=>(0.5/16, 0.1, 1.0, 32, 16), :KWARGS=>Dict([:n_episodes=>1000]))
]

function parallel_experiment_runs_args_episodic(experiment_file, args_kwargs_list, n_runs=10; exp_func_name=:run, num_workers=5, make_results=nothing)

    pids = nothing
    if IN_SLURM
        pids = addprocs(SlurmManager(parse(Int, ENV["SLURM_NTASKS"])))
        print("\n")
    else
        println(num_workers, " ", nworkers())
        if nworkers() == 1
            pids = addprocs(num_workers)
        elseif nworkers() < num_workers
            pids = addprocs((num_workers) - nworkers())
        end
    end

    println(nworkers(), " ", pids)

    @everywhere global exp_file=$experiment_file
    @everywhere include(exp_file)
    exp_func = getfield(Main, Symbol(exp_func_name))
    experiment(r, ak) = exp_func(ak[:ARGS]...; seed=1002349+r, ak[:KWARGS]...)

    res_dict = Dict{Int64, Any}()
    futures = Array{Array{Future,1}, 1}()

    for (args_kwargs_idx, args_kwargs) in enumerate(args_kwargs_list)

        in_futures = Array{Future,1}()

        for run in 1:n_runs
            append!(in_futures, [@spawn experiment(run, args_kwargs)])
        end
        if make_results == nothing
            results = zeros(n_runs, args_kwargs[:KWARGS][:n_episodes])
        else
            results = make_results(n_runs, args_kwargs)
        end

        append!(futures, [in_futures])

        res_dict[args_kwargs_idx] = Dict([
            "args"=>args_kwargs,
            "results"=>results
        ])
    end

    for (args_kwargs_idx, args_kwargs) in enumerate(args_kwargs_list)
        for run in 1:n_runs
            res_dict[args_kwargs_idx]["results"][run,:] .= fetch(futures[args_kwargs_idx][run])
        end
    end

    return res_dict
end

function parallel_experiment_runs(experiment_file, args_kwargs_list, id, n_runs=10)


    


end

function experiment(experiment_file, arg_file, id, r=1)
    
end

