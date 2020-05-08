#ifndef TABLESTRUCT
#define TABLESTRUCT
struct table_attributes
{
	int nextHope,ttl,cost;
	float relability;
	table_attributes (int a, float b, int c,int d): nextHope(a),relability(b) ,ttl(c),cost(d){}

};
#endif
