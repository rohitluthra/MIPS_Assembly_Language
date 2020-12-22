

.text

# ------------------------------------------------------------------------ Part I ------------------------------------------------------------------------
get_adfgvx_coords:

	move	$t0,	$a0				# storing first argument
	move	$t1,	$a1				# storing second arguments

	li	$t4,	0
	li	$t5,	0

	blt	$t0,	$zero,	partFirstFailed
	bgt	$t1,	5,	partFirstFailed

firstStep:
	beq	$t0,	0,	caseZero
	beq	$t0,	1,	caseOne
	beq	$t0,	2,	caseTwo
	beq	$t0,	3,	caseThree
	beq	$t0,	4,	caseFour
	beq	$t0,	5,	caseFive
	j	partFirstFailed

secondStep:

	beq	$t1,	0,	caseZero0
	beq	$t1,	1,	caseOne1
	beq	$t1,	2,	caseTwo2
	beq	$t1,	3,	caseThree3
	beq	$t1,	4,	caseFour4
	beq	$t1,	5,	caseFive5
	j	partFirstFailed

caseZero:
	li	$t4,	'A'
	j secondStep
caseOne:
	li	$t4,	'D'
	j secondStep
caseTwo:
	li	$t4,	'F'
	j secondStep
caseThree:
	li	$t4,	'G'
	j secondStep
caseFour:
	li	$t4,	'V'
	j secondStep
caseFive:
	li	$t4,	'X'
	j secondStep
#-------------------------------
caseZero0:
	li	$t5,	'A'
	j doneFirstPart
caseOne1:
	li	$t5,	'D'
	j doneFirstPart
caseTwo2:
	li	$t5,	'F'
	j doneFirstPart
caseThree3:
	li	$t5,	'G'
	j doneFirstPart
caseFour4:
	li	$t5,	'V'
	j doneFirstPart
caseFive5:
	li	$t5,	'X'
	j doneFirstPart

doneFirstPart:

	add	$v0,	$zero,	$t4
	add	$v1,	$zero,	$t5

	jr	$ra

partFirstFailed:
	li	$v0,	-1
	li 	$v1,	-1

	jr 	$ra

#------------------------------------------------------------------------ Part II ------------------------------------------------------------------------
search_adfgvx_grid:
	move	$t0,	$a0				# storing first argument
	move	$t1,	$a1				# storing second arguments

checkingInitial:

	blt	$t1,	48,	notFound
	blt	$t1,	65,	checkIfGT57
	j	checkingInitial2

checkIfGT57:
	bgt	$t1,	57,	notFound

checkingInitial2:
	bgt	$t1,	90,	notFound

	li	$t3,	6      				# number of rows/colomn
        li	$t5,	0				# row count
        li	$t6, 	0				# column count

loop:
	mult	$t3,	$t5
        mflo	$t8
        add	$t9,	$t6,	$t8
  	add	$t2,	$t0,	$t9			# base address + ElemSize (i*c + j)

  	lb	$t4,	0($t2)
  	beq	$t4,	$t1,	doneWithPartTwo

        addi	$t6,	$t6,	1   			# increment column counter
        bne	$t3,	$t6,	loop 			# not at end of row sooo go loop back

        move	$t6,	$zero     			# reset column count

        addi	$t5,	$t5,	1   			# increment row count
        bne	$t5,	$t3,	loop			# not at end sssooo loop back

	j notFound

doneWithPartTwo:

	add	$v0,	$zero,	$t5
	add	$v1,	$zero,	$t6
	jr	$ra

notFound:
	li	$v0,	-1
	li 	$v1,	-1

	jr 	$ra

#------------------------------------------------------------------------ Part III ------------------------------------------------------------------------
map_plaintext:
	addi	$sp,	$sp,	-12		# STORING S REGISTERS ON STACK BEFORE STARTING WITH PROGRAM
	sw	$s0,	0($sp)
	sw	$s1,	4($sp)
	sw	$s2,	8($sp)
	sw	$ra,	12($sp)

	move	$s0,	$a0			# matrix
	move	$s1,	$a1			# the message
	move	$s2,	$a2			# middle text buffer

	lb	$s3,	1($s2)
	beq	$s3,	0,	doneWithPartThree

loopPart3:					# THIS IS THE LOOP WHICH WILL GO AROUND PLAIN TEXT
	lb	$t9,	0($s1)
	beq	$t9,	0,	doneWithPartThree

	addi	$sp,	$sp,	-12
	sw	$s0,	0($sp)
	sw	$s1,	4($sp)
	sw	$s2,	8($sp)
	sw	$ra,	12($sp)

	# this is going to part 2
	move	$a0,	$s0
	lb	$a1,	0($s1)

	jal	search_adfgvx_grid			# PART 2

	# this is going to part 1
	move	$a0,	$v0
	move	$a1,	$v1

	lw	$ra,	12($sp)
	lw	$s2,	8($sp)
	lw	$s1,	4($sp)
	lw	$s0,	0($sp)
	addi	$sp,	$sp,	12

	addi	$sp,	$sp,	-12
	sw	$s0,	0($sp)
	sw	$s1,	4($sp)
	sw	$s2,	8($sp)
	sw	$ra,	12($sp)

	jal	get_adfgvx_coords			# PART 1

	move	$t0,	$v0
	move	$t1,	$v1

	lw	$ra,	12($sp)
	lw	$s2,	8($sp)
	lw	$s1,	4($sp)
	lw	$s0,	0($sp)
	addi	$sp,	$sp,	12

	lb	$s3,	0($s2)				# just check if there are more stars to store values at middle buffer
	beq	$s3,	0,	doneWithPartThree

	sb	$t0,	0($s2)				# UPDATING THE VALUES OF MIDDLETEXT BUFFER
	sb	$t1,	1($s2)

	addi	$s2,	$s2,	2			# INCREMENTING
	addi	$s1,	$s1,	1

	j	loopPart3				# JUMP BACK

doneWithPartThree:

	lw	$ra,	12($sp)				# RESTORING S REGISTERS OFF THE STACK BEFORE ENDING WITH PROGRAM
	lw	$s2,	8($sp)
	lw	$s1,	4($sp)
	lw	$s0,	0($sp)
	addi	$sp,	$sp,	12

	jr	$ra

partThreeFailed:					#
	jr	$ra


# ------------------------------------------------------------------------ Part IV ------------------------------------------------------------------------
swap_matrix_columns:


		move	$t0,	$a0				# matrix
		move	$t1,	$a1				# number of rows
		move	$t2,	$a2				# number of colomns
		move	$t3,	$a3				# colomn 1
		lw	$t4,	0($sp)				# colomn 2
		li	$t5,	0				# loop helper


		blez	$t1,		partfourFailed		# the following are cases of failure
		blez	$t2,		partfourFailed
		bltz 	$t3,		partfourFailed
		bge 	$t3,	$t2,	partfourFailed
		bge 	$t4,	$t2,	partfourFailed
		bltz	$t4,		partfourFailed


		add	$t8,	$t0,	$t4			# this gives me colomn 2
		add	$s1,	$zero,	$t8			# this is extra copy of the address of c2
		add	$s3,	$zero,	$t8			# this is extra copy of the address of c2

		add	$t7,	$t0,	$t3			# this gives me colomn 1
		add	$s0,	$zero,	$t7
		add	$s2,	$zero,	$t7			# this is extra copy of the address of c1

		sub	$sp,	$sp,	$t3			# adding colomn number of spaces on the stack

loopFourPart1:							# this put the second colomn on the stack
		beq	$t5,	$t1,	loopFourPart2
		lb	$t9,	0($t8)
		sb	$t9,	0($sp)
		addi	$sp,	$sp,	1
		addi	$t5,	$t5,	1
		add	$t8,	$t8,	$t2
		j loopFourPart1


loopFourPart2:							# setting value of counter again to 0 so it can be reused.
		li	$t5,	0

loopFourPart2Continue:						# this part changes values of second colomn to first colomn values
		beq	$t5,	$t1,	loopFourPart3
		lb	$s4,	0($s0)
		sb	$s4,	0($s1)
		addi	$t5,	$t5,	1
		add	$s1,	$s1,	$t2
		add	$s0,	$s0,	$t2

		j loopFourPart2Continue

loopFourPart3:							# setting value of counter again to 0 so it can be reused. and also updates the value of stack and current pointer of first colomn values(which was in use in loop part 2)
		li	$t5,	0
		sub	$s0,	$s0,	$t2
		addi	$sp,	$sp,	-1

loopFourPart3Continue:						# this pops out the values from stack and places them accordingly from bottom to up in first colomn
		beq	$t5,	$t1,	partfourPassed
		lb	$s3,	0($sp)
		sb	$s3,	0($s0)
		addi	$t5,	$t5,	1
		sub	$s0,	$s0,	$t2
		addi	$sp,	$sp,	-1
		j loopFourPart3Continue

partfourFailed:
		li	$v0,	-1
		jr 	$ra

partfourPassed:
		addi	$sp,	$sp,	1			# This makes sures if the stack pointer is up to date
		add	$sp,	$sp,	$t3

		li	$v0,	0
		jr 	$ra


# ------------------------------------------------------------------------ Part V ------------------------------------------------------------------------
key_sort_matrix:

		move	$t0,	$a0					# matrix
		move	$t1,	$a1					# number of rows
		move	$t2,	$a2					# number of colomns
		move	$t3,	$a3					# key matrix

		blez	$t1,	bubblesortEnd
		blez	$t2,	bubblesortEnd

		add	$s4,	$zero,	$t3

		lw	$t4,	0($sp)					# element Size

		li	$t5,	0					# loop counter 1
		li	$t6,	0					# loop counter 2
		li	$s1,	0					# loop counter 2

		beq	$t4,	4,	alternativeOption

bubbleSortPart1:

		beq 	$t5,	$t2,	bubblesortEnd
		sub	$t7,	$t2,	$t5				# (n - i)
		addi	$t7,	$t7,	-1				# ( (n - i) - 1 )

bubbleSortPart2:

		beq	$t6,	$t7,	incrementPart1
		addi	$s1,	$t6,	1
		lb	$t8,	0($t3)					# A[j]
		lb	$t9,	1($t3)					# A[ j + 1 ]
		bge	$t9,	$t8,	 incrementPart2
		addi	$sp,	$sp,	-48

		sw	$s1,	0($sp)
		sw	$t1,	4($sp)
		sw	$t2,	8($sp)
		sw	$t3,	12($sp)
		sw	$t4,	16($sp)
		sw	$t5,	20($sp)
		sw	$t6,	24($sp)
		sw	$t7,	28($sp)
		sw	$t8,	32($sp)
		sw	$t9,	36($sp)
		sw	$s4,	40($sp)
		sw	$ra,	44($sp)
		sw	$t0,	48($sp)

		move	$a3,	$t6

		jal	swap_matrix_columns

		lw	$t0,	48($sp)
		lw	$ra,	44($sp)
		lw	$s4,	40($sp)
		lw	$t9,	36($sp)
		lw	$t8,	32($sp)
		lw	$t7,	28($sp)
		lw	$t6,	24($sp)
		lw	$t5,	20($sp)
		lw	$t4,	16($sp)
		lw	$t3,	12($sp)
		lw	$t2,	8($sp)
		lw	$t1,	4($sp)
		lw	$s1,	0($sp)

		addi	$sp,	$sp,	48

		add	$s0,	$zero,	$t8
		sb	$t9,	0($t3)
		sb	$s0,	1($t3)

incrementPart2:

		addi	$t3,	$t3,	1
		addi	$t6,	$t6,	1

		j	bubbleSortPart2

incrementPart1:

		addi	$t5,	$t5,	1
		li	$t6,	0
		li	$t7,	0
		move	$t3,	$s4
		j	bubbleSortPart1

bubblesortEnd:

		jr	$ra

alternativeOption:


bubbleSortPart1A:

		beq 	$t5,	$t2,	bubblesortEndA
		sub	$t7,	$t2,	$t5				# (n - i)
		addi	$t7,	$t7,	-1				# ( (n - i) - 1 )

bubbleSortPart2A:

		beq	$t6,	$t7,	incrementPart1A

		addi	$s1,	$t6,	1

		lw	$t8,	0($t3)					# A[j]
		lw	$t9,	4($t3)					# A[ j + 1 ]

		bge	$t9,	$t8,	 incrementPart2A

		addi	$sp,	$sp,	-48

		sw	$s1,	0($sp)
		sw	$t1,	4($sp)
		sw	$t2,	8($sp)
		sw	$t3,	12($sp)
		sw	$t4,	16($sp)
		sw	$t5,	20($sp)
		sw	$t6,	24($sp)
		sw	$t7,	28($sp)
		sw	$t8,	32($sp)
		sw	$t9,	36($sp)
		sw	$s4,	40($sp)
		sw	$ra,	44($sp)
		sw	$t0,	48($sp)

		move	$a3,	$t6

		jal	swap_matrix_columns

		lw	$t0,	48($sp)
		lw	$ra,	44($sp)
		lw	$s4,	40($sp)
		lw	$t9,	36($sp)
		lw	$t8,	32($sp)
		lw	$t7,	28($sp)
		lw	$t6,	24($sp)
		lw	$t5,	20($sp)
		lw	$t4,	16($sp)
		lw	$t3,	12($sp)
		lw	$t2,	8($sp)
		lw	$t1,	4($sp)
		lw	$s1,	0($sp)

		addi	$sp,	$sp,	48

		add	$s0,	$zero,	$t8
		sw	$t9,	0($t3)
		sw	$s0,	4($t3)

incrementPart2A:
		addi	$t3,	$t3,	4
		addi	$t6,	$t6,	1

		j	bubbleSortPart2A

incrementPart1A:
		addi	$t5,	$t5,	1
		li	$t6,	0
		li	$t7,	0
		move	$t3,	$s4
		j	bubbleSortPart1A

bubblesortEndA:
		jr	$ra

# ------------------------------------------------------------------------ Part VI ------------------------------------------------------------------------
transpose:
		move	$t0,	$a0					# matrix source

		move	$t1,	$a1					# destination
		move	$t2,	$a2					# number of rows
		move	$t3,	$a3					# number of columns

		li	$t6,	0					# colomn counter j
		li	$t5,	0
		li	$t4,	0					# current row

		blez	$t2,	failedPart6
		blez	$t3,	failedPart6

		lb	$s0,	0($t1)
		beq	$s0,	0,	endPart6

loopPart6:

		beq	$t6,	$t3,	endPart6

		mult	$t4,	$t3
		mflo	$t7

		add	$t7,	$t7,	$t6
		add	$t8,	$t0,	$t7

		beq	$t5,	$t2,	loopNextColomn

		lb	$t9,	0($t8)
		sb	$t9,	0($t1)

		addi	$t4,	$t4,	1

		addi	$t1,	$t1,	1
		addi	$t5,	$t5,	1

		lb	$s0,	0($t1)
		beq	$s0,	0,	endPart6

		j	loopPart6

loopNextColomn:

		addi	$t6,	$t6,	1
		li	$t4,	0
		li	$t5,	0

		j	loopPart6

endPart6:
		li	$v0,	0
		jr	$ra

failedPart6:
		li	$v0,	-1
		jr	$ra


#------------------------------------------------------------------------  Part VII ------------------------------------------------------------------------
encrypt:

		move	$t0,	$a0				# ADFGVX grid - Array
		move	$t1,	$a1				# Plain Text
		move	$t2,	$a2				# Keyword
		move	$t3,	$a3				# Cipher Text - Array

		li	$t5,	0				# length of plain text
		li	$t6,	0				# length of keyword

		li	$s1,	1				# when going to part 2 elemsize is 1 by default

LengthOfPlainText:
		lb	$s0,	0($t1)
		beqz	$s0,	LengthOfKeyword
		addi	$t1,	$t1,	1
		addi	$t5,	$t5,	1

		j	LengthOfPlainText

LengthOfKeyword:
		lb	$s0,	0($t2)
		beqz	$s0,	LengthFound
		addi	$t2,	$t2,	1
		addi	$t6,	$t6,	1

		j	LengthOfKeyword

LengthFound:
		move	$t1,	$a1				# Plain Text
		move	$t2,	$a2				# Keyword
		li	$t4,	0

		sll	$s0,	$t5,	1
		div	$s0,	$t6
		mfhi	$t8							# remainder
		mflo	$t9							# Quotient
		blez 	$t8,	moveAhead11
		addi	$t9,	$t9,	1					# this is the length of Keyword

moveAhead11:
		mult	$t9,	$t6
		mflo	$s0

		move	$a0,	$s0				# for allocating Heap Memory
		li	$v0,	9
		syscall

		move	$t7,	$v0
		li	$t8,	'*'

setNewArrayTo:

		beq	$t4,	$s0,	initializedHeap
		sb	$t8,	0($t7)

		addi	$t7,	$t7,	1
		addi	$t4,	$t4,	1

		j	setNewArrayTo

initializedHeap:
		#li	$t8,	'\n'
		#sb	$t8,	0($t7)

		move	$t7,	$v0

		addi	$sp,	$sp,	-36					# PART 1 START

		sw	$t0,	0($sp)
		sw	$t1,	4($sp)
		sw	$t2,	8($sp)
		sw	$t3,	12($sp)
		sw	$t4,	16($sp)
		sw	$t5,	20($sp)
		sw	$t6,	24($sp)
		sw	$t8,	28($sp)
		sw	$t9,	32($sp)
		sw	$ra,	36($sp)

		move	$a0,	$t0						# ADFGVX GRID
		move	$a1,	$t1						# PLAIN TEXT
		move	$a2,	$t7						# MIDDLETEXT BUFFER FROM HEAP

		jal	map_plaintext

		lw	$ra,	36($sp)
		lw	$t9,	32($sp)
		lw	$t8,	28($sp)
		lw	$t6,	24($sp)
		lw	$t5,	20($sp)
		lw	$t4,	16($sp)
		lw	$t3,	12($sp)
		lw	$t2,	8($sp)
		lw	$t1,	4($sp)
		lw	$t0,	0($sp)

		addi	$sp,	$sp,	36					# PART 1 END

		addi	$sp,	$sp,	-44					# PART 2 START

		sw	$s1,	0($sp)
		sw	$t1,	4($sp)
		sw	$t2,	8($sp)
		sw	$t3,	12($sp)
		sw	$t4,	16($sp)
		sw	$t5,	20($sp)
		sw	$t6,	24($sp)
		sw	$t7,	28($sp)
		sw	$t0,	32($sp)
		sw	$t8,	36($sp)
		sw	$t9,	40($sp)
		sw	$ra,	44($sp)

		move	$a0,	$t7						# heap Array

		move	$a1,	$t9						# number of rows
		move	$a2,	$t6						# number of colomns
		move	$a3,	$t2						# keyword
										# elemnent size is on stack
		jal	key_sort_matrix

		lw	$ra,	44($sp)
		lw	$t9,	40($sp)
		lw	$t8,	36($sp)
		lw	$t0,	32($sp)
		lw	$t7	28($sp)
		lw	$t6,	24($sp)
		lw	$t5,	20($sp)
		lw	$t4,	16($sp)
		lw	$t3,	12($sp)
		lw	$t2,	8($sp)
		lw	$t1,	4($sp)
		lw	$s1,	0($sp)

		addi	$sp,	$sp,	44					# PART 2 END

		addi	$sp,	$sp,	-32					# PART 3 START

		sw	$t0,	0($sp)
		sw	$t1,	4($sp)
		sw	$t2,	8($sp)
		sw	$t3,	12($sp)
		sw	$t4,	16($sp)
		sw	$t5,	20($sp)
		sw	$t6,	24($sp)
		sw	$t7,	28($sp)
		sw	$ra,	32($sp)

		move	$a0,	$t7						# sorted
		move	$a1,	$t3						# cypher text
		move	$a2,	$t9						# number of rows
		move	$a3,	$t6						# number of colomns

		jal	transpose

		lw	$ra,	32($sp)
		lw	$t7	28($sp)
		lw	$t6,	24($sp)
		lw	$t5,	20($sp)
		lw	$t4,	16($sp)
		lw	$t3,	12($sp)
		lw	$t2,	8($sp)
		lw	$t1,	4($sp)
		lw	$t0,	0($sp)

		addi	$sp,	$sp,	32					# PART 3 END

		jr $ra

# ------------------------------------------------------------------------ Part VIII ------------------------------------------------------------------------
lookup_char:
		move	$t0,	$a0				# this is address
		move	$t1,	$a1				# X
		move	$t2,	$a2				# Y

		li	$t5,	6				# because its a 6x6 matrix

		blt	$t1,	48,	partEightFailed
		blt	$t1,	65,	checkIfGT57z
		j	checkingInitial2z

checkIfGT57z:
		bgt	$t1,	57,	partEightFailed

checkingInitial2z:
		bgt	$t1,	90,	partEightFailed

firstStepz:
		beq	$t1,	'A',	caseZeroz
		beq	$t1,	'D',	caseOnez
		beq	$t1,	'F',	caseTwoz
		beq	$t1,	'G',	caseThreez
		beq	$t1,	'V',	caseFourz
		beq	$t1,	'X',	caseFivez
		j	partEightFailed

secondStepz:

		beq	$t2	'A',	caseZero0z
		beq	$t2,	'D',	caseOne1z
		beq	$t2,	'F',	caseTwo2z
		beq	$t2,	'G',	caseThree3z
		beq	$t2,	'V',	caseFour4z
		beq	$t2,	'X',	caseFive5z
		j	partEightFailed

caseZeroz:
		li	$t3,	0
		j secondStepz
caseOnez:
		li	$t3,	1
		j secondStepz
caseTwoz:
		li	$t3,	2
		j secondStepz
caseThreez:
		li	$t3,	3
		j secondStepz
caseFourz:
		li	$t3,	4
		j secondStepz
caseFivez:
		li	$t3,	5
		j secondStepz
#-------------------------------
caseZero0z:
		li	$t4,	0
		j doneFirstPartz
caseOne1z:
		li	$t4,	1
		j doneFirstPartz
caseTwo2z:
		li	$t4,	2
		j doneFirstPartz
caseThree3z:
		li	$t4,	3
		j doneFirstPartz
caseFour4z:
		li	$t4,	4
		j doneFirstPartz
caseFive5z:
		li	$t4,	5
		j doneFirstPartz

doneFirstPartz:
		mult	$t3,	$t5
		mflo	$t6
		add	$t6,	$t6,	$t4
		add	$t7,	$t0,	$t6

		lb	$t7,	0($t7)

partEightPassed:
		li	$v0,	0
		add	$v1,	$zero,	$t7
		jr	$ra

partEightFailed:
		li	$v0,	-1
		li	$v1,	-1
		jr	$ra


# ------------------------------------------------------------------------ Part IX ------------------------------------------------------------------------
string_sort:


		move	$t0,	$a0				# word
		move	$t1,	$a0				# copy of word
		li	$t6,	0 				# length
		li	$t2,	0				# counter for outer loop
		li	$t5,	0				# counter for inner loop

LengthOfKeywordPart9:
		lb	$s0,	0($t0)
		beqz	$s0,	resetValues
		addi	$t0,	$t0,	1
		addi	$t6,	$t6,	1
		j	LengthOfKeywordPart9

resetValues:
		move	$t0,	$t1

BSP1:
		beq	$t2,	$t6,	PartNineFinished
		sub	$t3,	$t6,	$t2
		addi	$t3,	$t3,	-1

BSP2:
		beq	$t5,	$t3,	IncrementOuterLoop
		lb	$t8,	0($t0)
		lb	$t9,	1($t0)
		bge	$t9,	$t8,	IncrementInnerLoop
		add	$t7,	$zero,	$t8
		sb	$t9,	0($t0)
		sb	$t7,	1($t0)


IncrementInnerLoop:
		addi	$t5,	$t5,	1
		addi	$t0,	$t0,	1
		j BSP2

IncrementOuterLoop:
		li	$t5,	0
		addi	$t2,	$t2,	1
		move	$t0,	$t1
		j	BSP1

PartNineFinished:
		jr	$ra

PartNineFailed:
		jr	$ra

# ------------------------------------------------------------------------ Part X ------------------------------------------------------------------------
decrypt:


		move	$t0,	$a0				# ADFGVX grid
		move	$s7,	$a0
		move	$t1,	$a1				# Cipher text
		move	$t2,	$a2				# keyword

		move	$t3,	$a3				# plain text

		li	$t8,	0				# length of plain TExt
		li	$t9,	0				# length of keyword
		li	$t5,	0				#counter


LengthOfPlainTextTenth:
		lb	$s0,	0($t3)
		beqz	$s0,	LengthOfKeywordT
		addi	$t3,	$t3,	1
		addi	$t8,	$t8,	1
		j	LengthOfPlainTextTenth

LengthOfKeywordT:
		move	$t3,	$a3						# plain text

LengthOfKeywordTenth:
		lb	$s0,	0($t2)
		beqz	$s0,	LengthFoundT
		addi	$t2,	$t2,	1
		addi	$t9,	$t9,	1

		j	LengthOfKeywordTenth

LengthFoundT:
		move	$t2,	$a2						# keyword
		add	$a0,	$zero,	$t9					# copy of keyword
		li	$v0,	9
		syscall

		move	$t4,	$v0						# Heap_Keyword
		add	$s0,	$zero,	$t4
		move	$s2,	$v0						# extra copy of above

loopforCopyingKeyword:								# this whole step copies keywrd to a newly heap generated address

		beq	$t5,	$t9,	lengthCopied
		lb	$s0,	0($t2)
		sb	$s0,	0($t4)
		addi	$t5,	$t5,	1
		addi	$t2,	$t2,	1
		addi	$t4,	$t4,	1

		j	loopforCopyingKeyword

lengthCopied:
		sub	$t4,	$t4,	$t5
		sub	$t2,	$t2,	$t5
		move	$t2,	$a2						# keyword

		addi	$sp,	$sp,	-40

		sw	$t0,	0($sp)
		sw	$t1,	4($sp)
		sw	$t2,	8($sp)
		sw	$t3,	12($sp)
		sw	$t9,	16($sp)
		sw	$t5,	20($sp)
		sw	$s0,	24($sp)
		sw	$t8,	28($sp)
		sw	$s7,	32($sp)
		sw	$s5,	36($sp)
		sw	$ra,	40($sp)

		move	$a0,	$v0
		jal	string_sort						# Heap_Keyword

		lw	$ra,	40($sp)
		lw	$s5,	36($sp)
		lw	$s7,	32($sp)
		lw	$t8,	28($sp)
		lw	$s0,	24($sp)
		lw	$t5,	20($sp)
		lw	$t9,	16($sp)
		lw	$t3,	12($sp)
		lw	$t2,	8($sp)
		lw	$t1,	4($sp)
		lw	$t0,	0($sp)

		addi	$sp,	$sp,	36

		sll	$t6,	$t9	2					# as int is word and word is 4 bytes each
		add	$a0,	$zero,	$t6
		li	$v0,	9
		syscall

		move	$s1,	$v0						# Heap_KeyWord_Indices

		li	$t5,	0
		li	$t7,	0

loopPartTenth:									# for (int i = 0; i < i len(keyword); i++)
											 # heap_keyword_indices[i] = keyword.index_of(heap_keyword[i])
		beq	$t5,	$t9,	OutTenth

innneerr:
		lb	$s3,	0($t4)
		lb	$s0,	0($t2)
		beq	$s0,	$s3,	nextLoopPartTenth
		addi	$t7,	$7,	1
		addi	$t2,	$t2,	1

		j	innneerr

nextLoopPartTenth:

		sw	$t7,	0($s1)
		li	$t7,	0
		addi	$t5,	$t5,	1
		addi	$t4,	$t4,	1
		addi	$s1,	$s1,	4
		move	$t2,	$s5

		j	loopPartTenth

OutTenth:
		li	$t6,	0

LengthOfCipherTExtTenth:
		lb	$s0,	0($t1)
		beqz	$s0,	Doneeeeeee
		addi	$t1,	$t1,	1
		addi	$t6,	$t6,	1
		j	LengthOfCipherTExtTenth


Doneeeeeee:
		sub	$t1,	$t1,	$t6				# Cipher text

		div	$t6,	$t9
		mfhi	$s0							# remainder
		mflo	$t5							# Quotient
		blez 	$s0,	moveAhead111111
		addi	$t5,	$t5,	1					# colomns of cipher

moveAhead111111:

		add	$a0,	$zero,	$t6

		li	$v0,	9
		syscall
		move	$s4,	$v0						# heap_Cypher_Text_ array

		li	$s0,	'*'
		li	$t8,	0
setNewArrayTo111:

		beq	$t8,	$t6,	initializedHeap111
		sb	$s0,	0($s4)

		addi	$s4,	$s4,	1
		addi	$t8,	$t8,	1

		j	setNewArrayTo111
initializedHeap111:
		sub	$s4,	$s4,	$t8

		addi	$sp,	$sp,	-56

		sw	$t0,	0($sp)
		sw	$t1,	4($sp)
		sw	$t2,	8($sp)
		sw	$t3,	12($sp)
		sw	$t4,	16($sp)
		sw	$t5,	20($sp)
		sw	$t6,	24($sp)
		sw	$t7,	28($sp)
		sw	$t8,	32($sp)
		sw	$t9,	36($sp)
		sw	$s1,	40($sp)
		sw	$s2,	44($sp)
		sw	$s3,	48($sp)
		sw	$s7,	52($sp)
		sw	$ra,	56($sp)

		move	$a0,	$t1					# matrix source
		move	$a1,	$s4					# destination
		move	$a2,	$t5					# number of rows
		move	$a3,	$t9					# number of columns

		jal transpose

		lw	$ra,	56($sp)
		lw	$s7,	52($sp)
		lw	$s3,	48($sp)
		lw	$s2,	44($sp)
		lw	$s1,	40($sp)
		lw	$t9,	36($sp)
		lw	$t8,	32($sp)
		lw	$t7	28($sp)
		lw	$t6,	24($sp)
		lw	$t5,	20($sp)
		lw	$t4,	16($sp)
		lw	$t3,	12($sp)
		lw	$t2,	8($sp)
		lw	$t1,	4($sp)
		lw	$t0,	0($sp)

		addi	$sp,	$sp,	56

		addi	$sp,	$sp,	-56

		sw	$t0,	0($sp)
		sw	$t1,	4($sp)
		sw	$t2,	8($sp)
		sw	$t3,	12($sp)
		sw	$t4,	16($sp)
		sw	$t5,	20($sp)
		sw	$t6,	24($sp)
		sw	$t7,	28($sp)
		sw	$t8,	32($sp)
		sw	$t9,	36($sp)
		sw	$s1,	40($sp)
		sw	$s2,	44($sp)
		sw	$s3,	48($sp)
		sw	$s7,	52($sp)
		sw	$ra,	56($sp)

		move	$a0,	$s4					# matrix
		move	$a1,	$t9					# number of rows
		move	$a2,	$t5					# number of colomns
		move	$a3,	$s1					# key matrix

		jal key_sort_matrix


		lw	$ra,	56($sp)
		lw	$s7,	52($sp)
		lw	$s3,	48($sp)
		lw	$s2,	44($sp)
		lw	$s1,	40($sp)
		lw	$t9,	36($sp)
		lw	$t8,	32($sp)
		lw	$t7	28($sp)
		lw	$t6,	24($sp)
		lw	$t5,	20($sp)
		lw	$t4,	16($sp)
		lw	$t3,	12($sp)
		lw	$t2,	8($sp)
		lw	$t1,	4($sp)
		lw	$t0,	0($sp)

		addi	$sp,	$sp,	56

		li	$t6,0
LengthOfCipherTExtTenth1:
		lb	$s0,	0($t1)
		beqz	$s0,	Doneeeeeee1
		addi	$t1,	$t1,	1
		addi	$t6,	$t6,	1
		j	LengthOfCipherTExtTenth1


Doneeeeeee1:

loopOverheap_Cypher_Text_array:

		beqz	$t6,	doneWithParttenthfinallyy

		addi	$sp,	$sp,	-52
		sw	$t0,	0($sp)
		sw	$t1,	4($sp)
		sw	$t2,	8($sp)
		sw	$t3,	12($sp)
		sw	$t4,	16($sp)
		sw	$t5,	20($sp)
		sw	$t6,	24($sp)
		sw	$t7,	28($sp)
		sw	$t8,	32($sp)
		sw	$t9,	36($sp)
		sw	$s1,	40($sp)
		sw	$s2,	44($sp)
		sw	$s3,	48($sp)
		sw	$ra,	52($sp)

		lb	$t8,	0($s4)
		lb	$t9,	1($s4)


		move	$a0,	$s7				# this is address
		move	$a1,	$t8				# X
		move	$a2,	$t9				# Y

		jal lookup_char

		move	$t6,	$v1
		sb	$t6, 0($t3)

		lw	$ra,	52($sp)
		lw	$s3,	48($sp)
		lw	$s2,	44($sp)
		lw	$s1,	40($sp)
		lw	$t9,	36($sp)
		lw	$t8,	32($sp)
		lw	$t7	28($sp)
		lw	$t6,	24($sp)
		lw	$t5,	20($sp)
		lw	$t4,	16($sp)
		lw	$t3,	12($sp)
		lw	$t2,	8($sp)
		lw	$t1,	4($sp)
		lw	$t0,	0($sp)

		addi	$sp,	$sp,	52
		addi	$t6,	$t6,	-1
		addi	$s4,	$s4,	2
		addi	$t3,	$t3,	1

		j	loopOverheap_Cypher_Text_array


doneWithParttenthfinallyy:

			jr	$ra
#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
