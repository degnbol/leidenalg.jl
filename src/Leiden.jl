module Leiden
export leiden

# Lazy install python deps to local env.
env = joinpath(@__DIR__(),  "..", ".venv")
ENV["PYTHON"] = joinpath(env, "bin", "python")
ENV["PYCALL_JL_RUNTIME_PYTHON"] = ENV["PYTHON"]
ENV["PYTHONPATH"] = @__DIR__()
if !isdir(env)
    print("Installing python dependencies...")
    mkdir(env)
    using Conda
    Conda.create(env)
    Conda.add(["numpy", "leidenalg"], env)
    using Pkg
    Pkg.build("PyCall")
end

using PyCall

@pyinclude(joinpath(@__DIR__(), "leiden.py"))

function leiden(adj::T) where T<:AbstractMatrix
    py"leiden"(adj)
end

end;
