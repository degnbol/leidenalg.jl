#!/usr/bin/env python3
import numpy as np
from leiden import leiden

adj = np.loadtxt("./adj.tsv")
comm = leiden(adj)
print("\n".join(map(str, comm)))

