#Has all the words checking functions
#CS 3340
	
#check the length
#takes a string at $a0 and reads the length. $t0 is scanner, $t1 is couter, $t2 is scanners held value.
#Retuns length in $v1 
getLength:
	add $t0, $a0, $zero
	li $t1, 0
getLengthLoop:	
	lb $t2, ($t0)
	beq $t2, 0, getLengthReturn
	#inc counter
	add $t1, $t1, 1
	#inc scanner
	add $t0, $t0, 1
	j getLengthLoop
#return back
getLengthReturn:
	move $v1, $t1
	jr $ra
	
#toUpper. Makes comparing so much better
makeCaps:
	add $t0, $a0, $zero
#loop through changing to upper
makeCapsLoop:
	lb $t2, ($t0)
	beq $t2, 0, makeCapsReturn
	ble $t2, 'Z', makeCapsIsCap
	sub $t2, $t2, 'a'
	add $t2, $t2, 'A'
	sb $t2, ($t0)
makeCapsIsCap:
	#increase scanner
	add $t0, $t0, 1
	j makeCapsLoop
#all done. exit time
makeCapsReturn:
	jr $ra	
	
############################################################################################
#Takes a string in #a0, and determines if it's something we can work with, true or false
isValidInput:
	add $t0, $a0, $zero
#loop through it
isValidInputLoop:
	lb $t2, ($t0)
	beq $t2, 0, isValidInputPass
	blt $t2, 'A', isValidInputFail
	bgt $t2, 'z', isValidInputFail
	bgt $t2, 'Z', isValidCheck
	#next letter
	add $t0, $t0, 1
	j isValidInputLoop
#checks validity
isValidCheck:
	#not valid. Next!
	blt $t2, 'a', isValidInputFail
	#next letter
	add $t0, $t0, 1
	j isValidInputLoop
#failed input
isValidInputFail:
	li, $v1, 0
	jr $ra
#passed input
isValidInputPass:
	li, $v1, 1
	jr $ra
	
	
	
#will fill the letter array at $a0 with the info from the string in $a1
fillLetterArray:
	subi $sp, $sp, 4
	sw $ra, ($sp)  
	jal ClearLetterArray
	add $t0, $a1, $zero
#loop through filling letter array
fillLetterArrayLoop:
	lb $t1, ($t0)
	beq $t1, 0, fillLetterArrayReturn	
	sub $t1, $t1, 'A'
	add $t1, $t1, $a0
	lb $t2, ($t1)
	add $t2, $t2, 1
	sb $t2, ($t1)
	#next letter
	add $t0, $t0, 1 
	j fillLetterArrayLoop
#all done now. Just jump back
fillLetterArrayReturn:
	lw $ra, ($sp) 
	addi $sp, $sp, 4
	jr $ra
	
	
	
#Clears the letterArray in $a1.	
ClearLetterArray:
	add $t0, $a0, $zero	
	li $t1, 0
ClearLetterArrayLoop:
	beq $t1, 26, ClearLetterArrayReturn
	add $t1, $t1, 1
	sb $zero, ($t0) 
	#next letter!
	add $t0, $t0, 1
	j ClearLetterArrayLoop
#all done exit
ClearLetterArrayReturn:
	jr $ra




#checks if the letter array $a1 is in letter array $a0
CompareLetters:
	#compares
	li $t0, 0
#compares each and every one
CompareLettersLoop:
	beq $t0, 26, CompareLettersPass
	add $t1, $a0, $t0
	add $t2, $a1, $t0
	lb $t2, ($t2)
	lb $t1, ($t1)
	bgt $t2, $t1, CompareLettersFail
	#next letter
	add $t0, $t0, 1
	j CompareLettersLoop
#did it pass a compare?
CompareLettersPass:
	li $v1, 1
	jr $ra
#or did it fail?
CompareLettersFail:
	li $v1, 0
	jr $ra



#Takes words in $a0 and $a1 and returns boolean true/false. 1= true
diffrentWord:
	#scanner position
	li $t0, 0
#loop to check if the word'll pass or fail
diffrentWordLoop:
	add $t1, $a0, $t0
	add $t2, $a1, $t0
	lb $t1, ($t1)
	lb $t2, ($t2)
	beq $t1, 0, diffrentWordCheck
	bne $t2, $t1, diffrentWordPass
	#next letter!
	add $t0, $t0, 1
	j diffrentWordLoop
#check match
diffrentWordCheck:
	beq $t2, 0, diffrentWordFail
#it's a different return 1
diffrentWordPass:
	li $v1, 1
	jr $ra
#failed test. return 0
diffrentWordFail:
	li $v1, 0
	jr $ra


#Key letter check. It best be in there
HasKeyLetterScan:
	#set positions
	li $t0, 0
	lb $t1, keyLetter
#loop through each letter of word checking
HasKeyLetterScanLoop:
	add $t2, $a0, $t0
	lb $t2, ($t2)
	beq $t2, 0, HasKeyLetterScanFail
	beq $t1, $t2, HasKeyLetterScanPass
	#next letter!
	add $t0, $t0, 1
	j HasKeyLetterScanLoop
#it passed! it has key letter after scanning through. return 1
HasKeyLetterScanPass:
	li $v1, 1
	jr $ra
#doesn't have it
HasKeyLetterScanFail:
	li $v1, 0
	jr $ra

#random number time!
#$a0 gives upper limit. $v0 is the output.
randNumber:
	move $t1, $a0
	#random int
	li   $v0, 41
	syscall
	#mod the length of it. it could be big
	divu $t0, $a0, $t1      
	mfhi $v0
	#return
	jr $ra
	
	
	
