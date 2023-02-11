#
# Calculate sum from A to B.
# A = 1, B = 10.

.text
main:
	#
	# Your code goes here...
	#
	addi $t0 $zero 1  # A
	addi $t1 $zero 10 # B
	add  $t2 $zero $zero
	
loop:	add  $t2 $t0   $t2
	beq  $t0 $t1   end
	addi $t0 $t0   1
	j loop
	# Put your sum S into register $t2
end:	
	j	end	# Infinite loop at the end of the program. 
