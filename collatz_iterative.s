# CS61C Sp14 Project 1-2
# Task A: The Collatz conjecture

.globl main
.include "collatz_common.s"

main:
	jal read_input			# Get the number we wish to try the Collatz conjecture on
	move $a0, $v0			# Set $a0 to the value read
	la $a1, collatz_iterative	# Set $a1 as ptr to the function we want to execute
	jal execute_function		# Execute the function
	li $v0, 10			# Exit
	syscall
	
# --------------------- DO NOT MODIFY ANYTHING ABOVE THIS POINT ---------------------

# Returns the stopping time of the Collatz function (the number of steps taken till the number reaches one)
# using an ITERATIVE approach. This means that if the input is 1, your function should return 0.
#
# The initial value is stored in $a0, and you may assume that it is a positive number.
# 
# Make sure to follow all function call conventions.
collatz_iterative:
	addu $v0, $0, $0 #initialize count to zero
	
	loop:
	beq $a0, 1, return #$a0 = argument; testing if its equal to 1
	addiu $t2, $0, 2  #set t2 = 2
	div $a0, $t2	#divide arg by 2 to determine if its even or odd
	mfhi $t0	#mfhi moves the result of the division to t0
	beqz $t0, thenEven #if t0 is even -> thenEven else 
	# else
	addiu $t1, $0, 3 #set t1 = 3
	mult $a0, $t1	# arg * 3
	mflo $a0 	# arg = arg * 3
	addiu $a0, $a0, 1 #arg += 1
	addiu $v0,$v0, 1 # increment count
	j loop
	#then 
	thenEven:
	addiu $t1, $0, 2 #set t1 = 2
	div $a0, $t1 	#arg/2 
	mflo $a0	# arg = arg / 2
	addiu $v0,$v0, 1 #incrrment count
	j loop 	#loop
  
return:
	jr $ra

