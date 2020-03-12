#include "nodes.hpp"
#include<iostream>
#include <algorithm>
#include <map>
#include <list>
#include<stack>
#include "../routing/Dijikstra.hpp"
#ifndef GRAPH
#define GRAPH
using namespace std;


class Graph
{
    public:
    int vertex;
    map<int ,map<int,int>> adjList; //use extern
    map<int,int> Routing_Table; //int->current node, int ->nextHope

    Node *individual_Nodes; //It contains all the enformation about each nodes


    Graph(int v) :vertex {v}
    {
        //this->vertex=v;
        individual_Nodes=new Node[v]; //Here all individual nodes created
        for(int i=0;i<v;i++)
        {
            individual_Nodes[i].Node_id=i;
        }

    }

    void addEdge(int src,int des,int wt) //Let graph is bidirectional
    {
        adjList[src][des]=wt;
        adjList[des][src]=wt;

       // info[src].Node_id=src;

    }

    void getInfo(int node)
    {



    }
    void printList()
    {

        for(auto x:adjList)

        {
            cout<<x.first<<" ->: ";
            for(auto y:adjList[x.first])
            {
                cout<<"( "<<y.first<<", "<<y.second<<")";
            }
            cout<<endl;
        }
    }

    //here routing table is genrated
    void genrateTable(int src,int des)
    {
        Dijikstra d;
        stack<int> s=d.shortest_path(this->adjList,src,des,vertex);

        while(!s.empty())
        {
            int i=s.top();
            s.pop();
            if(des!=i)
            {
                Routing_Table [i]=s.top();
            }
        }


    }

    //Set table to each node
    void setTable()
    {
        for(int i=0;i<vertex;i++)
        {
            individual_Nodes[i].Routing_Table=Routing_Table;
        }
    }

};


#endif
