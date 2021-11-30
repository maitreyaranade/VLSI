#include<stdio.h>
#include<conio.h>
// Adding Two Numbers Without Using The + Operator
int main()
{
    int number1, number2;
    printf("Enter first number: \n"); 
    scanf("%d", &number1);
    printf("Enter second number: \n"); 
    scanf("%d", &number2);
    int sum = number1;

    // Addition of Two Numbers Without Using The + Operator

    for (int i = 0; i < number2; i++)
    {
        sum++;
    }
    
    printf("Sum of the two numbers using increment operator is: %d\n", sum);


    // Addition of Two Numbers using half adder method
    int sum2, a, b, carry;
    a = number1;
    b = number2;
    while (b != 0)
    {
        sum2 = a^b;
        carry = (a&b)<<1;
        a = sum2;
        b = carry;
    }

    printf("Sum of the two numbers using half adder method is: %d", a);

    return 0;     


}
