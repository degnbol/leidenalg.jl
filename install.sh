#!/usr/bin/env zsh
set -euo pipefail

# Get absolute path to script directory
SCRIPT_DIR=${0:a:h}
cd "$SCRIPT_DIR"

# Julia deps (includes igraph_jll)
julia --project=. -e 'using Pkg; Pkg.instantiate()'

# Get igraph paths from igraph_jll
igraph_prefix=$(julia --project=. -e 'using igraph_jll; igraph_jll.libigraph_path |> dirname |> dirname |> print')
echo "Using igraph from: $igraph_prefix"

# Workaround for igraph_jll bug: hardcoded libm.so path from cross-compilation build
# See: https://github.com/JuliaPackaging/Yggdrasil (report upstream)
igraph_targets="$igraph_prefix/lib/cmake/igraph/igraph-targets.cmake"
if grep -q '/opt/x86_64-linux-gnu' "$igraph_targets" 2>/dev/null; then
    echo "Patching igraph cmake config (hardcoded libm.so path workaround)"
    sed -i 's|"/opt/x86_64-linux-gnu/[^"]*libm.so"|"m"|g' "$igraph_targets"
fi

# Build libleidenalg.
if [[ ! -d deps/libleidenalg ]]; then
    git clone https://github.com/vtraag/libleidenalg deps/libleidenalg
fi
cd "$SCRIPT_DIR/deps/libleidenalg"
mkdir -p build
cd build
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH="$igraph_prefix" \
    -DBUILD_SHARED_LIBS=ON
cmake --build . -j
# Install to a local prefix
cmake --install . --prefix "$SCRIPT_DIR/deps/local"

# Build Julia C++ wrapper.
cd "$SCRIPT_DIR"
rm -rf build
mkdir build
cd build
# Get the path to libcxxwrap as mentioned on the README
# https://github.com/JuliaInterop/CxxWrap.jl
libcxxwrap_prefix=$(julia --project="$SCRIPT_DIR" -e 'using CxxWrap; println(CxxWrap.prefix_path())')
cmake -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_PREFIX_PATH="$libcxxwrap_prefix;$igraph_prefix;$SCRIPT_DIR/deps/local" \
    ../src/
cmake --build . --config Release
