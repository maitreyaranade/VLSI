 /*
 Write a program to construct a matrix M x N using class type object
 Use pointers, memory allocation
 */

#include<iostream>
using namespace std;

// M × N matrix
#define M 3
#define N 3

// Dynamic Memory Allocation in C++ for 2D Array or a matrix
class Matrix {

    private:
    int **A;  // when does this get deallocated?  Look up RAII

    public:
    Matrix()           // contructor 
        {  

        // dynamically create an array of pointers of size `M`
        A = new int*[M];

        // dynamically allocate memory of size `N` for each row
        for (int i = 0; i < M; i++) {
                A[i] = new int[N];
            }
        }
    void set_matrix_values();
    void show_matrix_values();
};

void Matrix :: set_matrix_values()
{    // assign values to the allocated memory
    for (int i = 0; i < M; i++)
    {
        for (int j = 0; j < N; j++) {
            A[i][j] = rand() % 100;
        }
    }
}

void Matrix :: show_matrix_values()
{   
    // print the 2D array
    for (int i = 0; i < M; i++)
    {
        for (int j = 0; j < N; j++) {
            std::cout << A[i][j] << " ";
        }
        std::cout << std::endl;
    }
}

int main()
{ 
    Matrix matrix1;
    matrix1.set_matrix_values();
    matrix1.show_matrix_values();
    return 0;
}