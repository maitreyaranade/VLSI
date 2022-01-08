 /*
 Use the dereference operator to access the class member in the following example

 Write a class M which contains 2 integer member x and y
 Include member functions to perform the following tasks:
    Get numbers from user
    Add the 2 numbers using pointers & dereference operator and return the sum
    Write a program to test your class
 */


#include<iostream>
using namespace std;

class M
{
	public:
      int number; 
      // int *ptr = &number;
      void get_number();
      void display_number();
      M add_numbers(int *number1, int *number2)
      {
         M sum;
         sum.number = *number1 + *number2;
         cout<<"\n\nAddition of the 2 numbers is: "<< sum.number;
         return sum;
      }
};

// int M :: *ptr = & M :: number;

void M :: get_number()
{
	cout<<"\n\nEnter any number: ";
	cin>>number;
}

void M :: display_number()
{
	cout<<"\n\nNumber given by the user is: " << number;
}


int main()
{
   M num1;
   num1.get_number();
   num1.display_number();

   M num2;
   num2.get_number();
   num2.display_number();

   M num3;
   num3 = num3.add_numbers(num1.ptr, num2.ptr);

   // M *numPtr;
   // numPtr = &num1;
   // cout << "\n" << numPtr->*ptr;
   // cout << "\n" << numPtr->number;

   return 0;
}