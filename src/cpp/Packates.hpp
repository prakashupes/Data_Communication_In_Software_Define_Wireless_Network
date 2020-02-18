#ifndef PACKETS
#define PACKETS
class Header
{
    int length,id,src,des,TYP;

};

class DataPacket
{
    Header h;
    string payload; //Actual data

}


#endif // PACKETS
