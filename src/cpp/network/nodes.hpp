
#include "Packates.hpp"
//#include "../routing/RoutingProtocol.hpp" //To define table structure
#include "../routing/TableStruct.hpp"
#include<queue>
#include <vector>
#ifndef NODE
#define NODE
struct Flowrule
{
	int nextHope,relay,ttl,cost;
	Flowrule(int a, int b, int c,int d): nextHope(a),relay(b) ,ttl(c),cost(d){}


};


class Node
{

    public:
    int Node_id;
   
   vector<table_attributes> flow_rule;
    int range=100;
    Packet tempPacket;//Node packet to temp //During transmision
    
    queue<Packet> q; //Contains all packets if cuur node =desti
    

    //means it can access node inside the range of 10unit
    //range
    //nearby node

};


#endif // NODE
