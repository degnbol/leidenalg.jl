#!/usr/bin/env zsh
set -euo pipefail

# Julia deps.
./install.jl

# Build igraph.
# https://igraph.org/c/doc/igraph-Installation.html
cd $0:h/igraph/
mkdir -p build/
cd build/
cmake ..
cmake --build .
cmake --build . --target check
cmake --install .

# Build libleidenalg.
cd $0:h/libleidenalg/
mkdir -p build/
cd build/
cmake ..
cmake --build .
cmake --build . --target install

# Build Julia C++ wrapper.
cd $0:h/
mkdir build/
cd build/
# Get the path to libcxxwrap as mentioned on the README
# https://github.com/JuliaInterop/CxxWrap.jl
libcxxwrap_prefix=$(julia --project=. -e 'using CxxWrap; println(CxxWrap.prefix_path())')
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$libcxxwrap_prefix ../src/
cmake --build . --config Release

