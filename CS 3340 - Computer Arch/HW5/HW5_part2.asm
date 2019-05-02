#Implement the C code snippet above in MIPS assembly language. 
#Use $s0 to hold the variable i. Be sure to handle the stack pointer appropriately.
# The array is stored on the stack of the setArray function 
#(i.e. when setArray function is called it allocates space for the array on the stack.).


#tested going 1 step at a time forward. it works.

.text
setArray:
	#gets a number and moves it to s1 since s0 is for i
	li $v0, 5
	syscall
	move $s1, $v0
	
	#counter also known as i
	li $s0, 0

	#look from 0 to 10.
	loop:
	beq $s0, 10, exit

	#we need to do some work on these first. s0 is i, s1 is num
	move $a0, $s0
	move $a1, $s1
	j compare
	
	#part 2 of the loop, or setting stack array and moving
	loopp2:
		sw $v0, 0($sp)
		addi $sp, $sp, -4
	
	#increase counter
	add $s0, $s0, 1
	j loop
	
	#all done!
	exit:
		li $v0, 10
		syscall
#compare function
compare:
	#jump to sub first
	jal sub
	
	#b1
	#so is sub(num, i) >= 0? if is, go to return1. else return 0
	bge $v0, 0, return1
	li $v0, 0	
	j loopp2
	
	#returns 1
	return1:
		li $v0, 1
		j loopp2
		
#subtraction function
sub:	
	#takes num - i. i = s0 = a0. when finished see comment b1 to continue
	sub $v0, $a1, $a0
	jr $ra
