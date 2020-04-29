#ifndef TABLESTRUCT
#define TABLESTRUCT
struct table_attributes
{
	int nextHope,relay,ttl,cost;
	table_attributes (int a, int b, int c,int d): nextHope(a),relay(b) ,ttl(c),cost(d){}

};
#endif
