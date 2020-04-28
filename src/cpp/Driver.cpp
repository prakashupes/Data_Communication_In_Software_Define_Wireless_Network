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
    Topology topology;
    topology.create_Network(g);
    topology.view_Network(g);

    Dijikstra d;
//    d.shortest_path(g,2,8);
    
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
    
    
    //Queue of packets
    
    queue<Packet> packet_queue;
    
    for(int i=0;i<v.size();i++)
    {
    	Packet p;
    	p.setMessage(v[i]);
    	p.setHeaderInfo(i,src,des);
    	packet_queue.push(p);
    }
    
	cout<<"Total packets "<<packet_queue.size();
	
	

    Routing r;
    r.genrateTable(src,des,g);
    r.setTable(g);
    
    //To start transmission
	Transmission t;

	while(!packet_queue.empty())
	{
		
    		t.startTransmission(g,packet_queue.front());
    		cout<<"Tranmission completed\n";
    		packet_queue.pop();
	}

    








}
