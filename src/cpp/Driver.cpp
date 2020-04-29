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

//using namespace std;

// C++ implementation to split string into 
// substrings on the basis of delimiter 
 
using namespace std; 

// function to split string into substrings on the 
// basis of delimiter and return the substrings 
// after split 
vector<string> split(string str, char dl) 
{ 
	string word = ""; 

	// to count the number of split strings 
	int num = 0; 

	// adding delimiter character at the end 
	// of 'str' 
	str = str + dl; 

	// length of 'str' 
	int l = str.size(); 

	// traversing 'str' from left to right 
	vector<string> substr_list; 
	for (int i = 0; i < l; i++) { 

		// if str[i] is not equal to the delimiter 
		// character then accumulate it to 'word' 
		if (str[i] != dl) 
			word = word + str[i]; 

		else { 

			// if 'word' is not an empty string, 
			// then add this 'word' to the array 
			// 'substr_list[]' 
			if ((int)word.size() != 0) 
				substr_list.push_back(word); 

			// reset 'word' 
			word = ""; 
		} 
	} 

	// return the splitted strings 
	return substr_list; 
} 

// Driver program to test above 



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
	
	int total_rec=g.individual_Nodes[des].packet_queue.size();
	cout<<"Total packet received at Desination"<<total_rec<<endl;
	
	

    








}
