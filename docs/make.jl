push!(LOAD_PATH,"../src/")

using Documenter, JuliaRL

makedocs(
    sitename="JuliaRL",
    modules = [JuliaRL],
    format = Documenter.HTML(prettyurls = false),
    pages = [
        "Home"=>"index.md",
         "Documentation" => Any[
             "Environments" => "docs/environments.md"
             "Agents" => "docs/agents.md"
             ]
    ]
)

deploydocs(
    repo = "github.com/mkschleg/JuliaRL.jl.git",
    devbranch = "master"
)
