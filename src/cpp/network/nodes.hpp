#include "routingTable.hpp"
#include "Packates.hpp"
#ifndef NODE
#define NODE

class Node
{
    public:
    int Node_id;
   // int data; //char queue  p p2 p
   // int weight;
    RoutingTable table;
    int range=10;
    Packet nodePacket;

    //means it can access node inside the range of 10unit
    //range
    //nearby node

};


#endif // NODE
