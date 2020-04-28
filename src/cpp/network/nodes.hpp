
#include "Packates.hpp"
#include<queue>
#include <map>
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
    Packet tempPacket;//Node packet to temp //During transmision
    
    queue<Packet> q; //Contains all packets if cuur node =desti
    

    //means it can access node inside the range of 10unit
    //range
    //nearby node

};


#endif // NODE
