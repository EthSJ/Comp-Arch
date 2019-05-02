#Time function. gets time and finds elasped
#CS 3340.501

.text
	getCurrentTime:
		li	$v0, 30				#Syscall 30
		syscall					#$a0 has lower 32 bits of the system time
		li	$t0, 1000			#Milliseconds to seconds
		div	$a0, $t0			#Seconds stored in $t0
		mflo	$v0				#Return seconds
		jr	$ra
				
	getTimeElapsed:					
		addi	$sp, $sp, -8
		sw	$ra, ($sp)
		sw	$a0, 4($sp)
		jal	getCurrentTime			#Find/Store time in $v0
		
		lw	$t0, 4($sp)			#Load Start time in $t0
		lw	$ra, ($sp)
		addi	$sp, $sp, 8
		sub	$v0, $v0, $t0			#get difference in time
		jr	$ra
