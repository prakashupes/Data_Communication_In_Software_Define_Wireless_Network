#include "../network/graph.hpp"
#include "../network/Packet.hpp"
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
            cout<<"Status: \nPacket reached at"<<current.Node_id;
        }
        while();

    }

};
#endif // TRANSMIT
