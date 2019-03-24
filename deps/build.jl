using PyCall
using Conda

# run(`$(joinpath(Conda.python_dir(Conda.ROOTENV),"python")) -m pip install 'gym[all]'`)

function install_python()
    try
        copy!(pygym, pyimport("gym"))
    catch ex
        println("Error in Gym Module")
        println(ex)
        if isa(ex, PyCall.PyError)
            if ex.T.__name__ == "ModuleNotFoundError"
                println("Gym not installed. Installing now.")
                # run(`$(joinpath(Conda.python_dir(Conda.ROOTENV),"python")) -c 'print("Hello")'`)
                
                # py"""import pip; pip install 'gym[all]';"""
                copy!(pygym, pyimport("gym"))
            else
                throw(ex)
            end
        else
            throw(ex)
        end
    end
end

install_python()
