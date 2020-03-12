#include "nodes.hpp"
#include<iostream>
#include <algorithm>
#include <map>
#include <list>
#ifndef GRAPH
#define GRAPH
using namespace std;
class Graph
{
    int vertex;
    map<int ,list<int>> adjList; //use extern
    public:
    Node *info; //It contains all the enformation about each nodes


    Graph(int v) :vertex {v}
    {
        //this->vertex=v;
        info=new Node[v];


    }

    void addEdge(int src,int des) //Let graph is bidirectional
    {
        adjList[src].push_back(des);
        adjList[des].push_back(src);
        info[src].Node_id=src;

    }

    void getInfo(int node)
    {
        cout<<"Neighbours are\n";
        cout<<node<<"-> ";
        for(auto x:adjList[node])
        {
            cout<<x<<" ";
        }
        cout<<endl;
       // cout<<"Data of node "<<info[node].data<<endl;


    }
    void printList()
    {

        for(auto x:adjList)

        {
            cout<<x.first<<" ->: ";
            for(int y:adjList[x.first])
            {
                cout<<y<<" ";
            }
            cout<<endl;
        }
    }

};


#endif
