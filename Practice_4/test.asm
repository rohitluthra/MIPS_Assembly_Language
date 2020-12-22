
.data

filename: .asciiz "nw_se_diag_win6.txt"
.align 2
board: .space 1000
row: .word 6
col: .word 8
player: .byte 'O'

.text
la	$a0, 	board
la 	$a1, 	filename
jal	load_board

#------- part 6 testing ----------
#la 	$a0, 	board
#lw 	$a1, 	row
#lw 	$a2, 	col
#lb	$a3,	player

#jal 	check_horizontal_capture

#move	$a0,	$v0
#li	$v0,	1
#syscall


#------- part 11/12 testing ----------
la	$a0,	board
lb	$a1,	player

jal	check_nw_se_diagonal_winner

move	$a0,	$v0
li	$v0,	1
syscall

li	$a0,	' '
li	$v0,	11
syscall

move	$a0,	$v1
li	$v0,	1
syscall

li	$a0,	'\n'
li	$v0,	11
syscall

#
#------- part 9/10 testing ----------
#la	$a0,	board
#lb	$a1,	player
#jal	check_vertical_winner

#move	$a0,	$v0
#li	$v0,	1
#syscall

#li	$a0,	' '
#li	$v0,	11
#syscall




#------- part 8 testing ----------
#la 	$a0, 	board
#lw 	$a1, 	row
#lw 	$a2, 	col
#lb	$a3,	player

#jal 	check_diagonal_capture

#move	$a0,	$v0
#li	$v0,	1
#syscall



#------- part 7 testing ----------
#la 	$a0, 	board
#lw 	$a1, 	row
#lw 	$a2, 	col
#lb	$a3,	player

#jal 	check_vertical_capture

#move	$a0,	$v0
#li	$v0,	1
#syscall


#------- part 2 testing ----------
#la 	$a0, 	board
#lw 	$a1, 	row
#lw 	$a2, 	col

#jal 	get_slot
#move	$a0,	$v0
#li	$v0,	1
#syscall

#------- part 3 testing ----------
#la 	$a0, 	board
#lw 	$a1, 	row
#lw 	$a2, 	col
#la	$a3,	player

#jal 	set_slot
#move	$a0,	$v0
#li	$v0,	1
#syscall

#------- part 4 testing ----------
#la 	$a0, 	board
#lw 	$a1, 	row
#lw 	$a2, 	col
#la	$a3,	player

#jal 	place_piece
#move	$a0,	$v0
#li	$v0,	1
#syscall

#------- part 5 testing ----------

#la	$a0,	board
#jal	game_status

#move	$a0,	$v0
#li	$v0,	1
#syscall

#li	$a0,	' '
#li	$v0,	11
#syscall

#move	$a0,	$v1
#li	$v0,	1
#syscall

#li	$a0,	'\n'
#li	$v0,	11
#syscall




    
#######################################################################
#			TEsting method		      		      #
#######################################################################
Print_board:
addi	$sp,	$sp,	-32
sw	$s0,	0($sp)
sw	$s1,	4($sp)
sw	$s2,	8($sp)
sw	$s3,	12($sp)
sw	$s4,	16($sp)
sw	$s5,	20($sp)
sw	$s6,	24($sp)
sw	$ra,	28($sp)

la 	$a0, 	board
move	$s0,	$a0	#board address
lw	$s1,	0($s0)


move    $s5, 	$s1     # $t0 = number of rows

move	$a0,	$s1
li	$v0,	1
syscall			# showing the number of rows

li	$a0,	'\n'
li	$v0,	11
syscall
    
lw	$s1,	4($s0)

move    $s6, 	$s1        # $t1 = number of columns

    
move	$a0,	$s1
li	$v0,	1
syscall			# showing the number of colomns

li	$a0,	'\n'
li	$v0,	11
syscall 

addi	$s0,	$s0,	8

move	$s3,	$zero	# current row counter
move	$s4,	$zero	# current colomn counter

loop:
#li	$a0,	' '
#li	$v0,	11
#syscall 
lbu	$s2,	0($s0)
move	$a0,	$s2
li	$v0,	11
syscall


addi	$s4,	$s4,	1
addi	$s0,	$s0,	1
addi	$t9,	$t9,	1
beq	$s4,	$s6,	reset_colomn
j	loop

reset_colomn:
li	$a0,	'\n'
li	$v0,	11
syscall
addi	$s3,	$s3,	1
bge	$s3,	$s5,	done_with_printing

#addi	$s0,	$s0,	1
move	$s4,	$zero

j	loop


done_with_printing:

lw	$ra,	28($sp)
lw	$s6,	24($sp)
lw	$s5,	20($sp)
lw	$s4,	16($sp)
lw	$s3,	12($sp)
lw	$s2,	8($sp)
lw	$s1,	4($sp)
lw	$s0,	0($sp)

addi	$sp,	$sp,	32
li	$v0,	10
syscall


.include "proj4.asm"
