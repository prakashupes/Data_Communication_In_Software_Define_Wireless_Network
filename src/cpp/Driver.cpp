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
	int count=0; //It will keep count of total send messages
	int message_index=0;
	int total_packets=0;
	Controller r;
	int vertex=10;
	int defualt_src=0;
	int defualt_des=9;
	queue<Packet> packet_queue;
	
	string msgArray[9] = {      "This is project team of developer",
	                       "Hello Everyone",
	                       "Welcome to our project",
	                       "SDN network",
	                       "Minor 2",
	                       "Our mentor is Dr Amit singh",
	                       "We have 4 member in our team",
	                       "Pradeep sir is my AC",
	                       "We are from oss"
	                       
				   };
				   
	Graph g(vertex);
    
    cout<<"Creating topology with vertex "<<vertex<<"....."<<endl;
    log::out<<"Creating topology with vertex "<<vertex<<"....."<<endl;
    Topology topology;
    topology.create_Network(g);
    topology.view_Network(g);
    
    /*******************8************************************************/
	
	cout<<"Enter time for simulation in millisec"<<endl;
	float simulationTime=0;
	cin>>simulationTime;
	
    	
    	float microseconds_=simulationTime*1000;
	auto start = high_resolution_clock::now();
	
	while(simulationTime>0)
	{
	
	if(message_index==8) message_index=0;
    
    	/***************************************************************************************/
    	//Message1 details
    	src1=(rand()%vertex);
    	des1=(rand()%vertex);
    	if(src1==des1)
    	{
    		src1=defualt_src;
    		des1=defualt_des;
    	}
    	
    	
    log::out<<"Entered source "<<src1<<endl;
    log::out<<"Entered destination "<<des1<<endl;
    
    //Time calculate start
     
    auto start = high_resolution_clock::now();
    
    ///
    Message m1;
  
    
    m1.setCompleteMessage(src1,des1,count,msgArray[message_index]);
    count++;
    message_index++;
    
    packet_queue=m1.split_into_packet();
    
    /********************************************************************************/
    /*
    src2=(rand()%vertex);
    	des2=(rand()%vertex);
    	if(src2==des2)
    	{
    		src2=defualt_src;
    		des2=defualt_des;
    	}
    	
    m2.setCompleteMessage(src2,des2,count,msgArray[message_index]);
    count++;
    message_index++;
    
     packet_queue=m2.split_into_packet();
    
    */
    /********************************************************************************/
    
    	total_packets=packet_queue.size();
	cout<<"Total "<<total_packets<<" packets created..."<<endl;
	log::out<<"Total "<<total_packets<<" packets created"<<endl;
	
	
	cout<<"SDN Applied...\nSetting controller..."<<endl;
	log::out<<"SDN Applied...\nSetting controller..."<<endl;
	
	cout<<"Preparing controller..."<<endl;
    
    	
    
    cout<<"Controller genrating routing table using link state routing protocol..."<<endl;
    log::out<<"Controller genrating routing table using link state routing protocol..."<<endl;
    
    r.genrateTable(src1,des1,g,m1.message_id);
    r.genrateLog();
    
    // r.genrateTable(src2,des2,g,m2.message_id);
    //r.genrateLog();
    //r.printTable();
    
    
    
    cout<<"Controller setting flow rule for nodes..."<<endl;
    log::out<<"Controller setting flow rule for nodes..."<<endl;
    
    r.genrateFlowRule(g.individual_Nodes);
    
    
    cout<<"Preparing Tranmission..."<<endl;
    cout<<"Tranmission started..."<<endl;
    
    log::out<<"Preparing Tranmission..."<<endl;
    log::out<<"Tranmission started..."<<endl;
    //To start transmission
	
	Transmission t; //

	while(!packet_queue.empty())
	{
	
	
		Packet ppp=packet_queue.front();
		//cout<<"Starting thrread\n";
    		std:: thread th(&Transmission::startTransmission,std::ref(g),std::ref(ppp));
    		th.join();
    		
    		cout<<"\nSending next packet...."<<endl;
    		log::out<<"\nSending next packet...."<<endl;
    		//t.startTransmission(g,packet_queue.front());
    		packet_queue.pop();
    		
    		
	}
	
	
	//Thread for transmision
	
	auto end = high_resolution_clock::now();
	auto x= duration_cast<microseconds> (end - start); //this is long type after x.count();
	long running_time=x.count();
	cout<<"\nThis transmision completed in "<<running_time<<" millisec"<<endl;
	
	microseconds_-=running_time;
	
	simulationTime=microseconds_/1000;
	cout<<"time left "<<simulationTime<<" millisec"<<endl;
	
	}
		
	
	
	
	//Calculation of loss and received
	
	cout<<"\nCalculating loss and success...."<<endl;
	log::out<<"\nCalculating loss and success...."<<endl;
	int total_rec=g.individual_Nodes[des1].packet_queue.size(); //Total received packet
	cout<<"Total packet received at Desination"<<total_rec<<endl;
	log::out<<"Total packet received at Desination"<<total_rec<<endl;
	
	int success=(total_rec/total_packets)*100;
	int loss= 100-success;
	
	cout<<"success rate "<<success<<"%"<<endl;
	log::out<<"success rate "<<success<<"%"<<endl;
	cout<<"loss rate "<<loss<<"%"<<endl;
	log::out<<"loss rate "<<loss<<"%"<<endl;
	
	cout<<"\nLog file for this transmision is stored at /temp/_log.txt"<<endl;
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
