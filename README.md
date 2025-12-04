Leiden algorithm wrapper in Julia.
Wraps the C++ package [`libleidenalg`](https://github.com/vtraag/libleidenalg).

# Dependencies

- cmake
- zsh
- Julia

# Install
Clone repo recursively then
```
./install.sh
```

# Example
```julia
using Leiden
using SparseArrays

adj = sprand(Float64, 20, 20, 0.2)
adj[diagind(adj)] .= 0.

partitions = leiden(adj)
@assert size(partitions) == (20,)
```
