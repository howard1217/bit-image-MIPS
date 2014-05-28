##### sparse2dense function code #####
.text
# sparse2dense will have 2 arguments: $a0 = address of sparse matrix data, $a1 = address of dense matrix, 
	#$a2 = matrix width
# Recall that sparse matrix representation uses the following format:
# Row r<y> {int row#, Elem *node, Row *nextrow}
# Elem e<y><x> {int col#, int value, Elem *nextelem}
sparse2dense:
	### YOUR CODE HERE ###
	la	$t0, 0($a1)	# address of the current position of dense matrix
	li	$t5, 0		# current row count
	li	$t1, 0		# y value on the dense matrix in a row
	la	$t2, 0($a0)	# current row of the sparse matrix
	addiu	$sp, $sp, -16
	sw	$ra, 0($sp)
	sw	$a0, 4($sp)
	sw	$a1, 8($sp)
	sw	$a2, 12($sp)
	sll	$a2, $a2, 2	# the value of width in bytes
rowLoop:
	beq	$t2, $0, return # return if the current row is null
	li	$t1, 0		# set the column count of the dense matrix to 0
	move	$a0, $t5	# move the row count of the dense matrix into argument
	lw 	$a1, 0($t2)	# move the row count of the sparse matrix into argument
	j	fillInZeroRows
setRows:
	lw	$t4, 4($t2)	# load the node from current row
	lw	$t2, 8($t2)	# load the next row
	
columnLoop:
	beq	$t1, $a2, finishRow	# iterate through a new row if the column count equals the width
	move 	$a0, $t1	# move the column count of the dense matrix into argument
	beq	$t4, $0, setRestZero
	lw	$a1, 0($t4) 	# move the column count of the sparse matrix into argument
	sll	$a1, $a1, 2	# current y value for sparse matrix in bytes
	j	fillInZeros
setNum:
	lw	$t3, 4($t4)	# get the value in the current node in sparse matrix
	sw	$t3, 0($t0)	# store the value in the current node in dense matrix
	addiu	$t1, $t1, 4	# add the column count of dense matrix by 4 bytes
	addiu	$t0, $t0, 4	# add the address of dense matrix by 4 bytes
	lw	$t4, 8($t4)	# load the new node
	j	columnLoop	

return:
	lw	$v0, 8($sp)
	jr	$ra	
	
fillInZeros:
	beq	$a0, $a2, finishRow
	beq	$a0, $a1, setNum	# if the column counts are the same for dense and sparse, set the current num
	sw	$0,  0($t0)	# store zero into current address of dense matrix
	addiu	$t0, $t0, 4	# increment the address count by 4 bytes
	addiu	$t1, $t1, 4	# increment the column count by 4 bytes
	addiu	$a0, $a0, 4	# increment the column count by 4 bytes
	j	fillInZeros

fillInZeroRows:
	beq	$a0, $a1, setRows # if the row counts are the same for dense and sparse, set the rows
	addu	$t0, $t0, $a2	# increment the address count by the width
	addi	$a0, $a0, 1	# increment the row count for dense matrix by 1
	addi	$t5, $t5, 1	# increment the row count for dense matrix by 1
	j	setRows
	
setRestZero:
	addiu	$a1, $a2, 0
	j	fillInZeros
	
finishRow:
	addi	$t5, $t5, 1
	j	rowLoop

	