#Homework 4 
#

.data
	#It says "Present thusly thine integer" i.e. "Give me an int"
	#I had fun with it.
	input: .asciiz "Present ðusly Þine integer: "
	iterative: .asciiz "The sum of integers up to 5 (iterative) is: "
	recursive: .asciiz "The sum of integers up to 5 (recursive) is: "
	Seeya: .asciiz "Goodbye!"
	
	#for shoving in the answer and input into
	number: .word 0
	answerR: .word 0
.text
main:
	#Prompts to enter integer
	li $v0, 4
	la $a0, input
	syscall
	
	#Gets input
	li $v0, 5
	syscall
	
	#stores the result.
	sw $v0, number
	
	#check to see if out of our bound
	ble $v0, 1, goodbye
	
	#iterative sum
	lw $a0, number
	jal sumI
	
	#display iterative answer
	li $v0, 4
	la $a0, iterative
	syscall
	#number part of iterative answer
	li $v0, 1
	move $a0, $t2
	syscall
	
	#register clean up from iterative part
	li $t0, 0
	li $t1, 0
	li $t2, 0
	
	#fancy way of puting in a new line character without writing it above
	addi $a0, $zero, 0xA
	addi $v0, $zero, 0xB
	syscall
	
	#recursive sum
	lw $a0, number
	jal sumRecursive
	sw $v0 answerR
	
	#display recursive answer
	li $v0, 4
	la $a0, recursive
	syscall
	#number part of recursive answer
	li $v0, 1
	lw $a0, answerR
	syscall
	
	#fancy way of puting in a new line character without writing it above
	addi $a0, $zero, 0xA
	addi $v0, $zero, 0xB
	syscall
	
	
	#back to start!
	j main
	
	#awww, it was 1 or less than. Time to quit
	goodbye:
		#Prompts to enter integer
		li $v0, 4
		la $a0, Seeya
		syscall
		#neatly closes
		li $v0, 10
		syscall
	
sumRecursive:
	#move stack pointer as needed with space
	subu $sp, $sp, 8
	sw $ra, ($sp)
	sw $s0, 4($sp)
	
	#Base case, i.e. hits one
	li $v0, 1
	beq $a0, 1, sumFin
	
	#recursive call for num -x
	move $s0, $a0
	sub $a0, $a0, 1
	jal sumRecursive
	
	#add tally part
	add $v0, $s0, $v0
	
	sumFin:
		#reset stuff as needed
		lw $ra, ($sp)
		lw $s0, 4($sp)
		#fix stack
		addu $sp, $sp, 8
		
		#return
		jr $ra
		
sumI:
	#moves over what we're going up to
	move $t0, $v0
	#this is our counter
	li $t1, 0
		
		loop:
			#if they match, go to end
			beq $t1, $t0, end
			#increase counter by 1
			addi $t1, $t1, 1 
			#take counter and add to total sum number
			add $t2, $t2, $t1
			#jump back up to loop
			j loop
		#time to quit. Jump to return address
		end:	
			jr $ra
