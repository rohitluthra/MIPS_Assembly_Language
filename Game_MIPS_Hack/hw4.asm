
.text

# ------------------------------------------------------------------------------ Part I ------------------------------------------------------------------------------
init_game:

		move	$t0,	$a0			# File Name`
		move	$t1,	$a1			# map_ptr
		move	$t9,	$a1			# extra copy of map_ptr
		move	$t2,	$a2			# playeR_ptr
		move	$s2,	$t2			# extra copy

		li	$t4,	0

		li	$v0,	13
		li	$a1,	0			# flag
		li	$a2,	0			# Modes are ignored

		syscall					# this will Open the file

		move	$t3,	$v0			# save the Decriptor
		lbu	$t4,	0($t1)

whileLoop:
		li	$v0,	14
		add	$a0,	$zero,	$t3
		add	$a1,	$zero,	$t1		# loading in map_ptr
		li	$a2,	1

		syscall

		lbu	$t4,	0($t1)			# storing into registe
		beq	$t4,	10,	ReadRowMap	#if current is \n then jump out.
		addi	$t1,	$t1,	1		# moving to nect position in map_ptr

		j	whileLoop

ReadRowMap:
		li	$s0,	0
		li	$s1,	0
		move	$s0,	$t3
		move	$s1,	$t1
		move	$t1,	$t9			# setting back address of t1 to original state

		# ------------------- for row -------------------

		li	$t8,	10			# just a temporary
		lbu	$t5,	0($t1)
		addi	$t5,	$t5,	-48				# bringing it down to 0-9 level
		mult	$t5,	$t8
		mflo	$t6
		lbu	$t7,	1($t1)
		addi	$t7,	$t7,	-48
		add	$t6,	$t6,	$t7			       	# this is the integer form
		sb	$t6,	0($t1)

		#add	$a0,	$zero,	$t6
		#li	$v0, 	1											#  Printing
		#syscall

		move	$t3,	$s0
		move	$t1,	$s1

whileLoop2:

		li	$v0,	14
		add	$a0,	$zero,	$t3
		add	$a1,	$zero,	$t1		# loading in map_ptr
		li	$a2,	1

		syscall

		lbu	$t4,	0($t1)			# storing into register
		beq	$t4,	10,	ReadColomntoMap	#if current is \n then jump out.
		addi	$t1,	$t1,	1		# moving to nect position in map_ptr

		j	whileLoop2

ReadColomntoMap:
		addi	$t1,	$t1,	-2		# moving to nect position in map_ptr
		li	$s0,	0
		li	$s1,	0
		move	$s0,	$t3
		move	$s1,	$t1
		move	$t1,	$t9			# setting back address of t1 to original state

		# ------------------- for colomn -------------------
		lbu	$t5,	2($t1)
		addi	$t5,	$t5,	-48				# bringing it down to 0-9 level
		mult	$t5,	$t8
		mflo	$t6
		lbu	$t7,	3($t1)
		addi	$t7,	$t7,	-48
		add	$t6,	$t6,	$t7				# this is the integer form
		sb	$t6,	1($t1)

		#add	$a0,	$zero,	$t6
		#li	$v0, 	1											#  Printing
		#syscall

		li	$t5,	0				# loop row
		lbu	$t6,	0($t1)				# actual row
		li	$t7,	0				# loop colomn
		lbu	$t8,	1($t1)				# actual colomn

		move	$t3,	$s0
		move	$t1,	$s1

readmap:
		li	$v0,	14
		add	$a0,	$zero,	$t3
		add	$a1,	$zero,	$t1		# loading in map_ptr
		li	$a2,	1

		syscall

		lbu	$t4,	0($t1)			# storing into register
		lbu	$s4,	0($t1)

		beq	$s4,	10,	moveToNextCol	#if current is \n then jump out.

		ori	$t4,	$t4,	0x80
		sb	$t4,	0($t1)

		beq	$s4,	'@',	savePlayerSpot

		addi	$t1,	$t1,	1		# moving to nect position in map_ptr
		addi	$t7,	$t7,	1

		j	readmap

moveToNextCol:

		addi	$t5,	$t5,	1
		li	$t7,	0
		beq	$t5,	$t6,	saveHealth1
		j	 readmap

savePlayerSpot:

		sb	$t5,	0($t2)
		sb	$t7,	1($t2)
		addi	$t1,	$t1,	1		# moving to nect position in map_ptr

		j readmap

saveHealth1:
		addi	$t2,	$t2,	2
saveHealth:
		li	$v0,	14
		add	$a0,	$zero,	$t3
		add	$a1,	$zero,	$t2		# loading in player_ptr
		li	$a2,	1
		syscall

		lbu	$t4,	($t2)			# storing into register

		beq	$t4,	10,	calculatetheHEalth	#if current is \n then jump out.
		addi	$t2,	$t2,	1
		j saveHealth

calculatetheHEalth:

		move	$t2,	$s2

		li	$t8,	10

		lb	$t5,	2($t2)

		addi	$t5,	$t5,	-48				# bringing it down to 0-9 level

		mult	$t5,	$t8
		mflo	$t6

		lb	$t7,	3($t2)
		addi	$t7,	$t7,	-48

		add	$t6,	$t6,	$t7				# this is the integer form

		sb	$t6,	2($t2)

		sb	$zero,	3($t2)					# coin is initally zero ----------------------

		li	$v0, 16				# close file
		add	$a0,	$zero,	$t3
		syscall

doneLooping2:

		move	$t1,	$t9

		li	$t5,	0
		lbu	$t6,	1($t1)			# number of colomn

		li	$a0,	'\n'
		li	$v0, 	11											#  Printing
		syscall

loopThrough:
		lbu	$t4,	2($t1)			# storing into register

		beq	$t4,	10,	end		#if current is \n then jump out.
		beq	$t5,	$t6,	nextLine

		add	$a0,	$zero,	$t4
		li	$v0, 	11											#  Printing
		syscall

		addi	$t1,	$t1,	1		# moving to nect position in map_ptr
		addi	$t5,	$t5,	1

		j	loopThrough

nextLine:
		li	$t5,	0
		li	$a0,	'\n'
		li	$v0, 	11											#  Printing
		syscall

		j	loopThrough


#loopThroughPlayer1:

	#	move	$t2,	$s2

#loopThroughPlayer:
	#	lbu	$t4,	0($t2)

	#	beq	$t4,	10,	end

	#	add	$a0,	$zero,	$t4
	#	li	$v0, 	1											#  Printing
	#	syscall

	#	addi	$t2,	$t2,	1

	#	j	loopThroughPlayer

end:

		jr	$ra


# ------------------------------------------------------------------------------ Part II ------------------------------------------------------------------------------
is_valid_cell:

		addi	$sp,	$sp,	-24

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s4,	16($sp)
		sw	$ra,	20($sp)

		move	$s0,	$a0					# map_ptr
		move	$s1,	$a1					# rows
		move	$s2,	$a2					# colomn

		lbu	$s3,	0($s0)
		lbu	$s4,	1($s0)

		bltz	$s1,		part2Failed
		bge	$s1,	$s3,	part2Failed
		bltz	$s2,		part2Failed
		bge	$s2,	$s4,	part2Failed

		lw	$ra,	20($sp)
		lw	$s4,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	24

		li	$v0,	0
		jr 	$ra


part2Failed:
		li	$v0,	-1
		jr	$ra

# ------------------------------------------------------------------------------ Part III ------------------------------------------------------------------------------
get_cell:

		move	$s0,	$a0				# map_Ptr
		move	$s1,	$a1				# target row
		move	$s2,	$a2				# target colomn

		lbu	$s3,	0($s0)				# total number of rows
		lbu	$s4,	1($s0)				# totol number of colomns

		bltz	$s1,		part3Failed		# cases
		bge	$s1,	$s3,	part3Failed
		bltz	$s2,		part3Failed
		bge	$s2,	$s4,	part3Failed

		addi	$sp,	$sp,	-24			# putting on stack before --- going to is_valid_cell

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s4,	16($sp)
		sw	$ra,	20($sp)

		jal	is_valid_cell

		move	$s5,	$v0				# storing the 0 Value
		bnez	$s5,	part3Failed			# if its not a valid then return -1

		lw	$ra,	20($sp)
		lw	$s4,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	24

		mul	$s6, 	$s4,	$s1
		add	$s6,	$s6,	$s2
		add	$s0,	$s0,	$s6

		addi	$s0,	$s0,	2
		#andi	$s6,	$s6,	0x7F			# flipping the last one....

		lbu	$s6,	0($s0)				# reaching that cell and storing the value
		move	$v0,	$s6
		jr	$ra

part3Failed:
		li	$v0,	-1
		jr	$ra



# ------------------------------------------------------------------------------ Part IV ------------------------------------------------------------------------------
set_cell:

		move	$s0,	$a0				# map_Ptr
		move	$s1,	$a1				# target row
		move	$s2,	$a2				# target colomn
		move	$s7,	$a3				# char to exchange

		lbu	$s3,	0($s0)				# total number of rows
		lbu	$s4,	1($s0)				# totol number of colomns

		bltz	$s1,		part4Failed		# cases
		bge	$s1,	$s3,	part4Failed
		bltz	$s2,		part4Failed
		bge	$s2,	$s4,	part4Failed

		addi	$sp,	$sp,	-28			# putting on stack before --- going to is_valid_cell

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s4,	16($sp)
		sw	$s7,	20($sp)
		sw	$ra,	24($sp)

		jal	is_valid_cell

		move	$s5,	$v0				# storing the 0 Value

		lw	$ra,	24($sp)
		lw	$s7,	20($sp)
		lw	$s4,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28

		bnez	$s5,	part4Failed			# if its not a valid then return -1

		mul	$s6,	$s4,	$s1
		add	$s6,	$s6,	$s2
		add	$s0,	$s0,	$s6

		addi	$s0,	$s0,	2

		sb	$s7,	($s0)				# reaching that cell and storing the value

		move	$t1,	$t0

end1:
		li	$v0,	0
		jr	$ra

part4Failed:
		li	$v0,	-1
		jr	$ra

# ----------------------------------------------------------- Part V ------------------------------------------------------------------------------
reveal_area:

		move	$s0,	$a0				# map_prt
		move	$s1,	$a1				# row
		move	$s4,	$a1				# extra copy of row
		move	$s2,	$a2				# colomn
		move	$s7,	$a2				# extra copy of colomn

		lbu	$t8,	0($s0)				# rows
		lbu	$t9,	1($s0)				# colomns

		li	$t1,	1

		mul	$s6,	$t9,	$s1
		add	$s6,	$s6,	$s2
		add	$s3,	$s6,	$s0

		addi	$s3,	$s3,	2

ultimateLoop1:

		beq	$t1,	1, 	case1
		beq	$t1,	2, 	case2
		beq	$t1,	3, 	case3
		beq	$t1,	4, 	case4
		beq	$t1,	5, 	case5
		beq	$t1,	6, 	case6
		beq	$t1,	7, 	case7
		beq	$t1,	8, 	case8
		beq	$t1,	9,	case9
		beq	$t1,	10,	case10

ultimateLoop:
		addi	$sp,	$sp,	-32			# putting on stack before --- going to is_valid_cell

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s4,	16($sp)
		sw	$s7,	20($sp)
		sw	$t1,	24($sp)
		sw	$ra,	28($sp)

		jal	is_valid_cell

		move	$s5,	$v0
		bnez	$s5,	part5Failed			# if its not a valid then return -1

		jal	get_cell

		move	$s6,	$v0
		andi	$s6,	$s6,	0x7F			# flipping the last one....
		addi	$sp,	$sp,	-4

		sw	$s6,	0($sp)

		move	$a3,	$s6

		jal	set_cell

		lw	$s6,	0($sp)

		addi	$sp,	$sp,	4

		move	$s5,	$v0
		bnez	$s5,	part5Failed			# if its not a valid then return -1

		lw	$ra,	28($sp)
		lw	$t1,	24($sp)
		lw	$s7,	20($sp)
		lw	$s4,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28
		addi	$t1,	$t1,	1

		j ultimateLoop1

case1:
		move	$s1,	$s4
		move	$a0,	$s0
		addi	$t4,	$s1,	-1
		addi	$t5,	$s2,	-1
		move	$a1,	$t4
		move	$a2,	$t5

		j ultimateLoop
case2:
		move	$s1,	$s4
		move	$a0,	$s0
		addi	$t4,	$s1,	-1
		move	$a1,	$t4
		move	$a2,	$s2

		j ultimateLoop
case3:

		move	$s1,	$s4
		move	$a0,	$s0
		addi	$t4,	$s1,	-1
		addi	$t5,	$s2,	1
		move	$a1,	$t4
		move	$a2,	$t5

		j ultimateLoop
case4:
		move	$s1,	$s4
		move	$a0,	$s0
		addi	$t5,	$s2,	-1
		move	$a1,	$s1
		move	$a2,	$t5

		j ultimateLoop

case5:
		move	$s1,	$s4
		move	$a0,	$s0
		addi	$t5,	$s2,	1
		move	$a1,	$s1
		move	$a2,	$t5

		j ultimateLoop

case6:
		move	$s1,	$s4

		move	$a0,	$s0
		addi	$t4,	$s1,	1
		addi	$t5,	$s2,	-1
		move	$a1,	$t4
		move	$a2,	$t5

		j ultimateLoop
case7:

		move	$s1,	$s4
		move	$a0,	$s0
		addi	$t4,	$s1,	1
		move	$a1,	$t4
		move	$a2,	$s2

		j ultimateLoop
case8:

		move	$s1,	$s4
		move	$a0,	$s0
		addi	$t4,	$s1,	1
		addi	$t5,	$s2,	1
		move	$a1,	$t4
		move	$a2,	$t5

		j ultimateLoop

case9:

		move	$a0,	$s0
		move	$a1,	$s1
		move	$a2,	$s2

		j ultimateLoop

case10:
		li	$v0,	0
		jr 	$ra

part5Failed:
		li	$v0,	-1
		jr	$ra


## ------------------------------------------  Part VI # ------------------------------------------
get_attack_target:
		move	$s0,	$a0					# map_ptr
		move	$s1,	$a1					# player_ptr
		move	$s2,	$a2					# direction

		lbu	$s3,	0($s1)					# total number of rows
		lbu	$s4,	1($s1)					# totalt number of colomns

		beq	$s2,	'U',	Up_Case
		beq	$s2,	'D',	down_case
		beq	$s2,	'L',	left_case
		beq	$s2,	'R',	right_case
		j	part6Failed

Up_Case:
		addi	$s3,	$s3,	-1
		j goAhead

down_case:
		addi	$s3,	$s3,	1
		j goAhead
left_case:

		addi	$s4,	$s4,	-1
		j goAhead

right_case:
		addi	$s4,	$s4,	1
		j goAhead

goAhead:
		move	$a0,	$s0
		move	$a1,	$s3
		move	$a2,	$s4

		addi	$sp,	$sp,	-24			# putting on stack before --- going to is_valid_cell

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s4,	16($sp)
		sw	$ra,	20($sp)

		jal	get_cell

		move	$s5,	$v0				# storing the 0 Value

		lw	$ra,	20($sp)
		lw	$s4,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	24

		beq	$s5,	'm',	goAhead_2
		beq	$s5,	'B',	goAhead_2
		beq	$s5,	'/',	goAhead_2

		j	part6Failed

goAhead_2:

		move	$v0,	$s5
		jr 	$ra

part6Failed:
		li	$v0,	-1
		jr 	$ra

# # ------------------------------------------  Part VII # ------------------------------------------
complete_attack:
		move	$s0,	$a0				# map_ptr
		move	$s1,	$a1				# player_ptr
		move	$s2,	$a2				# target_row
		move	$s3,	$a3				# target_colomn

		lbu	$s4,	1($s0)

		move 	$a0,	$s0
		move	$a1,	$s2
		move	$a2,	$s3

		addi	$sp,	$sp,	-24			# putting on stack before --- going to is_valid_cell

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s4,	16($sp)
		sw	$ra,	20($sp)

		jal 	get_cell

		move	$t1,	$v0

		lw	$ra,	20($sp)
		lw	$s4,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	24

		beq	$t1,	'm',	case_m
		beq	$t1,	'B',	case_b
		beq	$t1,	'/',	case_s


case_m:
		lbu	$s5,	2($s1)
		addi	$s5,	$s5,	-1
		sb	$s5,	2($s1)

		addi	$sp,	$sp,	-28			# putting on stack before --- going to is_valid_cell

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s4,	16($sp)
		sw	$s5,	20($sp)
		sw	$ra,	24($sp)

		move 	$a0,	$s0
		move	$a1,	$s2
		move	$a2,	$s3
		li	$a3,	'$'

		jal	set_cell

		lw	$ra,	24($sp)
		lw	$s5,	20($sp)
		lw	$s4,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28

		move	$t2,	$v0
		ble	$t2,	-1,	part7Failed
		blez	$s5,	playerDied

		j part7Passed

case_b:

		lbu	$s5,	2($s1)
		addi	$s5,	$s5,	-2
		sb	$s5,	2($s1)

		addi	$sp,	$sp,	-28			# putting on stack before --- going to is_valid_cell

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s4,	16($sp)
		sw	$s5,	20($sp)
		sw	$ra,	24($sp)

		move 	$a0,	$s0
		move	$a1,	$s2
		move	$a2,	$s3
		li	$a3,	'*'

		jal	set_cell

		lw	$ra,	24($sp)
		lw	$s5,	20($sp)
		lw	$s4,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28


		move	$t2,	$v0
		beq	$t2,	-1,	part7Failed

		blez	$s5,	playerDied

		j part7Passed

case_s:
		lbu	$s5,	2($s1)
		addi	$s5,	$s5,	-1
		sb	$s5,	2($s1)

		addi	$sp,	$sp,	-28			# putting on stack before --- going to is_valid_cell

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s4,	16($sp)
		sw	$s5,	20($sp)
		sw	$ra,	24($sp)

		move 	$a0,	$s0
		move	$a1,	$s2
		move	$a2,	$s3
		li	$a3,	'.'
		jal	set_cell

		lw	$ra,	24($sp)
		lw	$s5,	20($sp)
		lw	$s4,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28

		move	$t2,	$v0
		beq	$t2,	-1,	part7Failed

		blez	$s5,	playerDied

		j part7Passed

playerDied:
		lbu	$t1,	0($s1)
		lbu	$t2,	1($s1)

		move 	$a0,	$s0
		move	$a1,	$t1
		move	$a2,	$t2
		li	$a3,	'X'

		jal	set_cell

		move	$s5,	$v0
		beq	$s5,	-1,	part7Failed

		jr	$ra


part7Failed:

		jr	$ra

part7Passed:

		jr	$ra

# # ------------------------------------------  Part VIII # ------------------------------------------
monster_attacks:
		move	$s0,	$a0					# map
		move	$s1,	$a1					# player

		li	$s4,	1
		li	$s5,	0					# return counter

mainLoopStart:
		lbu	$s2,	0($s1)
		lbu	$s3,	1($s1)

		beq	$s4,	1,	case_one
		beq	$s4,	2,	case_two
		beq	$s4,	3,	case_three
		beq	$s4,	4,	case_four
		beq	$s4,	5,	case_five

part8Loop:

		addi	$sp,	$sp,	-28			# putting on stack before --- going to is_valid_cell

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s4,	16($sp)
		sw	$s5,	20($sp)
		sw	$ra,	24($sp)

		move	$a0,	$s0
		move	$a1,	$s2
		move	$a2,	$s3

		jal	get_cell

		move	$s6,	$v0

		lw	$ra,	24($sp)
		lw	$s5,	20($sp)
		lw	$s4,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28

		beq	$s6,	'm',	damage1
		beq	$s6,	'B',	damage2

		addi	$s4,	$s4,	1

		j	mainLoopStart

damage1:
		addi	$s5,	$s5,	1
		addi	$s4,	$s4,	1
		j 	mainLoopStart
damage2:
		addi	$s5,	$s5,	2
		addi	$s4,	$s4,	1
		j	mainLoopStart

case_one:
		addi	$s3,	$s3,	-1		# left
		j	part8Loop

case_two:
		addi	$s2,	$s2,	1		# down
		j	part8Loop

case_three:
		addi	$s2,	$s2,	-1		# up
		j	part8Loop

case_four:
		addi	$s3,	$s3,	1		# right
		j	part8Loop

case_five:
		move	$v0,	$s5
		jr	$ra


# ------------------------------------------ Part IX ----------------------------------------------
player_move:

		move	$s0,	$a0				# map
		move	$s1,	$a1				# player
		move	$s2,	$a2				# target Row
		move	$s3,	$a3				# target colomn

		addi	$sp,	$sp,	-20
		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$ra,	16($sp)

		move	$a0,	$s0
		move	$a1,	$s2
		move	$a2,	$s3

		jal	is_valid_cell						# validity Check

		move	$s4,	$v0

		bnez 	$s4,	part9Failed

		lw	$ra,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	20

		addi	$sp,	$sp,	-20
		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$ra,	16($sp)

		move	$a0,	$s0
		move	$a1,	$s1

		jal	monster_attacks						# total Damage

		move	$s4,	$v0

		lbu	$s5,	2($s1)
		beqz	$s5,	replaceWithXthenEnd
		sub	$s5,	$s5,	$s4
		sb	$s5,	2($s1)

		lw	$ra,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	20

		addi	$sp,	$sp,	-20
		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$ra,	16($sp)

		move	$a0,	$s0
		move	$a1,	$s2
		move	$a2,	$s3

		jal	get_cell

		move	$s4,	$v0

		lw	$ra,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	20

		beq	$s4,	'.',	casedot
		beq	$s4,	'$',	casedollor
		beq	$s4,	'*',	casestar
		beq	$s4,	'>',	caselast

casedot:
		lbu	$s5,	0($s1)
		lbu	$s6,	1($s1)

		addi	$sp,	$sp,	-20
		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$ra,	16($sp)

		move	$a0,	$s0
		move	$a1,	$s5
		move	$a2,	$s6
		li	$a3,	'.'

		jal	set_cell

		move	$s4,	$v0
		beq	$s4,	-1,	part9Failed

		lw	$ra,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	20

		addi	$sp,	$sp,	-20
		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$ra,	16($sp)

		move	$a0,	$s0
		move	$a1,	$s2
		move	$a2,	$s3
		li	$a3,	'@'

		jal	set_cell

		move	$s4,	$v0
		beq	$s4,	-1,	part9Failed

		lw	$ra,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	20

		sb	$s2,	0($s1)
		sb	$s3,	1($s1)

		j	doneWithPart9

casedollor:

		lbu	$s5,	0($s1)
		lbu	$s6,	1($s1)

		addi	$sp,	$sp,	-20
		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$ra,	16($sp)

		move	$a0,	$s0
		move	$a1,	$s5
		move	$a2,	$s6
		li	$a3,	'.'

		jal	set_cell

		move	$s4,	$v0
		beq	$s4,	-1,	part9Failed

		lw	$ra,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	20

		addi	$sp,	$sp,	-20
		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$ra,	16($sp)

		move	$a0,	$s0
		move	$a1,	$s2
		move	$a2,	$s3
		li	$a3,	'@'

		jal	set_cell

		move	$s4,	$v0
		beq	$s4,	-1,	part9Failed

		lw	$ra,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	20

		sb	$s2,	0($s1)
		sb	$s3,	1($s1)

		lbu	$s4,	3($s1)
		addi	$s4,	$s4,	1
		sb	$s4,	3($s1)

		j	doneWithPart9

casestar:
		lbu	$s5,	0($s1)
		lbu	$s6,	1($s1)

		addi	$sp,	$sp,	-20
		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$ra,	16($sp)

		move	$a0,	$s0
		move	$a1,	$s5
		move	$a2,	$s6
		li	$a3,	'.'

		jal	set_cell

		move	$s4,	$v0
		beq	$s4,	-1,	part9Failed

		lw	$ra,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	20

		addi	$sp,	$sp,	-20
		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$ra,	16($sp)

		move	$a0,	$s0
		move	$a1,	$s2
		move	$a2,	$s3
		li	$a3,	'@'

		jal	set_cell

		move	$s4,	$v0
		beq	$s4,	-1,	part9Failed

		lw	$ra,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	20

		sb	$s2,	0($s1)
		sb	$s3,	1($s1)

		lbu	$s4,	3($s1)
		addi	$s4,	$s4,	5
		sb	$s4,	3($s1)

		j	doneWithPart9

caselast:
		lbu	$s5,	0($s1)
		lbu	$s6,	1($s1)

		addi	$sp,	$sp,	-20
		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$ra,	16($sp)

		move	$a0,	$s0
		move	$a1,	$s5
		move	$a2,	$s6
		li	$a3,	'.'

		jal	set_cell

		move	$s4,	$v0
		beq	$s4,	-1,	part9Failed

		lw	$ra,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	20

		addi	$sp,	$sp,	-20
		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$ra,	16($sp)

		move	$a0,	$s0
		move	$a1,	$s2
		move	$a2,	$s3
		li	$a3,	'@'

		jal	set_cell

		move	$s4,	$v0
		beq	$s4,	-1,	part9Failed

		lw	$ra,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	20

		sb	$s2,	0($s1)
		sb	$s3,	1($s1)

		j	part9Failed

replaceWithXthenEnd:

		lbu	$t1,	0($s1)
		lbu	$t2,	1($s1)

		move 	$a0,	$s0
		move	$a1,	$t1
		move	$a2,	$t2
		li	$a3,	'X'

		jal	set_cell

		move	$s5,	$v0
		beq	$s5,	-1,	part9Failed

doneWithPart9:

		li	$v0,	0
		jr	$ra

part9Failed:

		li	$v0,	-1
		jr 	$ra


# -------------------------------------------- Part X -----------------------------------------
player_turn:

		move	$s0,	$a0					# map
		move	$s1,	$a1					# player
		move	$s2,	$a2					# direction

		lbu	$s3,	0($s1)					# player_ row
		lbu	$s4,	1($s1)					# player_Colomn

		beq 	$s2,	'U',	case_U
		beq	$s2,	'D',	case_D
		beq	$s2,	'L',	case_L
		beq	$s2,	'R',	case_R
		j	part10Failed

case_U:
		addi	$s6,	$s3,	-1
		move	$s7,	$s4
		j	nextStep

case_D:
		addi	$s6,	$s3,	1
		move	$s7,	$s4
		j	nextStep

case_L:
		move	$s6,	$s3
		addi	$s7,	$s4,	-1
		j	nextStep
case_R:

		move	$s6,	$s3
		addi	$s7,	$s4,	1
		j	nextStep


nextStep:
		addi	$sp,	$sp,	-28

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s6,	16($sp)
		sw	$s7,	20($sp)
		sw	$ra,	24($sp)

		move	$a0,	$s0
		move	$a1,	$s6
		move	$a2,	$s7

		jal	is_valid_cell

		move	$s5,	$v0

		beq	$s5,	-1,	part10Failed

		lw	$ra,	24($sp)
		lw	$s7,	20($sp)
		lw	$s6,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28

		addi	$sp,	$sp,	-28

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s6,	16($sp)
		sw	$s7,	20($sp)
		sw	$ra,	24($sp)

		move	$a0,	$s0
		move	$a1,	$s6
		move	$a2,	$s7

		jal	get_cell

		move	$s5,	$v0

		beq	$s5,	'#',	returnZero

		lw	$ra,	24($sp)
		lw	$s7,	20($sp)
		lw	$s6,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28

		addi	$sp,	$sp,	-28

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s6,	16($sp)
		sw	$s7,	20($sp)
		sw	$ra,	24($sp)

		move	$a0,	$s0
		move	$a1,	$s1
		move	$a2,	$s2

		jal	get_attack_target

		move	$s5,	$v0

		lw	$ra,	24($sp)
		lw	$s7,	20($sp)
		lw	$s6,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28
												# might out a statement where health is xero or less hence, not going ahead.
		beq	$s5,	'm',	goaheadAttack
		beq	$s5,	'B',	goaheadAttack
		beq	$s5,	'/',	goaheadAttack

		j	calll_player_move

goaheadAttack:

		addi	$sp,	$sp,	-28

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s6,	16($sp)
		sw	$s7,	20($sp)
		sw	$ra,	24($sp)

		move	$a0,	$s0
		move	$a1,	$s1
		move	$a2,	$s6
		move	$a3,	$s7

		jal	complete_attack
		#jal	player_move

		lw	$ra,	24($sp)
		lw	$s7,	20($sp)
		lw	$s6,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28

		j	returnZero

calll_player_move:
		addi	$sp,	$sp,	-28

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s6,	16($sp)
		sw	$s7,	20($sp)
		sw	$ra,	24($sp)

		move	$a0,	$s0
		move	$a1,	$s1
		move	$a2,	$s6
		move	$a3,	$s7

		jal	player_move

		lw	$ra,	24($sp)
		lw	$s7,	20($sp)
		lw	$s6,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28

		move	$s5,	$v0
		move	$v0,	$s5
		jr	$ra

returnZero:
		li	$v0,	0
		jr	$ra
part10Failed:
		li	$v0,	-1
		jr	$ra

# -------------------------------------------- Part XI ---------------------------------------
flood_fill_reveal:
		move	$s0,	$a0					# map
		move	$s1,	$a1					# row
		move	$s2,	$a2					# colomn

		move	$s3,	$a3					# bit [] []
		move	$t8,	$a3

		lbu	$s5,	0($s0)					# total number of row
		lbu	$s7,	1($s0)					# total number of colomn

		li	$s6,	1

		bltz	$s1,		part11Failed			# cases
		bge	$s1,	$s5,	part11Failed
		bltz	$s2,		part11Failed
		bge	$s2,	$s7,	part11Failed

		move	$fp,	$sp

		addi	$sp,	$sp,	-8
		sw	$s1,	0($sp)
		sw	$s2,	4($sp)

whileLoop1111:

		beq	$sp,	$fp,	endWhile

		lw	$t6,	4($sp)		#colomn
		lw	$t5,	0($sp)		# row

		addi	$sp,	$sp,	8

		addi	$sp,	$sp,	-28

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s6,	16($sp)
		sw	$t8,	20($sp)
		sw	$ra,	24($sp)

		move	$a0,	$s0
		move	$a1,	$t5
		move	$a2,	$t6

		jal	get_cell

		move	$s5,	$v0
		andi	$s5,	$s5,	0x7F

		lw	$ra,	24($sp)
		lw	$t8,	20($sp)
		lw	$s6,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28

		addi	$sp,	$sp,	-28

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s6,	16($sp)
		sw	$t8,	20($sp)
		sw	$ra,	24($sp)

	#	move	$a0,	$s0
		move	$a1,	$t5
		move	$a2,	$t6
		move	$a3,	$s5

		jal	set_cell

		lw	$ra,	24($sp)
		lw	$t8,	20($sp)
		lw	$s6,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	28

		li	$s6,	1

		addi	$t7,	$t7,	1

		move	$s1,	$t5
		move	$s2,	$t6

forEachLoop:

		beq	$s6,	1,	case_1_forEach
		beq	$s6,	2,	case_2_forEach
		beq	$s6,	3,	case_3_forEach
		beq	$s6,	4,	case_4_forEach
		beq	$s6,	5,	endforeach

case_1_forEach:

		addi	$s6,	$s6,	1
		addi	$s7,	$s1,	-1

		addi	$sp,	$sp,	-32

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s6,	16($sp)
		sw	$s7,	20($sp)
		sw	$t8,	24($sp)
		sw	$ra,	28($sp)

		#move	$a0,	$s0
		move	$a1,	$s7
		move	$a2,	$s2

		jal	get_cell

		lw	$ra,	28($sp)
		lw	$t8,	24($sp)
		lw	$s7,	20($sp)
		lw	$s6,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	32

		move	$t6,	$v0
		andi	$t6,	$t6,	0x7F

		beq	$t6,	'.',	check_visited_or_not

		j	forEachLoop

check_visited_or_not:


		lbu	$t0,	1($s0)
		mult	$t0,	$s7
		mflo	$t1

		add	$t1,	$t1,	$s2

		li	$t3,	32

		div	$t1,	$t3
		mflo	$t1		# Q
		mfhi	$t2		# R

		sll	$t1,	$t1,	2			# Quetient x 4
		#add	$t8,	$t8,	$t1

		add	$t9,	$t8,	$t1			# t9 is temp contains which word to go to

		lw	$t4,	0($t9)
					# loading the word in same rejister
		sub	$t2,	$t3,	$t2			# $t2 = 32 - remainder
		srlv	$t3,	$t4,	$t2			# doing srlv
		andi	$t3,	$t3,	0x1

		beq	$t3,	1,	forEachLoop

		ori	$t3,	$t3,	1
		sllv	$t3,	$t3,	$t2
		lw	$t4,	0($t9)
		or	$t4,	$t4,	$t3
		sw	$t4,	($t9)


		addi	$sp,	$sp,	-8
		sw	$s7,	0($sp)
		sw	$s2,	4($sp)

		j	forEachLoop

case_2_forEach:

		addi	$s6,	$s6,	1
		addi	$s7,	$s1,	1

		addi	$sp,	$sp,	-32

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s6,	16($sp)
		sw	$s7,	20($sp)
		sw	$t8,	24($sp)
		sw	$ra,	28($sp)

		move	$a0,	$s0
		move	$a1,	$s7
		move	$a2,	$s2

		jal	get_cell

		lw	$ra,	28($sp)
		lw	$t8,	24($sp)
		lw	$s7,	20($sp)
		lw	$s6,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	32

		move	$t6,	$v0
		andi	$t6,	$t6,	0x7F

		beq	$t6,	'.',	check_visited_or_not1

		j	forEachLoop

check_visited_or_not1:


		lbu	$t0,	1($s0)

		mult	$t0,	$s7
		mflo	$t1
		add	$t1,	$t1,	$s2
		li	$t3,	32
		div	$t1,	$t3
		mflo	$t1		# Q
		mfhi	$t2		# R
		sll	$t1,	$t1,	2			# Quetient x 4
		#add	$t8,	$t8,	$t1
		add	$t9,	$t8,	$t1			# t9 is temp contains which word to go to

		lw	$t4,	0($t9)				# loading the word in same rejister
		sub	$t2,	$t3,	$t2			# $t2 = 32 - remainder
		srlv	$t3,	$t4,	$t2			# doing srlv

		andi	$t3,	$t3,	0x1
		beq	$t3,	1,	forEachLoop
		ori	$t3,	$t3,	0x1
		sllv	$t3,	$t3,	$t2
		lw	$t4,	0($t9)
		or	$t4,	$t4,	$t3
		sw	$t4,	($t9)

		addi	$sp,	$sp,	-8
		sw	$s7,	0($sp)
		sw	$s2,	4($sp)


		j	forEachLoop

case_3_forEach:
		addi	$s6,	$s6,	1

		addi	$s7,	$s2,	-1

		addi	$sp,	$sp,	-32

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s6,	16($sp)
		sw	$s7,	20($sp)
		sw	$t8,	24($sp)
		sw	$ra,	28($sp)

		move	$a0,	$s0
		move	$a1,	$s1
		move	$a2,	$s7

		jal	get_cell

		lw	$ra,	28($sp)
		lw	$t8,	24($sp)
		lw	$s7,	20($sp)
		lw	$s6,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	32

		move	$t6,	$v0
		andi	$t6,	$t6,	0x7F
		beq	$t6,	'.',	check_visited_or_not11

		j	forEachLoop


check_visited_or_not11:


		lbu	$t0,	1($s0)
		mult	$t0,	$s1
		mflo	$t1
		add	$t1,	$t1,	$s7
		li	$t3,	32
		div	$t1,	$t3
		mflo	$t1		# Q
		mfhi	$t2		# R
		sll	$t1,	$t1,	2			# Quetient x 4
		#add	$t8,	$t8,	$t1
		add	$t9,	$t8,	$t1			# t9 is temp contains which word to go to
		lw	$t4,	0($t9)				# loading the word in same rejister
		sub	$t2,	$t3,	$t2			# $t2 = 32 - remainder
		srlv	$t3,	$t4,	$t2			# doing srlv
		andi	$t3,	$t3,	0x1
		beq	$t3,	1,	forEachLoop
		ori	$t3,	$t3,	0x1
		sllv	$t3,	$t3,	$t2
		lw	$t4,	0($t9)
		or	$t4,	$t4,	$t3
		sw	$t4,	($t9)

		addi	$sp,	$sp,	-8
		sw	$s1,	0($sp)
		sw	$s7,	4($sp)


		j	forEachLoop


case_4_forEach:
		addi	$s6,	$s6,	1

		addi	$s7,	$s2,	1

		addi	$sp,	$sp,	-32

		sw	$s0,	0($sp)
		sw	$s1,	4($sp)
		sw	$s2,	8($sp)
		sw	$s3,	12($sp)
		sw	$s6,	16($sp)
		sw	$s7,	20($sp)
		sw	$t8,	24($sp)
		sw	$ra,	28($sp)

		move	$a0,	$s0
		move	$a1,	$s1
		move	$a2,	$s7

		jal	get_cell

		lw	$ra,	28($sp)
		lw	$t8,	24($sp)
		lw	$s7,	20($sp)
		lw	$s6,	16($sp)
		lw	$s3,	12($sp)
		lw	$s2,	8($sp)
		lw	$s1,	4($sp)
		lw	$s0,	0($sp)

		addi	$sp,	$sp,	32

		move	$t6,	$v0
		andi	$t6,	$t6,	0x7F

		beq	$t6,	'.',	check_visited_or_not111

		j	forEachLoop

check_visited_or_not111:

		lbu	$t0,	1($s0)
		mult	$t0,	$s1
		mflo	$t1
		add	$t1,	$t1,	$s7
		li	$t3,	32
		div	$t1,	$t3
		mflo	$t1		# Q
		mfhi	$t2		# R
		sll	$t1,	$t1,	2			# Quetient x 4
		#add	$t8,	$t8,	$t1
		add	$t9,	$t8,	$t1			# t9 is temp contains which word to go to
		lw	$t4,	0($t9)				# loading the word in same rejister
		sub	$t2,	$t3,	$t2			# $t2 = 32 - remainder
		srlv	$t3,	$t4,	$t2			# doing srlv
		andi	$t3,	$t3,	0x1
		beq	$t3,	1,	forEachLoop
		ori	$t3,	$t3,	0x1
		sllv	$t3,	$t3,	$t2
		lw	$t4,	0($t9)
		or	$t4,	$t4,	$t3
		sw	$t4,	($t9)
		addi	$sp,	$sp,	-8
		sw	$s1,	0($sp)
		sw	$s7,	4($sp)


		j	forEachLoop

endforeach:
		j	whileLoop1111

endWhile:
		li	$v0,	0
		jr 	$ra

part11Failed:
		li	$v0,	-1
		jr 	$ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
