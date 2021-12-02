#include<stdio.h>
#include<conio.h>
#include <math.h>

// Binary Decimal conversion of numbers
int main()
{
    // Binary to Decimal
    int number1;
    printf("Enter a number in binary format only for converting it into decimal: \n"); 
    scanf("%d", &number1);
    
    // int binaryInput = 0;
    int decimalConverted = 0;
    int temp = number1;
    int decimalPower = 0;
    while(temp != 0)
    {
        // binaryInput = temp%10;
        decimalConverted += pow(2, decimalPower) * (temp % 10);
        // printf("Binary: %d, Decimal Power = %d, Decimal: %d, temp = %d\n", binaryInput, decimalPower, decimalConverted, temp);
        temp /= 10;
        decimalPower++;
    }
    printf("Binary number %d converted into Decimal form is %d \n", number1, decimalConverted);
 
    // Decimal to Binary
    int number2;
    // or you can take a user input here
    number2 = decimalConverted;
    // printf("Enter a number in decimal for converting it into binary: \n"); 
    // scanf("%d", &number2);

    int temp2 = number2;
    int binaryPower = 0;
    int binaryConverted = 0;
    while(temp2 != 0)
    {
        binaryConverted += pow(10, binaryPower) * (temp2 % 2);
        temp2 /= 2;
        // printf("Binary: %d, Decimal Power = %d, Decimal: %d\n", binaryConverted, decimalPower, temp2);
        binaryPower++;
    }
    printf("Decimal number %d converted into Binary form is %d \n", number2, binaryConverted);


    

    return 0;     


}
