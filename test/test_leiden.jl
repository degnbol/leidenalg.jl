#!/usr/bin/env julia
using DelimitedFiles
using Leiden

adj = readdlm("adj.tsv")
comm = leiden(adj)
println(join(comm, '\n'))
