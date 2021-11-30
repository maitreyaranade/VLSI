#include<stdio.h>
#include<conio.h>

int main()
{
    int number;
    printf("Enter a number to check for a Prime number: \n");
    scanf("%d", &number);
    int i = 2;
    int remainder = 0;
    int loopFlag = 0;
    while(i < number)
    {
        remainder = number % i;
        // printf("\n i = %d, remainder = %d, number = %d", i, remainder, number);
        if(remainder == 0)
        {
            printf("Given number is not a Prime number.\n");
            loopFlag = 1;
            break;
        }
        i++;
    }

    if(loopFlag != 1)
    {
        printf("Given number is a Prime number.\n");
    }

    return 0;     

}