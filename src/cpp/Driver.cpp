#include<iostream>

#include"network/nodes.hpp"
#include "network/graph.hpp"
#include "network/Packates.hpp"
#include "routing/topology.hpp"
#include "routing/Transmission.hpp"
#include "routing/RoutingProtocol.hpp"
#include "logs/log.hpp"

//using namespace std;

int main()
{

    int vertex=10;
    Graph g(vertex);
    Topology topology;
    topology.create_Network(g);
    topology.view_Network(g);

    Dijikstra d;
//    d.shortest_path(g,2,8);

    Packet packet;
    packet.setMessage();
    packet.setHeaderInfo();

    Routing r;
    r.genrateTable(packet.getSource(),packet.getDesti(),g);
    r.setTable(g);
  
    int t=5;
    
    while(t--)
    {
    	log::out<<"\n\nTransmission Num: "<<t+1;
    	Transmission t;
        t.startTransmission(g,packet);
    }  
    








}
