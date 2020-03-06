#ifndef PACKETS
#define PACKETS
class Header
{
    int length=10,id,src,des,TYP; //id =packet Id
    //next hop
    //if next hop== dst stop
    // routing table calculate by dijik
    //for range- use euclirian distance, if dis<20 then only node is wih in range
    //check medium relaibility
    //src and des ask fro usr and return a path wih in the range
    //if does not have action in routing table then only send t the routing table

};

class DataPacket
{
    Header h;
    string payload; //Actual data
    //dijikstra for


}


#endif // PACKETS
