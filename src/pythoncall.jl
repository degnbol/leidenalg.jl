# Code for the PythonCall.jl package.
using PythonCall

"""
Include code from a python file.
To include one term:
```v, = pyinclude(path, name)```
Implements the equivalent to the @pyinclude from PyCall.jl.
- path: filepath of python file.
- names: names of functions, variables, etc. from the python file to return.
"""
function pyinclude(path::String, names::Symbol...)
    T = NamedTuple{Symbol.(names), Tuple{(Any for _ in names)...}}
    code = read(path, String)
    pyexec(T, code, Main) |> values
end
function pyinclude(path::String, names::String...)
    pyinclude(path, Symbol.(names)...)
end

