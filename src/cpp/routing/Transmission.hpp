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
        int src=packet.getSource();
        int des=packet.getDesti();
        Node current=g.individual_Nodes[src];
        do
        {
            current.nodePacket=packet;
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

        cout<<"**Transmission Success***\n Packet reached succesfully"<<endl;

        cout<<"Path info: " ;

        for(auto x:current.Routing_Table)
        {
            cout<<x.first<<" ->";
        }

        cout<<des<<endl;
        

    }

};
#endif // TRANSMIT
