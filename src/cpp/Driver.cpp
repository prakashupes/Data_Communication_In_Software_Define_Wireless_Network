#include<iostream>


#include"nodes.hpp"
#include "graph.hpp"
//using namespace std;

int main()
{
    int vertex=10;
    Graph g(vertex);
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
    g.printList();
    g.getInfo(5);
}
