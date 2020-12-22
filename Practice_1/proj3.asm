.text

#######################################################################
#				part 1				      #
#######################################################################

strcmp:

addi	$sp,	$sp,	-32

move	$s2,	$t0
move	$s3,	$t1
move	$s4,	$t2
move	$s5,	$t3
move	$s6,	$t9

sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$ra,	28($sp)

move	$s0,	$a0		#length of string1
move	$s1,	$a1		#length of string2

li	$t0,	0
li	$t1,	0

beqz	$s0,	check_for_s1_zero	
check_for_s1_zero:
beqz	$s1,	both_equal_so_done

lbu	$t2,	0($s0)
beqz	$t2,	return_length_string_2

lbu	$t3,	0($s1)
beqz	$t3	return_length_string_1

loop_part_one:

lbu	$t2,	0($s0)
addi	$t0,	$t0,	1
lbu	$t3,	0($s1)
addi	$t1,	$t1,	1
beq	$t2,	$t3,	move_to_next
j	done_with_part_one

move_to_next:
beqz	$t3,	check_for_two
check_for_two:
beqz	$t2,	both_equal_so_done
addi	$s0,	$s0,	1
addi	$s1,	$s1,	1
j	loop_part_one


return_length_string_1:

lbu	$t2,	0($s0)
beqz	$t2,	string_2_length_zero
addi	$t0,	$t0,	1
addi	$s0,	$s0,	1
j	return_length_string_1

return_length_string_2:
lbu	$t3,	0($s1)
beqz	$t3,	string_1_length_zero
addi	$t1,	$t1,	1
addi	$s1,	$s1,	1
j	return_length_string_2

string_1_length_zero:
sub	$t9,	$zero,	$t1
move	$v0,	$t9
j	pull_from_stack_part_one

string_2_length_zero:
move	$v0,	$t0
j	pull_from_stack_part_one


both_equal_so_done:
li	$v0,	0
j	pull_from_stack_part_one

done_with_part_one:
sub	$t9,	$t2,	$t3
move	$v0,	$t9

pull_from_stack_part_one:
lw	$ra,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

move	$t0,	$s2
move	$t1,	$s3
move	$t2,	$s4
move	$t3,	$s5
move	$t9,	$s6

addi	$sp,	$sp,	32

jr	$ra


#######################################################################
#				part 2				      #
#######################################################################

find_string:

addi	$sp,	$sp,	-40

move	$s4,	$t0			# moving temp to s registers to follow register convntions.
move	$s5,	$t1
move	$s6,	$t6
move	$s7,	$t7

sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t9,	32($sp)
sw	$t3,	36($sp)
sw	$ra,	40($sp)

move	$s0,	$a0	# target
move	$s1,	$a1	# strings
move	$s3,	$a1	# extra copy
move	$s2,	$a2	# strings length
li	$t4,	0
li	$t0,	0	# counter_of_string
li	$t1,	0	# for_counting_all_character
li	$t7,	0	# length of target

blt	$s2,	2,	did_not_find_string

count_length_of_target:
lbu	$t6,	0($s0)
beqz	$t6,	done_counting
addi	$t7,	$t7,	1	# length of target
addi	$s0,	$s0,	1
j	count_length_of_target

done_counting:
sub        $s0,        $s0,        $t7
blt	$s2,	$t7,	did_not_find_string

count_characters:

lbu	$t3,	0($s1)
beqz	$t3,	move_to_part_one_1
addi	$t0,	$t0,	1
addi	$s1,	$s1,	1
addi	$t1,	$t1,	1	# total characters read
j	count_characters

move_to_part_one_1:

sub	$s1,	$s1,	$t0
addi	$t1,	$t1,	1	# counting \0 here
addi	$t0,	$t0,	1	# counting \0 here
beq	$t0,	1,	continue_with_left_part

move_to_part_one:
bgt	$t1,	$s2,	did_not_find_string

move	$a0,	$s0	# string 1
move	$a1,	$s1	# string 2

addi	$sp,	$sp,	-40

move	$s4,	$t0			# moving temp to s registers to follow register convntions.
move	$s5,	$t1
move	$s6,	$t6
move	$s7,	$t7

sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t9,	32($sp)
sw	$t3,	36($sp)
sw	$ra,	40($sp)

move	$a0,	$s0
jal	strcmp

lw	$ra,	40($sp)
lw	$t3,	36($sp)
lw	$t9,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)


move	$t0,	$s4			# pulling temp to s registers to follow register convntions.
move	$t1,	$s5
move	$t6,	$s6
move	$t7,	$s7

addi	$sp,	$sp,	40

move	$t9,	$v0

addi	$t4,	$t4,	1

beqz	$t9,	done_with_part_two

continue_with_left_part:
add	$s1,	$s1,	$t0

li	$t0,	0
j	count_characters

did_not_find_string:
li	$v0,	-1
j	pull_from_stack_part_2

done_with_part_two:
sub	$t9,	$s1,	$s3
move	$v0,	$t9

pull_from_stack_part_2:

lw	$ra,	40($sp)
lw	$t3,	36($sp)
lw	$t9,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)


move	$t0,	$s4			# pulling temp to s registers to follow register convntions.
move	$t1,	$s4
move	$t6,	$s6
move	$t7,	$s7

addi	$sp,	$sp,	40
jr	$ra


#######################################################################
#				part 3				      #
#######################################################################

hash:

addi	$sp,	$sp,	-36

move	$s2,	$t0
move	$s5,	$t1
move	$s6,	$t2
move	$s7,	$t3

sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$ra,	32($sp)

move	$s0,	$a0	# hash table
lw	$s3,	0($a0)
lw	$s4,	4($a0)

move	$s1,	$a1	# key
li	$t1,	0	# adding all ASCII numeric value

calculate_key:

lbu	$t0,	0($s1)
beqz	$t0,	done_with_calculating
add	$t1,	$t1,	$t0
addi	$s1,	$s1,	1
j	calculate_key

done_with_calculating:
div	$t1,	$s3
mfhi	$t2	# this has the remainder value

move	$v0,	$t2

move	$t0,	$s2
move	$t1,	$s5
move	$t2,	$s6
move	$t3,	$s7

lw	$ra,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

addi	$sp,	$sp,	36

jr	$ra

#######################################################################
#				part 4				      #
#######################################################################

clear:
addi	$sp,	$sp,	-20
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$t9,	12($sp)
sw	$ra,	16($sp)


move	$s0,	$a0	#address of hash table
move	$t9,	$a0	# helps in printing
lbu	$s1,	0($s0)	# capacity
sw	$zero,	4($s0)
li	$s2,	0	#loop helper
addi	$s0,	$s0,	8
reset_keys:
beq	$s2,	$s1,	reset_values
sw	$zero,	0($s0)
addi	$s0,	$s0,	4
addi	$s2,	$s2,	1
j	reset_keys

reset_values:
li	$s2,	0

reset_values_1:
beq	$s2,	$s1,	done
sw	$zero,	0($s0)
addi	$s0,	$s0,	4
addi	$s2,	$s2,	1
j	reset_values_1

done:
lw	$ra,	16($sp)
lw	$t9,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	20
jr	$ra

#######################################################################
#				part 5				      #
#######################################################################

get:

addi	$sp,	$sp,	-44
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t8,	32($sp)
sw	$t9,	36($sp)
sw	$ra,	40($sp)

move	$s0,	$a0	# hash table address
lbu	$s6,	0($s0)	# capacity
lbu	$t9,	4($s0)
beqz	$t9,	empty_slot

move	$s1,	$a1	# string key
li	$s5,	0	# number of probes

addi	$sp,	$sp,	-20
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s5,	8($sp)
sw	$s6,	12($sp)
sw	$ra,	16($sp)

jal	hash
move	$s3,	$v0	# this is my has value
move	$s7,	$v0	# extra copy of hash slot
li	$s2,	4

lw	$ra,	16($sp)
lw	$s6,	12($sp)
lw	$s5,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	20

mul	$s3,	$s3,	$s2	# this should have the space
addi	$s3,	$s3,	8	# this should have the final value of the slot 
add	$s3,	$s3,	$s0	# adding the address calculated to hash table address

lw	$t8,	0($s3)		# loading value in t8 will be useful as t8 will be reinitialised in next line
beqz	$t8,	empty_slot
#beq	$t8,	1,	empty_slot	# please consider case where we have 0 or 1 as both are considered as blank spaces.

li	$t8,	0	# counter helper in next loop

check_next_place:

add	$s5,	$t8,	$s7		# s7 value will remain same and we are putting it on stack, so need not to worry
bge	$s5,	$s6,	wrap_around	# might be bgt or bge consider the case where the hash number produced is the last slot in keys
j	skip_wrap_around

wrap_around:
mul	$t6,	$s7,	$s2
sub	$s3,	$s3,	$t6
addi	$s3,	$s3,	-4
li	$s7,	0
li	$s5,	0
# now i am at pos 0
j	skip_wrap_around_1

skip_wrap_around:

addi	$s5,	$t8,	-1

skip_wrap_around_1:
lw	$t6,	0($s3)
beqz	$t6,	empty_slot_while_probing
beq	$t6,	1,	detected_one
#beq	$s5,	1,	empty_slot_while_probing	# please consider case where we have 0 or 1 as both are considered as blank spaces.

addi	$sp,	$sp,	-40
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t8,	32($sp)
sw	$ra,	36($sp)

lw	$a0,	0($s3)
move	$a1,	$s1	# string 2

jal	strcmp

lw	$ra,	36($sp)
lw	$t8,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	40

move	$t6,	$v0		# If the two string are equal or not
#add	$s5,	$t8,	$s7	# when we do not reach the end, so the final slot value will be returned
beqz	$t6,	found_the_key
detected_one:

addi	$s3,	$s3,	4	# probing the slot by one (4 bits) place to check if its any other pleace.
addi	$t8,	$t8,	1	# incrementing probing counter

bgt	$t8,	$s6,	key_not_found	# this is for the case when we start at any place and we come at same place hence we dont find the key

# following code check for updated value of s3, this condition will be considered 
# as empty_slot_while_probing so updated value od t8 will be movwd to v1 and v0 is -1. 

# if its not the case then new updated value of s5 will be pushed on stack.

j	check_next_place	# looping back again

found_the_key:
addi	$s0,	$s0,	8
sub	$s7,	$s3,	$s0
div	$s7,	$s2
mflo	$s7
move	$v0,	$s7	# what slot is the key at
move	$v1,	$t8	# number of probes, initially it was t8.
j	pull_everything_from_stack

key_not_found:
li	$v0,	-1
addi	$v1,	$s6,	-1	# return capacity - 1
j	pull_everything_from_stack

empty_slot_while_probing:
li	$v0,	-1
move	$v1,	$t8
j	pull_everything_from_stack

empty_slot:
li	$v0,	-1
li	$v1,	0
j	pull_everything_from_stack

pull_everything_from_stack:

lw	$ra,	40($sp)
lw	$t9,	36($sp)
lw	$t8,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

addi	$sp,	$sp,	44
jr	$ra

#######################################################################
#				part 6				      #
#######################################################################

put:

# make sure to put all the registers on stack
addi	$sp,	$sp,	-64
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t2,	32($sp)
sw	$t4,	36($sp)
sw	$t5,	40($sp)
sw	$t6,	44($sp)
sw	$t8,	48($sp)
sw	$t9,	52($sp)
sw	$t1,	56($sp)
sw	$ra,	60($sp)

move	$s0,	$a0	# hash table address
move	$t3,	$a0
move	$s1,	$a1	# key to add
move	$s2,	$a2	# value of key

li	$s7,	4	# helper constant
li	$t2,	0

lw	$s3,	0($s0)
lw	$s4,	4($s0)
addi	$s5,	$s0,	8		# value
mul	$t7,	$s3,	$s7
add	$s6,	$s5,	$t7	# key

addi	$sp,	$sp,	-40
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t2,	32($sp)
sw	$ra,	36($sp)

jal hash
move	$t1,	$v0

lw	$ra,	36($sp)
lw	$t2,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	40

addi	$sp,	$sp,	-44
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t2,	32($sp)
sw	$t1,	36($sp)
sw	$ra,	40($sp)

jal	get
move	$t8,	$v0	# found or not
move	$t9,	$v1	# number of probing

lw	$ra,	40($sp)
lw	$t1,	36($sp)
lw	$t2,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	44

beq	$t8,	-1,	key_not_found_part_six
j	key_found_part_six

check_for_next_spot:
bge	$t1,	$s3,	move_to_first_spot_1
j	key_not_found_part_six # skip_move_to_first_spot

move_to_first_spot_1:
li	$t1,	0
beq	$t2,	$s3,	did_not_find_key	# when there is no psace available

key_not_found_part_six:
mul	$t5,	$t1,	$s7
add	$t5,	$s5,	$t5
lw	$t4,	0($t5)		# might remove
beqz	$t4,	put_value
beq	$t4,	1,	put_value
j	move_to_first_spot

key_found_part_six:
mul	$t5,	$t8,	$s7
add	$t6,	$s6,	$t5
sw	$s2,	0($t6)
j	found_the_key_1


put_value:
sw	$s1,	0($t5)
mul	$t5,	$t1,	$s7
add	$t5,	$s6,	$t5
sw	$s2,	0($t5)
addi	$s4,	$s4,	1
sw	$s4,	4($s0)
move	$v0,	$t1
j	done_with_part_six

move_to_first_spot:
addi	$t1,	$t1,	1
addi	$t2,	$t2,	1
j	check_for_next_spot

did_not_find_key:
li	$v0,	-1
li	$v1,	-1
j	done_with_part_six

found_the_key_1:
sub	$v1,	$s3,	$t1
add	$v1,	$v1,	$v0

done_with_part_six:

lw	$ra,	60($sp)
lw	$t1,	56($sp)
lw	$t9,	52($sp)
lw	$t8,	48($sp)
lw	$t6,	44($sp)
lw	$t5,	40($sp)
lw	$t4,	36($sp)
lw	$t2,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)


addi	$sp,	$sp,	64

jr	$ra


#######################################################################
#				part 7				      #
#######################################################################
delete:

addi	$sp,	$sp,	-52
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t4,	32($sp)
sw	$t5,	36($sp)
sw	$t6,	40($sp)
sw	$t7,	44($sp)
sw	$ra,	48($sp)

move	$s0,	$a0	# has table
move	$t3,	$a0
move	$s1,	$a1	# key

lw	$s4,	0($s0)
lw	$s5,	4($s0)
li	$s7,	4	# helpee constant
li	$s6,	1	#0x000000001

addi	$sp,	$sp,	-28

sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s4,	8($sp)
sw	$s5,	12($sp)
sw	$s6,	16($sp)
sw	$s7,	20($sp)
sw	$ra,	24($sp)	

jal	get
move	$s2,	$v0
move	$s3,	$v1

lw	$ra,	24($sp)
lw	$s7,	20($sp)
lw	$s6,	16($sp)
lw	$s5,	12($sp)
lw	$s4,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	28

bne	$s2,	-1,	keyfound_part_seven
j	done_with_part_seven

keyfound_part_seven:
mul	$t5,	$s2,	$s7
add	$t5,	$s0,	$t5
addi	$t5,	$t5,	8	# this is my key to be deleted

mul	$t6,	$s4,	$s7
add	$t7,	$t6,	$t5	# this is the value to be deleted

sw	$s6,	0($t5)
sw	$zero,	0($t7)

addi	$s5,	$s5,	-1
sw	$s5,	4($s0)

done_with_part_seven:

lw	$ra,	48($sp)
lw	$t7,	44($sp)
lw	$t6,	40($sp)
lw	$t5,	36($sp)
lw	$t4,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

addi	$sp,	$sp,	52

jr	$ra

#######################################################################
#				part 8				      #
#######################################################################

build_hash_table:

# place all the registers on the stack

move	$s0,	$a0	# hash tbale
move	$s1,	$a1	# strings
move	$s2,	$a2	# strings length
move	$s3,	$a3,	# filename
li	$s5,	0	# length of the key
li	$t8,	4
li	$t5,	'\0'

addi	$sp,	$sp,	-24
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s5,	16($sp)
sw	$ra,	20($sp)	

jal	clear

lw	$ra,	20($sp)
lw	$s5,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

addi	$sp,	$sp,	24

move	$a0,	$s3
li	$v0,	13
li	$a1,	0
li	$a2,	0
syscall

move	$s4,	$v0
beq	$s4,	-1,	done_with_part_eigth
addi	$sp,	$sp,	-80
move	$t1,	$sp

while_loop:

li	$v0,	14
move	$a0,	$s4
move	$a1,	$sp
li	$a2,	1
syscall

lw 	$t0, 	0($sp)     # buffer contains the values

beq	$t0,	32,	call_parttwo
#beq	$t0,	'\n',	end_of_line

addi	$sp,	$sp,	4
addi	$s5,	$s5,	1

j	while_loop

call_parttwo:
sw	$t5,	0($sp)
#addi	$sp,	$sp,	-28
#sw	$s0,	0($sp)
#sw	$s1,	4($sp)
#sw	$s2,	8($sp)
#sw	$s3,	12($sp)
#sw	$s4,	16($sp)
#sw	$s5,	20($sp)
#sw	$ra,	24($sp)	
addi	$sp,	$sp,	-4
move	$a0,	$t1
move	$a1,	$s1
move	$a2,	$s2

jal	find_string
move	$s6,	$v0

#lw	$ra,	24($sp)
#lw	$s5,	20($sp)
#lw	$s4,	16($sp)
#lw	$s3,	12($sp)
#lw	$s2,	8($sp)
#lw	$s1,	4($sp)
#lw	$s0,	0($sp)

#addi	$sp,	$sp,	28

done_with_part_eigth:

# make sure to pull fromm stacks

jr	$ra
#######################################################################
#				part 9				      #
#######################################################################
autocorrect:
jr $ra

