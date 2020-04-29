#include "Dijikstra.hpp"
#include "../network/graph.hpp"
#include "../logs/log.hpp"
#include "TableStruct.hpp"
#include<map>
#ifndef ROUTING
#define ROUTING

//We are using link state routing

class Routing
{

    public:
 	 map<int ,vector<table_attributes>> Routing_Table;
  	 void genrateTable(int src,int des,Graph &g)
    	{
      	  Dijikstra d;
       	 stack<int> s=d.shortest_path(g.adjList,src,des,g.vertex);
        
       	 while(!s.empty())
        	{
        	
        		int i=s.top();
        		s.pop();
        		if(des!=i)
        		{
        		//table_attributes t={s.top(),50,1};//let ttl=50,relay=1.0ie 100%
        			int cost=g.findCost(i,s.top());
        			Routing_Table [i].push_back(table_attributes(s.top(),50,1,cost));
        		
        		}
        		else
        		{
        			Routing_Table [i].push_back(table_attributes(i,50,1,0));	//des = curr
        		
        		}
        
       	 }

    }

};

#endif // ROUTING

