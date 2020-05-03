#include<iostream>
#include "../logs/log.hpp"
#ifndef PACKETS
#define PACKETS
using namespace std;
class Header
{
    public:
    int length=10,src,des,TYP; //id =packet Id
    string id;
    
    //next hop
    //if next hop== dst stop
    // routing table calculate by dijik
    //for range- use euclirian distance, if dis<20 then only node is wih in range
    //check medium relaibility
    //src and des ask fro usr and return a path wih in the range
    //if does not have action in routing table then only send t the routing table

};

class Packet
{
    Header header;
    string payload; //Actual data
    //dijikstra for
    public:
    void setMessage(string msg)
    {
        
        
        this->payload=msg;
    }
    void setHeaderInfo(string id,int src, int des) //will set information of header
    {
        
        header.src=src;
       

      
        header.des=des;
        header.id=id;
        header.TYP=0; //TYP 0 means msg container


    }
    int getSource()
    {
        return header.src;
    }
    int getDesti()
    {
        return header.des;
    }
    string getId()
    {
        return header.id;
    }
    string getMessage()
    {
        return payload;
    }


};


#endif // PACKETS
