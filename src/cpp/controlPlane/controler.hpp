#include "../network/nodes.hpp"
#include "../routing/RoutingProtocol.hpp"
#include "../logs/log.hpp"
#ifndef CONTROL
#define CONTROL


class Controller
{
	map<string,map<int ,vector<table_attributes>>> Routing_Table;
	
	
	public:
	
	 void genrateTable(int src,int des,Graph &g,string msg_id)
	{
		Routing r;
		r.genrateTable(src,des,g);
		Routing_Table[msg_id]=r.Routing_Table;
		
		
	
	}
	
	void genrateFlowRule(Node *individual_Nodes)
	{
		for(auto x: Routing_Table)
		{
		
			string msg_id=x.first;
			for(auto y:x.second)
			{
				auto v=(y.second);
				individual_Nodes[y.first].flow_rule[msg_id]=v;
			
			
			}
			
		}
	
	}
	
	
	void genrateLog()
	{
		table::out<<"id  Next_hope  reliability TTL  Cost"<<endl;
		for(auto x:Routing_Table)
		{
		
			cout<<"Routing table for msg_id "<<x.first<<endl;
			
			auto y=(x.second);
			for(auto z: y)
			{
				auto v=(z.second);
		table::out<<z.first<<"         "<<v[0].nextHope<<"        "<<v[0].relay<<"      "<<v[0].ttl<<"      "<<v[0].cost<<endl;
			
			cout<<z.first<<"         "<<v[0].nextHope<<"        "<<v[0].relay<<"      "<<v[0].ttl<<"      "<<v[0].cost<<endl;
			
			
			}
			//cout<<x.first<<"  "<<v[0].nextHope<<"  "<<v[0].relay<<"  "<<v[0].ttl<<"  "<<v[0].cost<<endl;
			
			
		}
	}	
	
};






//Set table to each node
    /*
    void setTable(Graph &g)
    {

        for(int i=0;i<g.vertex;i++)
        {
            g.individual_Nodes[i].Routing_Table=Routing_Table;
        }

    }
    */
#endif //CONTROL
