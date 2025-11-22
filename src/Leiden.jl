module Leiden
export leiden

include("pythoncall.jl") # pyinclude

py_leiden, = pyinclude(@__DIR__() * "/leiden.py", :leiden)

function leiden(adjacency_weighted::T) where T<:AbstractMatrix
    py_mat = Py(adjacency_weighted).to_numpy()
    py_comm = py_leiden(py_mat)
    pyconvert(Vector, py_comm)
end

end;
