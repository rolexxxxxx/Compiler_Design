#include<stdio.h>
int main ( ) 
{
    int num;
    int fact;
    fact=1;
    printf("Enter a number: ");
    scanf( "%d", &num );
    if (num < 0)
    {
        printf("Factorial of a negative number is undefined.\n");
	}
	else {
        int i;
        i=1;
        while(i<=num)
        {
        	fact=fact*i;
        	i=i+1;
        }
        
        printf("Factorial of %d is %d.\n", num, fact);
    }
    return 0;
}
