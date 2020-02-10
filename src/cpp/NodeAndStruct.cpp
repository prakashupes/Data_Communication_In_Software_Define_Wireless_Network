#include<bits/stdc++.h>
using namespace std;
struct Node
{
    int name;
    int data;//char queue  p p2 p3
    int weight;
    int table[2][2];

};
class Graph
{
    int vertex;
    map<int ,list<int>> adjList;
    public:
    Node *info; //It contains all the enformation about each nodes


    Graph(int v)
    {
        this->vertex=v;
        info=new Node[v];


    }

    void addEdge(int src,int des) //Let graph is bidirectional
    {
        adjList[src].push_back(des);
        adjList[des].push_back(src);
        info[src].name=src;

    }
    void setInfo(int node)
    {

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
        cout<<"Data of node "<<info[node].data<<endl;


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
int main()
{
    int vertex=10;
    Graph g(vertex);
    int i=1;
    while(i<(vertex*vertex)-vertex)
    {
        int u=(rand()%vertex);
        int v=(rand()%vertex);
        if(u!=v)
        {
            i++;
            //cout<<u<<", "<<v<<endl;
            g.addEdge(u,v);
        }

    }
    g.printList();
    g.getInfo(5);
}
