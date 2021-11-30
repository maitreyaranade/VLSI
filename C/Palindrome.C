#include<stdio.h>
#include<conio.h>

int main()
{
    int number;
    printf("Enter a number to check for a palindrome: \n");
    scanf("%d", &number);

    //  ---------------------- Method 1 ----------------------------
    printf("\nPalindrome check by Method 1: ");
    int count = 0;
    int num = number;
    int n = number;
    //  Calculating number of digits
    while (n != 0)
    {
        n /= 10;
        count++;
    }

    // All single digit numbers are palindrome
    // Palindrome check 
    int digits[count]; 
    int arrayIndex = 0;
    while(num != 0){
        int digit = num % 10;
        num = num / 10;
        digits[arrayIndex] = digit;
        arrayIndex++;
        // printf("%d\n", digit);
    }

    // Check the array for palindrome
    int palindromeFlag = 0;
    for (int i = 0; i < count; i++)
    {  
        // printf("Array element at %d location is: %d \n", i, digits[i]);
        // printf("Comparing digits: %d, %d \n", digits[i], digits[count - i -1]);
        if (digits[i] != digits[count - i -1]){
            palindromeFlag = 1;
        }            
    }
    
    if(palindromeFlag == 1)
    {
        printf(" Given number is not a palindrome! \n");
    }
    else{
        printf(" Given number is a palindrome! \n");
    }



    //  ---------------------- Method 2 ----------------------------
    int r,sum=0,temp; 
    int num2;
    num2 = number;
    temp = number;   
    printf("Palindrome check by Method 2: ");
    while(num2 > 0)    
    {    
        r = num2%10;    
        sum =(sum*10) + r;    
        num2 = num2/10;  
        // printf("Reverse number: %d, %d, %d \n", r, sum, num2);  
    }    

    if(temp==sum)    
        printf(" Given number is a palindrome! \n");
    else    
        printf(" Given number is not a palindrome! \n");

    return 0;     

}