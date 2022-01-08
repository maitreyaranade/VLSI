 /*
 Define a class with an array as a member of variable size 
 Write 2 public methods
    setval: Set values to the element of array
    display: Display the values of elements of an array
 Class name: array
 */

#include<iostream>
using namespace std;

const int size=5;

class array {
  int arr[size];
  public:
   void setval();
   void disp ();
};

void array :: setval () {
   cout<<"Enter elements of the array\n";
   for(int i=0; i<size; i++) {
      cin>>arr[i];
   }
}

void array :: disp (){
   for(int i=0; i<size; i++){
      cout<<"\nArray element number "<< i+1 <<" is: "<<arr[i];
      }
}

int main() {
   array arr1;
   arr1.setval() ;
   arr1.disp() ;
   return 0;
}
