

.data
	input: .asciiz "Enter a number: "
	output: .asciiz "The number of 1bit is "
.text
main:
	#prompt for input
	li $v0, 4
	la $a0, input
	syscall
	
	#gets input
	li $v0, 5
	syscall

	#move such where it needs and jumps
	move $a0, $v0

bitcount:
	#move arg into temp
	move $t0, $a0
	loop:
		#compare rightmost to see if 1
		andi $t1, $t0, 1
		#if it's 0, we don't need to add 1. (ie compare 1 and 1 = 1. 1 and 0 = 0)
		beq $t1, 0, add0
		#Add 1 to count. Well, really added s0+1 to count. But is same
		addi $s0, $s0, 1
	
		add0:
		#shift down 1
		srl $t0, $t0, 1
	
		#jump back to start as not done. otherwise print
		bne $t0, $zero, loop
		j print
print:
	#output prompt
	li $v0, 4
	la $a0, output
	syscall

	#move variables to print and print
	li $v0, 1
	move $a0, $s0
	syscall
	
	#neatly ends the program
	li $v0, 10
	syscall
