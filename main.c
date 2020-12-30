#include <math.h>
#include <stdio.h>

void subtract() {
  float a, b;
  printf("Enter the a in (a - b):\n");
  scanf("%f", &a);
  printf("Enter the b in (a - b):\n");
  scanf("%f", &b);
  puts("The result is: ");
  printf("%.2f\n", a - b);
}

void divide() {
  float a, b;
  printf("Enter the a in (a / b):\n");
  scanf("%f", &a);
  printf("Enter the b in (a / b):\n");
  scanf("%f", &b);
  if (b == 0) {
    puts("The denominator musn't be zero");
    return;
  }
  puts("The result is: ");
  printf("%.2f\n", a / b);
}

void power() {
  float a, b;
  printf("Enter the a in (a ^ b):\n");
  scanf("%f", &a);
  printf("Enter the b in (a ^ b):\n");
  scanf("%f", &b);
  puts("The result is: ");
  printf("%.2f", pow(a, b));
}

void max() {
  int n;
  float max, number;
  printf("Enter how many iterations you want:\n");
  scanf("%d", &n);

  printf("Enter the number: ");
  scanf("%f", &number);
  max = number;
  n--;
  for (int i = 0; i < n; i++) {
    printf("Enter the number: ");
    scanf("%f", &number);
    if (number > max) {
      max = number;
    }
  }
  printf("The max = %.2f\n", max);
}

void factorial() {
  int a;
  printf("Enter to get the factorial of number a\n");
  scanf("%d", &a);
  if (a < 0) {
    printf("it must be greater than zero\n");
    return;
  } else if (a == 0 || a == 1) {
    printf("%d\n", 0);
    return;
  }
  int sum = 1;
  do {
    sum *= a--;
  } while (a != 1);
  printf("%d\n", sum);
}

void (*branchTable[])() = {&subtract, &divide, &max, &power, &factorial};

int main() {
  while (1) {
    puts("Choose the operation you would like to perform: ");
    puts("Subtract: 0");
    puts("Divide: 1");
    puts("Max: 2");
    puts("Power: 3");
    puts("Factorial: 4");
    puts("Exit: 5");
    int n;
    scanf("%d", &n);
    if (n == 5) {
      return 0;
    }
    if (n < 5 && n >= 0) {
      (*branchTable[n])();
    }
  }
  return 0;
}
