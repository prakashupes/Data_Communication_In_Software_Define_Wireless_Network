#include <iostream>
#include <chrono>
#include <algorithm>
using namespace std::chrono;
using namespace std;
int main()
{
	float sec=2;
	float microseconds_=2*1000000;
	auto start = high_resolution_clock::now();
	int j=0;
	for(int i=0;i<10000;i++)
	{
		j++;
	}
	cout<<j<<endl;
	auto end = high_resolution_clock::now();
	auto x= duration_cast<microseconds> (end - start); //this is long type after x.count();
	int running_time=x.count();
		cout<<"\n program running for "<<running_time<<endl;
	microseconds_-=running_time;
	
	sec=microseconds_/1000000;
	cout<<"time left "<<sec;
		


}
