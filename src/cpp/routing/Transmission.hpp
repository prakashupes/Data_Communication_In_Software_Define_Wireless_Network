#include "../network/graph.hpp"
#include "../network/Packates.hpp"
#include "../network/nodes.hpp"
#include "../logs/log.hpp"

#ifndef TRANSMIT
#define TRANSMIT


class Transmission
{
	public:
   	void startTransmission(Graph &g, Packet &packet)
   	{
   		cout<<"\nTranmission started for (packet_id) "<<packet.getId()<<"..."<<endl;
   		log::out<<"\nTranmission started for (packet_id) "<<packet.getId()<<"..."<<endl;
     		int src=packet.getSource();
      		int des=packet.getDesti();
      		
        	Node current=g.individual_Nodes[src];
        
        	while(current.Node_id!=des)
       	{
        		//cout<<current.Node_id<<endl;
        		
        		cout<<"\n*Status*\n";
        		cout<<"Packat reached at "<<current.Node_id<<endl;
        		
        		log::out<<"\n*Status*\n";
        		log::out<<"Packat reached at "<<current.Node_id<<endl;
        		//Genrate log for this packet
        		cout<<"Setting up packet as temp..."<<endl;
        		log::out<<"Setting up packet as temp..."<<endl;
        		current.tempPacket=packet;
        		
        		int nextHopeId=current.flow_rule[0].nextHope;
        		cout<<"Packat forwarded to "<<nextHopeId<<endl;
        		log::out<<"Packat forwarded to "<<nextHopeId<<endl;
            		Node nextHope=g.individual_Nodes[nextHopeId];
        		current=nextHope;	
        	
        	}
        	
        	cout<<"Packet Reached at Desination "<<current.Node_id<<endl;
        	cout<<"Setting up packet to queue...."<<endl;
        	
        	log::out<<"Packet Reached at Desination "<<current.Node_id<<endl;
        	log::out<<"Setting up packet to queue...."<<endl;
        	g.individual_Nodes[current.Node_id].packet_queue.push(packet);
        	cout<<"Packat is pushed to the destination node of main topology...."<<endl;
        	log::out<<"Packat is pushed to the destination node of main topology...."<<endl;
        	//current.packet_queue.push(packet);
        	
        	
        	
        

    }

};
#endif // TRANSMIT
