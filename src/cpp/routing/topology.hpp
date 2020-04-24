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
            int wt=(u+v)%20;
            g.addEdge(u,v,wt);
        }

    }
    }


   
    void view_Network(Graph g)

    {
    	cout<<"Structure of WSN in form of graph: \n"<<endl;
        g.printList();
    }
    /*
    void create_Network(Graph & g)
    {
        g.addEdge(0,1,8);
        g.addEdge(0,4,5);
        g.addEdge(0,7,7);
        g.addEdge(1,2,8);
        g.addEdge(1,6,10);
        g.addEdge(1,3,15);
        g.addEdge(2,3,6);
        g.addEdge(2,5,7);
        g.addEdge(3,4,6);
        g.addEdge(3,10,9);

        g.addEdge(4,5,10);
        g.addEdge(4,9,9);
        g.addEdge(5,6,5);
        g.addEdge(5,8,6);

        g.addEdge(6,7,9);
        g.addEdge(6,10,13);
        g.addEdge(7,8,6);
        g.addEdge(8,9,8);
        g.addEdge(9,10,11);

    }
     */

};


#endif // TOPO
