#include "../network/graph.hpp"
#include "../network/Packates.hpp"
#include "../network/nodes.hpp"

#ifndef TRANSMIT
#define TRANSMIT


class Transmission
{
	public:
   	void startTransmission(Graph &g, Packet &packet)
   	{
   		cout<<"Tranmission started for (packet_id)"<<packet.getId()<<endl;
     		int src=packet.getSource();
      		int des=packet.getDesti();
      		
        	Node current=g.individual_Nodes[src];
        
        	while(current.Node_id!=des)
       	{
        		//cout<<current.Node_id<<endl;
        		
        		cout<<"*Status*\n";
        		cout<<"Packat reached at "<<current.Node_id<<endl;
        		
        		//Genrate log for this packet
        		
        		current.tempPacket=packet;
        		
        		int nextHopeId=current.flow_rule[0].nextHope;
            		Node nextHope=g.individual_Nodes[nextHopeId];
        	
        	
        		current=nextHope;	
        	
        	}
        	
        	cout<<"Packet Reached at Desination "<<current.Node_id<<endl;
        	cout<<"Setting packet to queue...."<<endl;
        	g.individual_Nodes[current.Node_id].packet_queue.push(packet);
        	cout<<"Packat is pushed to the destination node of main graph...."<<endl;
        	//current.packet_queue.push(packet);
        	
        	
        
        	
        
        
        
        /*
        do
        {
            current.tempPacket=packet;
            cout<<"\nStatus: \nPacket reached at"<<current.Node_id<<endl;
            

            int nextHopeId=current.Routing_Table[current.Node_id];
            Node nextHope=g.individual_Nodes[nextHopeId];

            cout<<"Packet Sent to"<<nextHopeId<<endl;
            if(current.range < g.adjList[current.Node_id][nextHopeId])
            {
                cout<<"\nNext Hope is out of range!!!"<<endl;
                cout<<"Packet lost at "<<current.Node_id<<endl;
                cout<<"Head Info:"<<endl;
                cout<<"Source :"<<packet.getSource()<<endl;
                cout<<"Desti: "<<packet.getDesti()<<endl;
                cout<<"Msg: "<<packet.getMessage()<<endl;

                cout<<"Transmission end!!"<<endl;

                exit(1);


            }
            else
            {
                current=nextHope;
            }



        }
        
        while(current.Node_id!=des);
        */
	/*
        cout<<"**Transmission Success***\n Packet reached succesfully"<<endl;

        cout<<"Path info: " ;

        for(auto x:current.Routing_Table)
        {
            cout<<x.first<<" ->";
        }

        cout<<des<<endl;
        */
      //  g.individual_Nodes[des].packet_queue.push(packet);
        

    }

};
#endif // TRANSMIT
