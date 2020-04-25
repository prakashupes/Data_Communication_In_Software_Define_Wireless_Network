#include "Dijikstra.hpp"
#include "../network/graph.hpp"
#include "../logs/log.hpp"
#include<map>
#ifndef ROUTING
#define ROUTING

//We are using link state routing
class Routing
{

    public:
   // map<int,int> routing_table;
  //  RoutingTable
  map<int,int> Routing_Table;
   void genrateTable(int src,int des,Graph &g)
    {
        Dijikstra d;
        stack<int> s=d.shortest_path(g.adjList,src,des,g.vertex);
	
        while(!s.empty())
        {
            int i=s.top();
            s.pop();
            if(des!=i)
            {
            	table::out<<i<<"         |"<<s.top()<<endl;
                Routing_Table [i]=s.top();
            }
        }


    }

    //Set table to each node
    void setTable(Graph &g)
    {

        for(int i=0;i<g.vertex;i++)
        {
            g.individual_Nodes[i].Routing_Table=Routing_Table;
        }

    }

};




#endif // ROUTING


   //int nextHope;
    //route
    //controller func paket 1
    //send to controller /
    //controler have avail networks  and
    //from src to dist execute diji
    //use 30 sec update table
    // src to desti
    //action --> forwad, drop, pause
    //TTL
    //
//thred for parellerprogramming

//Make exception for src and desi
