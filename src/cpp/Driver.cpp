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
	
    int vertex=10;
    Graph g(vertex);
    
    cout<<"Creating topology with vertex "<<vertex<<"....."<<endl;
    log::out<<"Creating topology with vertex "<<vertex<<"....."<<endl;
    Topology topology;
    topology.create_Network(g);
    topology.view_Network(g);
    
    
    
    int src,des;
    cout<<"Enter src\n";
    cin>>src;
    
    cout<<"Enter des\n";
    cin>>des;
    
    
    
    log::out<<"Entered source "<<src<<endl;
    log::out<<"Entered destination "<<des<<endl;
    cout<<"Enter message\n";
    string msg;
    cin.ignore();
    getline(cin,msg);
    log::out<<"Entered message "<<msg<<endl;
    
    //Time calculate start
     
    auto start = high_resolution_clock::now();
    
    ///
    Message m1;
    m1.setCompleteMessage(src,des,0,msg);
    queue<Packet> packet_queue=m1.split_into_packet();
    
    	int total_packets=packet_queue.size();
	cout<<"Total "<<total_packets<<" packets created..."<<endl;
	log::out<<"Total "<<total_packets<<" packets created"<<endl;
	
	
	cout<<"SDN Applied...\nSetting controller..."<<endl;
	log::out<<"SDN Applied...\nSetting controller..."<<endl;
	
	cout<<"Preparing controller..."<<endl;
    
    	Controller r;
    
    cout<<"Controller genrating routing table using link state routing protocol..."<<endl;
    log::out<<"Controller genrating routing table using link state routing protocol..."<<endl;
    
    r.genrateTable(src,des,g);
    //r.printTable();
    r.genrateLog();
    
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
	//For each node one transmision
		
    		t.startTransmission(g,packet_queue.front()); //return true if 
    		packet_queue.pop();
    		
	}
	
	
	//Thread for transmision
	
	auto end = high_resolution_clock::now();
		
		auto x= duration_cast<microseconds> (end - start); //this is long type after x.count();
		cout<<"\n program running for "<<x.count();
	
	
	
	//Calculation of loss and received
	
	cout<<"\nCalculating loss and success...."<<endl;
	log::out<<"\nCalculating loss and success...."<<endl;
	int total_rec=g.individual_Nodes[des].packet_queue.size();
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
	


}
