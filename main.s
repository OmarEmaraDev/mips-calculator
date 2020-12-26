# Definitions for system constants.
.eqv WORD_SIZE 4

# Definitions for system calls.
.eqv SYS_PRINT_INTEGER 1
.eqv SYS_PRINT_STRING 4
.eqv SYS_READ_INTEGER 5
.eqv SYS_EXIT 10
.eqv SYS_PRINT_CHARACTER 11
.eqv SYS_READ_CHARACTER 12

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

# Print the integer stored in a0.
.text
printInteger:
  push_ra
  li $v0, SYS_PRINT_INTEGER
  syscall
  pop_ra_and_return

# Print the null terimated string that starts at the addres stored in a0.
.text
printString:
  push_ra
  li $v0, SYS_PRINT_STRING
  syscall
  pop_ra_and_return

# Print a new line character.
.text
printNewLine:
  push_ra
  li $v0, SYS_PRINT_CHARACTER
  li $a0, '\n'
  syscall
  pop_ra_and_return

# Read an integer and store it in $v0.
.text
readInteger:
  push_ra
  li $v0, SYS_READ_INTEGER
  syscall
  pop_ra_and_return

# Read a character and store it in $v0.
.text
readCharacter:
  push_ra
  li $v0, SYS_READ_CHARACTER
  syscall
  pop_ra_and_return

# Exist the program.
.text
exit:
  li $v0, SYS_EXIT
  syscall

#####
# Operations
#####

.data
unimplemented_message: .asciiz  "Unimplemented operation!\n"
result_message: .asciiz  "The result is:\n"

# Subtract operation.

.data
subtract_a_message: .asciiz  "Enter the a in (a - b):\n"
subtract_b_message: .asciiz  "Enter the b in (a - b):\n"

.text
subtract:
  push_ra
  # Print the message for a.
  la $a0, subtract_a_message
  jal printString

  # Read a.
  jal readInteger
  move $t0, $v0

  # Print the message for b.
  la $a0, subtract_b_message
  jal printString

  # Read b.
  jal readInteger
  move $t1, $v0

  # Subtract.
  sub $t3, $t0, $t1

  # Print the result message.
  la $a0, result_message
  jal printString

  # Print the result.
  move $a0, $t3
  jal printInteger
  jal printNewLine

  pop_ra_and_return

# Divide operation.

.text
divide:
  push_ra
  la $a0, unimplemented_message
  jal printString
  pop_ra_and_return

# Max operation.

.text
max:
  push_ra
  la $a0, unimplemented_message
  jal printString
  pop_ra_and_return

# Power operation.

.text
power:
  push_ra
  la $a0, unimplemented_message
  jal printString
  pop_ra_and_return

# Factorial operation.

.text
factorial:
  push_ra
  la $a0, unimplemented_message
  jal printString
  pop_ra_and_return

#####
# Main
#####

.data
help_message: .ascii   "Choose the operation you would like to perform:\n"
              .ascii   "  Subtract: 0\n"
              .ascii   "  Divide: 1\n"
              .ascii   "  Max: 2\n"
              .ascii   "  Power: 3\n"
              .ascii   "  Factorial: 4\n"
              .asciiz  "  Exit: 5\n\n"

invalid_operation_message: .asciiz  "Invalid operation!\n"

# Construct the operations branch table.
branch_table: .word subtract, divide, max, power, factorial, exit

.text
.globl main
main:
  # Print the help message.
  la $a0, help_message
  jal printString

  # Read the operation code.
  jal readInteger
  move $s0, $v0

  # Validate the operation code.
  sge $t0, $s0, 0
  sle $t1, $s0, 5
  and $t3, $t0, $t1
  bnez $t3, is_valid_operation_code
    la $a0, invalid_operation_message
    jal printString
    b main
  is_valid_operation_code:

  # Call the operation from the branch table.
  sll $s0, $s0, 2
  lw $s0, branch_table($s0)
  jalr $s0

  # Print a new line and repeat main.
  jal printNewLine
  b main
