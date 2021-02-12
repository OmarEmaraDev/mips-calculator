# Definitions for system constants.
.eqv WORD_SIZE 4

# ASCII Codes
.eqv ASCII_NEW_LINE 10

# Definitions for system calls.
.eqv SYS_PRINT_INTEGER 1
.eqv SYS_PRINT_FLOAT 2
.eqv SYS_PRINT_STRING 4
.eqv SYS_READ_INTEGER 5
.eqv SYS_READ_FLOAT 6
.eqv SYS_EXIT 10
.eqv SYS_PRINT_CHARACTER 11
.eqv SYS_READ_CHARACTER 12

# Definitions for system call registers.
.eqv REG_SYS_CALL_ID $v0
.eqv REG_PRINT_INTEGER_ARG $a0
.eqv REG_PRINT_FLOAT_ARG $f12
.eqv REG_PRINT_STRING_ARG $a0
.eqv REG_READ_INTEGER_RET $v0
.eqv REG_READ_FLOAT_RET $f0
.eqv REG_PRINT_CHAR_ARG $a0
.eqv REG_READ_CHAR_RET $v0

# Macro to push the return address to the stack.
.macro push_ra
  addi $sp, $sp, -WORD_SIZE
  sw $ra, ($sp)
.end_macro

# Macro to pop the return address from the stack and jump to it.
.macro pop_ra_and_return
  lw $ra, ($sp)
  addi $sp, $sp, WORD_SIZE
  jr $ra
.end_macro

#####
# Utilities
#####

# Print the integer stored in REG_PRINT_INTEGER_ARG.
.text
printInteger:
  push_ra
  li REG_SYS_CALL_ID, SYS_PRINT_INTEGER
  syscall
  pop_ra_and_return

# Print the float stored in REG_PRINT_FLOAT_ARG.
.text
printFloat:
  push_ra
  li REG_SYS_CALL_ID, SYS_PRINT_FLOAT
  syscall
  pop_ra_and_return

# Print the null terimated string that starts at the address
# stored in REG_PRINT_STRING_ARG.
.text
printString:
  push_ra
  li REG_SYS_CALL_ID, SYS_PRINT_STRING
  syscall
  pop_ra_and_return

# Read an integer and store it in REG_READ_INTEGER_RET.
.text
readInteger:
  push_ra
  li REG_SYS_CALL_ID, SYS_READ_INTEGER
  syscall
  pop_ra_and_return

# Read a float and store it in REG_READ_FLOAT_RET.
.text
readFloat:
  push_ra
  li REG_SYS_CALL_ID, SYS_READ_FLOAT
  syscall
  pop_ra_and_return

# Exist the program.
.text
quit:
  li REG_SYS_CALL_ID, SYS_EXIT
  syscall

# Print the character stored in REG_PRINT_CHAR_ARG.
.text
printCharacter:
  push_ra
  li REG_SYS_CALL_ID, SYS_PRINT_CHARACTER
  syscall
  pop_ra_and_return

# Print a new line character.
.text
printNewLine:
  push_ra
  li REG_PRINT_CHAR_ARG, ASCII_NEW_LINE
  jal printCharacter
  pop_ra_and_return

# Read a character and store it in REG_READ_CHAR_RET.
.text
readCharacter:
  push_ra
  li REG_SYS_CALL_ID, SYS_READ_CHARACTER
  syscall
  pop_ra_and_return

#####
# Operations
#####

.data
result_message: .asciiz "The result is:\n"

# Subtract operation.

.data
subtract_a_message: .asciiz "Enter the a in (a - b):\n"
subtract_b_message: .asciiz "Enter the b in (a - b):\n"

.text
subtract:
  push_ra
  # Print the message for a.
  la REG_PRINT_STRING_ARG, subtract_a_message
  jal printString

  # Read a.
  jal readFloat
  mov.s $f24, REG_READ_FLOAT_RET

  # Print the message for b.
  la REG_PRINT_STRING_ARG, subtract_b_message
  jal printString

  # Read b.
  jal readFloat
  mov.s $f25, REG_READ_FLOAT_RET

  # Print the result message.
  la REG_PRINT_STRING_ARG, result_message
  jal printString

  # Subtract.
  sub.s REG_PRINT_FLOAT_ARG, $f24, $f25

  # Print the result.
  jal printFloat
  jal printNewLine

  pop_ra_and_return

# Divide operation.

.data
divide_a_message: .asciiz "Enter the a in (a / b):\n"
divide_b_message: .asciiz "Enter the b in (a / b):\n"
divide_error_message: .asciiz "The divisor must not be zero!\n"

.text
divide:
  push_ra
  # Print the message for a.
  la REG_PRINT_STRING_ARG, divide_a_message
  jal printString

  # Read a.
  jal readFloat
  mov.s $f24, REG_READ_FLOAT_RET

  # Print the message for b.
  la REG_PRINT_STRING_ARG, divide_b_message
  jal printString

  # Read b.
  jal readFloat
  mov.s $f25, REG_READ_FLOAT_RET

  # Check if the divisor is zero.
  mtc1 $zero, $f4
  c.eq.s $f25, $f4
  bc1f non_zero_divisor
    la REG_PRINT_STRING_ARG, divide_error_message
    jal printString
    pop_ra_and_return
  non_zero_divisor:

  # Print the result message.
  la REG_PRINT_STRING_ARG, result_message
  jal printString

  # Divide
  div.s REG_PRINT_FLOAT_ARG, $f24, $f25

  # Print the result.
  jal printFloat
  jal printNewLine

  pop_ra_and_return

# Max operation.

.data
max_list_length_message: .asciiz "Enter the length of the list you want to compute the max for:\n"
max_input_message: .asciiz "Enter the next number:\n"
max_error_message: .asciiz "The list must have at least two elements!\n"

.text
max:
  push_ra
  # Print the message for the list length.
  la REG_PRINT_STRING_ARG, max_list_length_message
  jal printString

  # Read the length of the list.
  jal readInteger
  move $s0, REG_READ_INTEGER_RET

  # Check if the length of the list is valid.
  sle $t0, $s0, 1
  beqz $t0, max_list_length_is_valid
    la REG_PRINT_STRING_ARG, max_error_message
    jal printString
    pop_ra_and_return
  max_list_length_is_valid:

  # Print the message for the first number.
  la REG_PRINT_STRING_ARG, max_input_message
  jal printString

  # Read the first number.
  jal readFloat
  mov.s $f24, REG_READ_FLOAT_RET

  # Iterate for the rest of the inputs.
  sub $s0, $s0, 1
  max_loop_start:
  beqz $s0, max_loop_end
    # Print the message for the next input.
    la REG_PRINT_STRING_ARG, max_input_message
    jal printString

    # Read the next number.
    jal readFloat
    mov.s $f25, REG_READ_FLOAT_RET

    # If the new number is larger, set it.
    c.lt.s $f25, $f24
    bc1t max_input_is_smaller
      mov.s $f24, $f25
    max_input_is_smaller:

    sub $s0, $s0, 1
    b max_loop_start
  max_loop_end:

  # Print the result message.
  la REG_PRINT_STRING_ARG, result_message
  jal printString

  # Print the result.
  mov.s REG_PRINT_FLOAT_ARG, $f24
  jal printFloat
  jal printNewLine

  pop_ra_and_return

# Power operation.
.data
power_a_message: .asciiz "Enter the a in (a ^ b):\n"
power_b_message: .asciiz "Enter the b in (a ^ b):\n"
power_error_message: .asciiz "a can't be 0 when b is less than or equal 0!\n"
one_float: .float 1.0

.text
power:
  push_ra
  # Print the message for a.
  la REG_PRINT_STRING_ARG, power_a_message
  jal printString

  # Read a.
  jal readInteger
  move $s0, REG_READ_INTEGER_RET

  # Print the message for b.
  la REG_PRINT_STRING_ARG, power_b_message
  jal printString

  # Read b.
  jal readInteger
  move $s1, REG_READ_INTEGER_RET

  # Validate inputs.
  seq $t0, $s0, $zero
  sle $s2, $s1, $zero
  and $t1, $t0, $s2
  beqz $t1, is_valid_power_input
    la REG_PRINT_STRING_ARG, power_error_message
    jal printString
    pop_ra_and_return
  is_valid_power_input:

  # Compute the power by multiplying a cumulatively b number of times.
  abs $s1, $s1
  li $t0, 1
  power_loop_start:
  beqz $s1, power_loop_end
    mul $t0, $t0, $s0
    sub $s1, $s1, 1
    b power_loop_start
  power_loop_end:

  # Convert the result into a float.
  mtc1 $t0, $f24
  cvt.s.w $f24, $f24

  # If b is negative, take the reciprocal.
  beqz $s2, is_positive_power
    lwc1 $f25, one_float
    div.s $f24, $f25, $f24
  is_positive_power:

  # Print the result message.
  la REG_PRINT_STRING_ARG, result_message
  jal printString

  # Print the result.
  mov.s REG_PRINT_FLOAT_ARG, $f24
  jal printFloat
  jal printNewLine

  pop_ra_and_return

# Factorial operation.

.data
factorial_message: .asciiz "Enter the number to compute the factorial for:\n"
factorial_error_message: .asciiz "The number must not be negative!\n"

.text
factorial:
  push_ra
  # Print the message for the number.
  la REG_PRINT_STRING_ARG, factorial_message
  jal printString

  # Read the number.
  jal readInteger
  move $t0, REG_READ_INTEGER_RET

  # Validate the input number.
  bgez $t0, is_valid_factorial_input
    la REG_PRINT_STRING_ARG, factorial_error_message
    jal printString
    pop_ra_and_return
  is_valid_factorial_input:

  # Compute the factorial by multiplying by integers from [number: 1].
  li $s1, 1
  factorial_loop_start:
  beqz $t0, factorial_loop_end
    mul $s1, $s1, $t0
    sub $t0, $t0, 1
    b factorial_loop_start
  factorial_loop_end:

  # Print the result message.
  la REG_PRINT_STRING_ARG, result_message
  jal printString

  # Print the result.
  move REG_PRINT_INTEGER_ARG, $s1
  jal printInteger
  jal printNewLine

  pop_ra_and_return

#####
# Main
#####

.data
help_message: .ascii  "Choose the operation you would like to perform:\n"
              .ascii  "  Subtract: 0\n"
              .ascii  "  Divide: 1\n"
              .ascii  "  Max: 2\n"
              .ascii  "  Power: 3\n"
              .ascii  "  Factorial: 4\n"
              .asciiz "  Quit: 5\n\n"

invalid_operation_message: .asciiz "Invalid operation!\n"

# Construct the operations branch table.
branch_table: .word subtract, divide, max, power, factorial, quit

.text
.globl main
main:
  # Print the help message.
  la REG_PRINT_STRING_ARG, help_message
  jal printString

  # Read the operation code.
  jal readInteger
  move $s0, REG_READ_INTEGER_RET

  # Validate the operation code.
  sge $t0, $s0, 0
  sle $t1, $s0, 5
  and $t3, $t0, $t1
  bnez $t3, is_valid_operation_code
    la REG_PRINT_STRING_ARG, invalid_operation_message
    jal printString
    b main
  is_valid_operation_code:

  # Call the operation from the branch table.
  # Multiply by WORD_SIZE, which is equivalent to a left shift by 2.
  mul $s0, $s0, WORD_SIZE
  lw $s0, branch_table($s0)
  jalr $s0

  # Print a new line and repeat main.
  jal printNewLine
  b main
