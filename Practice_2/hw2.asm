

.text

 ############################################## Part I ##############################################
index_of_car:
	move	$t4, 	$a0
	move 	$t0, 	$a1				# t0 = length
	move	$t1, 	$a2				# t1 = start Index
	move	$t2, 	$a3 				# t2 = year
	li	$t9,	0				# helps in moving to next index
	li	$t3, 	1885				# t3 = 1885

	ble	$t0, 	$zero, 	partFirstCasesFailed	# if $t0 <= zero,
	blt	$t1,	$zero,	partFirstCasesFailed
	ble	$t0,	$t1, 	partFirstCasesFailed
	ble	$t2,	$t3, 	partFirstCasesFailed		# $t2 < $t3
	li  	$t2,	0					# incrementor

 goToIndex:
	beq	$t9,	$t1,	partFirstLoop
	addi	$t4,	$t4,	16
	addi	$t9,	$t9,	1
	addi 	$t2,	$t2,	1			#increment

	j goToIndex


partFirstLoop:
	lbu	$t1,	12($t4)				#first byte
	lb	$t6,	13($t4)				#second byte
	li	$t7,	256				# storing 256
	mult	$t6,	$t7				# multyplying by 256
	mflo	$t8					#storing multiplication in $t8
	add	$t1,	$t1,	$t8			# adding to find actual year
	beq 	$t1, 	$a3, 	partFirstDone		# if equal, loop ended
	beq  	$t0,	$t2, 	partFirstCasesFailed	# if not found, lopp ends
	addi 	$t2,	$t2,	1			#increment
	addi 	$t4,	$t4,	16			#next car

	j partFirstLoop

partFirstCasesFailed:
	li 	$v0,	-1
	jr 	$ra

partFirstDone:
	move 	$v0,	$t2
	jr 	$ra

 ############################################## Part II ##############################################
strcmp:

	move	$t0,	$a0 				#first string
	lb 	$t2,	0($t0)

	move 	$t1,	$a1				#second String
	lb 	$t3,	0($t1)

	li 	$t4,	0

	beqz 	$t2,	zeroOutputSituation1
	beqz 	$t3,	zeroOutputSituation2

loop:
	beqz 	$t2, 	checkforThree
	beq 	$t2,	$t3, 	nextCharacter
	sub 	$t4,	$t2,	$t3
	j 	loopFinish

zeroOutputSituation1:
	bnez 	$t3,	countLength1
	li 	$v0,	0
	jr 	$ra

zeroOutputSituation2:
	bnez 	$t2,	countLength2
	li 	$v0,	0
	jr 	$ra

countLength1:
	beqz 	$t3,	loopFinish
	addi 	$t4,	$t4,	-1
	addi 	$t1,	$t1,	1
	lb 	$t3,	0($t1)
	j 	countLength1

countLength2:
	beqz 	$t2,	loopFinish
	addi 	$t4,	$t4,	1
	addi 	$t0,	$t0,	1
	lb  	$t2,	0($t0)
	j countLength2

nextCharacter:
	addi 	$t0,	$t0,	1
	lb 	$t2,	0($t0)
	addi 	$t1,	$t1,	1
	lb 	$t3,	0($t1)
	addi 	$t4,	$t4,	1
	j 	loop

checkforThree:
	beqz	$t3,	loopFinish2
	sub 	$t4,	$t2,	$t3
	j 	loopFinish

loopFinish2:
	li 	$v0,	0
	jr 	$ra

loopFinish:
	move	$v0,	$t4
	jr 	$ra

 ############################################## Part III ##############################################
memcpy:
	move 	$t0, 	$a0				# first argument
	move 	$t1, 	$a1				# second argument
	move 	$t2, 	$a2				# Third argument
	li  	$t3,	0 				# incrementor for for loop

	blez 	$t2, 	partThreecasesFailed

copyLoop:
	beq 	$t2,	$t3, 	endLoop
	lbu 	$t4, 	0($t0)				# first byte of source
	sb 	$t4, 	($t1)				# store the first byte to first byte of another string
	addi 	$t0,	$t0,	1
	addi 	$t1,	$t1,	1
	addi 	$t3,	$t3,	1
	j 	copyLoop

endLoop:
	li 	$v0,	0
	jr 	$ra

partThreecasesFailed:
	li 	$v0,	 -1
	jr 	$ra

 ############################################## Part IV ##############################################
insert_car:

	move 	$t0,	$a0					# cars array address
	move 	$t1,	$a1					# length of cars array
	move 	$t2,	$a2					# new car address
	move 	$t3,	$a3					# index to add the new car at
	li 	$t9,	1					# incrmentor
	sub	$t8,	$t1,	$t3
	bltz	$t1,	partFourFailed				# Special Cases
	bltz	$t3,	partFourFailed				# Special Cases
	bgt	$t3,	$t1,	partFourFailed			# Special Cases

goToLastArray:
	beq	$t1,	$t9,	goToPart3			# if at the end of array move to goAheadAddIt
	addi 	$t0,	$t0,	16				# move to next word, uf not at the end
	addi 	$t9,	$t9,	1
	j 	goToLastArray				# jump back to addNewCarAtLastIndex

goToPart3:

	add	$s0,	$zero,	$t2
	add	$s1,	$zero,	$a2
	add	$s2,	$zero,	$t0
	add	$s3,	$zero,	$ra

	beq	$t3,	$t1,	puttinglastCase

	beqz	$t8,	goAheadAddIt

	addi	$sp,	$sp,	-16

	sw	$s0,	($sp)
	sw	$s1,	4($sp)
	sw	$s2,	8($sp)
	sw	$s3,	12($sp)
	sw	$ra,	16($sp)

	addi	$t4,	$t0,	16
	move	$a0,	$t0					# last postion
	move	$a1,	$t4					# blank position
	addi	$a2,	$zero,	16					# index

	jal	memcpy

	lw	$ra,	16($sp)
	lw	$s3,	12($sp)
	lw	$s2,	8($sp)
	lw	$s1,	4($sp)
	lw	$s0,	0($sp)

	addi	$sp,	$sp,	16

	add	$t2,	$zero,	$s0
	add	$a2,	$zero,	$s1
	add	$t0,	$zero,	$s2
	add	$ra,	$zero,	$s3

	addi 	$t8,	$t8,	-1

	beqz	$t8,	goAheadAddIt

	addi	$t0,	$t0,	-16

	j 	goToPart3


puttinglastCase:

	addi	$t0,	$t0,	16
	j 	goAheadAddIt


goAheadAddIt:

	lw 	$t2, 	0($s0)
	sw	$t2,	0($t0)					# store the new car at the last index

	lw 	$t2, 	4($s0)
	sw	$t2,	4($t0)					# store the new car at the last

	lw 	$t2, 	8($s0)
	sw	$t2,	8($t0)					# store the new car at the last

	lbu	$t2,	12($s0)
	sb	$t2,	12($t0)

	lbu	$t2,	13($s0)
	sb	$t2,	13($t0)

	lb	$t2,	14($s0)
	sb	$t2,	14($t0)

	lb	$t2,	15($s0)
	sb	$t2,	15($t0)

	lb	$t2,	16($s0)
	sb	$t2,	16($t0)

partFourSuccessfullyDone:

	li	$v0,	0
	jr 	$ra

partFourFailed:
	li	$v0,	-1
	jr 	$ra

 ############################################## Part V ##############################################
most_damaged:
	move	$s0,	$a0					# all_cars [] address
	move	$s1,	$a1					# repairs [] address
	move	$s2,	$a2					# cars_length
	move	$s3,	$a3					# repairs_length
	li	$t4,	0					# incrmentor
	li	$t7,	0					# for max damage amount.
	blez	$s2,	partFiveCasesFailes			# special cases
	blez	$s3,	partFiveCasesFailes			# special Cases

firstLoop:							# first loop
	beq	$t4,	$s3,	exit				# got to exit when done with entire part 5
	lbu	$t1,	8($s1)					# next 6 lines are calculating cost of each car.
	lbu	$t2,	9($s1)
	li	$t3,	256
	mult	$t3,	$t2
	mflo	$t5
	add	$t6,	$t5,	$t1

	bgt	$t6,	$t7,	currentIsBigger			# if current car cost is bigger than entire max cost, then current will be max.
	j skipNext						# if not is not bigger than simple skip the next statement.

currentIsBigger:
	add	$t7,	$zero,	$t6

skipNext:							# this continues with the first part of the first loop
	addi	$t4,	$t4,	1				# Incrementor of the first loop
	addi	$s5,	$s1,	12				# storing address of next elemnt in array

	addi	$sp,	$sp,	-40				# Storing following on Stack
	sw	$s0,	0($sp)
	sw	$s1,	4($sp)
	sw	$s2,	8($sp)
	sw	$s3,	12($sp)
	sw	$t4,	16($sp)
	sw	$t0,	20($sp)
	sw	$t1,	24($sp)
	sw	$t2,	28($sp)
	sw	$t3,	32($sp)
	sw	$t6,	36($sp)
	sw	$ra,	40($sp)
	jal	oneMoreLoopInitialiser				# Jumping to nested loop, Which will start from curretn + 1 element.
	lw	$ra,	40($sp)					# loadin back from stack
	lw	$t6,	36($sp)
	lw	$t3,	32($sp)
	lw	$t2,	28($sp)
	lw	$t1,	24($sp)
	lw	$t0,	20($sp)
	lw	$t4,	16($sp)
	lw	$s3,	12($sp)
	lw	$s2,	8($sp)
	lw	$s1,	4($sp)
	lw	$s0,	0($sp)
	addi	$sp,	$sp,	40				# storing back space to stack.

	addi	$s1,	$s1,	12				# moving to next element in first loop
	add	$t8,	$t8,	$t6				# calculate total cost of current element in first loop.

	bgt	$t8,	$t7,	make8Bigger			# if biiger then set the new value.
	ble	$t8,	$t7,	valueRemainsSame		# if not then let the old value to stay.

	j firstLoop

make8Bigger:
	add	$t7,	$zero,	$t8
 	j firstLoop

 valueRemainsSame:
 	add	$t7,	$zero,	$t7
 	j firstLoop

oneMoreLoopInitialiser:						# This is the starting of second (nested) loop

	li	$t0,	0
	lw	$s6,	0($s1)					# storing current element in first loop address in s6
	sub	$s0,	$s3,	$t4
	li	$t8,	0					# stores the total value from second loop

oneMoreLoop:							# moving next from initialisation

	beq	$t0,	$s0,	doneWithSecondLoop
	lw	$s7,	0($s5)					#storing current element address in s7 to match with s6

	lbu	$t1,	8($s5)					# next 6 lines are calculating costs for current element.
	lbu	$t2,	9($s5)
	li	$t3,	256
	mult	$t3,	$t2
	mflo	$t5
	add	$t9,	$t5,	$t1

	beq	$s6,	$s7,	addCurrentValueToMax		# if current matches first loop element then, add the value current to previous
	bge	$t9,	$t7,	currentValueIsBigger

	addi	$t0,	$t0,	1				# otherwise, move on to next part.
	addi	$s5,	$s5,	12
	j oneMoreLoop

currentValueIsBigger:
	lw	$s4,	0($s5)
	lw	$s4,	0($s4)
	addi	$t0,	$t0,	1				# otherwise, move on to next part.
	addi	$s5,	$s5,	12
	j oneMoreLoop

addCurrentValueToMax:

	add	$t8,	$t8,	$t9
	addi	$t0,	$t0,	1				# Incrementor
	addi	$s5,	$s5,	12
	j oneMoreLoop

doneWithSecondLoop: 						# when done, move to from where it was called.
	jr	$ra

partFiveCasesFailes:						# otherwise, -1
	li	$v0,	-1
	li	$v1,	-1
	jr	$ra

exit:
	li	$t0,	-1
	li	$t1,	0
lastLoop:

	lw	$t1,	0($a0)
	beq	$s4,	$t1,	finishPartFive
	add	$t6,	$zero,	$t1
	addi	$t1,	$zero,	0

	addi	$t0,	$t0,	1
	addi	$a0,	$a0,	16
	j lastLoop

finishPartFive:

	add	$v0,	$zero,	$t0
	add	$v1,	$zero,	$t7
	jr 	$ra


 ############################################## Part VI ##############################################
sort:

	li	$t9,	1			# while Loop helper

	move	$s0,	$a0
	move	$s7,	$a0
	move	$s2,	$a0

	move	$s1,	$a1
	addi	$t1,	$s1,	-1
	add	$s3,	$zero,	$t1

	blez 	$t1,	partSixFailed


whileLoop:
	beqz	$t9,	partSixFinished
	li	$t9,	0
	li	$t0,	1			# incrementor

initialisingFirstLoop:
	add	$s0,	$zero,	$s2
	addi 	$s0,	$s0,	16
	add	$t1,	$zero,	$s3

firstPartLoop:
	bge	$t0,	$t1,	doneWithFirstNowSecondLoopPart1

	addi	$t5,	$s0,	16

	lbu	$t2,	12($s0)				#first byte
	lb	$t3,	13($s0)				#second byte
	li	$t4,	256				# storing 256
	mult	$t3,	$t4				# multyplying by 256
	mflo	$t8					#storing multiplication in $t8
	add	$t7,	$t2,	$t8			# adding to find actual year

	lbu	$t2,	12($t5)				#first byte
	lb	$t3,	13($t5)				#second byte
	li	$t4,	256				# storing 256
	mult	$t3,	$t4				# multyplying by 256
	mflo	$t8					#storing multiplication in $t8
	add	$t6,	$t2,	$t8			# adding to find actual year

	# my t6 and t2 will have the current value which i am going to compare

	bge	$t6,	$t7,	incrmentFirstLoop

	addi	$sp,	$sp,	-40

	sw	$s0,	0($sp)
	sw	$s1,	4($sp)
	sw	$s7,	8($sp)
	sw	$t0,	12($sp)
	sw	$t1,	16($sp)
	sw	$ra,	20($sp)

	add	$a0,	$zero,	$s0
	add	$a1,	$zero,	$sp
	li	$a2,	16
	jal	memcpy

	add	$a0,	$zero,	$t5
	add	$a1,	$zero,	$s0
	li	$a2,	16
	jal	memcpy

	add	$a0,	$zero,	$sp
	add	$a1,	$zero,	$t5
	li	$a2,	16
	jal	memcpy

	lw	$ra,	20($sp)
	lw	$t1,	16($sp)
	lw	$t0,	12($sp)
	lw	$s7,	8($sp)
	lw	$s1,	4($sp)
	lw	$s0,	0($sp)

	addi	$sp,	$sp,	40

	li	$t9,	1

incrmentFirstLoop:

	addi	$t0,	$t0,	2
	addi 	$s0,	$s0,	32
	j firstPartLoop

doneWithFirstNowSecondLoopPart1:

	addi	$t0,	$zero,	0
	add	$s7,	$zero,	$s2
	add	$t1,	$zero,	$s3

doneWithFirstNowSecondLoopPart2:

	bge	$t0,	$t1,	whileLoop

	addi	$t5,	$s7,	16
	lbu	$t2,	12($s7)				#first byte
	lb	$t3,	13($s7)				#second byte
	li	$t4,	256				# storing 256
	mult	$t3,	$t4				# multyplying by 256
	mflo	$t8					#storing multiplication in $t8
	add	$t7,	$t2,	$t8			# adding to find actual year

	lbu	$t2,	12($t5)				#first byte
	lb	$t3,	13($t5)				#second byte
	li	$t4,	256				# storing 256
	mult	$t3,	$t4				# multyplying by 256
	mflo	$t8					#storing multiplication in $t8
	add	$t6,	$t2,	$t8			# adding to find actual year

	# my t6 and t2 will have the current value which i am going to compare

	bge	$t6,	$t7,	incrmentsecondLoop

	addi	$sp,	$sp,	-40

	sw	$s0,	0($sp)
	sw	$s1,	4($sp)
	sw	$s7,	8($sp)
	sw	$t0,	12($sp)
	sw	$t1,	16($sp)
	sw	$ra,	20($sp)

	add	$a0,	$zero,	$s7
	add	$a1,	$zero,	$sp
	li	$a2,	16
	jal	memcpy

	add	$a0,	$zero,	$t5
	add	$a1,	$zero,	$s7
	li	$a2,	16
	jal	memcpy

	add	$a0,	$zero,	$sp
	add	$a1,	$zero,	$t5
	li	$a2,	16
	jal	memcpy

	lw	$ra,	20($sp)
	lw	$t1,	16($sp)
	lw	$t0,	12($sp)
	lw	$s7,	8($sp)
	lw	$s1,	4($sp)
	lw	$s0,	0($sp)

	addi	$sp,	$sp,	40

	li	$t9,	1

incrmentsecondLoop:
	addi 	$s7,	$s7,	32
	addi	$t0,	$t0,	2
	j doneWithFirstNowSecondLoopPart2

partSixFinished:
	li	$v0,0
	jr $ra

partSixFailed:
	li $v0, -1
	syscall

 ############################################## Part VII ##############################################
most_popular_feature:

	move	$s0,	$a0				# array of car
	move	$s1,	$a1				# length of car
	move	$s2,	$a2				# features in nibble (bytes)

	li	$t0,	0				# for convertible
	li	$t1,	0				# for Hybrid
	li	$t2,	0				# for Tints
	li	$t7,	0				# for GPS
	li	$t8,	0				#counter for loop


	blez 	$s1,	partSevenFailed
	blt	$s2,	1,	partSevenFailed
	bgt	$s2,	15,	partSevenFailed

partSevenMainLoop:
	beq	$t8,	$s1,	doneWithPartSeven
	lb 	$t9, 	14($s0)					# Feature
	# current car checking
	andi	$t3,	$t9,	8				# if it has GPS
	andi	$t4,	$t9,	4				# if it has Tints
	andi	$t5,	$t9,	2				# if it is hybrid
	andi	$t6,	$t9,	1				# if it is convertible

	# incoming third argument
	andi	$s3,	$s2,	8				# if it has GPS
	andi	$s4,	$s2,	4				# if it has Tints
	andi	$s5,	$s2,	2				# if it is hybrid
	andi	$s6,	$s2,	1				# if it is convertible

checkingForGPS:
	# current car checking, if it have following features or not
	beq	$s3,	8,	hasGPS
	j checkingForTints

hasGPS:
	beq	$t3,	8,	IncrementGPS
IncrementGPS:
	addi	$t7,	$t7,	1

checkingForTints:
	beq	$s4,	4,	hasTints
	j 	checkingForHybrid

hasTints:
	beq	$t4,	4,	IncrementTints
IncrementTints:
	addi	$t2,	$t2,	1

checkingForHybrid:
	beq	$s5,	2,	IsHybrid
	j 	checkingForConvertible

IsHybrid:
	beq	$t5,	2,	IncrementHybrid
IncrementHybrid:
	addi	$t1,	$t1,	1

checkingForConvertible:
	beq	$s6,	1,	isConvertible
	j 	moveBack
isConvertible:
	beq	$t6,	1,	IncrementConvertible
IncrementConvertible:
	addi	$t0,	$t0,	1

	addi	$s0,	$s0,	16
	addi	$t8,	$t8,	1

moveBack:
	j partSevenMainLoop


doneWithPartSeven:

	bgt	$t0,	$t1,	nextVal
	bgt	$t1,	$t2,	nextval3
	bgt	$t2,	$t7,	finishOffWith2
	j finishOffWith3

nextVal:
	bgt	$t0,	$t2, nextVal1

nextVal1:
	bgt	$t0,	$t7, finishOffWith0

nextval3:
	bgt	$t1,	$t7,	finishOffWith1
	j finishOffWith3


finishOffWith0:
	li	$v0,	1
	jr 	$ra

finishOffWith1:
	li	$v0,	2
	jr 	$ra

finishOffWith2:
	li	$v0,	4
	jr 	$ra

finishOffWith3:
	li	$v0,	8
	jr 	$ra

partSevenFailed:

	li	$v0,	-1
	jr	$ra



### Optional function: not required for the assignment ###
transliterate: #(character ch, string transliterate) returns number

	li	$t7,	0

	addi	$sp,	$sp,	-4
	sw	$ra,	0($sp)
	jal	index_of
	add	$t7,	$zero,	$v0

	lw	$ra,	0($sp)
	addi	$sp,	$sp,	4
	addi	$s7,	$zero,	10
	div	$t7, $s7
	mfhi	$t7
	add	$v0,	$zero	,$t7
	jr	$ra

### Optional function: not required for the assignment ###
index_of: #(character ch, string str) returns number

	move	$t1,	$a0
	move	$t2,	$a1
	li	$t9,	0
	li	$t4,	0

loopiinng:
	beq	$t1,	$t4,	comeOut
	lbu	$t4,	0($t2)
	addi	$t2,	$t2,	1
	addi	$t9,	$t9,	1

	j	loopiinng
comeOut:

	add	$v0,	$zero,	$t9
	jr 	$ra

### Optional function: not required for the assignment ###
char_at:# (index i, string str) returns letter

	move	$t0,	$a0				# current value of i
	move	$t1,	$a1				# Vin Number

	li	$t9,	0
	li	$t8,	0

charLoop:
	beq	$t9,	$t0,	goBack
	addi	$t9,	$t9,	1
	addi	$t1,	$t1,	1
	j	charLoop

goBack:
	lbu	$t8,	0($t1)
	add	$v0,	$zero,	$t8
	jr	$ra

 ############################################## Part VIII ##############################################
compute_check_digit:

	move	$s0,	$a0					# Vin Number
	move	$s1,	$a1					# Map
	move	$s2,	$a2					# weights
	move	$s3,	$a3					# Trans_str

	li	$s6,	0					# Sum
	li	$s4,	0					# Counter

partEightMainLoop:

	beq	$s4,	17,	doneWithPartEight

	# 1111

	addi	$sp,	$sp,	-4
	sw	$ra,	0($sp)

	add	$a0,	$zero,	$s4				# current value of i
	add	$a1,	$zero,	$s0				# Vin Number

	jal	char_at

	add	$t2,	$zero,	$v0

	lw	$ra,	0($sp)
	addi	$sp,	$sp,	4

	# 2222
	addi	$sp,	$sp,	-8

	sw	$t2,	0($sp)
	sw	$ra	4($sp)

	add	$a0,	$zero,	$t2				# current value of i
	add	$a1,	$zero,	$s3				# Vin Number

	jal	transliterate

	add	$t3,	$zero,	$v0

	lw	$ra,	4($sp)
	lw	$t2,	0($sp)

	addi	$sp,	$sp,	8

	# 3333

	addi	$sp,	$sp,	-12

	sw	$t2,	0($sp)
	sw	$t3,	4($sp)
	sw	$ra	8($sp)

	add	$a0,	$zero,	$s4				# current value of i
	add	$a1,	$zero,	$s2				# Vin Number

	jal	char_at

	add	$t4,	$zero,	$v0

	lw	$ra,	8($sp)
	lw	$t3,	4($sp)
	lw	$t2,	0($sp)

	addi	$sp,	$sp,	12

	# 4444
	addi	$sp,	$sp,	-16

	sw	$t2,	0($sp)
	sw	$t3,	4($sp)
	sw	$t4,	8($sp)
	sw	$ra	12($sp)


	add	$a0,	$zero,	$t4				# current value of i
	add	$a1,	$zero,	$s1				# Vin Number

	jal	index_of

	add	$t5,	$zero,	$v0

	lw	$ra,	12($sp)
	lw	$t4,	8($sp)
	lw	$t3,	4($sp)
	lw	$t2,	0($sp)

	addi	$sp,	$sp,	16

	multu	$t5,$t3

	mflo 	$t6

	add	$s6,	$s6,	$t6

	addi	$s4,	$s4,	1

	j	partEightMainLoop

doneWithPartEight:
	addi	$s7,	$zero,	11

	div	$s6,	$s7
	mfhi	$t1

	addi	$sp,	$sp,	-4
	sw	$ra	0($sp)

	add	$a0,	$zero,	$t1				# current value of i
	add	$a1,	$zero,	$s1				# Vin Number

	jal	char_at

	add	$t9,	$zero,	$v0

	lw	$ra,	0($sp)
	addi	$sp,	$sp,	4

	add	$v0,	$zero,	$t9

	jr 	$ra

#####################################################################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
############### DO NOT CREATE A .data SECTION! ######################
##### ANY LINES BEGINNING .data WILL BE DELETED DURING GRADING! #####
#####################################################################
