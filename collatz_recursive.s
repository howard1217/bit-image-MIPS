# CS61C Sp14 Project 1-2
# Task A: The Collatz conjecture

.globl main
.include "collatz_common.s"

main:
	jal read_input			# Get the number we wish to try the Collatz conjecture on
	move $a0, $v0			# Set $a0 to the value read
	la $a1, collatz_recursive	# Set $a1 as ptr to the function we want to execute
	jal execute_function		# Execute the function
	li $v0, 10			# Exit
	syscall
	
# --------------------- DO NOT MODIFY ANYTHING ABOVE THIS POINT ---------------------

# Returns the stopping time of the Collatz function (the number of steps taken till the number reaches one)
# using an RECURSIVE approach. This means that if the input is 1, your function should return 0.
#
# The current value is stored in $a0, and you may assume that it is a positive number.
#
# Make sure to follow all function call conventions.

collatz_recursive:
	addu $sp, $sp, -4
	sw  $ra, 0($sp)
	addiu $v0, $0, 0 # v0 = 0
	#sw $s0, 4($sp) #  saves times count as s0
	addiu $t0, $zero, 1 # t0 = 1
	beq   $a0, 1, return # if a0 == 1
	#test number for even or odd
	and $t0 ,$a0, 1
	# if (arg % t0 == 0) then even
	beqz $t0, even
	#else its odd
	mul $a0, $a0, 3
	addiu $a0, $a0, 1
	jal collatz_recursive
	addiu $v0, $v0, 1
	j return
	even:
	div $a0, $a0, 2
	jal collatz_recursive
	addiu $v0, $v0, 1

return: 
	lw  $ra, 0($sp)
	addu $sp, $sp, 4
	jr $ra	#jump back to the return address

	