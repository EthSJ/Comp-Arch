#prints my beautiful text box. Took forever. Please no one touch
#CS 3340


.text	
printWordBox:
	#moves arg to temp
	move	$t0, $a0
	
	#prints the top of the grid
	la 	$a0, gridPrintTop
	li 	$v0, 4
	syscall
	
	#prints top menu item
	la	$a0, menuLine0
	li	$v0, 4
	syscall
	
	#prints left of grid
	la 	$a0, gridPrintSideLeft
	li 	$v0, 4
	syscall
	
	#prints the letter
	li	$v0, 11
	lb	$a0, 0($t0)
	syscall
	
	#prints the inside of grid
	la 	$a0, gridPrintInside
	li 	$v0, 4
	syscall
	
	#prints the letter again
	li	$v0, 11
	lb	$a0, 1($t0)
	syscall
	
	#prints another grid side
	la 	$a0, gridPrintInside
	li 	$v0, 4
	syscall
	
	#prints ANOTHER letter again
	li	$v0, 11
	lb	$a0, 2($t0)
	syscall
	
	#prints the right side of the grid
	la 	$a0, gridPrintSideRight
	li 	$v0, 4
	syscall
	
	#onto line 2
	#prints the menu item
	la	$a0, menuLine1
	li	$v0, 4
	syscall
	
	#prints middle grid item
	la 	$a0, gridPrintMiddle
	li 	$v0, 4
	syscall
	
	#line three
	#print menu line 2
	la	$a0, menuLine2
	li	$v0, 4
	syscall
	
	#prints left side of grid
	la 	$a0, gridPrintSideLeft
	li 	$v0, 4
	syscall
	
	#prints letter
	li	$v0, 11
	lb	$a0, 3($t0)
	syscall
	
	#prints inside item of grid
	la 	$a0, gridPrintInside
	li 	$v0, 4
	syscall
	
	#prints letter
	li	$v0, 11
	lb	$a0, 4($t0)
	syscall
	
	#prints grid inside again
	la 	$a0, gridPrintInside
	li 	$v0, 4
	syscall
	
	#print letter
	li	$v0, 11
	lb	$a0, 5($t0)
	syscall
	
	#print right side of grid
	la 	$a0, gridPrintSideRight
	li 	$v0, 4
	syscall
	
	#fourth line, nearly done
	#menu item 3
	la	$a0, menuLine3
	li	$v0, 4
	syscall
	
	#middle grind print
	la 	$a0, gridPrintMiddle
	li 	$v0, 4
	syscall
	
	# fifth line. Nearly done
	la	$a0, menuLine4
	li	$v0, 4
	syscall
	
	#grid print a left side
	la 	$a0, gridPrintSideLeft
	li 	$v0, 4
	syscall
	
	#print a letter
	li	$v0, 11
	lb	$a0, 6($t0)
	syscall
	
	#print the inside
	la 	$a0, gridPrintInside
	li 	$v0, 4
	syscall
	
	#letter goes here
	li	$v0, 11
	lb	$a0, 7($t0)
	syscall
	
	#print a grid inside
	la 	$a0, gridPrintInside
	li 	$v0, 4
	syscall
	
	#print letter
	li	$v0, 11
	lb	$a0, 8($t0)
	syscall
	
	#print grid side right
	la 	$a0, gridPrintSideRight
	li 	$v0, 4
	syscall
	
	#line 6 - last line, hurray!
	#last menu side item
	la	$a0, menuLine5
	li	$v0, 4
	syscall
	
	#prints the bottom of grid
	la 	$a0, gridPrintBottom
	li 	$v0, 4
	syscall
	
	#padding for any following text
	la	$a0, newLineChar
	li	$v0, 4
	syscall
	
	#go back to where we were. Done here
	jr	$ra
	
	#Should look like this now:
	# +---+---+---+		|	Menu:				|
	# | X | Y | Z |		|  0:	menu item			|
	# |---+---+---|		|  1:	menu item			|
	# | B | A | W |		|  2:	menu item			|
	# |---+---+---|		|  3:	menu item			|
	# | R | Y | O |		|  4:	menu item			|
	# +---+---+---+		

