#ifndef MESSAGE
#define MESSAGE
#include "../network/Packates.hpp"
#include "../logs/log.hpp"
class Message
{
	string message,message_id;
	queue<Packet> packet_queue;
	public:
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
	
	queue<Packet> setMessage(int src,int des,int del) //del define num of objetc of src and destination
	// so that unique message_id can be created
	{
		cout<<"Enter message\n";
   		
   		 getline(cin,message);
   		 char dl=' ';
    		vector<string> v=split(message,dl);
    		message_id="M00"+std::to_string(del);
	
	}

};

#endif//MESSAGE
