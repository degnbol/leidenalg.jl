#!/usr/bin/env zsh
set -euo pipefail
cd $0:h/

# Julia deps (includes igraph_jll)
./install.jl

# Get igraph paths from igraph_jll
igraph_prefix=$(julia --project=. -e 'using igraph_jll; igraph_jll.libigraph_path |> dirname |> dirname |> print')
echo "Using igraph from: $igraph_prefix"

# Build libleidenalg.
if [[ ! -d deps/libleidenalg ]]; then
    git clone https://github.com/vtraag/libleidenalg deps/libleidenalg
fi
cd deps/libleidenalg/
mkdir -p build/
cd build/
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH="$igraph_prefix" \
    -DBUILD_SHARED_LIBS=ON
cmake --build . -j
# Install to a local prefix
cmake --install . --prefix "$0:h:A/deps/local"

# Build Julia C++ wrapper.
cd $0:h/
rm -rf build/
mkdir build/
cd build/
# Get the path to libcxxwrap as mentioned on the README
# https://github.com/JuliaInterop/CxxWrap.jl
libcxxwrap_prefix=$(julia --project=. -e 'using CxxWrap; println(CxxWrap.prefix_path())')
cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH="$libcxxwrap_prefix;$igraph_prefix;$0:h:A/deps/local" \
    ../src/
cmake --build . --config Release
