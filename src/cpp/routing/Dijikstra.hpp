#include<iostream>
#include<map>
#include<stack>
#ifndef DIJIKSTRA
#define DIJIKSTRA
#define inf 1e9
using namespace std;

class Dijikstra
{
   public:



int findMin( map<int,bool> &visited, map<int,int> &weigth,int v)
{
    int minWtNode=-1;
    for(int i=0;i<v;i++) //I represents the nodes
    {
        if(!visited[i] && (minWtNode==-1 || weigth[i]<weigth[minWtNode]))
        {
            minWtNode=i;
        }

    }
    return minWtNode;

}
stack<int> shortest_path(Graph g,int src,int des)
{
    int v=g.vertex;
    map<int,bool> visited;
    map<int, int> parent;
    map<int,int> weigth;
    for(int i=0;i<v;i++)
    {
        visited[i]=false;
        weigth[i]=inf;
    }
   // parent[0]=-1;
    weigth[src]=0;
    for(int i=0;i<v;i++)
    {
        int minWtNode=findMin(visited,weigth,v);
        visited[minWtNode]=true;
        for(auto neigh: g.adjList[minWtNode])
        {
            if(!visited[neigh.first]) //negh.first represents destination, 0->1 1 is neigh.first
            {
                if(weigth[neigh.first]>neigh.second+weigth[minWtNode])
                {
                    weigth[neigh.first]=neigh.second+weigth[minWtNode];
                    parent[neigh.first]=minWtNode;
                } //neigh.second reprsnt wt fro adjList
            }
        }

    }
    stack<int> s;
    s.push(des);
    int i=des;
    while(s.top()!=src)
    {
        cout<<"->"<<parent[s.top()];
        s.push(parent[s.top()]);
    }


    //cout<<weigth[des];

    return s;

}

};
#endif // DIJIKSTRA
