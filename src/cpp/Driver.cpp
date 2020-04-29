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
  
using namespace std; 
vector<string> split(string str, char dl) 
{ 
	string word = ""; 
	int num = 0; 
	str = str + dl; 
	int l = str.size(); 
	vector<string> substr_list; 
	for (int i = 0; i < l; i++) { 

		if (str[i] != dl) 
			word = word + str[i]; 

		else { 

			if ((int)word.size() != 0) 
				substr_list.push_back(word); 
			word = ""; 
		} 
	} 
	return substr_list; 
} 

int main()
{

    int vertex=10;
    Graph g(vertex);
    
    cout<<"Creating topology with vertex "<<vertex<<"....."<<endl;
    log::out<<"Creating topology with vertex "<<vertex<<"....."<<endl;
    Topology topology;
    topology.create_Network(g);
    topology.view_Network(g);
    
    cout<<"Enter message\n";
    string str;
    getline(cin,str);
    char dl=' ';
    vector<string> v=split(str,dl);
    
    
    int src,des;
    cout<<"Enter src\n";
    cin>>src;
    
    cout<<"Enter des\n";
    cin>>des;
    
    log::out<<"Entered message "<<str<<endl;
    log::out<<"Entered source "<<src<<endl;
    log::out<<"Entered destination "<<des<<endl;
    //Queue of packets
    
    cout<<"Setting message into packets...."<<endl;
    log::out<<"Setting message into packets...."<<endl;
    
    queue<Packet> packet_queue;
    
    for(int i=0;i<v.size();i++)
    {
    	Packet p;
    	p.setMessage(v[i]);
    	p.setHeaderInfo(i,src,des);
    	packet_queue.push(p);
    }
    
    	int total_packets=packet_queue.size();
	cout<<"Total "<<total_packets<<" packets created..."<<endl;
	log::out<<"Total "<<packet_queue.size()<<" packets created"<<endl;
	
	
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
	
	Transmission t;

	while(!packet_queue.empty())
	{
		
    		t.startTransmission(g,packet_queue.front()); //return true if 
    		packet_queue.pop();
	}
	
	
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
	cout<<"To help type ./a.out --h"<<endl;

  

}
