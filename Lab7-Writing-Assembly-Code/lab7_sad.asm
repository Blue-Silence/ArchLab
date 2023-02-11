#
# Sum of Absolute Differences Algorithm


.text


main:


	     # TODO1: initilize the rest of the memory.
	     
	     lui     $s0, 0x0000 # Address of first element in the vector
	     ori     $s0, 0x0000
	     addi   $t0, $0, 5		# left_image[0]	
	     sw      $t0, 0($s0)
	     addi   $t0, $0, 16	# left_image[1]		
	     sw      $t0, 4($s0)
	     addi   $t0, $0, 7		# left_image[2]		
	     sw      $t0, 8($s0)
	     addi   $t0, $0, 1		# left_image[3]	/[4]	
	     sw      $t0, 12($s0)
	     sw      $t0, 16($s0)
	     addi   $t0, $0, 13	# left_image[5]
	     sw      $t0, 20($s0)
	     addi   $t0, $0, 2		# left_image[6]
	     sw      $t0, 24($s0)
	     addi   $t0, $0, 8		# left_image[7]
	     sw      $t0, 28($s0)
	     addi   $t0, $0, 10	# left_image[8]
	     sw      $t0, 32($s0)	     	     	     
	     
	     addi   $t0, $0, 4		# right_image[0]	
	     sw      $t0, 36($s0)
	     addi   $t0, $0, 15	# right_image[1]		
	     sw      $t0, 40($s0)
	     addi   $t0, $0, 8		# left_image[2]		
	     sw      $t0, 44($s0)
	     addi   $t0, $0, 0		# right_image[3]	
	     sw      $t0, 48($s0)
	     addi   $t0, $0, 2		# right_image[4]
	     sw      $t0, 52($s0)
	     addi   $t0, $0, 12	# right_image[5]
	     sw      $t0, 56($s0)
	     addi   $t0, $0, 3		# right_image[6]
	     sw      $t0, 60($s0)
	     addi   $t0, $0, 7		# right_image[7]
	     sw      $t0, 64($s0)
	     addi   $t0, $0, 11	# right_image[8]
	     sw      $t0, 68($s0)	     	     	     
	     
	     
	# TODO4: Loop over the elements of left_image and right_image
	addi $s1, $s0, 36
	addi $s3, $s0, 36
	addi $s4, $s3, 36

loop:
	beq $s1, $s0, end_loop
	
	lw $a0, ($s0)
	lw $a1, ($s3)
	jal abs_diff
	sw $v0, ($s4)
	
	addi $s0, $s0, 4
	addi $s3, $s3, 4
	addi $s4, $s4, 4

	j loop
	

	
end_loop:

	#TODO5: Call recursive_sum and store the result in $t2	
	add $a0, $zero, $s3
	addi $a1, $zero, 9
	jal recursive_sum
	add $t2, $zero, $v0
	

end:	
	j	end	# Infinite loop at the end of the program. 

# TODO2: Implement the abs_diff routine here, or use the one provided
abs_diff:
	sub $v0, $a0, $a1
	blez $v0, get_minus
	jr $ra
	
get_minus:
	sub $v0, $zero, $v0
	jr $ra



# TODO3: Implement the recursive_sum routine here, or use the one provided
recursive_sum:    
	addi $sp, $sp, -8       # Adjust sp
        addi $t0, $a1, -1       # Compute size - 1
        sw   $t0, 0($sp)        # Save size - 1 to stack
        sw   $ra, 4($sp)        # Save return address
        bne  $a1, $zero, else   # size == 0 ?
        addi  $v0, $0, 0        # If size == 0, set return value to 0
        addi $sp, $sp, 8        # Adjust sp
        jr $ra                  # Return

else:     
	add  $a1, $t0, $0		#update the second argument
        jal   recursive_sum 
        lw    $t0, 0($sp)       # Restore size - 1 from stack
        sll  $t1, $t0, 2        # Multiply size by 4
        add   $t1, $t1, $a0     # Compute & arr[ size - 1 ]
        lw    $t2, 0($t1)       # t2 = arr[ size - 1 ]
        add   $v0, $v0, $t2     # retval = $v0 + arr[size - 1]
        lw    $ra, 4($sp)       # restore return address from stack         
        addi $sp, $sp, 8        # Adjust sp
        jr $ra                  # Return
