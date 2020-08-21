#include "../network/graph.hpp"
#include "../network/Packates.hpp"
#include "../network/nodes.hpp"
#include "../logs/log.hpp"
#include <string.h>

#ifndef TRANSMIT
#define TRANSMIT


class Transmission
{
	public:
   	static void startTransmission(Graph g, Packet packet)
   	{
   		string packet_id=packet.getId();
   		string msg_id=	packet_id.substr(0,4);
   		cout<<"Tranmission started for (packet_id) "<<packet_id<<"..."<<endl;
   		log::out<<"Tranmission started for (packet_id) "<<packet_id<<"..."<<endl;
   		
   		//cout<<"Message id "<<msg_id<<endl;
     		int src=packet.getSource();
      		int des=packet.getDesti();
      		
        	Node current=g.individual_Nodes[src];
        
        	while(current.Node_id!=des)
       	{
        		//cout<<current.Node_id<<endl;
        		
        		//cout<<"\n*Status*\n";
        		//cout<<"Packat reached at "<<current.Node_id<<endl;
        		
        		//log
        		log::out<<"\n*Status*\n";
        		log::out<<"Packat reached at "<<current.Node_id<<endl;
        		
        		
        		//cout<<"Setting up packet into buffer..."<<endl;
        		log::out<<"Setting up packet into buffer..."<<endl;
        		current.buffer.push(packet);
        		
        		//Now pop front packet of buffer
        		
        		Packet process_packet=current.buffer.front();
        		current.buffer.pop();
        		packet_id=process_packet.getId();
        		
        		msg_id=process_packet.getparent_msg_id();
        		
        		//cout<<"packet pop from buffer for transmision... id: "<<packet_id<<endl;
        		log::out<<"packet pop from buffer for transmision... id: "<<packet_id<<endl;
        		
        		//cout<<"finding next hope for packet from flow rule...."<<endl;
        		
        		log::out<<"finding next hope for packet from flow rule...."<<endl;
        		
        		
   			
        		int nextHopeId=current.flow_rule[msg_id][0].nextHope;
        		
        		//check relability to send into nextHope
        		
        		float relability=(float)(rand()%10)/10;
        		//cout<<"relability "<<relability<<endl;
        		
        		if(relability > (0.8))
        		{
        			cout<<"Packat could not be sent to next hope"<<endl;
        			cout<<"Medium relability is greater then 0.8 ie "<<relability<<endl;
        			log::out<<"Packat could not be sent to next hope"<<endl;
        			log::out<<"Medium relability is greater then 0.8 ie "<<relability<<endl;
        			cout<<"Packet lost between node "<<current.Node_id<<" "<<nextHopeId<<endl;
        			log::out<<"Packet lost between node "<<current.Node_id<<" "<<nextHopeId<<endl;
        			
        			return;
        		}
        		//cout<<"Packat forwarded to "<<nextHopeId<<endl;
        		log::out<<"Packat forwarded to "<<nextHopeId<<endl;
            		Node nextHope=g.individual_Nodes[nextHopeId];
        		current=nextHope;	
        	
        	}
        	
        	//cout<<"Packet Reached at Desination "<<current.Node_id<<endl;
        	//cout<<"Setting up packet to queue...."<<endl;
        	
        	log::out<<"Packet Reached at Desination "<<current.Node_id<<endl;
        	log::out<<"Setting up packet to queue...."<<endl;
        	g.individual_Nodes[current.Node_id].packet_queue.push(packet);
        	//cout<<"Packat is pushed to the destination node of main topology...."<<endl;
        	log::out<<"Packat is pushed to the destination node of main topology...."<<endl;
        	//current.packet_queue.push(packet);
        	cout<<"Tranmission completed for packet id ="<<packet_id<<"..."<<endl;
        	log::out<<"Tranmission completed for packet id ="<<packet_id<<endl<<"...";
     
    }

};
#endif // TRANSMIT
