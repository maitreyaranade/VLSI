 /*
 Write a class to represent time in hours and minutes.
 Include member functions to perform the following tasks:
    Get time from user in hours and minutes
    Display time in hours and minutes
    Take 2 time objects. Add and return the value and display it.

Write a C++ Program to Add Two Time Objects by passing values by call by reference
 */


#include<iostream>
using namespace std;

class time
{
    int hours;   
	int minutes;

	public:
    void get_time();
    void display_time();
    void add_time(time &, time &);
};

void time :: get_time()
{
	cout<<"\n\nEnter time in hours (24H format): ";
	cin>>hours;
	cout<<"\n\nEnter time in minutes: ";
	cin>>minutes;
}

void time :: display_time()
{
	cout<<"\n\nTime given by the user in HH:MM format is " << hours<<":"<< minutes;
}


void time :: add_time(time &t1, time &t2)
{
    minutes = t1.minutes+t2.minutes;
    hours = minutes/60;
    minutes = minutes%60;
    hours = hours + t1.hours + t2.hours;
    hours = hours % 24;

	cout<<"\n\nAddition of the 2 Time in HH:MM format is "<< hours<<":"<< minutes;
}

int main()
{
    time time1;
    time1.get_time();
    time1.display_time();

    time time2;
    time2.get_time();
    time2.display_time();

    time time3;
    time3.add_time(time1,time2);
    time3.display_time();

    return 0;
}





/*

Write a C++ Program to Add Two Time Objects by passing values by call by value

*/

/*
#include<iostream>
using namespace std;

class time
{
    int hours;   
	int minutes;

	public:
    void get_time();
    void display_time();
    void add_time(time, time);
};

void time :: get_time()
{
	cout<<"\n\nEnter time in hours (24H format): ";
	cin>>hours;
	cout<<"\n\nEnter time in minutes: ";
	cin>>minutes;
}

void time :: display_time()
{
	cout<<"\n\nTime given by the user in HH:MM format is " << hours<<":"<< minutes;
}


void time :: add_time(time t1,time t2)
{
    minutes = t1.minutes+t2.minutes;
    hours = minutes/60;
    minutes = minutes%60;
    hours = hours + t1.hours + t2.hours;
    hours = hours % 24;

	cout<<"\n\nAddition of the 2 Time in HH:MM format is "<< hours<<":"<< minutes;
}

int main()
{
    time time1;
    time1.get_time();
    time1.display_time();

    time time2;
    time2.get_time();
    time2.display_time();

    time time3;
    time3.add_time(time1,time2);
    time3.display_time();

    return 0;
}

*/