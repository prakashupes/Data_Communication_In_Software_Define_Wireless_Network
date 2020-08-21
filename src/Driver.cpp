#include<iostream>
#include <vector>
#include<queue>
#include "network/graph.hpp"
#include "routing/topology.hpp"
#include"network/nodes.hpp"
#include "network/Packates.hpp"
#include "routing/Transmission.hpp"
#include "routing/RoutingProtocol.hpp"
#include "logs/log.hpp"
#include "controlPlane/controler.hpp"
#include "message/message.hpp"
#include<thread>
#include <chrono>
#include <algorithm>
using namespace std; 
using namespace std::chrono;

int main()
{

	/***********************************************************************************************/
	//variables that can be used in out of simulation loop
	Message m1,m2;
	int src1,src2,des1,des2;
	int count=0; //It will keep count of total send messages //also equls num of transmision
	int message_index=0;
	int total_packets=0; //sent packets
	int total_rec=0; //received packets
	int vertex;
	int defualt_src=0;
	int defualt_des=9;
	float time=0; //for throughput calulation
	float throughput,pdr; //pdr=packet delevery ratio
	queue<Packet> packet_queue;
	Controller r;
	
	//It will be used for transmision, messgae transmitted
	string msgArray[9] = {      "This is project team of developer",
	                       "Hello Everyone !!",
	                       "Welcome to our project",
	                       "Software Defined Wireless Sensor network",
	                       "We are here for Minor 2 final presentation",
	                       "Our mentor is Dr Amit singh",
	                       "We have 4 member in our team",
	                       "Pradeep sir is my AC",
	                       "We are from oss"
	                       
				   };
				  
	/*************************************************Topology Creating Section********************************/			  
	cout<<"Enter num of vertex for transmision "<<endl;
	cin>>vertex;
	if(vertex<10)
	{
		cout<<"Minimum 10 vertex required ";
		exit(1);
	}			   
	Graph g(vertex);
    	cout<<"Creating topology with vertex "<<vertex<<"....."<<endl;
    	log::out<<"Creating topology with vertex "<<vertex<<"....."<<endl;
    	Topology topology;
    	topology.create_Network(g);
    	topology.view_Network(g);
    
    
    	/****************************User input section for simulation time************************************************/
	
	cout<<"Enter time for simulation in millisec"<<endl;
	if(time>300)
	{
		cout<<"Simulation limit upto 300";
		exit(1);
	}
	float simulationTime=0;
	cin>>simulationTime;
	time=simulationTime;
    	float microseconds_=simulationTime*1000;
	auto start = high_resolution_clock::now();
	
	/************************************Simulation started****************************/
	
	cout<<"Simulation started.... "<<endl;
	
	while(simulationTime>0)
	{
	
		if(message_index==8) message_index=0;
    
    		/************************setting details of src destination message**************************/
    		//Message1 details
    		src1=(rand()%vertex);
    		des1=(rand()%vertex);
    		if(src1==des1)
    		{
    			src1=defualt_src;
    			des1=defualt_des;
    		}
    	
    		cout<<"Entered source "<<src1<<endl;
    		log::out<<"Entered source "<<src1<<endl;
    		cout<<"Entered destination "<<des1<<endl;
    		log::out<<"Entered destination "<<des1<<endl;
    
   
     
    		auto start = high_resolution_clock::now();  //Timer start
    
    		Message m1;
  
    
    		m1.setCompleteMessage(src1,des1,count,msgArray[message_index]);
    		
    		packet_queue=m1.split_into_packet();
    		int packets_for_curr_messgae=packet_queue.size();
    		cout<<packets_for_curr_messgae<<" packets created for message "<<msgArray[message_index]<<" id :"<<m1.message_id<<endl;
    		log::out<<packets_for_curr_messgae<<" packets created for message "<<msgArray[message_index]<<" id :"<<m1.message_id<<endl;
    		
    		total_packets+=packet_queue.size();
		//cout<<"Total "<<total_packets<<" packets created..."<<endl;
		//log::out<<"Total "<<total_packets<<" packets created"<<endl;
    
    		count++;
    		message_index++;
    
   		 /*********************************SDN Section************************************************/
    
    
		cout<<"SDN Applied...\nSetting controller..."<<endl;
		log::out<<"SDN Applied...\nSetting controller..."<<endl;
	
		
    		cout<<"Controller genrating routing table using link state routing protocol..."<<endl;
    		log::out<<"Controller genrating routing table using link state routing protocol..."<<endl;
    
   		r.genrateTable(src1,des1,g,m1.message_id);
    		r.genrateLog();
    
    
    		cout<<"Controller setting flow rule for nodes..."<<endl;
    		log::out<<"Controller setting flow rule for nodes..."<<endl;
    
   		r.genrateFlowRule(g.individual_Nodes);
   		
    
    		 /*********************************Tranmission Section************************************************/
 
    		cout<<"\nTranmission started..."<<endl;
    
    		log::out<<"\nPreparing Tranmission..."<<endl;
    		log::out<<"Tranmission started..."<<endl;

	
		Transmission t; //

		while(!packet_queue.empty())
		{
	
	
			Packet ppp=packet_queue.front();
			
    			std:: thread th(&Transmission::startTransmission,std::ref(g),std::ref(ppp));
    			th.join();
    		
    			
    			packet_queue.pop();
    			
    			/****************calulating time left after this packet transmision*******************/
    			auto end = high_resolution_clock::now();
			auto x= duration_cast<microseconds> (end - start); //this is long type after x.count();
			long running_time=x.count();
			cout<<"This transmision completed in "<<running_time<<" millisec"<<endl;
			log::out<<"This transmision completed in "<<running_time<<" millisec"<<endl;
			microseconds_-=running_time;
			simulationTime=microseconds_/1000; //microseconds_ is millisec
			
			if(simulationTime<=0) break;
			cout<<"\nSending next packet...."<<endl;
    			log::out<<"\nSending next packet...."<<endl;
    		
    		
		}
	
	
		cout<<"time left "<<simulationTime<<" millisec"<<endl;
		total_rec+=g.individual_Nodes[des1].packet_queue.size(); //Total received packet
		cout<<"\nNext message processed"<<endl;
	
	}
	cout<<"Total transmision "<<(total_rec)<<endl;
	log::out<<"Total transmision "<<(total_rec)<<endl;
	cout<<"\nFor detailed transmision visit to log file stored at /temp/_output.log (Linux OS)"<<endl;
	/******************************************Simulation Completed****************************************/
	
	
	
	
	
	/***************************************Mathematical calulation*************************************/
	
	
	
	//cout<<"\nCalculating packet delevery ratio...."<<endl;
	log::out<<"\nCalculating packet delevery ratio...."<<endl;
	
	cout<<"\n------------------Mathematical analysis--------------------\n"<<endl; //store in log
	
	cout<<"Total successful transmitted packets "<<total_rec<<endl;
	log::out<<"Total successful transmitted packets"<<total_rec<<endl;
	
	float ratio=(float)total_rec/(float)total_packets;
	cout<<"Packet delevery ratio (pdr) =  "<<total_rec<<"/"<<total_packets<<" = "<<ratio<<endl;
	
	float success=ratio*100;
	float loss= 100-success;
	
	cout<<"success rate "<<success<<"%"<<endl;
	log::out<<"success rate "<<success<<"%"<<endl;
	cout<<"loss rate "<<loss<<"%"<<endl;
	log::out<<"loss rate "<<loss<<"%"<<endl;
	
	throughput=((float)total_rec/(float)time);
	cout<<"Throughput = "<<(throughput)*100<<" packets/sec"<<endl;
	
	
	cout<<"\nLog file for this transmision is stored at /temp/_output.log"<<endl;
	//cout<<"To help type ./a.out --h"<<endl;
	cout<<"If want to see log file here press 1 else 0";
	int ch;
	cin>>ch;
	if(ch==1)
	{
		log::flush() ;
		std::cout << "\n--------------------\n" << std::ifstream( log::path ).rdbuf() ;
	}
	ch=0;
	cout<<"If want to see routing table here press 1 else 0 ";
	
	cin>>ch;
	if(ch==1)
	{
		table::flush() ;
		std::cout << "\n--------------------\n" << std::ifstream( table::path ).rdbuf() ;
	}
	
	//simulationTime--;

}
