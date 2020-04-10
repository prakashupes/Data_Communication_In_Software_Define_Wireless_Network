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
     map<int,int> Routing_Table;
    int range=100;
    Packet nodePacket;

    //means it can access node inside the range of 10unit
    //range
    //nearby node

};


#endif // NODE
