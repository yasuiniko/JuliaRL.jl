using PyCall
using Conda

# run(`$(joinpath(Conda.python_dir(Conda.ROOTENV),"python")) -m pip install 'gym[all]'`)

function install_python()
    try
        copy!(pygym, pyimport("gym"))
    catch ex
        println("Error in Gym Module")
        # println(ex)
        if isa(ex, PyCall.PyError)
            println("PyCall Error -- assuming module not found")
            println("Gym not installed. Installing now.")
            # run(`$(joinpath(Conda.python_dir(Conda.ROOTENV),"python")) -c 'print("Hello")'`)
            # run(`ls $(Conda.python_dir(Conda.ROOTENV))`)
            run(`$(joinpath(Conda.python_dir(Conda.ROOTENV),"python")) -m pip install 'gym[all]'`)
            # py"""import pip; pip install 'gym[all]';"""
            copy!(pygym, pyimport("gym"))
        else
            throw(ex)
        end
    end
end

install_python()
