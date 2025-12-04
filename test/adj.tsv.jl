#!/usr/bin/env julia
using SparseArrays
using LinearAlgebra
using DelimitedFiles
using Random: seed!

seed!(42)
adj = sprand(Float64, 20, 20, 0.2)
adj[diagind(adj)] .= 0.

writedlm("adj.tsv", adj, '\t')

