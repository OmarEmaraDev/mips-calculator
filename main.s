# vim: filetype=asm

.equ DWORD_SIZE, 8

# Allocate a number of double words on the stack.
.macro stack_allocate n
  daddiu $sp, $sp, -(DWORD_SIZE * \n)
.endm

# Free a number of double words from the stack.
.macro stack_free n
  daddiu $sp, $sp, (DWORD_SIZE * \n)
.endm

# Store the GPR r in the stack at index n.
.macro stack_store_gpr r, n
  sd \r, (DWORD_SIZE * \n)($sp)
.endm

# Load the stack value at index n into GPR r.
.macro stack_load_gpr r, n
  ld \r, (DWORD_SIZE * \n)($sp)
.endm

# Load the stack value at index n into FPR r.
.macro stack_load_fpr r, n
  ldc1 \r, (DWORD_SIZE * \n)($sp)
.endm

# Load the address of the stack element at index n into GPR r.
.macro stack_load_address r, n
  daddiu \r, $sp, (DWORD_SIZE * \n)
.endm

#####
# Utilities
#####

# Print the long stored in $a0.

.data
print_long_format: .asciz "%ld"

.text
printLong:
  stack_allocate 1
  stack_store_gpr $ra, 0

  move $a1, $a0
  dla $a0, print_long_format
  jal printf

  stack_load_gpr $ra, 0
  stack_free 1
  jr $ra

# Print the double stored in $f12.

.data
print_double_format: .asciz "%lf"

.text
printDouble:
  stack_allocate 1
  stack_store_gpr $ra, 0

  dmfc1 $a1, $f12
  dla $a0, print_double_format
  jal printf

  stack_load_gpr $ra, 0
  stack_free 1
  jr $ra

# Print the null terimated string that starts at the address
# stored in $a0.

.data
print_string_format: .asciz "%s"

.text
printString:
  stack_allocate 1
  stack_store_gpr $ra, 0

  move $a1, $a0
  dla $a0, print_string_format
  jal printf

  stack_load_gpr $ra, 0
  stack_free 1
  jr $ra

# Read a long and store it in $v0.

.data
read_long_format: .asciz "%ld"

.text
readLong:
  stack_allocate 2
  stack_store_gpr $ra, 0

  dla $a0, read_long_format
  stack_load_address $a1, 1
  jal scanf
  stack_load_gpr $v0, 1

  stack_load_gpr $ra, 0
  stack_free 2
  jr $ra

# Read a double and store it in $f0.

.data
read_double_format: .asciz "%lf"

.text
readDouble:
  stack_allocate 2
  stack_store_gpr $ra, 0
  
  dla $a0, read_double_format
  stack_load_address $a1, 1
  jal scanf
  stack_load_fpr $f0, 1

  stack_load_gpr $ra, 0
  stack_free 2
  jr $ra

# Print a new line.

.data
empty_string: .asciz ""

.text
printNewLine:
  stack_allocate 1
  stack_store_gpr $ra, 0

  dla $a0, empty_string
  jal puts

  stack_load_gpr $ra, 0
  stack_free 1
  jr $ra

# Exist the program.
.text
quit:
  move $a0, $zero
  jal exit

#####
# Operations
#####

.data
result_message: .asciz "The result is:\n"

# Subtract operation.

.data
subtract_a_message: .asciz "Enter the a in (a - b):\n"
subtract_b_message: .asciz "Enter the b in (a - b):\n"

.text
subtract:
  stack_allocate 1
  stack_store_gpr $ra, 0

  # Print the message for a.
  dla $a0, subtract_a_message
  jal printString

  # Read a.
  jal readDouble
  mov.d $f24, $f0

  # Print the message for b.
  dla $a0, subtract_b_message
  jal printString

  # Read b.
  jal readDouble
  mov.d $f25, $f0

  # Print the result message.
  dla $a0, result_message
  jal printString

  # Subtract.
  sub.d $f12, $f24, $f25

  # Print the result.
  jal printDouble
  jal printNewLine

  stack_load_gpr $ra, 0
  stack_free 1
  jr $ra

# Divide operation.

.data
divide_a_message: .asciz "Enter the a in (a / b):\n"
divide_b_message: .asciz "Enter the b in (a / b):\n"
divide_error_message: .asciz "The divisor must not be zero!\n"

.text
divide:
  stack_allocate 1
  stack_store_gpr $ra, 0

  # Print the message for a.
  dla $a0, divide_a_message
  jal printString

  # Read a.
  jal readDouble
  mov.d $f24, $f0

  # Print the message for b.
  dla $a0, divide_b_message
  jal printString

  # Read b.
  jal readDouble
  mov.d $f25, $f0

  # Check if the divisor is zero.
  li.d $f4, 0
  c.eq.d $f25, $f4
  bc1f 1f
    dla $a0, divide_error_message
    jal printString
    stack_load_gpr $ra, 0
    stack_free 1
    jr $ra
  1:

  # Print the result message.
  dla $a0, result_message
  jal printString

  # Divide
  div.d $f12, $f24, $f25

  # Print the result.
  jal printDouble
  jal printNewLine

  stack_load_gpr $ra, 0
  stack_free 1
  jr $ra

# Max operation.

.data
max_list_length_message: .asciz "Enter the length of the list you want to compute the max for:\n"
max_input_message: .asciz "Enter the next number:\n"
max_error_message: .asciz "The list must have at least two elements!\n"

.text
max:
  stack_allocate 1
  stack_store_gpr $ra, 0

  # Print the message for the list length.
  dla $a0, max_list_length_message
  jal printString

  # Read the length of the list.
  jal readLong
  move $s0, $v0

  # Check if the length of the list is valid.
  slt $t0, $s0, 2
  beqz $t0, 1f
    dla $a0, max_error_message
    jal printString
    stack_load_gpr $ra, 0
    stack_free 1
    jr $ra
  1:

  # Print the message for the first number.
  dla $a0, max_input_message
  jal printString

  # Read the first number.
  jal readDouble
  mov.d $f24, $f0

  # Iterate for the rest of the inputs.
  dsub $s0, $s0, 1
  1:
  beqz $s0, 2f
    # Print the message for the next input.
    dla $a0, max_input_message
    jal printString

    # Read the next number.
    jal readDouble
    mov.d $f25, $f0

    # If the new number is larger, set it.
    c.lt.d $f25, $f24
    bc1t 3f
      mov.d $f24, $f25
    3:

    dsub $s0, $s0, 1
    b 1b
  2:

  # Print the result message.
  dla $a0, result_message
  jal printString

  # Print the result.
  mov.d $f12, $f24
  jal printDouble
  jal printNewLine

  stack_load_gpr $ra, 0
  stack_free 1
  jr $ra

# Power operation.
.data
power_a_message: .asciz "Enter the a in (a ^ b):\n"
power_b_message: .asciz "Enter the b in (a ^ b):\n"
power_error_message: .asciz "a can't be 0 when b is less than or equal 0!\n"

.text
power:
  stack_allocate 1
  stack_store_gpr $ra, 0

  # Print the message for a.
  dla $a0, power_a_message
  jal printString

  # Read the number.
  jal readLong
  move $s0, $v0

  # Print the message for b.
  dla $a0, power_b_message
  jal printString

  # Read the number.
  jal readLong
  move $s1, $v0

  # Validate the input number.
  seq $t0, $s0, $zero
  sle $s2, $s1, $zero
  and $t1, $t0, $s2
  beqz $t1, 1f
    dla $a0, power_error_message
    jal printString
    stack_load_gpr $ra, 0
    stack_free 1
    jr $ra
  1:

  # Compute the power by multiplying a cumulatively b number of times.
  abs $s1, $s1
  dli $t0, 1
  1:
  beqz $s1, 2f
    dmul $t0, $t0, $s0
    dsub $s1, $s1, 1
    b 1b
  2:

  # Convert the result into a float.
  dmtc1 $t0, $f24
  cvt.d.l $f24, $f24

  # If b is negative, take the reciprocal.
  beqz $s2, 1f
    li.d $f25, 1
    div.d $f24, $f25, $f24
  1:

  # Print the result message.
  dla $a0, result_message
  jal printString

  # Print the result.
  mov.d $f12, $f24
  jal printDouble
  jal printNewLine

  stack_load_gpr $ra, 0
  stack_free 1
  jr $ra

# Factorial operation.

.data
factorial_message: .asciz "Enter the number to compute the factorial for:\n"
factorial_error_message: .asciz "The number must not be negative!\n"

.text
factorial:
  stack_allocate 1
  stack_store_gpr $ra, 0

  # Print the message for the number.
  dla $a0, factorial_message
  jal printString

  # Read the number.
  jal readLong
  move $t0, $v0

  # Validate the input number.
  bgez $t0, 1f
    dla $a0, factorial_error_message
    jal printString
    stack_load_gpr $ra, 0
    stack_free 1
    jr $ra
  1:

  # Compute the factorial by multiplying integers in [number: 1].
  dli $s1, 1
  1:
  beqz $t0, 2f
    dmul $s1, $s1, $t0
    dsub $t0, $t0, 1
    b 1b
  2:

  # Print the result message.
  dla $a0, result_message
  jal printString

  # Print the result.
  move $a0, $s1
  jal printLong
  jal printNewLine

  stack_load_gpr $ra, 0
  stack_free 1
  jr $ra

#####
# Main
#####

.data
help_message: .ascii "Choose the operation you would like to perform:\n"
              .ascii "  Subtract: 0\n"
              .ascii "  Divide: 1\n"
              .ascii "  Max: 2\n"
              .ascii "  Power: 3\n"
              .ascii "  Factorial: 4\n"
              .asciz "  Quit: 5\n\n"

invalid_operation_message: .asciz "Invalid operation!\n"

# Construct the operations branch table.
branch_table: .quad subtract, divide, max, power, factorial, quit

.text
.global main
main:
  # Print the help message.
  dla $a0, help_message
  jal printString

  # Read the operation code.
  jal readLong
  move $s0, $v0

  # Validate the operation code.
  sge $t0, $s0, 0
  sle $t1, $s0, 5
  and $t3, $t0, $t1
  bnez $t3, 1f
    dla $a0, invalid_operation_message
    jal printString
    b main
  1:

  # Call the operation from the branch table.
  dmul $s0, $s0, DWORD_SIZE
  ld $s0, branch_table($s0)
  jalr $s0

  # Print a new line and repeat main.
  jal printNewLine
  b main
