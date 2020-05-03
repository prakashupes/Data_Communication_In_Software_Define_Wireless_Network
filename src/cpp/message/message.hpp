#ifndef MESSAGE
#define MESSAGE
#include "../network/Packates.hpp"
#include "../logs/log.hpp"
class Message
{
	public:
	string message,message_id;
	int src,des;
	
	
	vector<string> split(string str, char dl) 
	{ 
		cout<<"to be split "<<str<<endl;
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
	
	void setCompleteMessage(int src,int des,int del,string msg) //del define num of objetc of src and destination
	// so that unique message_id can be created
	{
		this->message=msg;
		
    		message_id="M00"+std::to_string(del);
    		log::out<<"Genrated message id"<<message_id<<endl;
    		this->src=src;
    		this->des=des;
	
	}
	queue<Packet> split_into_packet()
	{
		queue<Packet> packet_queue;
		cout<<"Setting message into packets...."<<endl;
    		log::out<<"Setting message into packets...."<<endl;	
		char dl=' ';
    		vector<string> v=split(this->message,dl);
    		for(int i=0;i<v.size();i++)
    		{
    			Packet p;
    			p.setMessage(v[i]);
    			p.setHeaderInfo(message_id+std::to_string(i),src,des);
    			packet_queue.push(p);
    		}
    		return packet_queue;
    		
	
	}

};

#endif//MESSAGE
