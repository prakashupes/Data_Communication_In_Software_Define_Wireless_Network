#include<iostream>


#include"network/nodes.hpp"
#include "network/graph.hpp"
#include "network/Packates.hpp"
#include "routing/topology.hpp"
//using namespace std;

int main()
{
    int vertex=10;
    Graph g(vertex);
    Topology topology;
    topology.create_Network(g);
    topology.view_Network(g);

    Packet packet;
    packet.setMessage();
    packet.setHeaderInfo();


}
