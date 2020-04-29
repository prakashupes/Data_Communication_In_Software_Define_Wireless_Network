#include "../network/nodes.hpp"
#include "../routing/RoutingProtocol.hpp"
#include "../logs/log.hpp"
#ifndef CONTROL
#define CONTROL


class Controller
{
	map<int ,vector<table_attributes>> Routing_Table;
	
	
	public:
	
	 void genrateTable(int src,int des,Graph &g)
	{
		Routing r;
		r.genrateTable(src,des,g);
		Routing_Table=r.Routing_Table;
	
	}
	
	void genrateFlowRule(Node *individual_Nodes)
	{
		for(auto x: Routing_Table)
		{
			auto v=(x.second);
			individual_Nodes[x.first].flow_rule=v;
			
		}
	
	}
	
	void genrateLog()
	{
		table::out<<"id  Next_hope  reliability TTL  Cost"<<endl;
		for(auto x:Routing_Table)
		{	auto v=(x.second);
			//cout<<x.first<<"  "<<v[0].nextHope<<"  "<<v[0].relay<<"  "<<v[0].ttl<<"  "<<v[0].cost<<endl;
			
			table::out<<x.first<<"         "<<v[0].nextHope<<"        "<<v[0].relay<<"      "<<v[0].ttl<<"      "<<v[0].cost<<endl;
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
