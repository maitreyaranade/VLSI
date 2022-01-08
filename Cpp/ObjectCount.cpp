 /*
 Define a class item. Declare a static variable with a name of count and use this member to count the number objects created.

 This class should have public methods to display the count value.
 
 Write a C++ program to Count the number of objects using the Static member function
 
        Important points about Static :

        A static member is shared by all objects of the class, all static data is initialized to zero when the first object is created, if no other initialization is present.

        A static member function can only access static data member, other static member functions and any other functions from outside the class.

        By declaring a function member as static, we make it independent of any particular object of the class. A static member function can be called even if no objects of the class exist and the static functions are accessed using only the class name and the scope resolution operator :: .

        We can’t put it in the class definition but it can be initialized outside the class as done in the following example by re-declaring the static variable, using the scope resolution operator :: to identify which class it belongs to.
 */


#include<iostream>
using namespace std;

class objectCount {
    static int count;   // Static member
  
public:
    objectCount()   // contructor 
    {
    ++count;
    }

    static void printObjCount(void)      // static member function
    {
        cout << "\nCount:" << count;
    }
};

int objectCount::count;

int main()
{
    objectCount::printObjCount();

    objectCount o1, o2;
    objectCount::printObjCount();
  
    objectCount o3, o4, o5, o6;
    objectCount::printObjCount();
    
    objectCount o7;
    objectCount::printObjCount();

    objectCount o8, o9;
    objectCount::printObjCount();

    return 0;
}