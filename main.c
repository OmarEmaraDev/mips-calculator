#include <float.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

void subtract() {
  puts("Enter the a in (a - b):");
  float a;
  scanf("%f", &a);
  puts("Enter the b in (a - b):");
  float b;
  scanf("%f", &b);
  puts("The result is:");
  printf("%.2f\n", a - b);
}

void divide() {
  puts("Enter the a in (a / b):");
  float a;
  scanf("%f", &a);
  puts("Enter the b in (a / b):");
  float b;
  scanf("%f", &b);

  if (b == 0.0f) {
    puts("The divisior must not be zero!");
    return;
  }

  puts("The result is:");
  printf("%.2f\n", a / b);
}

void power() {
  puts("Enter the a in (a ^ b):");
  float a;
  scanf("%f", &a);
  puts("Enter the b in (a ^ b):");
  float b;
  scanf("%f", &b);
  puts("The result is:");
  printf("%.2f\n", pow(a, b));
}

void max() {
  puts("Enter the length of the list you want to compute the max for:");
  int n;
  scanf("%d", &n);
  if (n < 2) {
    puts("The list must have at least two elements!");
    return;
  }

  float max = -FLT_MAX;
  for (int i = 0; i < n; i++) {
    puts("Enter the next number:");
    float number;
    scanf("%f", &number);
    if (number > max) {
      max = number;
    }
  }

  puts("The result is:");
  printf("%.2f\n", max);
}

void factorial() {
  puts("Enter the number to compute the factorial for:");
  int n;
  scanf("%d", &n);
  if (n < 0) {
    puts("The number must not be negative!");
    return;
  }

  int factorial = 1;
  for (int i = 1; i <= n; i++) {
    factorial *= i;
  }

  puts("The result is:");
  printf("%d\n", factorial);
}

void quit() { exit(0); }

void (*branchTable[])() = {&subtract, &divide, &max, &power, &factorial, &quit};

int main() {
  while (1) {
    puts("Choose the operation you would like to perform:");
    puts("  Subtract: 0");
    puts("  Divide: 1");
    puts("  Max: 2");
    puts("  Power: 3");
    puts("  Factorial: 4");
    puts("  Quit: 5");
    puts("");

    int n;
    scanf("%d", &n);
    if (n < 0 || n > 5) {
      puts("Invalid operation!");
      continue;
    }

    (*branchTable[n])();

    puts("");
  }
  return 0;
}
