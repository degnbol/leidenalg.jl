#include <igraph.h>
#include <GraphHelper.h>
#include <Optimiser.h>
#include <CPMVertexPartition.h>
#include <ModularityVertexPartition.h>
#include "jlcxx/jlcxx.hpp"

vector<size_t> leiden(vector<double> adj, int N)
{
    const igraph_matrix_t mat = igraph_matrix_view(adj.data(), N, N);

    // Initialize vector for edge weights.
    igraph_vector_t edge_weights;
    igraph_vector_init(&edge_weights, 0);

    igraph_t g;
    igraph_weighted_adjacency(
            &g, // modifies
            &mat,
            IGRAPH_ADJ_DIRECTED,
            &edge_weights, // modifies
            // include self-loops once
            IGRAPH_LOOPS_ONCE
      );

    Graph graph(&g);

    // second arg is resolution
    // CPMVertexPartition part(&graph, 0.05);
    ModularityVertexPartition part(&graph);

    Optimiser o;
    o.optimise_partition(&part);

    igraph_destroy(&g);

    return part.membership();
}


JLCXX_MODULE define_julia_module(jlcxx::Module& mod)
{
    mod.method("cxxleiden", &leiden);
}
