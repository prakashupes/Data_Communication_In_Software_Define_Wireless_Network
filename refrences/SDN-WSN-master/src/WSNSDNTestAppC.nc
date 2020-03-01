#include <Timer.h>
#include "WSNSDNTest.h"


configuration WSNSDNTestAppC{
}
implementation{
	
	components MainC;
	components WSNSDNTestC as App;
	components ActiveMessageC;
	components LedsC;
	
	components new TimerMilliC() as NeighborTimer;	
	components new TimerMilliC() as OneShotTimer1;
	components new TimerMilliC() as OneShotTimer2;
	components new TimerMilliC() as NetworkTimer;	
	components new TimerMilliC() as RelayTimer;
	components new TimerMilliC() as SinkTimer;
	components new TimerMilliC() as PeriodicAckTimer;
	components new TimerMilliC() as AckTimer;
	components new TimerMilliC() as SendAckTimer;
	components LocalTimeMilliC;	
	
	components new TimerMilliC() as PeriodicTimer;
	components new TimerMilliC() as PeriodicStartTimer;
	components new TimerMilliC() as DisplayTimer;
	
	
	components new AMSenderC(AM_NEIGHBORREQ) as SendNeighborREQ;
	components new AMSenderC(AM_NEIGHBORREP) as SendNeighborREP;
	components new AMSenderC(AM_NETWORK_MSG) as SendNetwork;
	components new AMSenderC(AM_NETWORK_MSG) as RelayNetwork;
	
	components new AMSenderC(AM_NODE_MSG) as SendNode;
	components new AMSenderC(AM_NODE_MSG) as SendRelayNode;
	components new AMSenderC(AM_ACK_MSG) as SendAck;
//	components new AMSenderC(AM_CONTROLLER_MSG) as SendController;   	
	
	
	components new AMReceiverC(AM_INITIALIZATION_MSG) as InitializationReceiver;
	components new AMReceiverC(AM_NEIGHBORREQ) as NeighborREQReceiver;
	components new AMReceiverC(AM_NEIGHBORREP) as NeighborREPReceiver;
	components new AMReceiverC(AM_NETWORK_MSG) as NetworkReceiver;
    components new AMReceiverC(AM_CONTROLLER_ROUTING_TABLE) as RoutingReceiver;

//	components new AMReceiverC(AM_NETWORK_MSG) as RelayReceiver;

	components new AMReceiverC(AM_NODE_MSG) as NodeReceiver;
	components new AMReceiverC(AM_ACK_MSG) as AckReceiver;
//	components new AMReceiverC(AM_CONTROLLER) as ControllerReceiver;
	
	
	
	App.Boot -> MainC;
	App.AMControl -> ActiveMessageC;
	
	App.NeighborMonitoring -> NeighborTimer;
	App.OneShotTimer1 -> OneShotTimer1;
	App.OneShotTimer2 -> OneShotTimer2;
	App.NetworkTimer -> NetworkTimer;
	App.RelayTimer -> RelayTimer;
	App.SinkTimer -> SinkTimer;
	App.PeriodicAckTimer -> PeriodicAckTimer;
	App.AckTimer -> AckTimer;
	App.SendAckTimer -> SendAckTimer;
	App.LocalTime -> LocalTimeMilliC;
	
	App.PeriodicTimer -> PeriodicTimer;
	App.PeriodicStartTimer -> PeriodicStartTimer;
	App.DisplayTimer -> DisplayTimer;
		
		
	

	App.SendNeighborREQ -> SendNeighborREQ;
	App.NeighborREQPacket -> SendNeighborREQ;
	App.NeighborREQAMPacket-> SendNeighborREQ;
	
	App.SendNeighborREP -> SendNeighborREP;
	App.NeighborREPPacket -> SendNeighborREP;
	App.NeighborREPAMPacket -> SendNeighborREP;
	
	App.SendNetwork -> SendNetwork;
	App.NetworkPacket -> SendNetwork;
	App.NetworkAMPacket -> SendNetwork;
	
	App.RelayPacket -> RelayNetwork;
	App.RelayAMPacket -> RelayNetwork;
	App.RelayNetwork -> RelayNetwork;
	
	App.NodePacket -> SendNode;
	App.NodeAMPacket -> SendNode;
	App.SendNode -> SendNode;	
	
	App.NodeRelayPacket -> SendRelayNode;
	App.NodeRelayAMPacket -> SendRelayNode;
	App.SendRelayNode -> SendRelayNode;
	
	App.AckPacket -> SendAck;
	App.AckAMPacket -> SendAck;
	App.SendAck -> SendAck;
	
//	App.SendController -> SendController;
    
    
//    App.PacketAck -> ActiveMessageC;
	App.PacketAck -> SendNeighborREQ;
	
	App.InitializationReceiver -> InitializationReceiver;
	App.NeighborREQReceiver -> NeighborREQReceiver;
	App.NeighborREPReceiver -> NeighborREPReceiver;
	App.NetworkReceiver -> NetworkReceiver;
    App.RoutingReceiver -> RoutingReceiver;
	
	
	App.NodeReceiver -> NodeReceiver;
	App.AckReceiver -> AckReceiver;
//	App.ControllerReceiver -> ControllerReceiver;	
	
	
	
}