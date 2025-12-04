#!/usr/bin/env zsh
set -euo pipefail

# Build igraph.
# https://igraph.org/c/doc/igraph-Installation.html
cd $0:h/
git clone https://github.com/igraph/igraph deps/igraph
cd deps/igraph/
mkdir -p build/
cd build/
cmake ..
cmake --build .
cmake --build . --target check
cmake --install .

# Build libleidenalg.
cd $0:h/
git clone https://github.com/vtraag/libleidenalg deps/libleidenalg
cd deps/libleidenalg/
mkdir -p build/
cd build/
cmake ..
cmake --build .
cmake --build . --target install

# Build Julia C++ wrapper.
cd $0:h/
rm -r build/
mkdir build/
cd build/
# Get the path to libcxxwrap as mentioned on the README
# https://github.com/JuliaInterop/CxxWrap.jl
libcxxwrap_prefix=$(julia --project=. -e 'using CxxWrap; println(CxxWrap.prefix_path())')
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$libcxxwrap_prefix ../src/
cmake --build . --config Release

