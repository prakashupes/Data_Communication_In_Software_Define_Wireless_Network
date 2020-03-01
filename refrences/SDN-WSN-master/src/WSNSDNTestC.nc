#include <math.h>
#include <Timer.h>
#include "WSNSDNTest.h"



module WSNSDNTestC{
	
	uses interface Boot;
	uses interface SplitControl as AMControl;
    uses interface Leds;
	uses interface PacketAcknowledgements as PacketAck;
	
	uses interface Timer<TMilli> as NeighborMonitoring;	
	uses interface Timer<TMilli> as OneShotTimer1;
	uses interface Timer<TMilli> as OneShotTimer2;
	uses interface Timer<TMilli> as NetworkTimer;
	uses interface Timer<TMilli> as RelayTimer;
	uses interface Timer<TMilli> as SinkTimer;
	uses interface Timer<TMilli> as PeriodicAckTimer;
	uses interface Timer<TMilli> as AckTimer;
	uses interface Timer<TMilli> as SendAckTimer;
	uses interface LocalTime<TMilli>;
	
	uses interface Timer<TMilli> as PeriodicTimer;
	uses interface Timer<TMilli> as PeriodicStartTimer;
	
	uses interface Timer<TMilli> as DisplayTimer;
	
	
	
	uses interface Packet as NeighborREQPacket;
	uses interface AMPacket as NeighborREQAMPacket;
	uses interface AMSend as SendNeighborREQ;
	
	uses interface Packet as NeighborREPPacket;
	uses interface AMPacket as NeighborREPAMPacket;
	uses interface AMSend as SendNeighborREP;
	
	uses interface Packet as NetworkPacket;
	uses interface AMPacket as NetworkAMPacket;
	uses interface AMSend as SendNetwork;
	
	uses interface Packet as RelayPacket;
	uses interface AMPacket as RelayAMPacket;
	uses interface AMSend as RelayNetwork;
	
	uses interface Packet as NodePacket;
	uses interface AMPacket as NodeAMPacket;
	uses interface AMSend as SendNode;
	
	uses interface Packet as NodeRelayPacket;
	uses interface AMPacket as NodeRelayAMPacket;
	uses interface AMSend as SendRelayNode;
	
	uses interface Packet as AckPacket;
	uses interface AMPacket as AckAMPacket;
	uses interface AMSend as SendAck;

//	uses interface Packet as ControllerPacket;
//	uses interface AMPacket as ControllerAMPacket;
//	uses interface AMSend as SendController;
	
	

	
	
	uses interface Receive as InitializationReceiver;
	
	uses interface Receive as NeighborREQReceiver;
	uses interface Receive as NeighborREPReceiver;
	uses interface Receive as NetworkReceiver;
	
	uses interface Receive as RoutingReceiver;
	
	uses interface Receive as NodeReceiver;
	uses interface Receive as AckReceiver;
//	uses interface Receive as ControllerReceiver;
	
	
}
implementation{
	
	enum
	{
//		MAX_NODES = 11/////////////////////////////////////////////////////////////////
        MAX_NODES = 49,/////////////////////////////////////////////////////////////////
        MAX_ACKS_ACKS = 8
	};
	
	uint16_t SINK_NODE_ID = 0x00;
//	uint16_t S_X = 10;
//	uint16_t S_Y = 10;
    uint16_t S_X = 3;
    uint16_t S_Y = 3;

	
	uint16_t HarvestingRate = 0x00;

	
	bool BUSY = FALSE;
	bool RADIO = FALSE;
	bool REQACKED = FALSE;
	bool REPACKED = FALSE;
	bool ACKED = FALSE;
	
	bool NODE = FALSE;
	bool BASESTATION = FALSE;
	bool CONTROLLER = FALSE;
	
	
	message_t pkt;
	
	Neighbor_List_t NextHop;
	Neighbor_List_t NeighborList[MAX_NEIGHBORS];
	Network_Msg_t NetworkMsg;
	
	Neighbor_List_t RelayMessage[MAX_NEIGHBORS];
	Network_Msg_t SinkMessage[MAX_NODES];
	Network_Msg_t SinkStoreMessage[MAX_NODES];
	
	RoutingTable_t RoutingTable;
	
	uint16_t SensedMessage = 0x03;                                       // = TOS_NODE_ID * HarvestingRate;
	
	uint16_t MessageSent = 0x00;
	uint16_t MessageReceived= 0x00;
	
	uint16_t REQMessageSent = 0x00;
	uint16_t REPMessageSent = 0x00;
	uint16_t NetworkMessageSent = 0x00;
	uint16_t RelayMessageSent = 0x00;
	
	uint16_t REQMessageReceived = 0x00;
	uint16_t REPMessageReceived = 0x00;
	uint16_t NetworkMessageReceived = 0x00;

	task void DoNothing();
	task void TaskSendNeighborREQ();
	task void TaskSendNeighborREP();
	task void TaskDisplayNeighbors();
	task void TaskFindNextHopToSink();
	task void TaskSendNetwork();
    task void TaskRelayNetwork();
	task void TaskDisplaySink();
	task void TaskNetworkInitialize();
	task void TaskPeriodicSensing();
	void Aggregate();
	
	void Send(uint16_t sendnode, uint16_t nodeid, uint16_t retransmissions, uint16_t sensedmsg, uint16_t count);
	void TaskSendAck(uint16_t SentNodeID, uint8_t acked);	
	
	
	
	event void Boot.booted()
	{
		dbg("WSNSDNTest", "Booted\n");
		
		call AMControl.start();
		
		if (TOS_NODE_ID == SINK_NODE_ID)
		{
			post TaskNetworkInitialize();			
		}	
		      
		SensedMessage = SensedMessage * TOS_NODE_ID;       
	}
	
	uint16_t index = 0x00;
	uint16_t index1 = 0x00;
	uint8_t ii = 0;
	task void TaskNetworkInitialize()
	{
		for(ii=0; ii<MAX_NEIGHBORS; ii++)
		{
			RoutingTable.Count = 0x00;
			RoutingTable.MatchAction[ii].USED = 0x00;
			RoutingTable.MatchAction[ii].NeighborNode = 0x00;
			RoutingTable.MatchAction[ii].Action = 0x00;
				
		}
		
		for(ii = 0 ; ii < MAX_NEIGHBORS ; ii++)
        {
        	NeighborList[ii].Neighbor_Address = 0x00;
        	NeighborList[ii].NodeID = 0x00;
        	NeighborList[ii].USED = 0x00;	
        	NeighborList[ii].N_X = 0x00;
        	NeighborList[ii].N_Y = 0x00;	
		}
		
		NextHop.Neighbor_Address = 0x00;
		NextHop.NodeID = 0x00;
		NextHop.USED = 0x00;
		NextHop.N_X = 0x00;
		NextHop.N_Y = 0x00;
		
		NetworkMsg.HostNodeID = 0x00;
		NetworkMsg.RelayNode = 0x00;
		NetworkMsg.USED = 0x00;
		for(index = 0; index<MAX_NEIGHBORS; index++)
		{
			NetworkMsg.Neighbor_List[index].Neighbor_Address = 0x00;
			NetworkMsg.Neighbor_List[index].NodeID = 0x00;
			NetworkMsg.Neighbor_List[index].USED = 0x00;
			NetworkMsg.Neighbor_List[index].N_X = 0x00;
			NetworkMsg.Neighbor_List[index].N_Y = 0x00;		
		}
		
		for(index=0; index<MAX_NEIGHBORS; index++)
		{
			RelayMessage[index].Neighbor_Address = 0x00;
			RelayMessage[index].NodeID = 0x00;
			RelayMessage[index].USED= 0x00;
			RelayMessage[index].N_X = 0x00;
			RelayMessage[index].N_Y = 0x00;
		}
		
		if(TOS_NODE_ID == SINK_NODE_ID)
		{
		for(index=0; index<MAX_NODES; index++)
		{
			SinkMessage[index].HostNodeID = 0x00;
			SinkMessage[index].RelayNode = 0x00;
			SinkMessage[index].USED = 0x00;
			
			SinkStoreMessage[index].HostNodeID = 0x00;
			SinkStoreMessage[index].RelayNode = 0x00;
			SinkStoreMessage[index].USED = 0x00;
			
			for(index1=0; index1<MAX_NEIGHBORS; index1++)
			{
				SinkMessage[index1].Neighbor_List[index1].Neighbor_Address = 0x00;
				SinkMessage[index1].Neighbor_List[index1].NodeID = 0x00;
				SinkMessage[index1].Neighbor_List[index1].USED = 0x00;
				SinkMessage[index1].Neighbor_List[index1].N_X = 0x00;
				SinkMessage[index1].Neighbor_List[index1].N_Y = 0x00;	
				
				SinkStoreMessage[index1].Neighbor_List[index1].Neighbor_Address = 0x00;
				SinkStoreMessage[index1].Neighbor_List[index1].NodeID = 0x00;
				SinkStoreMessage[index1].Neighbor_List[index1].N_X = 0x00;
				SinkStoreMessage[index1].Neighbor_List[index1].N_Y = 0x00;			
			}
		}	
		}

	}
	
	
	event void AMControl.startDone(error_t err)
	{
		if (err == SUCCESS)
		{
			dbg("WSNSDNTest", "Radio Switched On\n");
						
			RADIO = TRUE;
			
			dbg("WSNSDNTest", "\t\t\t\t\t\t\t AMControl REQ entered with Timer: %hhu \t %hhu \t %hhu\n", (TIMER_PERIODIC_MILLI), (5120*TOS_NODE_ID), 5120);
			call NeighborMonitoring.startOneShot((TIMER_ONE_SHOT*TOS_NODE_ID));//TIMER_PERIODIC_MILLI * TOS_NODE_ID + TIMER_ONE_SHOT));
            call NetworkTimer.startOneShot(TIMER_ONE_SHOT * MAX_NODES + TIMER_ONE_SHOT * TOS_NODE_ID);
            call DisplayTimer.startOneShot(TIMER_ONE_SHOT * MAX_NODES + TIMER_ONE_SHOT * TOS_NODE_ID);
		}
		else
		{
			call AMControl.start();
			RADIO = FALSE;
		}
	}
	
	event void AMControl.stopDone(error_t err)
	{}
	
	
	
	event void NeighborMonitoring.fired()
	{		
		dbg("WSNSDNTest", "NeighborMonitoring Timer REQ fired at %s\n", sim_time_string());
		post TaskSendNeighborREQ();
	}
	
	event void OneShotTimer1.fired()
	{
		dbg("WSNSDNTest", "\t\t\t\t\t\t\t OneShotTimer REQ entered\n");
		post TaskSendNeighborREQ();

	}
	
	event void OneShotTimer2.fired()
	{
		if (!REPACKED)
		{
			dbg("WSNSDNTest", "\t\t\t\t\t\t\t OneShotTimer REP entered\n");
			post TaskSendNeighborREP();
		}
		else
		{
			post DoNothing();
		}
	}
	
	event void DisplayTimer.fired()
	{
		post TaskDisplayNeighbors();
		post TaskFindNextHopToSink();	
	}
	


	uint16_t U_X = 0x00;
	uint16_t U_Y = 0x00;	
	event message_t* InitializationReceiver.receive(message_t* initMsg, void* payload, uint8_t len)
	{
		uint16_t Type;
		
		
		if (len != sizeof(initialization_msg_t))
		{
			dbg("Boot", "Nothing inside Initialization Message\n");
			return initMsg;
		}
		else
		{
			initialization_msg_t* im = (initialization_msg_t*)payload;
			U_X = im->UX;
			U_Y = im->UY;
			HarvestingRate = im->ReplenishmentRate;
			Type = im->Type;
			
			dbg("WSNSDNTest", "Initialization Message Recieved; Being Written on NOde\n");
		}
		
		dbg("Boot", "node:%hhu \t UX: %hhu \t UY: %hhu \n \t\t\t Harvesting Rate:%hhu\n \t\t\t Type:%hhu\n", TOS_NODE_ID, U_X, U_Y, HarvestingRate, Type);
		
		return initMsg;
	}
	

	
	nx_uint16_t Count;
	
	uint16_t REPnode = 0x00;
	
	event message_t* NeighborREQReceiver.receive(message_t* REQmsg, void* payload, uint8_t len)
	{
		if (len != sizeof(NeighborREQ_t))
		{
			dbg("Boot", "\t Nothing inside REQ Message\n");
			return REQmsg;		
		}
		else
		{			
			NeighborREQ_t* NREQmsg = (NeighborREQ_t*)payload;
			REPnode = NREQmsg->nodeid;
			
			dbg("WSNSDNTest", "\t Received REQ from %hhu\n", REPnode);
			
			dbg("WSNSDNTest", "\t\t\t\t\t\t\t NeighborREQReceiver REP entered\n");
			REPACKED = FALSE;
			post TaskSendNeighborREP();
			
			

		}		
		
		MessageReceived++;
		REQMessageReceived++;	
		
		return REQmsg;
		
	}
	

	uint8_t i = 0x00;
	uint16_t NeighborNode = 0x00;
	uint16_t N_X = 0x00;
	uint16_t N_Y = 0x00;
	uint8_t NoNeighbors = 0x00;
	
	bool NeighborExists = FALSE;
	
	event message_t* NeighborREPReceiver.receive(message_t* REPmsg, void* payload, uint8_t len)
	{
		if (len != sizeof(NeighborREP_t))
		{
			dbg("Boot", "\t\t Nothing inside REP Message\n");
			return REPmsg;
		}
		else
		{				
			NeighborREP_t* NREPmsg = (NeighborREP_t*)payload;
			NeighborNode = NREPmsg->nodeid;
			N_X = NREPmsg->N_X;
			N_Y = NREPmsg->N_Y;
			
						
			dbg("Boot", "REP message received from %hhu\n", NeighborNode);
			
//			Neighbor_List_t* nl = &NeighborList[i];
//			(*nl).Neighbor_Address = 0x00;
//			(*nl).NodeID = 0x00;
//			(*nl).USED = FALSE;

//            NeighborList[i].Neighbor_Address = 0x00;
//            NeighborList[i].NodeID = 0x00;
//            NeighborList[i].USED = 0x00;
//            NeighborList[i].N_X = 0x00;
//            NeighborList[i].N_Y = 0x00;

            for (index=0; index<MAX_NEIGHBORS;index++)
            {
            	if(NeighborList[index].USED)
            	{
            		if (NeighborList[index].NodeID == NeighborNode)
            	    {
            	    	NeighborExists = TRUE;
            	    }
            	}
            }
            
            if (NeighborExists == FALSE)
            {
            NeighborList[i].Neighbor_Address = i;
            NeighborList[i].NodeID = NeighborNode;
            NeighborList[i].USED = 0x01;
            NeighborList[i].N_X = N_X;
            NeighborList[i].N_Y = N_Y;
            
            	    
		    i++;
		    NoNeighbors = i;
		    }
		 }		 
		 
		 post TaskDisplayNeighbors();
		 
		 MessageReceived++;
		 REPMessageReceived++;

		return REPmsg;		
	}
	
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////	
	
	task void TaskSendNeighborREQ()
	{		
		
		NeighborREQ_t* NREQpkt = (NeighborREQ_t*)(call NeighborREQPacket.getPayload(&pkt, sizeof(NeighborREQ_t)));
		
		dbg("WSNSDNTest", "\t TaskSendNeighborREQ entered\n");
		
		if (NREQpkt == NULL)
		{
			dbg("WSNSDNTest", "\t NREQpkt is empty\n");
			return;
		}
		
		if (!BUSY)
		{
			
			NREQpkt->nodeid = TOS_NODE_ID;
		
		  
		    if (call PacketAck.requestAck(&pkt) == SUCCESS)
		    {
		    	dbg("WSNSDNTest", "SUCCESS: Ack supported\n");
		    }
		    

		    if (call SendNeighborREQ.send(AM_BROADCAST_ADDR, &pkt, sizeof(NeighborREQ_t)) == SUCCESS)
		    {
		    	dbg("WSNSDNTest", "\t REQ sent\n");
		    	BUSY = TRUE;
		    }
		}
		else
		{
			dbg("WSNSDNTest", "\t REQ not sent\n");
			call OneShotTimer1.startOneShot(TIMER_ONE_SHOT);
			
		}
		
	}
	
	event void SendNeighborREQ.sendDone(message_t* msg, error_t err)
	{
		MessageSent++;
		REQMessageSent++;
		BUSY = FALSE;
		return;
	}	
	

	task void TaskSendNeighborREP()
	{
		NeighborREP_t* NREPpkt = (NeighborREP_t*)(call NeighborREPPacket.getPayload(&pkt, sizeof(NeighborREP_t)));
		dbg("WSNSDNTest", "\t\t\t REP entered\n");
		
		if (NREPpkt == NULL)
		{
			dbg("WSNSDNTest", "\t\t\t REP message empty\n");
			return;
		}
		
		if (!BUSY)
		{
			NREPpkt->nodeid = TOS_NODE_ID;
			NREPpkt->N_X = U_X;
			NREPpkt->N_Y = U_Y;
			
			dbg("WSNSDNTest","\t\t\t REP not BUSY\n");
		
		    call PacketAck.requestAck(&pkt);
		    if (call SendNeighborREP.send(REPnode, &pkt, sizeof(NeighborREP_t)) == SUCCESS)
		    {		    	
		    	BUSY = TRUE;	
		    	dbg("WSNSDNTest", "\t\t\t REP sent to %hhu\n", REPnode);	    	
		    } 
        }   
        else
        {
        	call OneShotTimer2.startOneShot(TIMER_ONE_SHOT*TOS_NODE_ID);
        	dbg("WSNSDNTest", "\t\t\t REP OneShotTimer called\n");
        } 
    }
	
	event void SendNeighborREP.sendDone(message_t* msg, error_t err)
	{
		MessageSent++;
		REPMessageSent++;
		
		if (call PacketAck.wasAcked(msg) == TRUE)
		{
			
			REPACKED = TRUE;
		}
		else if (call PacketAck.wasAcked(msg) == FALSE)
		{	
		    if (!REPACKED)
		    {
		    	dbg("WSNSDNTest", "\t\t\t\t\t\t\t SendNeighborREP REP entered\n");
		    	post TaskSendNeighborREP();
		    }
		    else
		    {
		    	post DoNothing();
		    }
		}
		else
		{
			dbg("WSNSDNTest", "\t\t\t\t\t\t\t\t Packet Ack Undefined\n");
		}
		
		BUSY = FALSE;
		return;
	}
	
	


///////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////
	
	
		


	
	
	
	
	
	
	
	
	
	
	task void TaskDisplayNeighbors()
	{
		uint16_t j = 0x00;	
		
		for (j = 0; j < MAX_NEIGHBORS; j++)
		{
			if (NeighborList[j].USED == 0x01)
		    {
		    	dbg("Neighbors", "%hhu Neighbor List:          Time: %s\n NODE: %hhu  Neighbor Address: %hhu NodeID: %hhu  Coordinates: %hhu %hhu\n\n", NoNeighbors, sim_time_string(), TOS_NODE_ID, NeighborList[j].Neighbor_Address, NeighborList[j].NodeID, NeighborList[j].N_X, NeighborList[j].N_Y);
		    }
		    else
		    {
		    	dbg("Neighbors", "\tUNUSED: %hhu  \n \t\tNeighbor_Address:%hhu  NodeID: %hhu  X: %hhu  Y: %hhu\n", NeighborList[j].USED, NeighborList[j].Neighbor_Address, NeighborList[j].NodeID, NeighborList[j].N_X, NeighborList[j].N_Y);
		    }
		}	
	}
	
	uint16_t GeoNextHop = 0x00;
	uint16_t Neighbor_Index = 0x00;
	uint16_t u = 0x00;
	uint16_t v = 0x00;
	uint16_t w = 0x00;
	uint32_t x = 0x00;
	uint32_t y = 0x00;
	uint32_t z = 0x00;
	uint32_t zz = 0x00;
	
	task void TaskFindNextHopToSink()
	{
		uint16_t jj = 0x00;
		
		NextHop.N_X = 0x00;
		NextHop.N_Y = 0x00;
		NextHop.Neighbor_Address = 0x00;
		NextHop.NodeID = 0x00;
		NextHop.USED = 0x00;
		
		
		NextHop = NeighborList[0];
		
		if (TOS_NODE_ID == SINK_NODE_ID)
		{
			NextHop.NodeID = 0x00;
		}
		else
		{
		for(jj=0; jj<MAX_NEIGHBORS; jj++)
		{
			//dbg("Boot", "Address:%hhu, Node:%hhu, N_X: %hhu, N_Y: %hhu, Used:%hhu\n", NextHop.Neighbor_Address, NextHop.NodeID, NextHop.N_X, NextHop.N_Y, NextHop.USED);
			if (NeighborList[jj].USED == 0x01)
			{
		     	u = NeighborList[jj].N_Y;
		        v = S_Y;
		        w = NeighborList[jj].N_Y - S_Y;
		        x = pow((NeighborList[jj].N_Y - S_Y), 2);
		        y = (NeighborList[jj].N_Y - S_Y) * (NeighborList[jj].N_Y - S_Y);
		        z = sqrt( pow( (NextHop.N_X - S_X), 2) + pow( (NextHop.N_Y - S_Y), 2) );
		        zz = sqrt( pow( (NeighborList[jj+1].N_X - S_X), 2) + pow( (NeighborList[jj+1].N_Y - S_Y), 2) );
			
			    dbg("Boot", "Node: %hhu, u = %hhu, v = %hhu, w = %hhu, x = %hhu, y = %hhu, z = %hhu, zz = %hhu\n", NeighborList[jj].NodeID, u, v, w, x, y, z, zz);
			    if(NeighborList[jj+1].USED == 0x01)
			    {
				    if( zz < z)
				    {
				    	NextHop = NeighborList[jj+1];
				    }
				    
			    }
		
			}
		}
		}
				
		
		dbg("Boot", "Next Geo hop is: %hhu\n", NextHop.NodeID);
	}
	


	
	
	task void DoNothing()
	{}
	
	
	
	
	
	
	
	
	
	
	
	

//	Neighbor_List_t RelayToSinkMessage[0];
	
	
	
	uint16_t NetworkMessageNodeID = 0x00;
	uint16_t kk = 0x00;
	uint16_t kkk = 0x00;
//	Network_Msg_t SinkMessage[];
//  Network_Msg_t SinkStoreMessage[];
    uint16_t RelayNodeDebug = 0x00;////////////////////////////////Remove after debug///////////////////

	event message_t* NetworkReceiver.receive(message_t* NRmsg, void* payload, uint8_t len)
	{
		if (len != sizeof(Network_Msg_t))
		{
			dbg("Relay", "Nothing inside Network Message\n");
			return NRmsg;
		}
		else
		{
			
			Network_Msg_t* NMTmsg = (Network_Msg_t*)payload;
			
			for(kk=0; kk<MAX_NEIGHBORS; kk++)
			{
				    RelayMessage[kk].Neighbor_Address = 0x00;	
				    RelayMessage[kk].NodeID = 0x00;
				    RelayMessage[kk].USED = 0x00;
				    RelayMessage[kk].N_X = 0x00;
				    RelayMessage[kk].N_Y = 0x00;					    
			}
			

			
			if (TOS_NODE_ID != SINK_NODE_ID)
			{			
			    NetworkMessageNodeID = NMTmsg->HostNodeID;
			    dbg("Relay", "Neighbor list of Node: %hhu\n", NMTmsg->HostNodeID);
				for(kk=0; kk<MAX_NEIGHBORS; kk++)
				{			

				    if(NMTmsg->Neighbor_List[kk].USED == 0x01)
				    {
				    	{
				    		RelayMessage[kk].Neighbor_Address = NMTmsg->Neighbor_List[kk].Neighbor_Address;
				    		RelayMessage[kk].NodeID = NMTmsg->Neighbor_List[kk].NodeID;
				    		RelayMessage[kk].USED = NMTmsg->Neighbor_List[kk].USED;
				    		RelayMessage[kk].N_X = NMTmsg->Neighbor_List[kk].N_X;
				    		RelayMessage[kk].N_Y = NMTmsg->Neighbor_List[kk].N_Y;
				        }		
				        RelayNodeDebug = NMTmsg->RelayNode;
				        dbg("Relay", "Received\t\t\t\tNo.%hhu Node:%hhu USED:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);
				        dbg("Relay", "Stored  \t\t\t\tNo.%hhu Node:%hhu USED:%hhu X:%hhu Y:%hhu\n", RelayMessage[kk].Neighbor_Address, RelayMessage[kk].NodeID, RelayMessage[kk].USED, RelayMessage[kk].N_X, RelayMessage[kk].N_Y);
				    }
				    else
				    {
				    	dbg("Relay", "Received Network Message\tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);				   	
				        dbg("Relay", "Stored Network Message  \tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kk].USED, RelayMessage[kk].Neighbor_Address, RelayMessage[kk].NodeID, RelayMessage[kk].N_X, RelayMessage[kk].N_Y);
				    }
				}
				
				dbg("Relay", "Network Message of %hhu received from node:%hhu.\n", NetworkMessageNodeID, RelayNodeDebug);
			    
			    //TaskRelayNetwork();	
			    call RelayTimer.startOneShot(TIMER_ONE_SHOT);
			}
			else
			{
				
				dbg("Boot", "Message Received from %hhu of %hhu\n", 
				                                        NMTmsg->RelayNode,
				                                        NMTmsg->HostNodeID);
				for(kk=0; kk<MAX_NODES; kk++)
				{
					dbg("Boot", "\t\tNo.%hhu ID:%hhu USED:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].Neighbor_Address,
					                                                             NMTmsg->Neighbor_List[kk].NodeID,
					                                                             NMTmsg->Neighbor_List[kk].USED,
					                                                             NMTmsg->Neighbor_List[kk].N_X,
					                                                             NMTmsg->Neighbor_List[kk].N_Y);
				}
				
				
				dbg("Sink", "Node: %hhu\n", NMTmsg->HostNodeID);
				
				SinkStoreMessage[NMTmsg->HostNodeID].HostNodeID = NMTmsg->HostNodeID;
				SinkStoreMessage[NMTmsg->HostNodeID].RelayNode = NMTmsg->RelayNode;
				SinkStoreMessage[NMTmsg->HostNodeID].NoNeighbors = NMTmsg->NoNeighbors;
				for (kk=0; kk<MAX_NODES; kk++)
				{
					
				
					if(NMTmsg->Neighbor_List[kk].USED == 0x01)
				    {
				    	{
				    		RelayMessage[kk].Neighbor_Address = NMTmsg->Neighbor_List[kk].Neighbor_Address;
				    		RelayMessage[kk].NodeID = NMTmsg->Neighbor_List[kk].NodeID;
				    		RelayMessage[kk].USED = NMTmsg->Neighbor_List[kk].USED;
				    		RelayMessage[kk].N_X = NMTmsg->Neighbor_List[kk].N_X;
				    		RelayMessage[kk].N_Y = NMTmsg->Neighbor_List[kk].N_Y;
				        }		
				        RelayNodeDebug = NMTmsg->RelayNode;
//				        dbg("Sink", "\tSink Message Received  No.%hhu Node:%hhu USED:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);
//				        dbg("Sink", "\tSink Message Stored    No.%hhu Node:%hhu USED:%hhu X:%hhu Y:%hhu\n", RelayMessage[kk].Neighbor_Address, RelayMessage[kk].NodeID, RelayMessage[kk].USED, RelayMessage[kk].N_X, RelayMessage[kk].N_Y);
				    }
				    
				    else
				    {
//				    	dbg("Sink", "Sink Message Received Message  UNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);				   	
//				        dbg("Sink", "Sink Message Stored Message    UNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kk].USED, RelayMessage[kk].Neighbor_Address, RelayMessage[kk].NodeID, RelayMessage[kk].N_X, RelayMessage[kk].N_Y);
				    }
				    
				    SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].Neighbor_Address = NMTmsg->Neighbor_List[kk].Neighbor_Address;
				    SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].NodeID = NMTmsg->Neighbor_List[kk].NodeID;
				    SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].USED = NMTmsg->Neighbor_List[kk].USED;
				    SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].N_X = NMTmsg->Neighbor_List[kk].N_X;
				    SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].N_Y = NMTmsg->Neighbor_List[kk].N_Y;
				    
				    if(SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].USED == 0x01)
				    {

				        dbg("Sink", "\t\tStoreSink Message Stored  No.%hhu Node:%hhu USED:%hhu X:%hhu Y:%hhu\n", SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].Neighbor_Address,
				                                                                                                 SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].NodeID,
				                                                                                                 SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].USED,
				                                                                                                 SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].N_X,
				                                                                                                 SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].N_Y);
				        dbg("Sink", "\t\tStoreSink Relayed    No.%hhu Node:%hhu USED:%hhu X:%hhu Y:%hhu\n", RelayMessage[kk].Neighbor_Address, 
				                                                                                           RelayMessage[kk].NodeID, 
				                                                                                           RelayMessage[kk].USED, 
				                                                                                           RelayMessage[kk].N_X, 
				                                                                                           RelayMessage[kk].N_Y);
				    }
				    
				    else
				    {
				    	dbg("Sink", "StoreSink Message Received  UNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].Neighbor_Address,
				                                                                                                 SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].NodeID,
				                                                                                                 SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].USED,
				                                                                                                 SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].N_X,
				                                                                                                 SinkStoreMessage[NMTmsg->HostNodeID].Neighbor_List[kk].N_Y);					   	
				        dbg("Sink", "StoreSink Message Stored    UNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kk].USED, RelayMessage[kk].Neighbor_Address, RelayMessage[kk].NodeID, RelayMessage[kk].N_X, RelayMessage[kk].N_Y);
				    }
				    
				 
	
				}
				
				
				
				
				SinkMessage[NMTmsg->HostNodeID].HostNodeID = NMTmsg->HostNodeID;
				SinkMessage[NMTmsg->HostNodeID].USED = 0x01;
				for(kk=0; kk<MAX_NEIGHBORS; kk++)
				{
					SinkMessage[NMTmsg->HostNodeID].Neighbor_List[kk] = NMTmsg->Neighbor_List[kk];
				}
				
				
				
//					SinkMessage[kkk].HostNodeID = NMTmsg->HostNodeID;
//				    SinkMessage[kkk].USED = 0x01;
//				    for(kk=0; kk<MAX_NEIGHBORS; kk++)
//				    {
//				    	SinkMessage[kkk].Neighbor_List[kk] = NMTmsg->Neighbor_List[kk];
//				    }
//				
				kkk++;
				//post TaskDisplaySink();
//				call SinkTimer.startOneShot(TIMER_PERIODIC_MILLI * 8);
			}
			
		}
		
		MessageReceived++;
		NetworkMessageReceived++;
	
		return NRmsg;
	}
	
//	uint16_t tt = 0x00;
//    uint16_t ttt = 0x00;
	task void TaskDisplaySink()
	{	
//		for(tt=0; tt<MAX_NODES; tt++)
//		{
//			
//			dbg("Sink", "Node:%hhu %s\n", SinkMessage[tt].HostNodeID, sim_time_string());
//			if(SinkMessage[tt].USED == 0x01)
//			{
//			for (ttt= 0; ttt<MAX_NEIGHBORS; ttt++)
//			{
//				if (SinkMessage[tt].Neighbor_List[ttt].USED == 0x01)
//				{
//					dbg("Sink", "%hhu %hhu\t\t\t%hhu. Neighbor: %hhu \t X:%hhu Y:%hhu\n", tt, ttt, SinkMessage[tt].Neighbor_List[ttt].Neighbor_Address, SinkMessage[tt].Neighbor_List[ttt].NodeID, SinkMessage[tt].Neighbor_List[ttt].N_X, SinkMessage[tt].Neighbor_List[ttt].N_Y);
//                }  			                
//			}
//			}
//		}		
	}
	
	event void SinkTimer.fired()
	{
//		dbg("Sink", "Timer Started at %s\n", sim_time_string());
//		post TaskDisplaySink();
	}
	
	event void NetworkTimer.fired()
	{		
		if (TOS_NODE_ID != SINK_NODE_ID)
		{
			post TaskSendNetwork();
		}	
	}
	
	
	uint16_t k = 0x00;
	
	task void TaskSendNetwork()
	{
		Network_Msg_t* NMpkt = (Network_Msg_t*)(call NetworkPacket.getPayload(&pkt, sizeof(Network_Msg_t)));
		dbg("Relay", "\t Network Msg entered at %s\n", sim_time_string());
		
		if(NMpkt == NULL)
		{
			dbg("Relay", "\t Network Msg empty\n");
		}
		
		if (!BUSY)
		{
			NMpkt->HostNodeID = TOS_NODE_ID;
			NMpkt->USED = 0x00;
			NMpkt->NoNeighbors = NoNeighbors;
			for(k=0; k<MAX_NEIGHBORS; k++)
			{
				if(NeighborList[k].USED == 0x01)
				{
					NMpkt->Neighbor_List[k].Neighbor_Address = NeighborList[k].Neighbor_Address;
					NMpkt->Neighbor_List[k].NodeID = NeighborList[k].NodeID;
					NMpkt->Neighbor_List[k].USED = 0x01;
					NMpkt->Neighbor_List[k].N_X = NeighborList[k].N_X;
					NMpkt->Neighbor_List[k].N_Y = NeighborList[k].N_Y;
					
				} 
//				else
//				{
//					NMpkt->Neighbor_List[k].Neighbor_Address = 0x22;
//					NMpkt->Neighbor_List[k].NodeID = 0x22;
//					NMpkt->Neighbor_List[k].USED = 0x22;
//					NMpkt->Neighbor_List[k].N_X = 0x22;
//					NMpkt->Neighbor_List[k].N_Y = 0x22;
//				}
			}	
			NMpkt->RelayNode = TOS_NODE_ID;		 
			
		      
			
			call PacketAck.requestAck(&pkt);
			if(call SendNetwork.send(NextHop.NodeID, &pkt, sizeof(Network_Msg_t)) == SUCCESS)
			{
				BUSY = TRUE;
				dbg("Relay", "\t\t\t  jnjbcejbvebvejbv Network Msg sent from %hhu to %hhu\n", NMpkt->HostNodeID, NextHop.NodeID);
				for (k=0; k<MAX_NEIGHBORS; k++)
			    {
			    	if (NMpkt->Neighbor_List[k].USED == 0x01)///////////
			    	{
			    	dbg("Relay", "Network Message from node:%hhu\n No.%hhu. %hhu  Neighbor: %hhu X:%hhu, Y:%hhu\n", NMpkt->HostNodeID, NMpkt->Neighbor_List[k].Neighbor_Address, NMpkt->Neighbor_List[k].USED, NMpkt->Neighbor_List[k].NodeID, NMpkt->Neighbor_List[k].N_X, NMpkt->Neighbor_List[k].N_Y);
			        }
			        else
			        {
			        	dbg("Relay", "UNUSED:%hhu No.%hhu Neighbor:%hhu X:%hhu Y:%hhu\n", NMpkt->Neighbor_List[k].USED, NMpkt->Neighbor_List[k].Neighbor_Address, NMpkt->Neighbor_List[k].NodeID, NMpkt->Neighbor_List[k].N_X, NMpkt->Neighbor_List[k].N_Y);
			        }
			    } 
			}
			
		}
		else
		{
			call NetworkTimer.startOneShot(TIMER_ONE_SHOT * TOS_NODE_ID);
			dbg("Relay", "Network busy: Tiemr entered again\n");
		}
		
	}

	event void SendNetwork.sendDone(message_t* msg, error_t err)
	{
		MessageSent++;
		NetworkMessageSent++;
		
		if(call PacketAck.wasAcked(msg) == TRUE)
		{
						
		}
		else
		{
			call NetworkTimer.startOneShot(TIMER_ONE_SHOT * TOS_NODE_ID);
			dbg("Relay", "Network msg not acked; sent again\n");
		}
		BUSY = FALSE;
		return;			
	}
	
	uint16_t kkkk = 0x00;

	task void TaskRelayNetwork()
	{
		Network_Msg_t* NMRpkt = (Network_Msg_t*)(call RelayPacket.getPayload(&pkt, sizeof(Network_Msg_t)));
		
		if (NMRpkt == NULL)
		{
			dbg("Relay", "Network relay empty\n");
		}
		
//		for(kkkk=0; kkkk<MAX_NEIGHBORS; kkkk++)
//		{
//			//dbg("Relay", "Received Network Message\tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);				   	
//			dbg("Relay", "SENDRELAY: Stored Network Message  \tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kkkk].USED, RelayMessage[kkkk].Neighbor_Address, RelayMessage[kkkk].NodeID, RelayMessage[kkkk].N_X, RelayMessage[kkkk].N_Y);
//		}
		
		if (!BUSY)
		{
//			for(kkkk=0; kkkk<MAX_NEIGHBORS; kkkk++)
//		    {
//			//dbg("Relay", "Received Network Message\tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);				   	
//			dbg("Relay", "\t 1 SENDRELAY: Stored Network Message  \tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kkkk].USED, RelayMessage[kkkk].Neighbor_Address, RelayMessage[kkkk].NodeID, RelayMessage[kkkk].N_X, RelayMessage[kkkk].N_Y);
//		    }
		    
		    NMRpkt->HostNodeID = 0x00;
		    NMRpkt->RelayNode = 0x00;
		    NMRpkt->NoNeighbors = 0x00;
		    NMRpkt->USED = 0x00;
		    for(kk=0; kk<MAX_NEIGHBORS; kk++)
		    {
		    	NMRpkt->Neighbor_List[kk].Neighbor_Address = 0x00;
		    	NMRpkt->Neighbor_List[kk].NodeID = 0x00;
		    	NMRpkt->Neighbor_List[kk].USED = 0x00;
		    	NMRpkt->Neighbor_List[kk].N_X = 0x00;
		    	NMRpkt->Neighbor_List[kk].N_Y = 0x00;
		    }
		
		
			NMRpkt->HostNodeID = NetworkMessageNodeID;
			for (kk = 0; kk < MAX_NEIGHBORS; kk++)
			{
//				for(kkkk=0; kkkk<MAX_NEIGHBORS; kkkk++)
//		        {
//			     //dbg("Relay", "Received Network Message\tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);				   	
//			     dbg("Relay", "\t\t 2 SENDRELAY: Stored Network Message  \tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kkkk].USED, RelayMessage[kkkk].Neighbor_Address, RelayMessage[kkkk].NodeID, RelayMessage[kkkk].N_X, RelayMessage[kkkk].N_Y);
//		        }
				/////////////////////////////////////////INsert one more for loop and store the neighbor list again//
				if(RelayMessage[kk].USED == 0x01)
				{
//					for(kkkk=0; kkkk<MAX_NEIGHBORS; kkkk++)
//		            {
//			           //dbg("Relay", "Received Network Message\tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);				   	
//			           dbg("Relay", "\t\t\t 3 SENDRELAY: Stored Network Message  \tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kkkk].USED, RelayMessage[kkkk].Neighbor_Address, RelayMessage[kkkk].NodeID, RelayMessage[kkkk].N_X, RelayMessage[kkkk].N_Y);
//		            }
				NMRpkt->Neighbor_List[kk].Neighbor_Address = RelayMessage[kk].Neighbor_Address;
				NMRpkt->Neighbor_List[kk].NodeID = RelayMessage[kk].NodeID;
				NMRpkt->Neighbor_List[kk].USED = RelayMessage[kk].USED;
				NMRpkt->Neighbor_List[kk].N_X = RelayMessage[kk].N_X;
				NMRpkt->Neighbor_List[kk].N_Y = RelayMessage[kk].N_Y; 
				}
//				else
//				{
//					NMRpkt->Neighbor_List[kk].Neighbor_Address = 0x24;
//					NMRpkt->Neighbor_List[kk].NodeID = 0x24;
//					NMRpkt->Neighbor_List[kk].USED = 0x24;
//					NMRpkt->Neighbor_List[kk].N_X = 0x24;
//					NMRpkt->Neighbor_List[kk].N_Y = 0x24;
//				}
			}
			NMRpkt->RelayNode = TOS_NODE_ID;
			
//			for(kkkk=0; kkkk<MAX_NEIGHBORS; kkkk++)
//		    {
//			//dbg("Relay", "Received Network Message\tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);				   	
//			dbg("Relay", "\t\t\t\t 4 SENDRELAY: Stored Network Message  \tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kkkk].USED, RelayMessage[kkkk].Neighbor_Address, RelayMessage[kkkk].NodeID, RelayMessage[kkkk].N_X, RelayMessage[kkkk].N_Y);
//		    }
			
			call PacketAck.requestAck(&pkt);
			if (call RelayNetwork.send(NextHop.NodeID, &pkt, sizeof(Network_Msg_t)) == SUCCESS)
			{
//				for(kkkk=0; kkkk<MAX_NEIGHBORS; kkkk++)
//		        {
//			     //dbg("Relay", "Received Network Message\tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);				   	
//			     dbg("Relay", "\t\t\t\t\t 5 SENDRELAY: Stored Network Message  \tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kkkk].USED, RelayMessage[kkkk].Neighbor_Address, RelayMessage[kkkk].NodeID, RelayMessage[kkkk].N_X, RelayMessage[kkkk].N_Y);
//		         dbg("Relay", "\t\t\t\t\t 5 RELAYSENT: Sent Relay Message      \tUNUSED:%hhu No.%hhu NOde:%hhu X:%hhu Y:%hhu\n", NMRpkt->Neighbor_List[kkkk].USED, NMRpkt->Neighbor_List[kkkk].Neighbor_Address, NMRpkt->Neighbor_List[kkkk].NodeID, NMRpkt->Neighbor_List[kkkk].N_X, NMRpkt->Neighbor_List[kkkk].N_Y);
//		        }
		
				BUSY = TRUE;/////////////////////
				dbg("Relay", "\t\t\t\t  kefbjejfbkfeekcjw  Network message of %hhu relayed from %hhu\n",NMRpkt->HostNodeID, TOS_NODE_ID);
			
				for (kk=0; kk<MAX_NEIGHBORS; kk++)
			    {
//			    	for(kkkk=0; kkkk<MAX_NEIGHBORS; kkkk++)
//		            {
//			           //dbg("Relay", "Received Network Message\tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);				   	
//			           dbg("Relay", "\t\t\t\t\t\t 6 SENDRELAY: Stored Network Message  \tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kkkk].USED, RelayMessage[kkkk].Neighbor_Address, RelayMessage[kkkk].NodeID, RelayMessage[kkkk].N_X, RelayMessage[kkkk].N_Y);
//		            }
			    	
			    	if (NMRpkt->Neighbor_List[kk].USED == 0x01)///////////
			    	{
			    	dbg("Relay", "\t\tRelay Message from node:%hhu No.%hhu. %hhu\t\tNeighbor: %hhu X:%hhu, Y:%hhu\n", NMRpkt->HostNodeID, NMRpkt->Neighbor_List[kk].Neighbor_Address, NMRpkt->Neighbor_List[kk].USED, NMRpkt->Neighbor_List[kk].NodeID, NMRpkt->Neighbor_List[kk].N_X, NMRpkt->Neighbor_List[kk].N_Y);
			        dbg("Relay", "\t\tRelay Message stored         No.%hhu. %hhu\t\tNeighbor: %hhu X:%hhu, Y:%hhu\n", RelayMessage[kk].Neighbor_Address, RelayMessage[kk].USED, RelayMessage[kk].NodeID, RelayMessage[kk].N_X, RelayMessage[kk].N_Y);
			        }
			        else
			        {
			        	dbg("Relay", "Changed realy message\tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", NMRpkt->Neighbor_List[kk].USED, NMRpkt->Neighbor_List[kk].Neighbor_Address, NMRpkt->Neighbor_List[kk].NodeID, NMRpkt->Neighbor_List[kk].N_X, NMRpkt->Neighbor_List[kk].N_Y);
			            dbg("Relay", "ChangedStored Message\tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kk].USED, RelayMessage[kk].Neighbor_Address, RelayMessage[kk].NodeID, RelayMessage[kk].N_X, RelayMessage[kk].N_Y);
			        }
			        
//			        for(kkkk=0; kkkk<MAX_NEIGHBORS; kkkk++)
//		            {
//			          //dbg("Relay", "Received Network Message\tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);				   	
//			          dbg("Relay", "\t\t\t\t\t\t\t 7 SENDRELAY: Stored Network Message  \tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kkkk].USED, RelayMessage[kkkk].Neighbor_Address, RelayMessage[kkkk].NodeID, RelayMessage[kkkk].N_X, RelayMessage[kkkk].N_Y);
//		            }
			    } 
//			        for(kkkk=0; kkkk<MAX_NEIGHBORS; kkkk++)
//		            {
//			          //dbg("Relay", "Received Network Message\tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", NMTmsg->Neighbor_List[kk].USED, NMTmsg->Neighbor_List[kk].Neighbor_Address, NMTmsg->Neighbor_List[kk].NodeID, NMTmsg->Neighbor_List[kk].N_X, NMTmsg->Neighbor_List[kk].N_Y);				   	
//			          dbg("Relay", "\t\t\t\t\t\t\t\t 8 SENDRELAY: Stored Network Message  \tUNUSED:%hhu No.%hhu Node:%hhu X:%hhu Y:%hhu\n", RelayMessage[kkkk].USED, RelayMessage[kkkk].Neighbor_Address, RelayMessage[kkkk].NodeID, RelayMessage[kkkk].N_X, RelayMessage[kkkk].N_Y);
//		            }
			
			}
		}
		
		return;
	}
	
	event void RelayNetwork.sendDone(message_t* msg, error_t err)
	{
		MessageSent++;
		RelayMessageSent++;
		
		if(call PacketAck.wasAcked(msg) == TRUE)
		{
						
		}
		else
		{
			call RelayTimer.startOneShot(TOS_NODE_ID * TIMER_ONE_SHOT);
			dbg("Relay", "Network message not forwarded; send again\n");
		}
		
		BUSY = FALSE;
		return;
	}
	
	event void RelayTimer.fired()
	{
		post TaskRelayNetwork();
		dbg("Relay", "RelayTimer fired\n");
	}

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	uint16_t f = 0x00;
	event message_t* RoutingReceiver.receive(message_t* routeMsg, void* payload, uint8_t len)
	{
		if (len != sizeof(Controller_Routing_Table_t))
		{
			dbg("Periodic", "Nothing inside Routing Msg\n");
			return routeMsg;
		}
		else
		{
			Controller_Routing_Table_t* crt = (Controller_Routing_Table_t*)payload;
			
			for(f=0; f<MAX_NEIGHBORS; f++)
			{
				RoutingTable.MatchAction[f].USED = crt->NeighborAction[f].USED;
				RoutingTable.MatchAction[f].NeighborNode = crt->NeighborAction[f].NeighborNode;
				RoutingTable.MatchAction[f].Action = crt->NeighborAction[f].Action;
				
			}
		}
		dbg("Boot", "\nMessage Sent:%hhu  Message Received:%hhu\n", MessageSent, MessageReceived);
		dbg("Boot", "REQSent:%hhu REPSent:%hhu NetworkSent:%hhu RelaySent:%hhu\n", REQMessageSent, REPMessageSent, NetworkMessageSent, RelayMessageSent);
		dbg("Boot", "REQReceived:%hhu REPReceived:%hhu NetworkReceived:%hhu\n", REQMessageReceived, REPMessageReceived, NetworkMessageReceived);
		dbg("Discovery", "%hhu %hhu %hhu\n", TOS_NODE_ID, MessageSent, MessageReceived);
		// "%hhu %hhu\n", MessageSent, MessageReceived);
		dbg("Periodic","Routing Table:\n");
		for (f=0; f<MAX_NEIGHBORS; f++){
		dbg("Periodic", "USED:%hhu   Neighbor Node: %hhu \t Action: %hhu\n", RoutingTable.MatchAction[f].USED, RoutingTable.MatchAction[f].NeighborNode, RoutingTable.MatchAction[f].Action);
		}
		
		if (TOS_NODE_ID != SINK_NODE_ID)
		{
			//call PeriodicTimer.startPeriodic(TIMER_PERIODIC_MILLI * 20);
			call PeriodicStartTimer.startOneShot(TIMER_ONE_SHOT * 4 * TOS_NODE_ID);
		}
		
		return routeMsg;
	}
	
	
	
	
	
	
	
	
	
	
	uint16_t TotalMessages = 0x00;
	uint16_t SentMessages = 0x00;
	uint16_t Acknowledged = 0x00;
	uint16_t Retransmissions = 0x00;
	
	uint16_t TotalRelayed = 0x00;
	uint16_t RelayAcknowledged = 0x00;
	uint16_t TotalRelayRetransmissions = 0x00;
	
	uint16_t TotalAcked = 0x00;
	uint16_t AckedAcked = 0x00;
	uint16_t AckedRetransmissions = 0x00;
	event void PeriodicStartTimer.fired()
	{
		call PeriodicTimer.startPeriodic(TIMER_PERIODIC_MILLI);	    
	}
	uint16_t counter = 0x00;
	event void PeriodicTimer.fired()
	{
		ACKED = FALSE;
		
		dbg("Periodic", "Periodic Timer at %s \n", sim_time_string());
		dbg("Ack", "Periodic Timer at %s\n", sim_time_string());
		dbg("PeriodicSink", "Periodic Timer at %s \n", sim_time_string());
		if (TOS_NODE_ID == 0x01){dbg("PeriodicSink", "\t\t\t\t\t Node 1 Periodic Timer\n");}
		dbg("Periodic", "\t\t\t\t\t\tTotal Messages:%hhu Total Relayed: %hhu Sent Messages:%hhu \t \n Acknowledged: %hhu RelayAcknowledged: %hhu Retansmissions: %hhu RelayRetransmissions: %hhu\t\tCounter: %hhu \t\tAckedAcked:%hhu AckedRetransmissions:%hhu TotalAcked:%hhu \n",TotalMessages, TotalRelayed, SentMessages, Acknowledged, RelayAcknowledged, Retransmissions, TotalRelayRetransmissions, counter, AckedAcked, AckedRetransmissions, TotalAcked);
	    dbg("Data", "%hu %hu %hu %hu %hu %hu %hu %hu %hu %hu %hu\n", TOS_NODE_ID, counter, TotalMessages, Acknowledged, Retransmissions, TotalRelayed, RelayAcknowledged, TotalRelayRetransmissions, TotalAcked, AckedAcked, AckedRetransmissions);
		counter++;
		post TaskPeriodicSensing();	
	}
	
	

	task void TaskPeriodicSensing()
	{
		node_msg_t* nmtpkt = (node_msg_t*)(call NodePacket.getPayload(&pkt, sizeof(node_msg_t)));
		dbg("Periodic", "Sensing Entered\n");
		
		if (nmtpkt == NULL)
		{
			dbg("Periodic", "Sensed message empty\n");
		    return;
		}
		
		if (!BUSY)
		{
			nmtpkt->SentNode = TOS_NODE_ID;
			nmtpkt->NodeID = TOS_NODE_ID;
			nmtpkt->Retransmissions = Retransmissions;
			nmtpkt->SensedMsg = SensedMessage;
			nmtpkt->Count = counter;
			
			ACKED = FALSE;
			if(call SendNode.send(AM_BROADCAST_ADDR, &pkt, sizeof(node_msg_t)) == SUCCESS)
			{
				BUSY = TRUE;
				SentMessages++;
				dbg("Periodic", "\t Sensed Message Sent from node:%hhu Sensed Message: %hhu Count: %hhu\n", nmtpkt->NodeID, nmtpkt->SensedMsg, nmtpkt->Count);
			}
		}
	}
	
	event void SendNode.sendDone(message_t* msg, error_t err)
	{
		TotalMessages++;
		if (ACKED == TRUE)
		{
			Acknowledged++;		
		}
		else
		{
			dbg("Ack", "Not acked; Timer Entered\n");
			call PeriodicAckTimer.startOneShot(TIMER_ONE_SHOT);
			//call AckTimer.startOneShot(TIMER_ONE_SHOT);
			//Send(RelaySensedNode);
		}
		
		BUSY = FALSE;	
		return;
	}	
	
	event void PeriodicAckTimer.fired()
	{
		if(ACKED == TRUE)
		{
			Acknowledged++;
		}
		else
		{
			Retransmissions++;
			post TaskPeriodicSensing();
		}
		
	}
	
	
	
	uint8_t acks_acks = 0x00;
	
	
	
	uint16_t RelaySentNode = 0x00;
	uint16_t RelaySensedNode = 0x00;
	uint16_t RelayRetransmissions = 0x00;
	uint16_t RelaySensedMsg = 0x00;
	uint16_t RelayCount = 0x00;
	uint16_t ff = 0x00;
	event message_t* NodeReceiver.receive(message_t* nodeMsg, void* payload, uint8_t len)
	{
		RelaySensedNode = 0x00;
		SensedMessage = 0x03 * TOS_NODE_ID;
		RelaySensedMsg = 0x00;
		acks_acks = 0x00;
		
		if (len != sizeof(node_msg_t))
		{
			dbg("Periodic", "Nothing inside Sensing Message\n");
			return nodeMsg;
		}
		else
		{
			
			node_msg_t* nm = (node_msg_t*)payload;
			RelaySentNode = nm->SentNode;
			RelaySensedNode = nm->NodeID;
			RelayRetransmissions = nm->Retransmissions;
			RelaySensedMsg = nm->SensedMsg;	
			RelayCount = nm->Count;

			dbg("Periodic", "\t\t\t\tPeriodic message received from Node: %hhu \n \t\t Node: %hhu \n \t\t Retranmissions: %hhu \n \t\t Sensed Message: %hhu\n", RelaySentNode, RelaySensedNode, RelayRetransmissions, RelaySensedMsg);
//					dbg("Periodic","Routing Table:\n");
//					for (f=0; f<MAX_NEIGHBORS; f++){
//		dbg("Periodic", "USED:%hhu   Neighbor Node: %hhu \t Action: %hhu\n", RoutingTable.MatchAction[f].USED, RoutingTable.MatchAction[f].NeighborNode, RoutingTable.MatchAction[f].Action);
//		}
//		dbg("Periodic","Routing Table:\n");
			for(ff=0; ff<MAX_NEIGHBORS; ff++)
			{
//						for (f=0; f<MAX_NEIGHBORS; f++){
//		dbg("Periodic", "USED:%hhu   Neighbor Node: %hhu \t Action: %hhu\n", RoutingTable.MatchAction[f].USED, RoutingTable.MatchAction[f].NeighborNode, RoutingTable.MatchAction[f].Action);
//		}
		
				if (RoutingTable.MatchAction[ff].USED == 1)
				{
				if (RelaySentNode == RoutingTable.MatchAction[ff].NeighborNode)
				{
					dbg("Periodic", "\t\t\t\tMessage Sent from Node: %hhu Routing table:   Node: %hhu Action:%hhu\n", RelaySentNode, RoutingTable.MatchAction[ff].NeighborNode, RoutingTable.MatchAction[ff].Action);
					switch(RoutingTable.MatchAction[ff].Action)
					{
						case (0):
					    {
					    	dbg("Periodic", "\t\t\t\t\t\t\t\t\t\t\tDo Nothing\n");
						    post DoNothing();
						    return nodeMsg;
						}
					    case (1):
					    {
						    dbg("Periodic", "\t\t\t\t\t\t\t\t\t\t\tSend\n");
						    TaskSendAck(RelaySentNode, 0x01);
						    Send(nm->SentNode, nm->NodeID, nm->Retransmissions, nm->SensedMsg, nm->Count);
						    return nodeMsg;
					    }
				     	case (2):
					    {
						    dbg("Periodic", "\t\t\t\t\t\t\t\t\t\t\tAggregate : %hhu\n", RelaySensedMsg);
						    TaskSendAck(RelaySentNode, 0x01);
						    Aggregate();
						    dbg("PeriodicSink", "RelaySensedMsg: %hhu\n", RelaySensedMsg);
						   // RelaySensedMsg = SensedMessage + RelaySensedMsg;
						    Send(nm->SentNode, nm->NodeID, nm->Retransmissions, RelaySensedMsg, nm->Count);
						    return nodeMsg;
					    }
					    case (3):
					    {
					    	TaskSendAck(RelaySentNode, 0x01);
						    if (TOS_NODE_ID == SINK_NODE_ID)
						    {
						    	dbg("PeriodicSink", "Acked:%hhu\t\t\t\t\t\t\t\t\tPeriodic Message received from %hhu \n \t\t\t\t\tNode:%hhu Retransmissions:%hhu SensedMsg:%hhu Count:%hhu\n", ACKED, RelaySentNode, RelaySensedNode, RelayRetransmissions, RelaySensedMsg, RelayCount);
						    	dbg("SinkData", "Node:%hu Count:%hu SensedMsg:%hu Sent From:%hu\n", nm->NodeID, nm->Count, nm->SensedMsg, nm->SentNode);
			                }		
			                return nodeMsg;
			      		}
					}
					
				}
				}
			}	
		}
	
	    return nodeMsg;
	}
	
	void Aggregate()
	{
//		atomic{
		RelaySensedMsg = SensedMessage + RelaySensedMsg;
//		}
		dbg("PeriodicSink", "Aggregate: RelaySensedMsg:%hhu\n", RelaySensedMsg);
	
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	uint16_t relaysentnode = 0x00;
	uint16_t relaynodeid = 0x00;
	uint16_t relayretransmissions = 0x00;
	uint16_t relaysensedmsg = 0x00;
	uint16_t relaycount = 0x00;
	
	
	
	void Send(uint16_t sensednode, uint16_t nodeid, uint16_t retransmissions, uint16_t sensedmsg, uint16_t count)
	{
		node_msg_t* nmtpkt = (node_msg_t*)(call NodeRelayPacket.getPayload(&pkt, sizeof(node_msg_t)));
		
		if (nmtpkt == NULL)
		{			
			dbg("Periodic", "Relay Sensed Message is empty\n");
			return;
		}
		
		nmtpkt->SentNode = TOS_NODE_ID;
		nmtpkt->NodeID = nodeid;
		nmtpkt->Retransmissions = retransmissions;
		nmtpkt->SensedMsg = sensedmsg;
		nmtpkt->Count = count;
		
		relaysentnode = nmtpkt->SentNode;
		relaynodeid = nmtpkt->NodeID;
		relayretransmissions = nmtpkt->Retransmissions;
		relaysensedmsg = nmtpkt->SensedMsg;
		relaycount = nmtpkt->Count;
		
		ACKED = FALSE;
		if (call SendRelayNode.send(AM_BROADCAST_ADDR, &pkt, sizeof(node_msg_t)))
		{
			dbg("PeriodicSink", "\t\t\t\t\t\t\t\t\t Message sent from node: %hhu \t\t node: %hhu with data: %hhu count:%hhu\n", nmtpkt->SentNode, nmtpkt->NodeID, nmtpkt->SensedMsg, nmtpkt->Count);
			SentMessages++;
			BUSY = TRUE;
		}
	}
	
	event void SendRelayNode.sendDone(message_t* msg, error_t err)
	{
		dbg("Sink", "\t\t\t Relay send done : Total:%hhu Acked:%hhu Retransmistted: %hhu\n", TotalRelayed, RelayAcknowledged, TotalRelayRetransmissions);
		TotalRelayed++;
		dbg("Sink", "\t\t\t Relay send done : Total:%hhu Acked:%hhu Retransmistted: %hhu\n", TotalRelayed, RelayAcknowledged, TotalRelayRetransmissions);
		if (ACKED == TRUE)
		{
			dbg("Sink", "Relay ACKED\n");
			dbg("Sink", "\t\t\t Relay send done : Total:%hhu Acked:%hhu Retransmistted: %hhu\n", TotalRelayed, RelayAcknowledged, TotalRelayRetransmissions);
			RelayAcknowledged++;
			dbg("Sink", "\t\t\t Relay send done : Total:%hhu Acked:%hhu Retransmistted: %hhu\n", TotalRelayed, RelayAcknowledged, TotalRelayRetransmissions);		
		}
		else
		{
			dbg("Sink", "Relay Not Acked\n");
			dbg("Ack", "Not acked; Timer Entered\n");
			dbg("Sink", "\t\t\t Relay send done : Total:%hhu Acked:%hhu Retransmistted: %hhu\n", TotalRelayed, RelayAcknowledged, TotalRelayRetransmissions);
			call AckTimer.startOneShot(TIMER_ONE_SHOT * 3);
			//Send(RelaySensedNode);
		}
		BUSY = FALSE;
		return;
	}
	
	event void AckTimer.fired()
	{
		dbg("Sink", "Relay Ack Timer Fired\n");
		dbg("Ack", "Ack Timer Entered\n");
		dbg("Sink", "\t\t\t Relay send done : Total:%hhu Acked:%hhu Retransmistted: %hhu\n", TotalRelayed, RelayAcknowledged, TotalRelayRetransmissions);
		if (ACKED == TRUE)
		{
			dbg("Sink", "Relay Acked in Timer\n");
			RelayAcknowledged++;	
			dbg("Sink", "\t\t\t Relay send done : Total:%hhu Acked:%hhu Retransmistted: %hhu\n", TotalRelayed, RelayAcknowledged, TotalRelayRetransmissions);		
		}
		if (ACKED != TRUE)
		{
			dbg("Sink", "\t\t\t Relay not Acked; Send again\n");
			dbg("Ack", "Ack Timer Fired\n");
			dbg("Sink", "\t\t\t Relay send done : Total:%hhu Acked:%hhu Retransmistted: %hhu\n", TotalRelayed, RelayAcknowledged, TotalRelayRetransmissions);
			TotalRelayRetransmissions++;
			dbg("Sink", "\t\t\t Relay send done : Total:%hhu Acked:%hhu Retransmistted: %hhu\n", TotalRelayed, RelayAcknowledged, TotalRelayRetransmissions);
		    Send(relaysentnode, relaynodeid, relayretransmissions, relaysensedmsg, relaycount);
		}
		
		//ACKED = FALSE;
		   
	}
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

//	uint16_t Retransmissions = 0x00;
    uint16_t AckSendNodeID = 0x00;

	
	void TaskSendAck(uint16_t SendNodeID, uint8_t acked)
	{
		ack_msg_t* ampkt = (ack_msg_t*)(call AckPacket.getPayload(&pkt, sizeof(ack_msg_t)));
		
		if (ampkt == NULL)
		{
			dbg("Ack", "Ack Message is empty\n");
			dbg("Periodic", "Ack Message is empty\n");
			return;
		}
		
		AckSendNodeID = SendNodeID;
		
		ampkt->ACKED = acked;
		ampkt->AckedNode = TOS_NODE_ID;
		
		call PacketAck.requestAck(&pkt);
		if (call SendAck.send(SendNodeID, &pkt, sizeof(ack_msg_t)))
		{
			dbg("Periodic", "Periodic Message to %hhu acknowledged\n", SendNodeID);
			dbg("Ack", "Ack to Periodic Message Sent to %hhu\n", SendNodeID);
			BUSY = TRUE;
		}
		
	}
	
	
	bool SENDACKED = FALSE;	
	event void SendAck.sendDone(message_t* msg, error_t err)
	{
		TotalAcked++;
		if (call PacketAck.wasAcked(msg) == TRUE)
		{
			SENDACKED = TRUE;
			AckedAcked++;
			dbg("Periodic", "Ack Acked\n");
		}
		else
		{
			acks_acks++;
//			call SendAckTimer.startOneShot(TIMER_ONE_SHOT);
			AckedRetransmissions++;
			if (acks_acks < MAX_ACKS_ACKS)
			{
				dbg("Periodic", "Ack not acked; sent again\n");
			    TaskSendAck(AckSendNodeID, 0x01);
			}
		}
		
		dbg("Ack", "Ack Sent done\n");
		BUSY = FALSE;
		return;
	}
	
	event void SendAckTimer.fired()
	{
		if (SENDACKED == TRUE)
		{
			dbg("Periodic", "Send Ack Timer Entered\n");
			AckedAcked++;            
     		SENDACKED = FALSE;
		}			
		
		else
		{
			dbg("Periodic", "Send Ack sent again\n");
			AckedRetransmissions++;
		    TaskSendAck(AckSendNodeID, 0x01);
		}	
	}
	
	event message_t* AckReceiver.receive(message_t* ackMsg, void* payload, uint8_t len)
	{
		//ACKED = FALSE;
		
		if (len != sizeof(ack_msg_t))
		{
			dbg("Ack", "Nothing inside ack message\n");
			dbg("Periodic", "Nothing inside the ack message\n");
			return ackMsg;
		}
		else
		{
			
			ack_msg_t* amt = (ack_msg_t*)payload;
			dbg("Ack", "Ack Received : ACKED: %hhu\n", amt->ACKED);
			dbg("Periodic", "Ack Received from %hhu ACKED:%hhu\n", amt->AckedNode, amt->ACKED);
			if (amt->ACKED == 0x01)
			{
				ACKED = TRUE;
				dbg("Ack", "Acked from %hhu received %hhu\n", amt->AckedNode, amt->ACKED);			
			}

		}
		
		return ackMsg;
	}
	

	
		

	
}