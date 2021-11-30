#include<stdio.h>
#include<conio.h>

/* A number can be said as a strong number when the sum of the factorial of the individual digits is equal to the number. */


/* function declaration */
int fact(int num1);

int main()
{
    int number;
    printf("Enter a number to check for a strong number: \n");
    scanf("%d", &number);
    // int factorial = fact(number);
    // printf("%d\n", factorial);

    //  ---------------------- Method 1 ----------------------------
    int count = 0;
    int num = number;
    int n = number;
    //  Calculating number of digits
    while (n != 0)
    {
        n /= 10;
        count++;
    }

    // Add factorials of digits
    int strongNumber =0;
    while(num != 0){
        int digit = num % 10;
        num = num / 10;
        strongNumber = strongNumber + fact(digit);
    }

    if(number == strongNumber)
    {
        printf(" Given number is a strong number! \n");
    }
    else{
        printf(" Given number is not a strong number! \n");
    }

    return 0;
}


/* function returning factorial of a numbers */
int fact(int num1) {

    /* local variable declaration */
    int fact = 1;

    for (int i = num1; i > 0; i--)
    {   
        fact = fact * i;       
    }
 
   return fact; 
}