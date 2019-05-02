# Lets validate all that input
#CS 3340


.text
# validateInput block
#sets possible word count to 0
validateInput:
	add	$s1, $0, $0	
#set user word count to 0
validateInputNextWord:
	add	$t1, $0, $0

#loop to validate word
validateInputLoop:	
	#load user's word	
	la	$t0, userWord
	#load current possble word
	lw	$s0, correctWordsPointerArray($s1)
	#validate input exit is false if this called
	beq	$s0, 0, validateInputExitFalse
	#keep validating input
	bne	$s0, 1, validateInputCont
	addi	$s1, $s1, 4
	#go to next word
	j	validateInputNextWord 
validateInputCont:
	#add counter to userWord[0] to get next byte
	add	$t2, $t1, $t0
	#does the same thing to posibleWord
	add	$s2, $t1, $s0
	#loads next byte from user
	lb	$t3, 0($t2)
	#load next byte from possible words, ready to compare yet?
	lb	$s3, 0($s2)
	
	#if there are no more chars in user word, check if there're anymore in the possibleWord
	beq	$t3, $0, validateInputExitCondition
	#new line check! Goes to same place as above
	beq	$t3, '\n', validateInputExitCondition

	# if'n there ain't no more chars, exit via false
	beq	$s3, $0, validateInputCheckNext
	
	#if the characters aren't the same exit via false. Kinda a backup in case
	bne	$t3, $s3, validateInputCheckNext
	
	#increase the counter
	addi	$t1, $t1, 1
	j	validateInputLoop

#validates input exit condition. check if 0 or that wonky \r character
validateInputExitCondition:
	beq	$s3, $0, validateInputExitTrue
	beq	$s3, '\r', validateInputExitTrue
#checks next input.
validateInputCheckNext:
	addi	$s1, $s1, 4
	j	validateInputNextWord

#validates input exit false. I.e. not right input
validateInputExitFalse:
	#outputs prompt to correct input
	la	$a0, incorrectInput
	li	$v0, 4
	syscall
	
	#back to checking if it's ok
	add	$v0, $0, $0
	j	validateInputExit
	
#input text was right
validateInputExitTrue:
	#load correct input text
	la	$a0, correctEntryText
	li	$v0, 4
	syscall
	
	#move string pointer over to correctWords. From user
	sw	$s0, correctWords($s1)
	li	$t0, 1
	#this one is from dictionary
	sw	$t0, correctWordsPointerArray($s1)
		
	addi	$v0, $0, 1
#exit out of this
validateInputExit:
	jr	$ra
	
# printPossibleWords
#set a 0 and get ready to print
printPossibleWords:
	add	$t1, $0, $0
#loops through printing possible words
printPossibleWordsLoop:
	lw	$t0, correctWordsPointerArray($t1)
	beq	$t0, 0, printPossibleExit	
	bne	$t0, 1, printWord
	addi	$t1, $t1, 4
	j	printPossibleWordsLoop
#prints the word
printWord:
	lb	$t2, 0($t0)
	#prints the word itself
	la	$a0, ($t0)
	li	$v0, 4
	syscall
	
	#formatting!
	la	$a0, commaSpace
	li	$v0, 4
	syscall
	
	#move and start another print
	addi	$t1, $t1, 4
	j	printPossibleWordsLoop
#all done. exit out
printPossibleExit:
	jr	$ra
	
# printCorrectWords
#0 out
printCorrectWords:
	add	$t1, $0, $0

#prints out the correct words. mirrors one above it
printCorrectWordsLoop:
	lw	$t0, correctWords($t1)
	beq	$t0, 0, printCorrectExit	
	bne	$t0, 1, printCorrectWord
	addi	$t1, $t1, 4
	j	printCorrectWordsLoop
#prints out the words you got correct
printCorrectWord:
	lb	$t2, 0($t0)
	#print the word
	la	$a0, ($t0)
	li	$v0, 4
	syscall
	#formatting!
	la	$a0, commaSpace
	li	$v0, 4
	syscall
	
	#loops back
	addi	$t1, $t1, 4
	j	printCorrectWordsLoop
#time to exit
printCorrectExit:
	jr	$ra		
	
##clearCorrectWords
# set every pointer to 1. this is clean up
clearCorrectWords:
	add	$t1, $0, $0
clearCorrectWordsLoop:
	beq	$t1, 9996, clearCorrectWordsExit
	lw	$t0, correctWords($t1)
	addi	$t0, $0, 1
	sw	$t0, correctWords($t1)
	add	$t1, $t1, 4
	j	clearCorrectWordsLoop
#exit out of the clean up
clearCorrectWordsExit:
	sw	$0, correctWords($t1)
	jr	$ra
	
#takeOutNonMidLetter i.e. don't touch that middle letter for shuffle
#take stack and fix up every one
takeOutNonMidLetter:
	addi	$sp, $sp, -4
	sw	$ra, ($sp)
	add	$t3, $0, $0
#loop to take out
takeOutLoop:
	lw	$t0, correctWordsPointerArray($t3)
	#exit if null pointer
	beq	$t0, 0, takeOutExit
	# if it's not 1, check word for mid letter
	bne	$t0, 1, takeOutWordTest
	#increase counter to word align
	addi	$t3, $t3, 4
	#jump back up, there's always more
	j	takeOutLoop
#tests if we can take it out
takeOutWordTest:
	#load string into a
	move	$a0, $t0
	#check for that key letter
	jal	HasKeyLetterScan
	#it's not there, take out word. Otherwise back to top
	beq	$v1, $0, takeOutWord	
	#more aligning
	addi	$t3, $t3, 4
	j	takeOutLoop
#take it out
takeOutWord:
	#load 1 into t2
	li	$t2, 1
	#store it in array
	sw	$t2, correctWordsPointerArray($t3)
	lw	$t4, totalPossibleWords
	addi	$t4, $t4, -1
	sw	$t4, totalPossibleWords
	#word align
	addi	$t3, $t3, 4
	j	takeOutLoop
#time to exit
takeOutExit:
	lw	$ra, ($sp)
	addi	$sp, $sp, 4
	jr	$ra
