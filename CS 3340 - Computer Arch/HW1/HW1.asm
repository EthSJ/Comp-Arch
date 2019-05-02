# Homework one for CS 3340.501
#Sample input/output picture included called HW1_[exj140630]
.data
	promptOne: .asciiz "Give me an integer number: "
	promptTwo: .asciiz "Give me another integer number: "
	sumOutput: .asciiz "The sum of the two inputted numbers is: "
.text
main:
	#Prompts to enter integer
	li $v0, 4
	la $a0, promptOne
	syscall
	
	#Gets input
	li $v0, 5
	syscall
	
	#stores the result.
	move $t0, $v0
	
	#second prompt
	li $v0, 4
	la $a0, promptTwo
	syscall
	
	#Second input
	li $v0, 5
	syscall
	
	#Stores the result again
	move $t1, $v0
	
	#adds the two numbers and places in $t2
	add $t2, $t0, $t1
	
	
	# prints sum output prompt
	li $v0, 4
	la $a0, sumOutput
	syscall
	
	#prints the resulting
	li $v0, 1
	move $a0, $t2
	syscall	
	
	#Nicely ends program
	li $v0, 10
	syscall
