#include<iostream>


#include"network/nodes.hpp"
#include "network/graph.hpp"
#include "network/Packates.hpp"
#include "routing/topology.hpp"
#include "routing/Dijikstra.hpp"
#include "routing/Transmission.hpp"
//using namespace std;

int main()
{
    int vertex=10;
   // Graph g(vertex);
    Topology topology;
    topology.create_Network(g);
    topology.view_Network(g);

    Dijikstra d;
//    d.shortest_path(g,2,8);

    Packet packet;
    packet.setMessage();
    packet.setHeaderInfo();

    g.genrateTable(packet.getSource(),packet.getDesti());
    g.setTable();

    Transmission t;
    t.startTransmission(g,packet);

    //Print routing tabele
   /* for(auto x:g.Routing_Table)
    {
        cout<<x.first<<" "<<x.second<<endl;

    }
    */
    g.individual_Nodes[packet.getSource()].nodePacket=packet;
   // while(packet.)



}
