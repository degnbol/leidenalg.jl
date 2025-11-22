import numpy as np
import leidenalg
import igraph as ig

def leiden(adjacency_weighted):
    """
    Given a (weighted) adjacency matrix, get the partitioning of each node according to the Leiden algorithm.
    The Leiden algorithm attempts to maximise a notion of modularity in the given data.
    It was designed to improve on the popular Louvain algorithm.
    """
    G = ig.Graph.Weighted_Adjacency(adjacency_weighted)
    parts = leidenalg.find_partition(G, leidenalg.ModularityVertexPartition)
    comm = np.zeros(adjacency_weighted.shape[0], dtype=int)
    for i, part in enumerate(parts):
        comm[part] = i+1
    return comm

