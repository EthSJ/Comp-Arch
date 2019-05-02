#a macro file for assisting
#CS 3340.501 
		
#Pointer moves to z string
#Put pointer in register x
#Put arrays entry in pointer y
#Number of entry's wanted in register z
	
.macro get_WordArray (%x, %y, %z) 
	sll $t7, %z, 2
	add $t7, %y, $t7
	lw %x, ($t7)
.end_macro
