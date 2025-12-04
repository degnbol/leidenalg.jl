module Leiden
# export leiden
using CxxWrap

@wrapmodule(() -> joinpath(@__DIR__(), "..", "build", "libwrapper"))

__init__() = @initcxx
# function leiden(adjacency_weighted::T) where T<:AbstractMatrix
#     py_mat = Py(adjacency_weighted).to_numpy()
#     py_comm = py_leiden(py_mat)
#     pyconvert(Vector, py_comm)
# end

end;
