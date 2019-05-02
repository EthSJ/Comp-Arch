.data
	myarray: .word 1, 2, 3, 4, 5, 6, 7

.text
main: 
	#change to get i
	li $t1, 2
	
	#A
	sll $t1, $t1, 2
	
	#pseudo 
	lw $s0, myarray($t1)