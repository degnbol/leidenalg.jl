Leiden algorithm wrapper in Julia.
Wraps the C++ package `libleidenalg`.

Example use:
```julia
using Leiden: leiden

adj = randn(7, 7)
partitions = leiden(adj)
@assert size(partitions) == (7,)
```
