import numpy as np
import leidenalg
import igraph as ig

def leiden(adj):
    """
    Given a (weighted) adjacency matrix, get the partitioning of each node according to the Leiden algorithm.
    The Leiden algorithm attempts to maximise a notion of modularity in the given data.
    It was designed to improve on the popular Louvain algorithm.
    """
    G = ig.Graph.Weighted_Adjacency(adj)
    # Returned as a list of lists
    parts = leidenalg.find_partition(G, leidenalg.ModularityVertexPartition)
    mem = np.asarray(parts.membership)
    # Partition identifiers are arbitrary, 0-indexed and the list may not start with 0 as the first entry.
    # Change the arbitrary identifiers of partitions so they are increasing order.
    # For the sake of stability in comparisons.
    # Also, start from 1.
    comm = np.zeros(len(mem), dtype=int)
    for part in range(1, len(parts)+1):
        # Get first node that isn't assigned a partition yet.
        i = np.nonzero(comm == 0)[0][0]
        # Partition re-assignment.
        comm[mem[i] == mem] = part
    return comm

