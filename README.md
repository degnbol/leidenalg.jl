
Leiden algorithm wrapper in Julia.
Wraps the Python package `leidenalg`, 
which itself is a wrapper of C++ code, see
https://github.com/vtraag/leidenalg.
Calls Python code from Julia using `PythonCall`.

Example use:
```julia
using Leiden: leiden

adj = randn(7, 7)
partitions = leiden(adj)
@assert size(partitions) == (7,)
```

