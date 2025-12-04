#!/usr/bin/env zsh
set -euo pipefail
cd $0:h

# ./adj.tsv.jl
./test_leiden.jl > ./test_leiden.jl.txt
uv run ./test_leiden.py > ./test_leiden.py.txt
cmp ./test_leiden.{jl,py}.txt
