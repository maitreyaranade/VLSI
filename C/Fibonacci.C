#include<stdio.h>
#include<conio.h>

int main()
{
    int number;
    printf("Enter number of values (>2) to compute in a Fibonacci series: \n");
    scanf("%d", &number);

    //  ---------------------- Method 1 ----------------------------
    // printf("\nPalindrome check by Method 1: ");
    int count = number-2;
    int number1 = 0;
    int number2 = 1;
    int sum = 0;

    printf("Fibonacci series: 0, 1");
    
    for (int i = 0; i < count; i++)
    {  
        sum = number1 + number2;
        printf(", %d", sum);  
        number1 = number2;
        number2 = sum;  
    }

    return 0;     

}