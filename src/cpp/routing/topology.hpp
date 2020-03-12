#include "../network/graph.hpp"
#ifndef TOPO
#define TOPO
class Topology
{
    int vertex=10;
    public:
    void create_Network(Graph & g) //It will create a graph
    {
        int i=1;
    while(i<(vertex*4)-vertex)
    {
        int u=(rand()%vertex);
        int v=(rand()%vertex);
        if(u!=v)
        {
            i++;
            //cout<<u<<", "<<v<<endl;
            g.addEdge(u,v);
        }

    }
    }

    void view_Network(Graph g)

    {
        g.printList();
    }

};


#endif // TOPO
