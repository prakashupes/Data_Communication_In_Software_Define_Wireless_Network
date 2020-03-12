#include "nodes.hpp"
#include<iostream>
#include <algorithm>
#include <map>
#include <list>

#ifndef GRAPH
#define GRAPH
using namespace std;
/*class Graph
{
    int vertex;
    map<int ,list<int>> adjList; //use extern
    public:
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

    void addEdge(int src,int des) //Let graph is bidirectional
    {
        adjList[src].push_back(des);
        adjList[des].push_back(src);
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
            for(int y:adjList[x.first])
            {
                cout<<y<<" ";
            }
            cout<<endl;
        }
    }

};
*/

class Graph
{
    public:
    int vertex;
    map<int ,list<pair<int,int>>> adjList; //use extern

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
        adjList[src].push_back(make_pair(des,wt));
        adjList[des].push_back(make_pair(src,wt));
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

};


#endif
