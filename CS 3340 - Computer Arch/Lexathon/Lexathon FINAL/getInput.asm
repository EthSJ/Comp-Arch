# Gets the input
#CS 3340.

.text
#gets the user input
getUserInput:
	#move stack pointer and asks for input
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	la 	$a0, askForInput
	li 	$v0, 4
	syscall
	
	#loads the word
	la 	$a0, userWord
	la 	$a1, userWord
	li 	$v0, 8
	syscall
	
	#determines which menu item will be run
	la	$a0, userWord
	lb	$t0, 0($a0)
	beq	$t0, '0', exitInput
	beq	$t0, '1', exitInputRand
	beq	$t0, '2', exitInputTime
	beq	$t0, '3', exitInputWords
	beq	$t0, '4', exitInputInstructions
	
	#loads the userword and goes to make it all upper. easier to match
	la	$a0, userWord		
	jal	makeCaps		
	
	#jumps back to a return
	addi	$v0, $0, 5
	j	getInputReturn
	
#exits the random input
exitInputRand:
	addi	$v0, $0, 1
	j	getInputReturn

#exits the input time
exitInputTime:
	addi	$v0, $0, 2
	j	getInputReturn
	
#exits the inputting words
exitInputWords:
	addi	$v0, $0, 3
	j	getInputReturn
	
#exit the input instructions
exitInputInstructions:
	addi	$v0, $0, 4
	j	getInputReturn
#exit the input
exitInput:
	add	$v0, $0, $0

#returns the stack so we know where to go back to
getInputReturn:
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	jr	$ra
	
	
#prints out what the user entered
printUserInput:
	#loads and prints the typed in text
	la	$a0, typedInText
	li	$v0, 4
	syscall
	#returns
	jr	$ra
	
#asks if you want to play again
inputPlayAgain:
	#loads and prints the prompt
	la	$a0, runProgramAgainText
	li	$v0, 4
	syscall
#gets input to determine playing again
getPlayAgainInput:
	#gets the input
	la 	$a0, userWord
	la 	$a1, userWord
	li 	$v0, 8
	syscall

	#loads the word and then checks which it is
	la	$a0, userWord
	lb	$t0, 0($a0)
	#exits if play again is false
	beq	$t0, '0', exitPlayAgainFalse
	#exits if play again is true, which isn't an exit but restarts
	beq	$t0, '1', exitPlayAgainTrue
	
	#invalid, not sure what you gave me
	la	$a0, invalidPlayAgain
	li	$v0, 4
	syscall
	
	#jump back to where we were
	j	getPlayAgainInput
#jumps to play again if it's true
exitPlayAgainTrue:
	addi	$v0, $0, 1
	j	exitPlayAgain
#doesn't do much of anything if it's false
exitPlayAgainFalse:
	add	$v0, $0, $0
#simply jumps back to where we were
exitPlayAgain:
	jr	$ra
