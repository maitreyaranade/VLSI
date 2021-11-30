#include <stdio.h>

/* function declaration */
int sum_recursion( int arr[], int n); 

int main()
{
    /* Variable declaration */
   int array[] = {1,2,3,4,5,6,7};
   int i, sumPointer =0;
   int *ptr;

   printf("\n ------ Sum of array elements using pointers ------ \n");

   /* array is equal to base address
    * array = &array[0] */
   ptr = array;

   for(i=0;i<7;i++) 
   {
        //*ptr refers to the value at address
        sumPointer = sumPointer + *ptr;
        printf("\nPointer points to this address: %d", ptr);
        printf("\nValue stored at this address: %d", *ptr);
        ptr++;
   }

   printf("\nSum of array elements using pointers is: %d", sumPointer);

   printf("\n\n ------ Sum of array elements using recursion ------ \n");

   
   int sumRecursion;
   sumRecursion = sum_recursion(array,6);
   printf("\nSum of array elements using recursion is: %d", sumRecursion);

   return 0;
}

int sum_recursion( int arr[], int n ) 
{
   if (n < 0) {
     //base case:
     return 0;
    } else{
     //Recursion: calling itself
     return arr[n] + sum_recursion(arr, n-1);
    }
}