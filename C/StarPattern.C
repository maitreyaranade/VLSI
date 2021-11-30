#include<stdio.h>
#include<conio.h>

int main()
{
    int n;
    printf("Enter the number of levels (1-10) in a pyramid: \n");
    scanf("%d", &n);

    // Normal pyramid of stars
    printf("\n  -- Pyramid of Stars --  \n\n");
    for (int row = 0; row <n; row++)
    {
       for (int blank = (n-row); blank > 0; blank--)
       {
           printf(" ");
       }

       for (int col = 0; col < row+1; col++)
       {
           printf("* ");
       }
        printf("\n");
    }
 
    // Pyramid of Numbers
    printf("\n  -- Pyramid of Numbers --  \n\n");
    for (int row = 0; row <n; row++)
    {
       for (int blank = (n-row); blank > 0; blank--)
       {
           printf(" ");
       }

       for (int col = 0; col < row+1; col++)
       {
           printf("%d ", row+1);
       }
        printf("\n");
    }

    
    // Floyd's Triangle
    printf("\n  -- Floyd's Triangle--  \n\n");
    int number = 1;
    for (int row = 0; row <n; row++)
    {
       for (int blank = (n-row); blank > 0; blank--)
       {
           printf(" ");
       }

       for (int col = 0; col < row+1; col++)
       {
           printf("%d ", number);
           number++;
       }
        printf("\n");
    }

    // Pyramid of Alphabets
    printf("\n  -- Pyramid of Alphabets --  \n\n");
    char alphabet = 'A';
    for (int row = 0; row <n; row++)
    {
       for (int blank = (n-row); blank > 0; blank--)
       {
           printf(" ");
       }

       for (int col = 0; col < row+1; col++)
       {
           printf("%c ", alphabet);
       }
        printf("\n");
        alphabet++;
    }

    // Inverted pyramid
    printf("\n  -- Inverted Pyramid of Stars --  \n\n");
    for (int row = 0; row < n; row++)
    {
       for (int blank = 0; blank < row; blank++)
       {
           printf(" ");
       }

       for (int col = (n-row); col > 0; col--)
       {
           printf("* ");
       }
        printf("\n");
    }
    
    // Half pyramid
    printf("\n  -- Half Pyramid of Stars --  \n\n");
    for (int row = 0; row <= n; row++)
    {
       for (int col = 1; col < row +1; col++)
       {
           printf("* ");
       }
        printf("\n");
    }
    
    // Half pyramid Inverted
    printf("\n -- Half Inverted Pyramid of Stars -- \n\n");
    for (int row = 0; row <= n; row++)
    {
       for (int col = (n-row); col > 0; col--)
       {
           printf("* ");
       }
        printf("\n");
    }

    // Half pyramid flipped
    printf("\n  -- Half flipped Pyramid of Stars --  \n\n");
    for (int row = 0; row <= n; row++)
    {
       for (int blank = 0; blank < row; blank++)
       {
           printf("  ");
       }

       for (int col = (n-row); col > 0; col--)
       {
           printf("* ");
       }
        printf("\n");
    }
}