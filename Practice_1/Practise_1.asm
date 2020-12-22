

.data
# Command-line arguments
num_args: .word 0
addr_arg0: .word 0
addr_arg1: .word 0
addr_arg2: .word 0
addr_arg3: .word 0
no_args: .asciiz "You must provide at least one command-line argument.\n"

# Error messages
invalid_operation_error: .asciiz "INVALID_OPERATION\n"
invalid_args_error: .asciiz "INVALID_ARGS\n"

# Output strings
zero_str: .asciiz "Zero\n"
neg_infinity_str: .asciiz "-Inf\n"
pos_infinity_str: .asciiz "+Inf\n"
NaN_str: .asciiz "NaN\n"
floating_point_str: .asciiz "_2*2^"

# Miscellaneous strings
nl: .asciiz "\n"

# Put your additional .data declarations here, if any.
part: .space 32

# Main program starts here
.text
.globl main
main:
    # Do not modify any of the code before the label named "start_coding_here"
    # Begin: save command-line arguments to main memory
    sw $a0, num_args
    beq $a0, 0, zero_args
    beq $a0, 1, one_arg
    beq $a0, 2, two_args
    beq $a0, 3, three_args
four_args:
    lw $t0, 12($a1)
    sw $t0, addr_arg3
three_args:
    lw $t0, 8($a1)
    sw $t0, addr_arg2
two_args:
    lw $t0, 4($a1)
    sw $t0, addr_arg1
one_arg:
    lw $t0, 0($a1)
    sw $t0, addr_arg0
    j start_coding_here
zero_args:
    la $a0, no_args
    li $v0, 4
    syscall
    j exit
    # End: save command-line arguments to main memory

start_coding_here:
	 li   $t0, '2'						#Loadin 2,F,C in t-0,1,2 registers
	 li   $t1, 'F'
	 li   $t2, 'C'

	la   $a0, addr_arg0					# load the address of first char in $a0
  	lw   $a0, 0($a0)					# load the address of $a0 into $a0 as word
   	lbu  $a0, 0($a0)					# this loads the actual value in $a0

   	 beq  $a0, $t0, check_for_exactly_one_other_arg_2	# check if first arg is 2
   	 beq  $a0, $t1, check_for_exactly_one_other_arg_F	# check if first arg is F
   	 beq  $a0, $t2, check_for_exactly_three_other_arg	# check if first arg is C

   	 j    wrong_first_arg
#######################################################################################################################
#`														      #
#					PART 1: Helper labels.		                                              #
#														      #
#													              #
#######################################################################################################################
check_for_exactly_one_other_arg_2:				#if this is false then show invalid_args_error otherwise move to passed_2_and_3_test

 	la    $t4, num_args					# This puts num_args's address in $t4
 	lbu   $t4, 0($t4)					# This load first unsigned byte from $t4, Hence you will get Value
 	li    $t5, 2						# Pushing imm : 2 in $t5
 	beq   $t4,$t5, twos_compliment				# Testing if it passed
 	bne   $t4,$t5, failed_2_or_3_test			# Testing if it failed

 check_for_exactly_one_other_arg_F:

 	la    $t4, num_args					# This puts num_args's address in $t4
 	lbu   $t4, 0($t4)					# This load first unsigned byte from $t4, Hence you will get Value
 	li    $t5, 2						# Pushing imm : 2 in $t5
 	beq   $t4,$t5, twos_compliment				# Testing if it passed
 	bne   $t4,$t5, failed_2_or_3_test			# Testing if it failed

failed_2_or_3_test:
	la $a0, invalid_args_error
	li $v0,4
	syscall
	j exit

check_for_exactly_three_other_arg:				#if this is false then show invalid_args_error
	la    $t4, num_args					# This puts num_args's address in $t4
 	lbu   $t4, 0($t4)					# This load first unsigned byte from $t4, Hence you will get Value
 	li    $t5, 4						# Pushing imm : 2 in $t5
 	beq   $t4,$t5, continue_part_4				# Testing if it passed
 	bne   $t4,$t5, failed_2_or_3_test			# Testing if it failed

wrong_first_arg:
	la $a0, invalid_operation_error
	li $v0,4
	syscall
	j exit

#######################################################################################################################
#`				                                                                                      #
#						PART 2: Helper labels                        			      #
#								                                                      #
#######################################################################################################################
twos_compliment:

	 li $t5,48				# $t5 = 0, 48 is decimal of 0
	 li $t4,49				# $t4 = 1, 49 is decimal of 1
	 la  $a0, addr_arg1
	 lw  $a0, 0($a0)
	 add $t0,$zero,$zero				#counter for the loop

#########################################
#	This is loop part - 1 		#
#########################################
check_for_correct_second_argument:

	lbu  $t1 ,0($a0)			#this loads the current address's byte value and it gets increased by 1 if the value is 0 or 1
	beqz  $t1,for_loop_part_2
	bne   $t1, $t4, it_is_not_1		#this and next statement checks, if the current bit is 1 or 0
	beq   $t1, $t4, move_ahead_in_for_loop

it_is_not_1:
	bne  $t1, $t5, it_is_not_0_and_1
	beq  $t1, $t5, move_ahead_in_for_loop

move_ahead_in_for_loop:

	addi  $t0,$t0,1				#increment for  counter.
	addi  $a0,$a0,1
	j check_for_correct_second_argument

it_is_not_0_and_1:
	la $a0, invalid_args_error
	li $v0,4
	syscall
	j exit

#########################################
#	This is loop part - 2 		#
#########################################

for_loop_part_2:
	add $t3,$zero,$t0			#now i have copy of number of 1 and 0
	bgt $t0,32,failed_2_or_3_test
	la  $a0, addr_arg1
	lw  $a0, 0($a0)
	addi $t0,$zero,1			#counter for the loop
	add  $t7,$zero , $a0
	add  $t8, $a0,$t3			#store LSB in second argument

continuing_loop_part_2:

	lbu   $t1 ,0($a0)			#this loads the current address's byte value and it gets increased by 1 if the value is 0 or 1
	beqz  $t1,for_loop_end_part_2
	sub   $t2,$t3,$t0
	li    $t6,1
	beq   $t1, $t4, multiplying_by_2
	beq   $t1, $t5, move_ahead_0

multiplying_by_2:
	beqz  $t2, move_ahead_1
	sll   $t6, $t6 ,1
	addiu    $t2, $t2, -1
	j multiplying_by_2

move_ahead_1:
  	beq   $t7,$a0, change_value_to_nagative
  	add   $t9,$t9,$t6
  	#add   $a1, $a1, $t6
	addi  $t0,$t0,1				#increment for  counter.
	addi  $a0,$a0,1
	j continuing_loop_part_2

move_ahead_0:

	addi  $t0,$t0,1				#increment for  counter.
	addi  $a0,$a0,1
	j continuing_loop_part_2

change_value_to_nagative:
	li $t7, -1
	mul $t6, $t6, $t7
	add $t9,$zero, $t6
	addi  $t0,$t0,1				#increment for  counter.
	addi  $a0,$a0,1
	j continuing_loop_part_2

for_loop_end_part_2:
	add $a1,$zero,$t9
	add $a0,$zero, $a1
	li $v0,1
	syscall
	j exit


#######################################################################################################################
#`				                                                                                      #
#						PART 4: Helper labels                        			      #
#								                                                      #
#######################################################################################################################

continue_part_4:

	 la  $a0, addr_arg1			#second argument
	 lw  $a0, 0($a0)
	 la  $a1, addr_arg2			#third argument
	 lw  $a1, 0($a1)
	 la  $a2, addr_arg3			#fourth argument
	 lw  $a2, 0($a2)
	 li $t8,49			#ascii value od 2
	 li $t9,66			# ascii value of 65

	 lbu   $t1,0($a1)
	 bgt   $t1,$t9, failed_2_or_3_test
	 blt   $t1,$t8, failed_2_or_3_test

	 lbu   $t1,0($a2)					#stores third argument base number
	 bgt   $t1,$t9, failed_2_or_3_test
	 blt   $t1,$t8, failed_2_or_3_test


	 add $t0,$zero,$zero				#counter, helps in counting number of digits
	 add $t5,$zero,$zero				# will store the first conversion final value

	  lbu $t7,0($a1)					#stores third argument base number
	  addiu  $t7,$t7,-48				#convert to decimal

counting_number_of_digits_in_second_argument:
	 lbu   $t2,  0($a0)
	 beqz  $t2, convert_to_base_part_1
	 addi  $t0,$t0,1				#increment for  counter.
	 addi  $a0,$a0,1
	 li    $t6,1
	 j counting_number_of_digits_in_second_argument

convert_to_base_part_1:
	add $t3,$zero,$t0			#now i have copy of number of 1 and 0
	la  $a0, addr_arg1
	lw  $a0, 0($a0)
	li  $t0,1			#reusing $t0 as i++
	li  $t6,1
	li  $t9,0

convert_to_base_part_1_continue:
	li  $t6,1
	lbu   $t5 ,0($a0)			#this loads the current address's byte value and it gets increased by 1 if the value is 0 or 1
	beqz  $t5,convert_to_base_part_2_continue
	sub   $t2,$t3,$t0
	j  multiplying_Process

multiplying_Process:
	beqz  $t2, next_step
	mul   $t6, $t6 ,$t7
	addiu    $t2, $t2, -1
	j multiplying_Process

next_step:
	addi  $t5,$t5,-48
	mul   $t8,$t5,$t6
	add   $t9,$t9,$t8
	addi  $t0,$t0,1				#increment for  counter.
	addi  $a0,$a0,1
	j convert_to_base_part_1_continue

convert_to_base_part_2_continue:

	lbu    $t7,0($a2)				#stores third argument base number
	addiu  $t7,$t7,-48

division_part:

	beqz $t9,exit
	div $t9,$t7
	mfhi $t6		#remainder
	mflo $t5		#quotient
	add $s0,$zero,$t6
	j end_2

end_2:
	add $a0,$s0,$zero
	li $v0,1
	syscall
	add $t9,$zero,$t5
	j division_part

base_10_exit:
	add  $a0,$zero,$t9
	li $v0,1
	syscall
	j exit
exit:
	la $a0, nl
	li $v0,4
	syscall
       	li $v0, 10   # terminate program
       	syscall
