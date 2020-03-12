#include<iostream>
#ifndef PACKETS
#define PACKETS
using namespace std;
class Header
{
    public:
    int length=10,id,src,des,TYP; //id =packet Id
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
    void setMessage()
    {
        std::cout<<"Enter Message :";
        getline(cin,payload);
        //this->payload=msg;
    }
    void setHeaderInfo() //will set information of header
    {
        cout<<"\nEnter Source of message :";
        cin>>header.src;
        if(header.src<0 || header.src>9)
        {
            cout<<"Invalid Source: please check network\n";
            header.src=0;
            exit(1);

        }

        cout<<"\nEnter Desti of message :";
        cin>> header.des;

         if(header.des<0 || header.des>9)
        {
            cout<<"Invalid Desination : please check network\n";
            header.des=0;
            exit(1);

        }
        header.id=1;
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


};


#endif // PACKETS
