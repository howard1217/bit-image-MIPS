##### Variables #####
.data
# Header for dense matrix
head:		.asciiz	"  -----0----------1----------2----------3----------4----------5----------6----------7----------8----------9-----\n"

##### print_dense function code #####
.text
# print_dense will have 3 arguments: $a0 = address of dense matrix, $a1 = matrix width, $a2 = matrix height
print_dense:
    addiu $sp, $sp, -4
    sw $ra, 0($sp)
    li $v0, 4 #load immediate with printing code
    move $t4, $a0
    la $a0, head
    jal print_str
    #count = t0 = 0
    addiu $t0, $0, 0
    loopOuter:
    	bge $t0, $a2, finOuter
    	# while (count < matrix height) {
    	# print out the current row number, t0
    	move $a0, $t0
    	jal print_int
    	jal print_space
    	#count for width = t1 = 0
    	addiu $t1, $0, 0
		loopInner: 
    			bge $t1, $a1, finInner
    			lw $a0, 0($t4)
    			jal print_intx
    			addiu $t1, $t1, 1
    			addiu $t4, $t4, 4
    			jal print_space
    			j loopInner
    	finInner:
    	addiu $t0, $t0, 1
    	jal print_newline
    	j loopOuter
    finOuter:
    lw $ra, 0($sp)
    addiu $sp, $sp, 4
    jr $ra