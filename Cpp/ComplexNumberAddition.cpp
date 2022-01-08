 /*
 Write a class to represent complex numbers in x+ iy format
 Real and imaginary parts should be float

 Include member functions to perform the following tasks:
    Get complex numbers from user in x+ iy format
    Display complex numbers in x+ iy format
    Add 2 complex numbers, and return the value and display it.
 */



#include<iostream>
using namespace std;

class complex
{
    float x;   
	float y;

	public:
    void get_complex_number();
    void display_complex_number();
    complex add_complex_number(complex &cmplx1, complex &cmplx2)
    {
        complex cmplx;
        cmplx.y = cmplx1.y + cmplx2.y;
        cmplx.x = cmplx1.x + cmplx2.x;

        cout<<"\n\nAddition of the 2 complex numbers in 'x+ iy' format is: "<< cmplx.x<<" +i "<< cmplx.y;
        return cmplx;
    }
};

void complex :: get_complex_number()
{
	cout<<"\n\nEnter real compnent of the complex number: ";
	cin>>x;
	cout<<"\n\nEnter imaginary compnent of the complex number: ";
	cin>>y;
}

void complex :: display_complex_number()
{
	cout<<"\n\nComplex number given by the user in 'x+ iy' format is: " << x<<" +i "<< y;
}


int main()
{
    complex cmplx1;
    cmplx1.get_complex_number();
    cmplx1.display_complex_number();

    complex cmplx2;
    cmplx2.get_complex_number();
    cmplx2.display_complex_number();

    complex cmplx3;
    cmplx3 = cmplx3.add_complex_number(cmplx1,cmplx2);

    return 0;
}



