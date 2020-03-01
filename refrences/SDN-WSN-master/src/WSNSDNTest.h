#ifndef WSNSDNTEST_H
#define WSNSDNTEST_H

enum
{
	MAX_NEIGHBORS = 10, // Maximum message length in TOSSIM: 128 bytes, 6 bytes for each Routing table entry  
	AM_INITIALIZATION_MSG = 10,
	AM_NEIGHBORREQ = 5,
	AM_NEIGHBORREP = 4,
	AM_NETWORK_MSG = 6,
	AM_CONTROLLER_ROUTING_TABLE= 7,
	AM_NODE_MSG = 8,
	AM_ACK_MSG = 11,
	AM_CONTROLLER_MSG = 9,	
	TIMER_PERIODIC_MILLI = 2160,
	TIMER_ONE_SHOT = 128
};

typedef nx_struct initialization_msg
{
	nx_uint16_t UX;
	nx_uint16_t UY;
	nx_uint16_t ReplenishmentRate;
	nx_uint16_t Type;
}initialization_msg_t;

////////////////////////////////////////////////////////////
typedef nx_struct NeighborREQ
{
	nx_uint16_t nodeid;
}NeighborREQ_t;

typedef nx_struct NeighborREP
{
	nx_uint16_t nodeid;
	nx_uint16_t N_X;
	nx_uint16_t N_Y;
}NeighborREP_t;

typedef nx_struct Neighbor_List
{
	nx_uint16_t Neighbor_Address;
	nx_uint16_t NodeID;
	nx_uint8_t USED;
	nx_uint16_t N_X;
	nx_uint16_t N_Y;
}Neighbor_List_t;

typedef nx_struct Network_Msg
{
	nx_uint16_t HostNodeID;
	nx_uint16_t RelayNode; //////////////////////////////Remove after debug////////////////
	nx_uint16_t NoNeighbors;
	nx_uint8_t USED;
	Neighbor_List_t Neighbor_List[];
}Network_Msg_t;
//////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////
typedef nx_struct NeighborAction
{
	nx_uint8_t USED;
	nx_uint16_t NeighborNode;	
	nx_uint16_t Action;
}NeighborAction_t;

typedef nx_struct Controller_Routing_Table
{
	nx_uint16_t nodeid;
	NeighborAction_t NeighborAction[MAX_NEIGHBORS];
}Controller_Routing_Table_t;
//////////////////////////////////////////////////////////////




////////////////////////////////////////
typedef nx_struct node_msg            //
{                                     //
	nx_uint16_t SentNode;             // 
	nx_uint16_t NodeID;               //
	nx_uint16_t Retransmissions;      //
	nx_uint16_t SensedMsg;            //
	nx_uint16_t Count;                // 
}node_msg_t;                          //
                                      //
typedef nx_struct ack_msg             //
{                                     //
	nx_uint8_t ACKED;                 //
	nx_uint16_t AckedNode;            //
}ack_msg_t;                           //
                                      //                           
                                      //
typedef nx_struct controller_msg      //
{                                     //
	nx_uint16_t counter;              //
}controller_msg_t;                    //
////////////////////////////////////////




//////////////////////////////////////////////////////////////
typedef struct MatchAction            //           
{                                     //
	uint8_t USED;                     //                    
	uint16_t NeighborNode;            //
	uint16_t Action;                  //                  
}MatchAction_t;                       //                      
                                      //  Node's Routing Table                      
typedef struct RoutingTable           //                            
{                                     //                     
	uint16_t Count;                   //                              
	MatchAction_t MatchAction[MAX_NEIGHBORS];      //                          
}RoutingTable_t;                      //                           
//////////////////////////////////////////////////////////////


#endif /* WSNSDNTEST_H */
