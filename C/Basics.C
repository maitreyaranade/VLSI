#include <stdio.h>
#include <limits.h>


int globalVariable = 100;

int main(int argc, char **argv)
{  
    printf("\nargc = %d", argc );
    int k;
    for (k = 0; k < argc; k++)
    {   printf("\nargv[%d] = %s", k, argv[k] );
    }
     

    int localVariable = 10;
    printf("\nSize of short int: %d \n", sizeof(short int));
    printf("Size of int: %d \n", sizeof(int));
    printf("Size of long int: %d \n", sizeof(long int));
    printf("Size of long long int: %d \n", sizeof(long long int));
    printf("sizeof(short) <= sizeof(int) <= sizeof(long) <= sizeof(long long) \n");    
    printf("Size of char: %d \n", sizeof(char));
    printf("Size of float: %d \n", sizeof(float));
    printf("Size of double: %d \n", sizeof(double));
    printf("Size of long double: %d \n", sizeof(long double));
    
    int signedIntLow = INT_MIN;
    int signedIntHigh = INT_MAX;

    printf("Range of signed integer is from: %d to %d \n", signedIntLow, signedIntHigh);

    unsigned int unsignedIntLow = 0;
    unsigned int unsignedIntHigh = UINT_MAX;

    printf("Range of unsigned integer is from: %u to %u \n", unsignedIntLow, unsignedIntHigh);

    short int shortSignedIntLow = SHRT_MIN;
    short int shortSignedIntHigh = SHRT_MAX;

    printf("Range of short signed integer is from: %d to %d \n", shortSignedIntLow, shortSignedIntHigh);

    short unsigned int shortUnsignedIntLow = 0;
    short unsigned int shortUnsignedIntHigh = USHRT_MAX;

    printf("Range of unsigned short signed integer is from: %u to %u \n", shortUnsignedIntLow, shortUnsignedIntHigh);

    long int longSignedIntLow =  LONG_MIN;
    long int longSignedIntHigh = LONG_MAX;

    printf("Range of long signed integer is from: %ld to %ld \n", longSignedIntLow, longSignedIntHigh);

    long unsigned int longUnsignedIntLow = 0;
    long unsigned int longUnsignedIntHigh = ULONG_MAX;

    printf("Range of unsigned long signed integer is from: %lu to %lu \n", longUnsignedIntLow, longUnsignedIntHigh);

    printf("\n ------- Pointers ----------");

    int i = 3;
    int *j;
    printf("\nj is a pointer pointing to i which stores value of 3");

    j = &i;
    printf ( "\nAddress of i = %u", &i );
    printf ( "\nAddress of i = %u", j );
    printf ( "\nAddress of j = %u", &j );
    printf ( "\nValue of j = %u", j );
    printf ( "\nValue of i = %d", i );
    printf ( "\nValue of i = %d", *( &i ) );
    printf ( "\nValue of i = %d", *j );


    return 0;
}