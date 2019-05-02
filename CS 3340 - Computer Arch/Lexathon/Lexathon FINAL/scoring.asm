#Scoring file. Determines score.
#CS 3340

# Update the score based on the following conditions:
# 1. If the user waits more than 5 seconds, the score is decreased by 1.
# 2. If the user types in a word in under 5 seconds, the length of the word is added to the time and the amount of time it took to enter is multiplied by the word length and added to the score.
# 3. If the user types in another word in less than 5 seconds, then the score and time are double math condition from step 2

.text
notValidUpdateScore:
	add	$t0, $0, $a0				# load the amount of time left
	add	$t1, $0, $a1				# load the time it took to enter
	sub	$t2, $t0, $t1				# time left - time it took
	sw	$t2, totalLeft				# update time
	lw	$t2, score				# subtract from score and update variable
	blt	$t1, 5, invalidUpdateCheckTime
	div	$t1, $t1, 5				# divide by 5 with integer division
invalidUpdateSubtPoint:	
	beq	$t1, 0, invalidUpdateCheckTime
	beq	$t2, 0, invalidUpdateCheckTime
	addi	$t2, $t2, -1
	addi	$t1, $t1, -1
	j	invalidUpdateSubtPoint
invalidUpdateCheckTime:
	sw	$t2, score
	lw	$t0, totalLeft
	ble	$t0, $0, invalidUpdateTimeOut
	la 	$a0, timeText
	li 	$v0, 4
	syscall
	lw	$a0, totalLeft
	li 	$v0, 1
	syscall
	la 	$a0, secondsText
	li 	$v0, 4
	syscall
	addi	$v0, $0, 1		# return 1 if more time remains
	j	invalidUpdateExit
invalidUpdateTimeOut:
	la 	$a0, exitByOutOfTime
	li 	$v0, 4
	syscall
	add	$v0, $0, $0		# return 0 if out of time
invalidUpdateExit:
	jr	$ra
updateScore:
	add	$t0, $0, $a0				# length
	add	$t1, $0, $a1				# load current score
	add	$t2, $0, $a2				# total amount of time left. 
							# Time taken is subtracted from it and new points are added to it.
	add	$t4, $0, $a3				# get the time it took to enter
	lw	$s0, numWordsEnteredCorrect
	addi	$s0, $s0, 1
	sw	$s0, numWordsEnteredCorrect
	la	$a0, wordsFoundSoFar1
	li	$v0, 4
	syscall
	lw	$a0, numWordsEnteredCorrect
	li 	$v0, 1
	syscall
	la	$a0, slash
	li	$v0, 4
	syscall
	lw	$a0, totalPossibleWords
	li	$v0, 1
	syscall
	la	$a0, wordsFoundSoFar2
	li	$v0, 4
	syscall
	sub	$t2, $t2, $t4			# total amount of time left - time took to enter
	ble	$t2, $0, updateScoreExit	# if the time is <= 0, exit the program
	ble	$t4, 5, addExtraToTimeNScore 	# if (time took to enter <= 5): add extra to score? else
	div	$t4, $t4, 5			# done to figure out how many 5 seconds have passed (one point taken away per 5 seconds)
subtPoint:
	beq	$t4, $0, stopSubt		# subtract 1 from the score and reset the fiveSecondCount to 0
	beq	$t1, $0, stopSubt		# if the score (t1) goes to 0, exit.
	subi	$t1, $t1, 1			# subtract 1 from the score
	subi	$t4, $t4, 1			# subtract one from the modded time
	j	subtPoint
addExtraToTimeNScore:
	addi	$s0, $0, 5			# 5 - (time taken to enter) :: (if time < 5)
	sub	$t4, $s0, $t4
	mul	$t0, $t4, $t0			# inverse time * length stored in length (so a bonus is added to the score)
stopSubt:					# may do some sort of multiplying for the score? if timeToEnter < 5: (5-timeToEnter) * length = added to score, else: length = added to score
	addi	$t2, $t2, 20			# time increases by 20
	add	$t1, $t1, $t0			# increase score
	sw	$t1, score
	sw	$t2, totalLeft
# Prints out everything. 			# This is working. Just execute the program. - S
displayScore:					
	la 	$a0, scoreText
	li 	$v0, 4
	syscall
	add 	$a0, $t1, $0
	li 	$v0, 1
	syscall
	la 	$a0, timeText
	li 	$v0, 4
	syscall
	add 	$a0, $t2, $0
	li 	$v0, 1
	syscall
	la 	$a0, secondsText
	li 	$v0, 4
	syscall
	addi	$v0, $0, 1
	jr	$ra
# Does what it says. Updates the score when time runs out and terminates game. Jumps to Play Again.
updateScoreExit:
	la 	$a0, exitByOutOfTime
	li 	$v0, 4
	syscall
	add	$v0, $0, $0
	jr	$ra
	
#display final score and info code : shows score, time, words per minute, total # of words per time and percent of words found.
displayFinalScore:
	#score
	la 	$a0, finalScoreText
	li 	$v0, 4
	syscall
	lw 	$a0, score
	li 	$v0, 1
	syscall
	#Total time
	la 	$a0, totalTimeText
	li 	$v0, 4
	syscall
	lw 	$a0, totalTime
	li 	$v0, 1
	syscall
	la 	$a0, secondsText
	li 	$v0, 4
	syscall
	#Words per minute
	la 	$a0, wPMText
	li 	$v0, 4
	syscall
	lw	$t0, totalTime			#$t0 contains time in seconds
	lw	$t1, numWordsEnteredCorrect	#t1 contains numWordsEnteredCorrect
	addi	$t2, $0, 60
	mul	$t1, $t1, $t2
	div	$t1, $t1, $t0
	add 	$a0, $t1, $0
	li 	$v0, 1
	syscall
	#Percentage of words correct/possible
	lw	$t0, numWordsEnteredCorrect	
	lw	$t1, totalPossibleWords		
	addi	$t3, $0, 100		
	mul	$t0, $t0, $t3		
	div	$t2, $t0, $t1		
	la 	$a0, percentFoundText
	li 	$v0, 4
	syscall
	lw	$a0, numWordsEnteredCorrect
	li 	$v0, 1
	syscall
	la	$a0, slash
	li	$v0, 4
	syscall
	lw	$a0, totalPossibleWords
	li	$v0, 1
	syscall
	la	$a0, openParenthesis
	li	$v0, 4
	syscall
	sw	$t2, percent
	lw	$a0, percent
	li	$v0, 1
	syscall
	la	$a0, close
	li	$v0, 4
	syscall
	jr	$ra
