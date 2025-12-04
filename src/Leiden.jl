module Leiden
export leiden
using CxxWrap

@wrapmodule(() -> joinpath(@__DIR__(), "..", "build", "libwrapper"))

__init__() = @initcxx

function leiden(adj::T) where T<:AbstractMatrix
    M, N = size(adj)
    @assert M == N "Adjacency matrix should be square. $M != $N"
    adj = adj |> vec |> StdVector
    cxxleiden(adj, N) .|> Int
end

end;
