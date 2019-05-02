#Sets up. Random letts, imports words, gets nine letters.
#CS 3340

.text
setupGame:
	add	$sp, $sp, -4
	sw	$ra, 0($sp)
	jal getFileName
	jal inportFile 			# Fills the string dictionary with the word file.
	jal fillDictionaryArray 	# Fills the pointers in this array!
	jal getNineLetter  		# Gets a random word 9 letter word and scramble letters.	
	jal randomizeWord
	jal getKeyLetter
	lw	$ra, 0($sp)
	add	$sp, $sp, 4
	jr $ra
