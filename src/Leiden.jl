module Leiden
export leiden
using CxxWrap
using igraph_jll

# Load igraph_jll dependencies before loading our wrapper
# This must happen before @wrapmodule which runs at precompile time
const _igraph_handle = igraph_jll.libigraph_handle

@wrapmodule(() -> joinpath(@__DIR__(), "..", "build", "libwrapper"))

__init__() = @initcxx

function leiden(adj::T)::Vector{Int} where T<:AbstractMatrix
    M, N = size(adj)
    @assert M == N "Adjacency matrix should be square. $M != $N"
    adj = adj |> collect |> vec .|> Float64 |> StdVector
    mem = cxxleiden(adj, N) .|> Int
    # Partition identifiers are arbitrary, 0-indexed and the list may not start with 0 as the first entry.
    # Change the arbitrary identifiers of partitions so they are increasing order.
    # For the sake of stability in comparisons.
    # Also, start from 1.
    comm = zeros(Int, length(mem))
    for part in 1:(maximum(mem)+1)
        # Get first node that isn't assigned a partition yet.
        i = findfirst(comm .== 0)
        # Partition re-assignment.
        comm[mem[i] .== mem] .= part
    end
    comm
end

end;
