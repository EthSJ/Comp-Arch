#Main file (run from here)
#CS 3340.501


#Guys, I know our little in jokes are nice and they help destress while doing this
#but PLEASE remember to remove them before final version. Thanks -E
.data
# printInstructions messages
directions1:	.asciiz "-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=Welcome to Lexathon!-=-=-=-=--=-=-=-=-=-=-=-==-=-=-=-=-=\n"
directions2:	.asciiz "Your goal is to find as many 4 letter or more words as you can, using the middle letter.\n"
directions3:	.asciiz "You start with 60 seconds and for each correct word, you get 20 seconds.\n"
directions4:	.asciiz "This time will be shown so you know how long you now have for each correct entry.\n\n"
directions5:	.asciiz "The game ends when the time runs out or you type 0 to quit.\n\n"
directions6:	.asciiz "The score is determined by the percentage of words found and the speed in which they are found.\n"
directions7:	.asciiz "Ready to begin? (Press enter)\n"
	
# printWordBox.asm messages
#No one touch my beautiful grid. Please.
gridPrintTop:		.asciiz "\n\t+---+---+---+\t\t"
gridPrintMiddle:	.asciiz "\t|---+---+---|\t\t"
gridPrintBottom:	.asciiz "\t+---+---+---+\t\t"
gridPrintSideLeft:	.asciiz "\t| "
gridPrintSideRight:	.asciiz " |\t\t"
gridPrintInside:	.asciiz " | "

menuLine0:	.asciiz "|	Menu:				|\n"
menuLine1:	.asciiz "|  0:	Quit				|\n"
menuLine2:	.asciiz "|  1:	Shuffle letters			|\n"
menuLine3:	.asciiz "|  2:	Time left			|\n"
menuLine4:	.asciiz "|  3:	Display words entered		|\n"
menuLine5:	.asciiz "|  4:	Pause and display instructions	|\n"
	
#getInput.asm messages	+ helpful
askForInput: 	.asciiz "Enter in a word:\n"
typedInText:	.asciiz "Good Game!\n"
userWord:	.align 2
		.space 10
startInput:	.word 0

	
#scoring.asm messages	"These are working. !!DO NOT!! Rename these variables unless you want to break it!!!!!!!! - S 																												#Just (Don't) do it, Folks
startText:		.asciiz "This tests the scoring subroutine\n"
secondsText:		.asciiz " seconds\n"
scoreText:		.asciiz "Score: "
timeText:		.asciiz "\nTime remaining: "
finalScoreText:		.asciiz "\nYour final score is: "
totalTimeText:		.asciiz "\nTotal time: "
timeTestText:		.asciiz "Your entry took: "
wPMText:		.asciiz "Words per minute: "
percentFoundText:	.asciiz "\nPercentage of words found: "
exitByOutOfTime:	.asciiz "Out of Time!\n"
exitByGetAllWords:	.asciiz "Congratulations! You found all the words!\n"
wordsFoundSoFar1:	.asciiz "You have found "
wordsFoundSoFar2:	.asciiz " so far!\n"
close:			.asciiz "%)\n"
newLineChar:		.asciiz "\n"
score:			.word 0
wordLength:		.word 6
totalTime:		.word 0
totalLeft:		.word 60
			.align 2
beginTime:		.word 0	
statusTime:		.word 0
numWordsEnteredCorrect:	.word 0
totalPossibleWords:	.word 0
openParenthesis:	.asciiz "("
slash:			.asciiz "/"
percent:		.word 0
			.space 4

#timeFunction.asm	
startTime:		.word 
			.space 4
endTime: 		.word
			.space 4
currentTime: 		.word
printTimeDisplay: 	.asciiz ""
myWord: 		.space 10
			.align 0

#General stuff (variables and padding for text output)
strspace: 			.asciiz " "
newline: 			.asciiz "\n"
commaSpace:			.asciiz ", "
wordstyped: 			.asciiz "The correct words you entered are: \n"
wordsleft: 			.asciiz ": \n "
correctEntryText:		.asciiz "\nIt's about time you got a word right!\n"
wordsEnteredCorrect:		.align 2
	  			.space 1000
numwordsEnteredCorrect:		.align 2
				.word 0
numwordsMissed: 		.align 2
				.word 0
enteredword : 			.align 2
				.space 10
missedWordsArray:		.align 2
	  			.space 1000
incorrectInput: 		.asciiz "That's not correct (Make sure you're using the middle letter).\n"
wordsUserMissed: 		.asciiz "\n The words you missed are: \n"	
thisWordIsRepeated:		.asciiz "You have already entered this word!\n"
fileName:			.asciiz	"    "
dictionary:			.space 500000
dictionaryArray:		.align	2
				.space 368000
correctWordsPointerArray:	.align	2
				.space 10000
lengthOfList:			.word	0
wordInBox:			.align	0
				.space 10
lettersInBox:			.space 26
lettersInInput:			.space 26
keyLetter:			.byte 'A'
endline:			.asciiz "----"

#validateInput.asm messages
correctWords:		.space 10000
printCorrectWordsText:	.asciiz "The correct words you entered are: \n"
printMissedWordsText:	.asciiz "\nThe words you missed are: \n"
			.align 2

# Extra variables
runProgramAgainText: 	.asciiz "Want to play again? (Yes - 1, No - 0)\n"	
invalidPlayAgain: 	.asciiz "Invalid entry. Please enter 1 to play again or 0 to exit\n"


#Text part of all of this. 
.text
	#global main. Very important. Do not unglobl this
	.globl main
	
	#all the needed files
	.include "macros.asm"
	.include "importing.asm"
	.include "WordTests.asm"
	.include "setup.asm"
	.include "printWordBox.asm"
	.include "getInput.asm"
	.include "scoring.asm"
	.include "timeFunction.asm"
	.include "validateInput.asm"

main:	
	
	playAgain:
		#Sets the times, possible words, score and such up
		sw	$0, totalPossibleWords
		sw	$0, totalTime
		sw	$0, score
		sw	$0, numWordsEnteredCorrect
		li	$t1, 60
		sw	$t1, totalLeft
		
		#jumps to set up the game
		jal	setupGame
		#jumps to the instruction print block
		jal 	printInstructions
	
		#gets input from any to start
		la 	$a0, startInput
		la 	$a1, startInput
		li 	$v0, 8
		syscall
	
		#gets current time and saves start time
		jal 	getCurrentTime
		sw	$v0, startTime
	
		#clears correct words and takes out the letters other than mid
		jal	clearCorrectWords
		jal	takeOutNonMidLetter
	
		#Jumps to run the whole thing time to start
		jal	setUp
	
		#gets the time it took
		lw	$a0, startTime
		jal	getTimeElapsed
		sw	$v0, totalTime
		
		#displays the final score
		jal 	displayFinalScore
	
		#prompt to show we're going to print the correct words
		la	$a0, printCorrectWordsText
		li	$v0, 4
		syscall
	
		#prints out what you got right
		jal	printCorrectWords
		
		la	$a0, newline
		li	$v0, 4
		syscall
		
		#prompt for printing missed words
		la	$a0, printMissedWordsText
		li	$v0, 4
		syscall
	
		#prints all the possible words
		jal	printPossibleWords
		#breaks up long list with 2 newlines.
		la	$a0, newLineChar
		li	$v0, 4
		syscall
		la	$a0, newLineChar
		li	$v0, 4
		syscall	
		#You wanna play again? Jump to and ask
		jal	inputPlayAgain
	
		#if 0, exit out of the program and quitter
		bne	$v0, $0, playAgain
		
		#Nicely exits the program
		li	$v0, 10
		syscall
	
	#Set up the stack pointer
	setUp:
		addi	$sp, $sp, -4
		sw	$ra, 0($sp)
		
	#loops through the program as needed
	programLoop:
		#loads the num of correct words and possible in
		lw	$t0, numWordsEnteredCorrect
		lw	$t1, totalPossibleWords
	
		#branch if all words are right to allCorrectWords
		beq	$t0, $t1, enteredAllCorrectWords

		#wordbox! This prints in out so it looks nice
		la 	$a0, wordInBox
		jal 	printWordBox
		
		#Sets the time up so it counts down correctly
		beq	$s5, 1, skipTime
		sw	$0, beginTime
		
		#gets the current time so we know what we're starting from
		jal 	getCurrentTime
		sw	$v0, beginTime
	
	#skips over the time not caring
	skipTime:
		#gets input
		jal	getUserInput
		add	$s5, $v0, $0
		
		#I swear I will find what you entered and I will make sure it's right. Switch statement
		#checks first for whether or not the user enters in a 0
		beq	$s5, $0, end
		beq	$s5, 1, random
		beq	$s5, 2, displayTime
		beq	$s5, 3, displayEntered
		beq	$s5, 4, instructions
	
		#Checks all the vailidating
		jal	validateInput		# <------ E, here is where validation stuff is called
		
		#0 is invalid, 1 is valid
		bne	$v0, $0, correctEntry
	
	#that's not right. Curse you!
	incorrectEntry:
		#grab time again
		lw	$a0, beginTime
		jal	getTimeElapsed
		
		#moves $v0 to $t1
		add	$t1, $v0, $0
		#storing up the time
		add	$a1, $t1, $0
		#The total time itself
		lw	$a0, totalLeft
		#jump to valid time update score. update stack
		jal	notValidUpdateScore
		beq	$v0, $0, end
		j	programLoop
		
	#correct entry
	correctEntry:
		#get the time
		lw	$a0, beginTime
		jal	getTimeElapsed
		add	$t0, $v0, $0
		
		#scoring and time left, updating score and checking word length
		lw	$a0, wordLength
		#store score
		lw	$a1, score
		#time left in seconds
		lw	$a2, totalLeft
		#time it too in seconds
		add	$a3, $0, $t0
		#update score and then update stack (if needed)
		jal	updateScore
		beq	$v0, $0, end
		
		#loop again
		j	programLoop
		
	#So it's time to just stop. You got all the words. Well done!																																		Maine Lobster
	enteredAllCorrectWords:
		la	$a0, exitByGetAllWords
		li	$v0, 4
		syscall
	
	#runs print user input and such
	end:
		jal	printUserInput
		
		#returns stack
		lw	$ra, 0($sp)
		addi	$sp, $sp, 4
		jr	$ra
		
	#lets pick a random word
	random:
		jal	randomizeWord
		j	programLoop
		
	#shows you how long left
	displayTime:
		la	$a0, timeText
		li	$v0, 4
		syscall
		
		#Time
		lw	$a0, beginTime
		jal	getTimeElapsed
		add	$t0, $v0, $0
		
		#Loads up the time left
		lw	$t1, totalLeft
		sub	$t1, $t1, $t0
		sw	$t1, totalLeft
		
		#if it's less than or 0, time to end program	
		ble	$t1, $0, end
	
		#move temp and prints
		move	$a0, $t1
		li	$v0, 1
		syscall
		
		#loads seconds text and prints
		la	$a0, secondsText
		li	$v0, 4
		syscall
		
		#jump to program loop
		j	programLoop
		
	#displays the endered words	
	displayEntered:
		#prints correct words
		la	$a0, printCorrectWordsText
		li	$v0, 4
		syscall
		
		#prints the correct words
		jal	printCorrectWords
		j	programLoop
		
	#prints out the instructions
	instructions:
		jal 	printInstructions
		la 	$a0, startInput
		la 	$a1, startInput
		li 	$v0, 8
		syscall
		
		#back up to the main part again	
		j	programLoop
		
	#prints out the directions	
	printInstructions:
		#direction clumps (direction 1)
		la $a0, directions1
		li $v0, 4
		syscall
	
		#direction 2
		la $a0, directions2
		li $v0, 4
		syscall
		
		#direction 3
		la $a0, directions3
		li $v0, 4
		syscall
		
		#direction 4
		la $a0, directions4
		li $v0, 4
		syscall
		
		#direction 5
		la $a0, directions5
		li $v0, 4
		syscall
		
		#direction 6
		la $a0, directions6
		li $v0, 4
		syscall
		
		#direction 7
		la $a0, directions7
		li $v0, 4
		syscall
		
		#return back to where we need to be
		jr $ra
