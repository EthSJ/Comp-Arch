
.data
	prompt: .asciiz "Give me a dollar amount: "
	output: .asciiz "The amount in yen is: "
	yen: .float 103.97
.text

main:
	#gets static yen amount ready
	lwc1 $f2, yen
	
	#prompt for input
	li $v0, 4
	la $a0, prompt
	syscall
	
	#gets input (float)
	li $v0, 6
	syscall

	#float math! stores in $f4 because reasons
	mul.s $f4, $f0, $f2
	
	#prompt for outpus
	li $v0, 4
	la $a0, output
	syscall
	
	#print out the number
	li $v0 2
	add.s $f12, $f0, $f4
	syscall
	
	#fancy way of puting in a new line character without writing it above
	addi $a0, $zero, 0xA
	addi $v0, $zero, 0xB
	syscall
	
	#because repeats were requested
	j main