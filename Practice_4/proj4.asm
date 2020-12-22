

#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################
#################### DO NOT CREATE A .data SECTION ####################

.text
#######################################################################
#				part 1				      #
#######################################################################
load_board:

addi	$sp,	$sp,	-56

sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s5,	12($sp)
sw	$s6,	16($sp)
sw	$s7,	20($sp)
sw	$t0,	24($sp)
sw	$t1,	28($sp)
sw	$t3,	32($sp)
sw	$t4,	36($sp)
sw	$t5,	40($sp)
sw	$t6,	44($sp)
sw	$t7,	48($sp)
sw	$ra,	52($sp)

move	$s0,	$a0	# board address
move	$t1,	$a0
move	$s1,	$a1	# file name
li	$s5,	10
li	$t0,	0
li	$s6,	0
li	$s7,	0

li	$t5,	0	# number of X's
li	$t6,	0	# number of O's
li	$t7,	0	# number of invalid character

li	$s3,	0
move	$a0,	$a1
li	$v0,	13
li	$a1,	0
li	$a2,	0
syscall

move	$s2,	$v0	# saving the Descriptor
beq	$s2,	-1,	done_with_part_one_1

while_Loop:
li	$v0,	14
move	$a0,	$s2	# discriptor
move	$a1,	$s0	# board address
li	$a2,	1
syscall

lbu	$t4,	0($s0)
beq	$t4,	10,	read_Colomn
addi	$t4,	$t4,	-48

addi	$t0,	$t0,	1
bne	$t0,	1,	dontmultiply
mul	$s6,	$t4,	$s5
j	skip_dontmultiply
dontmultiply:

add	$s6,	$s6,	$t4

skip_dontmultiply:
addi	$s0,	$s0,	1

j	while_Loop

read_Colomn:
addi	$s0,	$s0,	-1
beq	$t0,	1,	divide
j	skip_divide_1
divide:
div	$s6,	$s5
mflo	$s6	# one digit value
skip_divide_1:
li	$t0,	0

skip_divide:	# here s6 has final vlaue of row

li	$v0,	14
move	$a0,	$s2	# discriptor
move	$a1,	$s0	# board address
li	$a2,	1
syscall

lbu	$t4,	0($s0)
beq	$t4,	10,	read_slots
addi	$t4,	$t4,	-48
addi	$t0,	$t0,	1
bne	$t0,	1,	dontmultiply_1
mul	$s7,	$t4,	$s5
j	skip_dontmultiply_1
dontmultiply_1:

add	$s7,	$s7,	$t4

skip_dontmultiply_1:
addi	$s0,	$s0,	1

j	skip_divide

read_slots:
beq	$t0,	1,	divide_1
j	skip_divide_1_1
divide_1:
div	$s7,	$s5
mflo	$s7	# one digit value

skip_divide_1_1:
move	$s0,	$t1
sw	$s6,	0($s0)
sw	$s7,	4($s0)
addi	$s0,	$s0,	8
li	$t3,	'.'
mul	$t4,	$s6,	$s7
li	$t0,	0

read_slots_1:
beq	$t0,	$t4,	done_reading_board
li	$v0,	14
move	$a0,	$s2	# discriptor
move	$a1,	$s0	# board address
li	$a2,	1
syscall

lbu	$t2,	0($s0)

beq	$t2,	46,	move_next
beq	$t2,	88,	increment_x
beq	$t2,	79,	increment_o
beq	$t2,	10,	move_next_11

sb	$t3,	0($s0)
addi	$t7,	$t7,	1
j	skip_move_next

increment_x:
addi	$t5,	$t5,	1
j	move_next

increment_o:
addi	$t6,	$t6,	1

move_next:
sb	$t2,	0($s0)

skip_move_next:
addi	$t0,	$t0,	1

addi	$s0,	$s0,	1

j	read_slots_1

move_next_11:

addi	$s0,	$s0,	0

j	read_slots_1

done_reading_board:

sll	$v0,	$t5,	16
sll	$t6,	$t6,	8
add	$v0,	$v0,	$t6
add	$v0,	$v0,	$t7

move	$a0,	$s2
li	$v0,	16			# closing the file
syscall

j	done_with_part_one

done_with_part_one_1:

li	$v0,	-1

done_with_part_one:

lw	$ra,	52($sp)
lw	$t7,	48($sp)
lw	$t6,	44($sp)
lw	$t5,	40($sp)
lw	$t4,	36($sp)
lw	$t3,	32($sp)
lw	$t1,	28($sp)
lw	$t0,	24($sp)
lw	$s7,	20($sp)
lw	$s6,	16($sp)
lw	$s5,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	56
jr	$ra

#######################################################################
#				part 2				      #
#######################################################################
get_slot:

addi	$sp,	$sp,	-24
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$ra,	20($sp)

move	$s0,	$a0	# board
move	$s1,	$a1	# row
move	$s2,	$a2	# col

lw	$s3,	0($s0)	# total rows
addi	$t4,	$s3,	-1
lw	$s4,	4($s0)	# total colmn
addi	$t5,	$s4,	-1
addi	$s0,	$s0,	8

bltz	$s1,	part_two_failed
bgt	$s1,	$t4,	part_two_failed
bltz	$s2,	part_two_failed
bgt	$s2,	$t5,	part_two_failed

beqz	$s1,	simplyAdd

mul	$s3,	$s1,	$s4
add	$s3,	$s2,	$s3
add	$s0,	$s0,	$s3
j	skip_simplyadd

simplyAdd:
add	$s0,	$s0,	$s2
j	donneeeee

skip_simplyadd:
donneeeee:
lbu	$v0,	0($s0)

lw	$ra,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	24

jr	$ra

part_two_failed:

lw	$ra,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	24

li	$v0,	-1
jr 	$ra

#######################################################################
#				part 3				      #
#######################################################################
set_slot:

# put everything on stack
addi	$sp,	$sp,	-40
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$t2,	28($sp)
sw	$t3,	32($sp)
sw	$ra,	36($sp)

move	$s0,	$a0	# board address

move	$s1,	$a1	#row
move	$s2,	$a2	# colomn
move	$s3,	$a3	# character
#lbu	$s3,	0($s3)							####### changes this bcz of part 6 issue where '.' has to be replaced

lw	$s4,	0($s0)	# total rows
addi	$t2,	$s4,	-1
lw	$s5,	4($s0)	# total coloms
addi	$t3,	$s5,	-1
addi	$s0,	$s0,	8

bltz	$s1,	part_three_failed
bgt	$s1,	$t2,	part_three_failed
bltz	$s2,	part_three_failed
bgt	$s2,	$t3,	part_three_failed

beqz	$s1,	simplyAddandchange

mul	$s6,	$s1,	$s5
add	$s6,	$s2,	$s6
add	$s0,	$s0,	$s6
j	skip_simplyAddandchange

simplyAddandchange:
add	$s0,	$s0,	$s2

skip_simplyAddandchange:
sb	$s3,	0($s0)
move	$v0,	$s3
j	pull_from_stack

part_three_failed:
li	$v0,	-1

pull_from_stack:

lw	$ra,	36($sp)
lw	$t3,	32($sp)
lw	$t2,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	40

# pull from stack here.
jr	$ra



#######################################################################
#				part 4				      #
#######################################################################
place_piece:

addi	$sp,	$sp,	-40
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$t2,	28($sp)
sw	$t3,	32($sp)
sw	$ra,	36($sp)

move	$s0,	$a0	# board
move	$s1,	$a1	# row
move	$s2,	$a2	# colomn
move	$s3,	$a3	# player
#lbu	$s3,	0($s3)					# changed thus bcz of part 6 issues

beq	$s3,	'X',	move_ahead_part_four
beq	$s3,	'O',	move_ahead_part_four
j	part_four_failed

move_ahead_part_four:

lw	$s4,	0($s0)	# total rows
addi	$t2,	$s4,	-1
lw	$s5,	4($s0)	# total coloms
addi	$t3,	$s5,	-1
addi	$s0,	$s0,	8

bltz	$s1,	part_four_failed
bgt	$s1,	$t2,	part_four_failed
bltz	$s2,	part_four_failed
bgt	$s2,	$t3,	part_four_failed

beqz	$s1,	simplyAddandchange_1

mul	$s6,	$s1,	$s5
add	$s6,	$s2,	$s6
add	$s0,	$s0,	$s6
j	skip_simplyAddandchange_1

simplyAddandchange_1:
add	$s0,	$s0,	$s2

skip_simplyAddandchange_1:
lbu	$s6,	0($s0)
beq	$s6,	'X',	part_four_failed
beq	$s6,	'O',	part_four_failed

addi	$sp,	$sp,	-40
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$t2,	28($sp)
sw	$t3,	32($sp)
sw	$ra,	36($sp)

jal	set_slot

lw	$ra,	36($sp)
lw	$t3,	32($sp)
lw	$t2,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	40

move	$t9,	$v0
beq	$t9,	-1,	part_four_failed

j	pull_from_stack_part_four


part_four_failed:
li	$v0,	-1

pull_from_stack_part_four:
lw	$ra,	36($sp)
lw	$t3,	32($sp)
lw	$t2,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	40

jr	$ra

#######################################################################
#				part 5				      #
#######################################################################
game_status:

addi	$sp,	$sp,	-36
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$ra,	32($sp)

move	$s0,	$a0
lw	$s1,	0($s0)
lw	$s2,	4($s0)
mul	$s3,	$s2,	$s1	# loop helper
li	$s4,	0
li	$s6,	0		# number of x
li	$s7,	0		# number of o

addi	$s0,	$s0,	8


loop_part_five:

beq	$s4,	$s3,	done_loooping
lbu	$s5,	0($s0)
beq	$s5,	'X',	increment_x_part_five
beq	$s5,	'O',	increment_o_part_five
j	continue_ahead

increment_x_part_five:
addi	$s6,	$s6,	1
j	continue_ahead

increment_o_part_five:
addi	$s7,	$s7,	1

continue_ahead:

addi	$s0,	$s0,	1
addi	$s4,	$s4,	1
j	loop_part_five

done_loooping:
move	$v0,	$s6
move	$v1,	$s7

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
#				part 6				      #
#######################################################################
check_horizontal_capture:

addi	$sp,	$sp,	-60
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t0,	32($sp)
sw	$t1,	36($sp)
sw	$t2,	40($sp)
sw	$t3,	44($sp)
sw	$t8,	48($sp)
sw	$t9,	52($sp)
sw	$ra,	56($sp)

move	$s0,	$a0	# board
move	$t9,	$a0	# extra copy of board
move	$s1,	$a1	# row
move	$s2,	$a2	# column
move	$s3,	$a3	# player


li	$t1,	0	# final number of captures

lw	$s4,	0($s0)	# total rows
addi	$t2,	$s4,	-1
lw	$s5,	4($s0)	# total coloms
addi	$t3,	$s5,	-1
addi	$s0,	$s0,	8

bltz	$s1,	part_six_failed
bgt	$s1,	$t2,	part_six_failed
bltz	$s2,	part_six_failed
bgt	$s2,	$t3,	part_six_failed

addi	$sp,	$sp,	-48
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$t1,	24($sp)
sw	$t2,	28($sp)
sw	$t3,	32($sp)
sw	$t9,	36($sp)
sw	$t8,	40($sp)
sw	$ra,	44($sp)

jal	get_slot

lw	$ra,	44($sp)
lw	$t8,	40($sp)
lw	$t9,	36($sp)
lw	$t3,	32($sp)
lw	$t2,	28($sp)
lw	$t1,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	48

li	$t3,	1			# helper in set call
li	$t4,	2

move	$t0,	$v0
beq	$t0,	$s3,	move_ahead_part_six
#j	done_with_part_six		# this was changed to following statem
j	part_six_failed

move_ahead_part_six:
beqz	$s1,	simplyAddandchange_part_six

mul	$s6,	$s1,	$s5
add	$s7,	$s6,	$s5
add	$s7,	$s0,	$s7			# this the last right side slot in the current row..... just make sure it doesnt go 1 position ahead.
add	$t8,	$s0,	$s6			# first slot of whatver row we are in.
add	$s6,	$s2,	$s6
add	$s0,	$s0,	$s6
move	$t6,	$s0
j	skip_simplyAddandchange_part_six

simplyAddandchange_part_six:
move	$t8,	$s0				# first slot of the first row
add	$s0,	$s0,	$s2
add	$s7,	$s0,	$s5			# when we are first row, to get to last slot addo s) plus total no. of column.
move	$t6,	$s0

skip_simplyAddandchange_part_six:				####### for right side ############
addi	$t0,	$s0,	3	# mving 3 ahead to check for captures
lbu	$t5,	0($t0)

bgt	$t0,	$s7,	check_for_left_side		# this is check if the last slot of the row is passed or not , while looping.
beq	$t5,	$s3,	check_for_in_between_values
j	check_for_left_side

skip_simplyAddandchange_part_six_for_left_side:			####### for left side ############

addi	$t0,	$s0,	-3	# mving 3 ahead to check for captures
lbu	$t5,	0($t0)

blt	$t0,	$t8,	done_with_part_six		# this is check if the last slot of the row is passed or not , while looping.
beq	$t5,	$s3,	check_for_in_between_values
j	done_with_part_six

check_for_in_between_values:

beq	$t5,	'X',	check_for_O_inbetween
beq	$t5,	'O',	check_for_X_inbetween

check_for_O_inbetween:
add	$t2,	$s0,	$t3	####

lbu	$t2,	0($t2)
beq	$t2,	'O',	go_ahead_check_next
j	check_for_left_side

go_ahead_check_next:
add	$t2,	$s0,	$t4	####
lbu	$t2,	0($t2)

beq	$t2,	'O',	match_found_O
j	check_for_left_side

match_found_O:
addi	$t1,	$t1,	2

addi	$sp,	$sp,	-28
sw	$s7,	0($sp)
sw	$t0,	4($sp)
sw	$t1,	8($sp)
sw	$t9,	12($sp)
sw	$t8,	16($sp)
sw	$t6,	20($sp)
sw	$ra,	24($sp)		# assuming the rest value are already being pushed on stack in set slot part

move	$a0,	$t9
move	$a1,	$s1	# first capture replaced
sub	$a2,	$s0,	$t8	####
add	$a2,	$a2,	$t3
li	$a3,	'.'

jal	set_slot
# idk what to do with the returned value

lw	$ra,	24($sp)
lw	$t6,	20($sp)
lw	$t8,	16($sp)
lw	$t9,	12($sp)
lw	$t1,	8($sp)
lw	$t0,	4($sp)
lw	$s7,	0($sp)
addi	$sp,	$sp,	28

addi	$sp,	$sp,	-28
sw	$s7,	0($sp)
sw	$t0,	4($sp)
sw	$t1,	8($sp)
sw	$t9,	12($sp)
sw	$t8,	16($sp)
sw	$t6,	20($sp)
sw	$ra,	24($sp)		# assuming the rest value are already being pushed on stack in set slot part

move	$a0,	$t9
move	$a1,	$s1	# second capture replaced.
sub	$a2,	$s0,	$t8	####
add	$a2,	$a2,	$t4
li	$a3,	'.'

jal	set_slot
# idk what to do with the returned value

lw	$ra,	24($sp)
lw	$t6,	20($sp)
lw	$t8,	16($sp)
lw	$t9,	12($sp)
lw	$t1,	8($sp)
lw	$t0,	4($sp)
lw	$s7,	0($sp)
addi	$sp,	$sp,	28

bgt	$t0,	$s0,	keep_on_right_side
move	$s0,	$t0
j	skip_simplyAddandchange_part_six_for_left_side

keep_on_right_side:
move	$s0,	$t0
j	skip_simplyAddandchange_part_six


check_for_X_inbetween:
add	$t2,	$s0,	$t3	####
lbu	$t2,	0($t2)
beq	$t2,	'X',	go_ahead_check_next_X
j	check_for_left_side

go_ahead_check_next_X:
add	$t2,	$s0,	$t4	####
lbu	$t2,	0($t2)
beq	$t2,	'X',	match_found_X
j	check_for_left_side

match_found_X:
addi	$t1,	$t1,	2

addi	$sp,	$sp,	-28
sw	$s7,	0($sp)
sw	$t0,	4($sp)
sw	$t1,	8($sp)
sw	$t9,	12($sp)
sw	$t8,	16($sp)
sw	$t6,	20($sp)
sw	$ra,	24($sp)		# assuming the rest value are already being pushed on stack in set slot part

move	$a0,	$t9
move	$a1,	$s1	# first capture replaced
sub	$a2,	$s0,	$t8	####
add	$a2,	$a2,	$t3
li	$t5,	'.'
move	$a3,	$t5

jal	set_slot
# idk what to do with the returned value

lw	$ra,	24($sp)
lw	$t6,	20($sp)
lw	$t8,	16($sp)
lw	$t9,	12($sp)
lw	$t1,	8($sp)
lw	$t0,	4($sp)
lw	$s7,	0($sp)
addi	$sp,	$sp,	28

addi	$sp,	$sp,	-28
sw	$s7,	0($sp)
sw	$t0,	4($sp)
sw	$t1,	8($sp)
sw	$t9,	12($sp)
sw	$t8,	16($sp)
sw	$t6,	20($sp)
sw	$ra,	24($sp)		# assuming the rest value are already being pushed on stack in set slot part

move	$a0,	$t9
move	$a1,	$s1	# second capture replaced.
sub	$a2,	$s0,	$t8	####
add	$a2,	$a2,	$t4
li	$a3,	'.'

jal	set_slot
# idk what to do with the returned value

lw	$ra,	24($sp)
lw	$t6,	20($sp)
lw	$t8,	16($sp)
lw	$t9,	12($sp)
lw	$t1,	8($sp)
lw	$t0,	4($sp)
lw	$s7,	0($sp)
addi	$sp,	$sp,	28

blt	$t0,	$s0,	keep_on_left_side
move	$s0,	$t0
j	skip_simplyAddandchange_part_six

keep_on_left_side:
move	$s0,	$t0
j	skip_simplyAddandchange_part_six_for_left_side

check_for_left_side:
move	$s0,	$t6
li	$t3,	-1			# helper in set call
li	$t4,	-2
j	skip_simplyAddandchange_part_six_for_left_side

done_with_part_six:
move	$v0,	$t1
j	pull_from_stack_part_six

part_six_failed:
li	$v0,	-1

pull_from_stack_part_six:
lw	$ra,	56($sp)
lw	$t9,	52($sp)
lw	$t8,	48($sp)
lw	$t3,	44($sp)
lw	$t2,	40($sp)
lw	$t1,	36($sp)
lw	$t0,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

addi	$sp,	$sp,	60

jr	$ra


#######################################################################
#				part 7				      #
#######################################################################
check_vertical_capture:


addi	$sp,	$sp,	-60
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t0,	32($sp)
sw	$t1,	36($sp)
sw	$t2,	40($sp)
sw	$t3,	44($sp)
sw	$t8,	48($sp)
sw	$t9,	52($sp)
sw	$ra,	56($sp)

move	$s0,	$a0	# board
move	$t9,	$a0	# extra copy of board
move	$s1,	$a1	# row
move	$s2,	$a2	# column
move	$s3,	$a3	# player

li	$t1,	0	# final number of captures

lw	$s4,	0($s0)	# total rows
addi	$t2,	$s4,	-1
lw	$s5,	4($s0)	# total coloms
addi	$t3,	$s5,	-1
addi	$s0,	$s0,	8

bltz	$s1,	part_seven_failed
bgt	$s1,	$t2,	part_seven_failed
bltz	$s2,	part_seven_failed
bgt	$s2,	$t3,	part_seven_failed

addi	$sp,	$sp,	-48
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$t1,	24($sp)
sw	$t2,	28($sp)
sw	$t3,	32($sp)
sw	$t9,	36($sp)
sw	$t8,	40($sp)
sw	$ra,	44($sp)

jal	get_slot

lw	$ra,	44($sp)
lw	$t8,	40($sp)
lw	$t9,	36($sp)
lw	$t3,	32($sp)
lw	$t2,	28($sp)
lw	$t1,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	48

addi	$t4,  	$s1,	2	# number of colomns by 2
addi	$t3,	$s1,	1	# helper in set call

move	$t0,	$v0
beq	$t0,	$s3,	move_ahead_part_seven

j	part_seven_failed

move_ahead_part_seven:
beqz	$s1,	simplyAddandchange_part_seven
add	$t8,	$s0,	$s2		# this should be first value in the current colomn.

mul	$s6,	$s1,	$s5
add	$s6,	$s2,	$s6
add	$s0,	$s0,	$s6
move	$t6,	$s0			# current value of s0, where we land first.

sub	$s7,	$s4,	$s1
mul	$s7,	$s5,	$s7
add	$s7,	$s0,	$s7		# ( s0 + {s4 - s1)*s5}) last values in that column.
sub	$s7,	$s7,	$s5

j	skip_simplyAddandchange_part_seven

simplyAddandchange_part_seven:
add	$t8,	$s0,	$s2		# this should be first value in the current colomn.
add	$s0,	$s0,	$s2
mul	$s7,	$s5,	$s4
add	$s7,	$s0,	$s7
sub	$s7,	$s7,	$s5

skip_simplyAddandchange_part_seven:				####### for right side ############
li 	$t0,	3
mul	$t0,	$s5,	$t0
add	$t0,	$s0,	$t0	# mving 3 ahead to check for captures
lbu	$t5,	0($t0)

bgt	$t0,	$s7,	check_for_left_side_part_seven		# this is check if the last slot of the row is passed or not , while looping.
beq	$t5,	$s3,	check_for_in_between_values_part_seven
j	check_for_left_side_part_seven

skip_simplyAddandchange_part_seven_for_left_side:			####### for left side ############

li  	$t0,  	3
mul 	$t0,  	$s5,  $t0
add	$t0,	$s0,	$t0	# mving 3 ahead to check for captures
lbu	$t5,	0($t0)

blt	$t0,	$t8,	done_with_part_seven		# this is check if the last slot of the row is passed or not , while looping.
beq	$t5,	$s3,	check_for_in_between_values_part_seven
j	done_with_part_seven

check_for_in_between_values_part_seven:

beq	$t5,	'X',	check_for_O_inbetween_part_seven
beq	$t5,	'O',	check_for_X_inbetween_part_seven

check_for_O_inbetween_part_seven:
add	$t2,	$s0,	$s5	####
lbu	$t2,	0($t2)
beq	$t2,	'O',	go_ahead_check_next_part_seven
j	check_for_left_side_part_seven

go_ahead_check_next_part_seven:
add	$t2,	$s0,	$s5	####
add	$t2,	$t2,	$s5	####
lbu	$t2,	0($t2)
beq	$t2,	'O',	match_found_O_part_seven
j	check_for_left_side_part_seven

match_found_O_part_seven:
addi	$t1,	$t1,	2

addi	$sp,	$sp,	-28
sw	$s7,	0($sp)
sw	$t0,	4($sp)
sw	$t1,	8($sp)
sw	$t9,	12($sp)
sw	$t8,	16($sp)
sw	$t6,	20($sp)
sw	$ra,	24($sp)		# assuming the rest value are already being pushed on stack in set slot part

move	$a0,	$t9
move	$a1,	$t3		# first capture replaced
move	$a2,	$s2	####
li	$a3,	'.'

jal	set_slot
# idk what to do with the returned value

lw	$ra,	24($sp)
lw	$t6,	20($sp)
lw	$t8,	16($sp)
lw	$t9,	12($sp)
lw	$t1,	8($sp)
lw	$t0,	4($sp)
lw	$s7,	0($sp)
addi	$sp,	$sp,	28

addi	$sp,	$sp,	-28
sw	$s7,	0($sp)
sw	$t0,	4($sp)
sw	$t1,	8($sp)
sw	$t9,	12($sp)
sw	$t8,	16($sp)
sw	$t6,	20($sp)
sw	$ra,	24($sp)		# assuming the rest value are already being pushed on stack in set slot part

move	$a0,	$t9
move	$a1,	$t4	# first capture replaced
move	$a2,	$s2	####
li	$a3,	'.'

jal	set_slot
# idk what to do with the returned value

lw	$ra,	24($sp)
lw	$t6,	20($sp)
lw	$t8,	16($sp)
lw	$t9,	12($sp)
lw	$t1,	8($sp)
lw	$t0,	4($sp)
lw	$s7,	0($sp)
addi	$sp,	$sp,	28

bgt	$t0,	$s0,	keep_on_right_side_part_seven
move	$s0,	$t0

addi	$t3,	$t3,	-3
addi	$t4,	$t4,	-3

j	skip_simplyAddandchange_part_seven_for_left_side

keep_on_right_side_part_seven:
move	$s0,	$t0
addi	$t3,	$t3,	3
addi	$t4,	$t4,	3
j	skip_simplyAddandchange_part_seven

###########################################################################################################################################################
check_for_X_inbetween_part_seven:
add	$t2,	$s0,	$s5	####
lbu	$t2,	0($t2)

beq	$t2,	'X',	go_ahead_check_next_part_seven_X
j	check_for_left_side_part_seven

go_ahead_check_next_part_seven_X:
add	$t2,	$s0,	$s5	####
add	$t2,	$t2,	$s5	####
lbu	$t2,	0($t2)
beq	$t2,	'X',	match_found_X_1
j	check_for_left_side_part_seven

match_found_X_1:
addi	$t1,	$t1,	2

addi	$sp,	$sp,	-28
sw	$s7,	0($sp)
sw	$t0,	4($sp)
sw	$t1,	8($sp)
sw	$t9,	12($sp)
sw	$t8,	16($sp)
sw	$t6,	20($sp)
sw	$ra,	24($sp)		# assuming the rest value are already being pushed on stack in set slot part

move	$a0,	$t9
move	$a1,	$t3	# first capture replaced
move	$a2,	$s2	####
li	$t5,	'.'
move	$a3,	$t5

jal	set_slot
# idk what to do with the returned value

lw	$ra,	24($sp)
lw	$t6,	20($sp)
lw	$t8,	16($sp)
lw	$t9,	12($sp)
lw	$t1,	8($sp)
lw	$t0,	4($sp)
lw	$s7,	0($sp)
addi	$sp,	$sp,	28

addi	$sp,	$sp,	-28
sw	$s7,	0($sp)
sw	$t0,	4($sp)
sw	$t1,	8($sp)
sw	$t9,	12($sp)
sw	$t8,	16($sp)
sw	$t6,	20($sp)
sw	$ra,	24($sp)		# assuming the rest value are already being pushed on stack in set slot part

move	$a0,	$t9
move	$a1,	$t4	# second capture replaced.
move	$a2,	$s2	####
li	$a3,	'.'

jal	set_slot
# idk what to do with the returned value

lw	$ra,	24($sp)
lw	$t6,	20($sp)
lw	$t8,	16($sp)
lw	$t9,	12($sp)
lw	$t1,	8($sp)
lw	$t0,	4($sp)
lw	$s7,	0($sp)
addi	$sp,	$sp,	28

blt	$t0,	$s0,	keep_on_left_side_part_seven
move	$s0,	$t0
addi	$t3,	$t3,	3
addi	$t4,	$t4,	3
j	skip_simplyAddandchange_part_seven

keep_on_left_side_part_seven:
move	$s0,	$t0
addi	$t3,	$t3,	-3
addi	$t4,	$t4,	-3
j	skip_simplyAddandchange_part_seven_for_left_side

check_for_left_side_part_seven:
move	$s0,	$t6

addi	$t4,  	$s1,	-2	# number of colomns by 2
addi	$t3,	$s1,	-1	# helper in set call

sub	$t2,	$s5,	$s5
sub	$s5,	$t2,	$s5
#j	done_with_part_seven
j	skip_simplyAddandchange_part_seven_for_left_side

done_with_part_seven:
move	$v0,	$t1
j	pull_from_stack_part_seven

part_seven_failed:
li	$v0,	-1

pull_from_stack_part_seven:
lw	$ra,	56($sp)
lw	$t9,	52($sp)
lw	$t8,	48($sp)
lw	$t3,	44($sp)
lw	$t2,	40($sp)
lw	$t1,	36($sp)
lw	$t0,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

addi	$sp,	$sp,	60

jr	$ra

#######################################################################
#				part 8				      #
#######################################################################

check_diagonal_capture:


addi	$sp,	$sp,	-60
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t0,	32($sp)
sw	$t1,	36($sp)
sw	$t2,	40($sp)
sw	$t3,	44($sp)
sw	$t8,	48($sp)
sw	$t9,	52($sp)
sw	$ra,	56($sp)

move	$s0,	$a0	# board
move	$t9,	$a0	# extra copy of board
move	$s1,	$a1	# row
move	$s2,	$a2	# column
move	$s3,	$a3	# player


li	$t1,	0	# final number of captures

lw	$s4,	0($s0)	# total rows
addi	$t2,	$s4,	-1
lw	$s5,	4($s0)	# total coloms
addi	$t3,	$s5,	-1
addi	$s0,	$s0,	8

bltz	$s1,	part_eight_failed
bgt	$s1,	$t2,	part_eight_failed
bltz	$s2,	part_eight_failed
bgt	$s2,	$t3,	part_eight_failed

addi	$sp,	$sp,	-48
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$t1,	24($sp)
sw	$t2,	28($sp)
sw	$t3,	32($sp)
sw	$t9,	36($sp)
sw	$t8,	40($sp)
sw	$ra,	44($sp)

jal	get_slot

lw	$ra,	44($sp)
lw	$t8,	40($sp)
lw	$t9,	36($sp)
lw	$t3,	32($sp)
lw	$t2,	28($sp)
lw	$t1,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	48

li	$t4,  	2
li	$t3,	1	# helper in set call

move	$t0,	$v0
beq	$t0,	$s3,	move_ahead_part_eight

j	part_eight_failed


move_ahead_part_eight:

beqz	$s1,	simplyAddandchange_part_eight
#addi	$t8,	$s1,
#add	$t8,	$s0,	$t8		# this should be first value in the current colomn.
move	$t8,	$s0

mul	$s6,	$s1,	$s5
add	$s6,	$s2,	$s6
add	$s0,	$s0,	$s6
move	$t6,	$s0			# current value of s0, where we land first.

#sub	$s7,	$s5,	$s2		# totlal number of colomns left to cover.
#mul	$s7,	$s5,	$s7
#add	$s7,	$s0,	$s7
#sub	$s7,	$s7,	$s5
j	skiippppppppp

simplyAddandchange_part_eight:
#add	$t8,	$s0,	$zero		# same as s0 as they are in first row

add	$s0,	$s0,	$s2

#sub	$s7,	$s5,	$s2		# totlal number of colomns left to cover.
#mul	$s7,	$s5,	$s7
#add	$s7,	$s0,	$s7
#sub	$s7,	$s7,	$s5

# above is working (assumption)

#mul	$s7,	$s5,	$s2
#add	$s7,	$s0,	$s7
#sub	$s7,	$s7,	$s5


skiippppppppp:

addi	$sp,	$sp,	-8		# saving s1 and s2 value on stakc
sw	$s1,	0($sp)
sw	$s2,	4($sp)

addi	$s1,	$s1,	3
addi	$s2,	$s2,	3
li	$t5,	0
bge	$s2,	$s5,	no_right_side_to_check
bge	$s1,	$s4,	no_right_side_to_check

mul	$s6,	$s1,	$s5
add	$s6,	$s2,	$s6
add	$t5,	$s0,	$s6		#t5,	will have final right side diagnol value to check

no_right_side_to_check:
addi	$s1,	$s1,	-6
addi	$s2,	$s2,	-6

bge	$s2,	$s5,	no_left_side_to_check
bge	$s1,	$s4,	no_left_side_to_check

after_one_left_capture:
mul	$s6,	$s1,	$s5
add	$s6,	$s2,	$s6
add	$s6,	$t8,	$s6		#s6,	will have final left side diagnol value to check
lw	$s2,	4($sp)
lw	$s1,	0($sp)
addi	$sp,	$sp,	8
j	skip_simplyAddandchange_part_eight

no_left_side_to_check:

lw	$s2,	4($sp)
lw	$s1,	0($sp)
addi	$sp,	$sp,	8		# pulling s1 ans s2 old values.
j	done_with_part_eight		# if no left and right are present



skip_simplyAddandchange_part_eight:				####### for right side ############
#li 	$t0,	3
#mul	$t0,	$s5,	$t0
#add	$t0,	$s0,	$t0	# mving 3 ahead to check for captures
move	$t0,	$t5

beqz	$t5,	check_for_left_side_part_eight
lbu	$t5,	0($t5)

#bgt	$t0,	$s7,	check_for_left_side_part_eight		# this is check if the last slot of the row is passed or not , while looping.
beq	$t5,	$s3,	check_for_in_between_values_part_eight
j	check_for_left_side_part_eight

skip_simplyAddandchange_part_eight_for_left_side:			####### for left side ############
move	$t0,	$s6
#li  	$t0,  	3
#mul 	$t0,  	$s5,  $t0
#add	$t0,	$s0,	$t0	# mving 3 ahead to check for captures
lbu	$t5,	0($s6)

#blt	$t0,	$t8,	done_with_part_eight		# this is check if the last slot of the row is passed or not , while looping.
beq	$t5,	$s3,	check_for_in_between_values_part_eight
j	done_with_part_eight

check_for_in_between_values_part_eight:

beq	$t5,	'X',	check_for_O_inbetween_part_eight
beq	$t5,	'O',	check_for_X_inbetween_part_eight

check_for_O_inbetween_part_eight:
add	$t2,	$s0,	$s5	####
add	$t2,	$t2,	$t3
lbu	$t2,	0($t2)
beq	$t2,	'O',	go_ahead_check_next_part_eight
j	check_for_left_side_part_eight

go_ahead_check_next_part_eight:
add	$t2,	$s0,	$s5	####
add	$t2,	$t2,	$s5	####
add	$t2,	$t2,	$t4
lbu	$t2,	0($t2)
beq	$t2,	'O',	match_found_O_part_eight
j	check_for_left_side_part_eight

match_found_O_part_eight:
addi	$t1,	$t1,	2

addi	$sp,	$sp,	-28
sw	$s7,	0($sp)
sw	$t0,	4($sp)
sw	$t1,	8($sp)
sw	$t9,	12($sp)
sw	$t8,	16($sp)
sw	$t6,	20($sp)
sw	$ra,	24($sp)		# assuming the rest value are already being pushed on stack in set slot part

move	$a0,	$t9
add	$a1,	$s1,	$t3		# first capture replaced
add	$a2,	$s2,	$t3
li	$a3,	'.'

jal	set_slot
# idk what to do with the returned value

lw	$ra,	24($sp)
lw	$t6,	20($sp)
lw	$t8,	16($sp)
lw	$t9,	12($sp)
lw	$t1,	8($sp)
lw	$t0,	4($sp)
lw	$s7,	0($sp)
addi	$sp,	$sp,	28

addi	$sp,	$sp,	-28
sw	$s7,	0($sp)
sw	$t0,	4($sp)
sw	$t1,	8($sp)
sw	$t9,	12($sp)
sw	$t8,	16($sp)
sw	$t6,	20($sp)
sw	$ra,	24($sp)		# assuming the rest value are already being pushed on stack in set slot part

move	$a0,	$t9
add	$a1,	$s1,	$t4		# first capture replaced
add	$a2,	$s2,	$t4	####
li	$a3,	'.'

jal	set_slot
# idk what to do with the returned value

lw	$ra,	24($sp)
lw	$t6,	20($sp)
lw	$t8,	16($sp)
lw	$t9,	12($sp)
lw	$t1,	8($sp)
lw	$t0,	4($sp)
lw	$s7,	0($sp)
addi	$sp,	$sp,	28

bgt	$t0,	$s0,	keep_on_right_side_part_eight
move	$s0,	$t0

li	$t3,	-1
li	$t4,	-2


addi	$sp,	$sp,	-8		# saving s1 and s2 value on stakc
sw	$s1,	0($sp)
sw	$s2,	4($sp)

addi	$s1,	$s1,	-3
addi	$s2,	$s2,	-3

move	$t0,	$s6

beqz	$s1,	pullandleaveL	# just to get out of loop

mul	$s6,	$s1,	$s5
add	$s6,	$s2,	$s6
add	$s6,	$t8,	$s6		#s6,	will have final left side diagnol value to check
lw	$s2,	4($sp)
lw	$s1,	0($sp)
addi	$sp,	$sp,	8

j	skip_simplyAddandchange_part_eight_for_left_side

pullandleaveL:

lw	$s2,	4($sp)
lw	$s1,	0($sp)
addi	$sp,	$sp,	8
j	done_with_part_eight

keep_on_right_side_part_eight:
move	$s0,	$t0

j	skip_simplyAddandchange_part_eight

###########################################################################################################################################################
check_for_X_inbetween_part_eight:
add	$t2,	$s0,	$s5	####
add	$t2,	$t2,	$t3
lbu	$t2,	0($t2)

beq	$t2,	'X',	go_ahead_check_next_part_eight_X
j	check_for_left_side_part_eight

go_ahead_check_next_part_eight_X:
add	$t2,	$s0,	$s5	####
add	$t2,	$t2,	$s5	####
add	$t2,	$t2,	$t4
lbu	$t2,	0($t2)
beq	$t2,	'X',	match_found_X_part_eight
j	check_for_left_side_part_eight

match_found_X_part_eight:
addi	$t1,	$t1,	2

addi	$sp,	$sp,	-28
sw	$s7,	0($sp)
sw	$t0,	4($sp)
sw	$t1,	8($sp)
sw	$t9,	12($sp)
sw	$t8,	16($sp)
sw	$t6,	20($sp)
sw	$ra,	24($sp)		# assuming the rest value are already being pushed on stack in set slot part

move	$a0,	$t9
add	$a1,	$s1,	$t3		# first capture replaced
add	$a2,	$s2,	$t3
li	$t5,	'.'
move	$a3,	$t5

jal	set_slot
# idk what to do with the returned value

lw	$ra,	24($sp)
lw	$t6,	20($sp)
lw	$t8,	16($sp)
lw	$t9,	12($sp)
lw	$t1,	8($sp)
lw	$t0,	4($sp)
lw	$s7,	0($sp)
addi	$sp,	$sp,	28

addi	$sp,	$sp,	-28
sw	$s7,	0($sp)
sw	$t0,	4($sp)
sw	$t1,	8($sp)
sw	$t9,	12($sp)
sw	$t8,	16($sp)
sw	$t6,	20($sp)
sw	$ra,	24($sp)		# assuming the rest value are already being pushed on stack in set slot part

move	$a0,	$t9
add	$a1,	$s1,	$t4		# first capture replaced
add	$a2,	$s2,	$t4
li	$a3,	'.'

jal	set_slot
# idk what to do with the returned value

lw	$ra,	24($sp)
lw	$t6,	20($sp)
lw	$t8,	16($sp)
lw	$t9,	12($sp)
lw	$t1,	8($sp)
lw	$t0,	4($sp)
lw	$s7,	0($sp)
addi	$sp,	$sp,	28

blt	$t0,	$s0,	keep_on_left_side_part_eight
move	$s0,	$t0

addi	$t3,	$t3,	3
addi	$t4,	$t4,	3
j	skip_simplyAddandchange_part_eight

keep_on_left_side_part_eight:
move	$s0,	$t0

li	$t3,	-1
li	$t4,	-2

addi	$sp,	$sp,	-8		# saving s1 and s2 value on stakc
sw	$s1,	0($sp)
sw	$s2,	4($sp)

addi	$s1,	$s1,	-3
addi	$s2,	$s2,	-3

beqz	$s1,	pullandleaveL

mul	$s6,	$s1,	$s5
add	$s6,	$s2,	$s6
add	$s6,	$t8,	$s6		#s6,	will have final left side diagnol value to check
lw	$s2,	4($sp)
lw	$s1,	0($sp)
addi	$sp,	$sp,	8
j	skip_simplyAddandchange_part_eight_for_left_side

check_for_left_side_part_eight:
move	$s0,	$t6

li	$t3,	-1
li	$t4,	-2

sub	$t2,	$s5,	$s5
sub	$s5,	$t2,	$s5

j	skip_simplyAddandchange_part_eight_for_left_side

done_with_part_eight:
move	$v0,	$t1
j	pull_from_stack_part_eight

part_eight_failed:
li	$v0,	-1

pull_from_stack_part_eight:
lw	$ra,	56($sp)
lw	$t9,	52($sp)
lw	$t8,	48($sp)
lw	$t3,	44($sp)
lw	$t2,	40($sp)
lw	$t1,	36($sp)
lw	$t0,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

addi	$sp,	$sp,	60

jr	$ra


#######################################################################
#				part 9				      #
#######################################################################
check_horizontal_winner:

addi	$sp,	$sp,	-60
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s3,	8($sp)
sw	$s4,	12($sp)
sw	$s5,	16($sp)
sw	$t0,	20($sp)
sw	$t1,	24($sp)
sw	$t2,	28($sp)
sw	$t3,	32($sp)
sw	$t8,	36($sp)
sw	$t9,	40($sp)
sw	$t4,	44($sp)
sw	$s7,	48($sp)
sw	$s6,	52($sp)
sw	$ra,	56($sp)

move	$s0,	$a0	# board
move	$t9,	$a0	# extra copy of board
move	$s3,	$a1	# player
move	$t8,	$a1	# extra copy


bne	$s3,	88,	check_for_O
j	skippp
check_for_O:
bne	$s3,	79	return_negative
skippp:
li	$t1,	0	# final number of captures
li	$t0,	0

lw	$s4,	0($s0)	# total rows
addi	$s7,	$s4,	-1
lw	$s5,	4($s0)	# total coloms
addi	$s6,	$s5,	-1

blt	$s5,	5,	return_negative

addi	$s0,	$s0,	8

bltz	$s7,	return_negative
bltz	$s6,	return_negative

li	$t3,	0
li	$t4,	0

main_loop:

addi	$sp,	$sp,	-60
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s3,	8($sp)
sw	$s4,	12($sp)
sw	$s5,	16($sp)
sw	$t0,	20($sp)
sw	$t1,	24($sp)
sw	$t2,	28($sp)
sw	$t3,	32($sp)
sw	$t8,	36($sp)
sw	$t9,	40($sp)
sw	$t4,	44($sp)
sw	$s7,	48($sp)
sw	$s6,	52($sp)
sw	$ra,	56($sp)

move	$a0,	$t9
move	$a1,	$t3	# current row
move	$a2,	$t4	# current column
move	$a3,	$t8	# initial a1 value
jal	get_slot

lw	$ra,	56($sp)
lw	$s6,	52($sp)
lw	$s7,	48($sp)
lw	$t4,	44($sp)
lw	$t9,	40($sp)
lw	$t8,	36($sp)
lw	$t3,	32($sp)
lw	$t2,	28($sp)
lw	$t1,	24($sp)
lw	$t0,	20($sp)
lw	$s5,	16($sp)
lw	$s4,	12($sp)
lw	$s3,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

addi	$sp,	$sp,	60

move	$t0,	$v0
beq	$t0,	$s3,	increment_count

li	$t1,	0
j	increment_colomn

increment_count:
addi	$t1,	$t1,	1
beq	$t1,	5,	done_with_part_ninth

increment_colomn:
addi	$t4,	$t4,	1

beq	$t4,	$s5,	move_to_next_row
j	main_loop

move_to_next_row:
addi	$t3,	$t3,	1
beq	$t3,	$s4,	check_for_colomn_number
li	$t4,	0
li	$t1,	0
j	main_loop

check_for_colomn_number:
beq	$t4,	$s5,	return_negative

j	main_loop

done_with_part_ninth:

move	$v0,	$t3
addi	$v1,	$t4,	-4
j	pull_from_stack_part_ninth

return_negative:
li	$v0,	-1
li	$v1,	-1

pull_from_stack_part_ninth:

lw	$ra,	56($sp)
lw	$s6,	52($sp)
lw	$s7,	48($sp)
lw	$t4,	44($sp)
lw	$t9,	40($sp)
lw	$t8,	36($sp)
lw	$t3,	32($sp)
lw	$t2,	28($sp)
lw	$t1,	24($sp)
lw	$t0,	20($sp)
lw	$s5,	16($sp)
lw	$s4,	12($sp)
lw	$s3,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

addi	$sp,	$sp,	60
jr	$ra

#######################################################################
#				part 10				      #
#######################################################################
check_vertical_winner:

addi	$sp,	$sp,	-60
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s3,	8($sp)
sw	$s4,	12($sp)
sw	$s5,	16($sp)
sw	$t0,	20($sp)
sw	$t1,	24($sp)
sw	$t2,	28($sp)
sw	$t3,	32($sp)
sw	$t8,	36($sp)
sw	$t9,	40($sp)
sw	$t4,	44($sp)
sw	$s7,	48($sp)
sw	$s6,	52($sp)
sw	$ra,	56($sp)

move	$s0,	$a0	# board
move	$t9,	$a0	# extra copy of board

move	$s3,	$a1	# player
move	$t8,	$a1	# extra copy


bne	$s3,	88,	check_for_O_part_tenth
j	skippp_1
check_for_O_part_tenth:
bne	$s3,	79	part_tenth_failed
skippp_1:
li	$t1,	0	# final number of captures
li	$t0,	0

lw	$s4,	0($s0)	# total rows
addi	$s7,	$s4,	-1
lw	$s5,	4($s0)	# total coloms
addi	$s6,	$s5,	-1
blt	$s5,	5,	part_tenth_failed

addi	$s0,	$s0,	8

bltz	$s7,	part_tenth_failed
bltz	$s6,	part_tenth_failed

li	$t3,	0
li	$t4,	0

main_loop_part_tenth:

addi	$sp,	$sp,	-60
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s3,	8($sp)
sw	$s4,	12($sp)
sw	$s5,	16($sp)
sw	$t0,	20($sp)
sw	$t1,	24($sp)
sw	$t2,	28($sp)
sw	$t3,	32($sp)
sw	$t8,	36($sp)
sw	$t9,	40($sp)
sw	$t4,	44($sp)
sw	$s7,	48($sp)
sw	$s6,	52($sp)
sw	$ra,	56($sp)

move	$a0,	$t9
move	$a1,	$t3	# current row
move	$a2,	$t4	# current column
move	$a3,	$t8	# initial a1 value
jal	get_slot

lw	$ra,	56($sp)
lw	$s6,	52($sp)
lw	$s7,	48($sp)
lw	$t4,	44($sp)
lw	$t9,	40($sp)
lw	$t8,	36($sp)
lw	$t3,	32($sp)
lw	$t2,	28($sp)
lw	$t1,	24($sp)
lw	$t0,	20($sp)
lw	$s5,	16($sp)
lw	$s4,	12($sp)
lw	$s3,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

addi	$sp,	$sp,	60

move	$t0,	$v0
beq	$t0,	$s3,	increment_count_part_tenth

li	$t1,	0
j	increment_colomn_part_tenth

increment_count_part_tenth:
addi	$t1,	$t1,	1
beq	$t1,	5,	done_with_part_tenth

increment_colomn_part_tenth:
addi	$t3,	$t3,	1
beq	$t3,	$s4,	move_to_next_col_part_tenth
j	main_loop_part_tenth

move_to_next_col_part_tenth:
addi	$t4,	$t4,	1
beq	$t4,	$s5,	check_for_colomn_number_part_tenth
li	$t3,	0

li	$t1,	0
j	main_loop_part_tenth

check_for_colomn_number_part_tenth:
beq	$t4,	$s5,	part_tenth_failed

j	main_loop_part_tenth

done_with_part_tenth:

move	$v1,	$t4
addi	$v0,	$t3,	-4
j	pull_from_stack_part_tenth

part_tenth_failed:
li	$v0,	-1
li	$v1,	-1

pull_from_stack_part_tenth:

lw	$ra,	56($sp)
lw	$s6,	52($sp)
lw	$s7,	48($sp)
lw	$t4,	44($sp)
lw	$t9,	40($sp)
lw	$t8,	36($sp)
lw	$t3,	32($sp)
lw	$t2,	28($sp)
lw	$t1,	24($sp)
lw	$t0,	20($sp)
lw	$s5,	16($sp)
lw	$s4,	12($sp)
lw	$s3,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

addi	$sp,	$sp,	60
jr	$ra

#######################################################################
#				part 11				      #
#######################################################################
check_sw_ne_diagonal_winner:

addi	$sp,	$sp,	-76
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t0,	32($sp)
sw	$t1,	36($sp)
sw	$t9,	40($sp)
sw	$t8,	44($sp)
sw	$t6,	48($sp)
sw	$t5,	52($sp)
sw	$t3,	56($sp)
sw	$t4,	60($sp)
sw	$t2,	64($sp)
sw	$t7,	68($sp)
sw	$ra,	72($sp)

move	$s0,	$a0	# board

move	$s3,	$a1	# player
move	$t8,	$a1	# extra copy


bne	$s3,	88,	check_for_O_part_eleven
j	skippp_1_1
check_for_O_part_eleven:
bne	$s3,	79	part_eleven_failed
skippp_1_1:
li	$t1,	0	# final number of captures
li	$t0,	0

lw	$s4,	0($s0)	# total rows
lw	$s2,	0($s0)	# total rows
lw	$t9,	4($s0)	# total coloms
addi	$s7,	$s4,	-1
addi	$s6,	$t9,	-1
#blt	$s5,	5,	part_eleven_failed

#addi	$s0,	$s0,	8

bltz	$s7,	part_eleven_failed
bltz	$s6,	part_eleven_failed

li	$t5,	2
li	$t6,	1
li	$t1,	0
li	$s5,	0
li	$t2,	0
li	$t7,	0

div	$t9,	$t5
mflo	$t3		# half od columns


div	$s4,	$t5
mflo	$t4		# half of rows

#blt	$t3,	5,	part_eleven_failed
#blt	$t4,	5,	part_eleven_failed


main_loop_part_eleven:

addi	$sp,	$sp,	-76
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t0,	32($sp)
sw	$t1,	36($sp)
sw	$t9,	40($sp)
sw	$t8,	44($sp)
sw	$t6,	48($sp)
sw	$t5,	52($sp)
sw	$t3,	56($sp)
sw	$t4,	60($sp)
sw	$t2,	64($sp)
sw	$t7,	68($sp)
sw	$ra,	72($sp)

# push on stacks

move	$a0,	$s0
move	$a1,	$t4
move	$a2,	$s5
move	$a3,	$t8

jal	get_slot

lw	$ra,	72($sp)
lw	$t7,	68($sp)
lw	$t2,	64($sp)
lw	$t4,	60($sp)
lw	$t3,	56($sp)
lw	$t5,	52($sp)
lw	$t6,	48($sp)
lw	$t8,	44($sp)
lw	$t9,	40($sp)
lw	$t1,	36($sp)
lw	$t0,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	76

move	$s4,	$v0

beq	$s4,	$s3,	middle_loop
j	start_again

middle_loop:
# push on stacks
addi	$sp,	$sp,	-76
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t0,	32($sp)
sw	$t1,	36($sp)
sw	$t9,	40($sp)
sw	$t8,	44($sp)
sw	$t6,	48($sp)
sw	$t5,	52($sp)
sw	$t3,	56($sp)
sw	$t4,	60($sp)
sw	$t2,	64($sp)
sw	$t7,	68($sp)
sw	$ra,	72($sp)

move	$a0,	$s0
sub	$a1,	$t4,	$t6
add	$a2,	$s5,	$t6
#addi	$a2,	$a2,	-1
move	$a3,	$t8

jal	get_slot

lw	$ra,	72($sp)
lw	$t7,	68($sp)
lw	$t2,	64($sp)
lw	$t4,	60($sp)
lw	$t3,	56($sp)
lw	$t5,	52($sp)
lw	$t6,	48($sp)
lw	$t8,	44($sp)
lw	$t9,	40($sp)
lw	$t1,	36($sp)
lw	$t0,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	76

addi	$sp,	$sp,	-4
sw	$s5,	0($sp)
move	$s5,	$v0
beq	$s5,	$s4,	middle_Loop_2
lw	$s5,	0($sp)
addi	$sp,	$sp,	4
j	start_again


middle_Loop_2:
lw	$s5,	0($sp)
addi	$sp,	$sp,	4
addi	$t1,	$t1,	1
beq	$t1,	5,	put_it_on_stack
addi	$t6,	$t6,	1
j	middle_loop

put_it_on_stack:

move	$t2,	$t4
move	$t7,	$s5
j	start_again
start_again:
li	$t6,	1
li	$t1,	1
addi	$t0,	$t3,	-1
beq	$s5,	$t0,	start_col_to_zero
addi	$s5,	$s5,	1

beq	$t4,	$s2,	check_for_col_length

j	main_loop_part_eleven

start_col_to_zero:
li	$s5,	0
addi	$t4,	$t4,	1
addi	$t0,	$s2,	-1
beq	$t4,	$t0,	check_for_col_length
j	main_loop_part_eleven

check_for_col_length:
addi	$t0,	$t3,	-1
beq	$s5,	$t0,	done_with_part_eleven
#addi	$t4,	$t4,	1
j	main_loop_part_eleven

done_with_part_eleven:
move	$v0,	$t2
move	$v1,	$t7
j	pull_from_stack_part_eleven
#lw	$s2,	0($s0)	# total rows
#lw	$t9,	4($s0)	# total coloms

#sub	$v0,	$s2,	$t6
#sub	$v1,	$t9,	$t6



part_eleven_failed:
li	$v0,	-1
li	$v1,	-1


pull_from_stack_part_eleven:
beqz	$v0,	checkforv1
j	xxxxxxxx
checkforv1:
beqz	$v1,	makeitaa
j	xxxxxxxx
makeitaa:
li	$v1,	-1
li	$v0,	-1

xxxxxxxx:
lw	$ra,	72($sp)
lw	$t7,	68($sp)
lw	$t2,	64($sp)
lw	$t4,	60($sp)
lw	$t3,	56($sp)
lw	$t5,	52($sp)
lw	$t6,	48($sp)
lw	$t8,	44($sp)
lw	$t9,	40($sp)
lw	$t1,	36($sp)
lw	$t0,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	76

jr	$ra

#######################################################################
#				part 12				      #
#######################################################################
check_nw_se_diagonal_winner:



addi	$sp,	$sp,	-76
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t0,	32($sp)
sw	$t1,	36($sp)
sw	$t9,	40($sp)
sw	$t8,	44($sp)
sw	$t6,	48($sp)
sw	$t5,	52($sp)
sw	$t3,	56($sp)
sw	$t4,	60($sp)
sw	$t2,	64($sp)
sw	$t7,	68($sp)
sw	$ra,	72($sp)

move	$s0,	$a0	# board

move	$s3,	$a1	# player
move	$t8,	$a1	# extra copy


bne	$s3,	88,	check_for_O_part_twelve
j	skippp_1_1_1
check_for_O_part_twelve:
bne	$s3,	79	part_twelve_failed
skippp_1_1_1:
li	$t1,	0	# final number of captures
li	$t0,	0

lw	$s4,	0($s0)	# total rows
lw	$s2,	0($s0)	# total rows
lw	$t9,	4($s0)	# total coloms
addi	$s7,	$s4,	-1
addi	$s6,	$t9,	-1
#blt	$s5,	5,	part_twelve_failed

#addi	$s0,	$s0,	8

bltz	$s7,	part_twelve_failed
bltz	$s6,	part_twelve_failed

li	$t5,	2
li	$t6,	1
li	$t1,	0
li	$s5,	0
li	$t2,	0
li	$t7,	0

div	$t9,	$t5
mflo	$t3		# half od columns


#div	$s4,	$t5
#mflo	$t4		# half of rows
li  $t4,  0

#blt	$t3,	5,	part_twelve_failed
#blt	$t4,	5,	part_twelve_failed


main_loop_part_twelve:

addi	$sp,	$sp,	-76
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t0,	32($sp)
sw	$t1,	36($sp)
sw	$t9,	40($sp)
sw	$t8,	44($sp)
sw	$t6,	48($sp)
sw	$t5,	52($sp)
sw	$t3,	56($sp)
sw	$t4,	60($sp)
sw	$t2,	64($sp)
sw	$t7,	68($sp)
sw	$ra,	72($sp)

move	$a0,	$s0
move	$a1,	$t4
move	$a2,	$s5
move	$a3,	$t8

jal	get_slot

lw	$ra,	72($sp)
lw	$t7,	68($sp)
lw	$t2,	64($sp)
lw	$t4,	60($sp)
lw	$t3,	56($sp)
lw	$t5,	52($sp)
lw	$t6,	48($sp)
lw	$t8,	44($sp)
lw	$t9,	40($sp)
lw	$t1,	36($sp)
lw	$t0,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	76

move	$s4,	$v0

beq	$s4,	$s3,	middle_loop_part_twelve
j	start_again_1

middle_loop_part_twelve:
# push on stacks
addi	$sp,	$sp,	-76
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t0,	32($sp)
sw	$t1,	36($sp)
sw	$t9,	40($sp)
sw	$t8,	44($sp)
sw	$t6,	48($sp)
sw	$t5,	52($sp)
sw	$t3,	56($sp)
sw	$t4,	60($sp)
sw	$t2,	64($sp)
sw	$t7,	68($sp)
sw	$ra,	72($sp)

move	$a0,	$s0
add	$a1,	$t4,	$t6
add	$a2,	$s5,	$t6
#addi	$a2,	$a2,	-1
move	$a3,	$t8

jal	get_slot

lw	$ra,	72($sp)
lw	$t7,	68($sp)
lw	$t2,	64($sp)
lw	$t4,	60($sp)
lw	$t3,	56($sp)
lw	$t5,	52($sp)
lw	$t6,	48($sp)
lw	$t8,	44($sp)
lw	$t9,	40($sp)
lw	$t1,	36($sp)
lw	$t0,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	76

addi	$sp,	$sp,	-4
sw	$s5,	0($sp)
move	$s5,	$v0
beq	$s5,	$s4,	middle_loop_part_twelve_2
lw	$s5,	0($sp)
addi	$sp,	$sp,	4
j	start_again_1


middle_loop_part_twelve_2:
lw	$s5,	0($sp)
addi	$sp,	$sp,	4
addi	$t1,	$t1,	1
beq	$t1,	5,	put_it_on_stack_2
addi	$t6,	$t6,	1
j	middle_loop_part_twelve

put_it_on_stack_2:

move	$t2,	$t4
move	$t7,	$s5
j	start_again_1

start_again_1:
li	$t6,	1
li	$t1,	1
addi	$t0,	$t3,	-1
beq	$s5,	$t0,	start_col_to_zero_2
addi	$s5,	$s5,	1

beq	$t4,	$t0,	check_for_col_length_2

j	main_loop_part_twelve

start_col_to_zero_2:
li	$s5,	0
addi	$t4,	$t4,	1
addi	$t0,	$s2,	-1
beq	$t4,	$t0,	check_for_col_length_2
j	main_loop_part_twelve

check_for_col_length_2:
addi	$t0,	$t3,	-1
beq	$s5,	$t0,	done_with_part_twelve
#addi	$t4,	$t4,	1
j	main_loop_part_twelve

done_with_part_twelve:

li	$t6,	1

vvvvvvv:
addi	$sp,	$sp,	-76
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$s7,	28($sp)
sw	$t0,	32($sp)
sw	$t1,	36($sp)
sw	$t9,	40($sp)
sw	$t8,	44($sp)
sw	$t6,	48($sp)
sw	$t5,	52($sp)
sw	$t3,	56($sp)
sw	$t4,	60($sp)
sw	$t2,	64($sp)
sw	$t7,	68($sp)
sw	$ra,	72($sp)

move	$a0,	$s0
sub	$a1,	$t2,	$t6
sub	$a2,	$t7,	$t6
move	$a3,	$t8

jal	get_slot

lw	$ra,	72($sp)
lw	$t7,	68($sp)
lw	$t2,	64($sp)
lw	$t4,	60($sp)
lw	$t3,	56($sp)
lw	$t5,	52($sp)
lw	$t6,	48($sp)
lw	$t8,	44($sp)
lw	$t9,	40($sp)
lw	$t1,	36($sp)
lw	$t0,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	76


addi	$sp,	$sp,	-4
sw	$s5,	0($sp)
move	$s5,	$v0
beq	$s5,	$s3,	xxxxxx
lw	$s5,	0($sp)
addi	$sp,	$sp,	4

j	finally_out
xxxxxx:
lw	$s5,	0($sp)
addi	$sp,	$sp,	4
#addi	$t6,	$t6,	1
sub	$t2,	$t2,	$t6
sub	$t7,	$t7,	$t6
j	vvvvvvv

finally_out:
move	$v0,	$t2
move	$v1,	$t7
j	pull_from_stack_part_twelve

part_twelve_failed:
li	$v0,	-1
li	$v1,	-1


pull_from_stack_part_twelve:

lw	$ra,	72($sp)
lw	$t7,	68($sp)
lw	$t2,	64($sp)
lw	$t4,	60($sp)
lw	$t3,	56($sp)
lw	$t5,	52($sp)
lw	$t6,	48($sp)
lw	$t8,	44($sp)
lw	$t9,	40($sp)
lw	$t1,	36($sp)
lw	$t0,	32($sp)
lw	$s7,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	76

jr	$ra


#######################################################################
#				part 13				      #
#######################################################################
simulate_game:

addi	$sp,	$sp,	-16
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)

move	$s0,	$a0
move	$s1,	$a1
move	$s2,	$a2
move	$s3,	$a3

addi	$sp,	$sp,	-4
sw	$ra,	0($sp)
jal 	load_board
lw	$ra,	0($sp)
addi	$sp,	$sp,	4

lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)
addi	$sp,	$sp,	16
jr $ra
