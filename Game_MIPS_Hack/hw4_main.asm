.data
map_filename: .asciiz "map3.txt"
# num words for map: 45 = (num_rows * num_cols + 2) // 4 
# map is random garbage initially
.asciiz "Don't touch this region of memory"
map: .word 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 0x632DEF01 0xAB101F01 0xABCDEF01 0x00000201 0x22222222 0xA77EF01 0x88CDEF01 0x90CDEF01 0xABCD2212 
.asciiz "Don't touch this"
# player struct is random garbage initially
player: .word 0x2912FECD
.asciiz "Don't touch this either"
# visited[][] bit vector will always be initialized with all zeroes
# num words for visited: 6 = (num_rows * num*cols) // 32 + 1
visited: .word 0 0 0 0 0 0 
.asciiz "Really, please don't mess with this string"

welcome_msg: .asciiz "Welcome to MipsHack! Prepare for adventure!\n"
pos_str: .asciiz "Pos=["
health_str: .asciiz "] Health=["
coins_str: .asciiz "] Coins=["
your_move_str: .asciiz " Your Move: "
you_won_str: .asciiz "Congratulations! You have defeated your enemies and escaped with great riches!\n"
you_died_str: .asciiz "You died!\n"
you_failed_str: .asciiz "You have failed in your quest!\n"
flood_fill:	.asciiz "flood fill\n"
init_map_print: .asciiz "Init Method print : "
value_comingBack: .asciiz " Value returned is "

.text
print_map:
		la 	$t0, 	map  
		lbu	$t4,	1($t0)
		li	$t5,	0
		
		li	$a0,	'\n'
		li	$v0,	11
		syscall
		li	$a0,	'\n'
		li	$v0,	11
		syscall
looppp:
		lbu	$t1,	2($t0)
		
		beqz	$t1,	endddd
		beq	$t4, 	$t5,	nextLINNNEE
			
		move	$a0,	$t1	
		li	$v0,	11
		syscall
		
		addi	$t5,	$t5,	1
		addi	$t0,	$t0,	1
		
		j looppp
		
nextLINNNEE:
		li	$t5,	0
		
		li	$a0,	'\n'
		li	$v0,	11
		syscall
		
		j looppp
		
endddd:
		jr $ra



print_player_info:
		la $t0, player
		
		li	$a0,	' '
		li	$v0,	11
		syscall

		lb	$a0,	($t0)	
		li	$v0,	1
		syscall
		
		li	$a0,	','
		li	$v0,	11
		syscall

		lb	$a0,	1($t0)	
		li	$v0,	1
		syscall
		
		li	$a0,	' '
		li	$v0,	11
		syscall
		
		li	$a0,	'['
		li	$v0,	11
		syscall

		lb	$a0,	2($t0)	
		li	$v0,	1
		syscall
		
		li	$a0,	']'
		li	$v0,	11
		syscall
		
		li	$a0,	' '
		li	$v0,	11
		syscall
		
		li	$a0,	'['
		li	$v0,	11
		syscall

		lb	$a0,	3($t0)	
		li	$v0,	1
		syscall
		
		li	$a0,	']'
		li	$v0,	11
		syscall

		jr 	$ra
		
	
.globl main
main:

		la 	$a0, 	welcome_msg
		li 	$v0, 	4
		syscall


		la	$a0,	map_filename
		la	$a1,	map
		la	$a2,	player

		jal 	init_game						# calling part 1
		
		la	$a0,	map
		li	$a1,	1
		li	$a2,	7
		la	$a3,	visited
		
		jal	flood_fill_reveal

		jal print_map 
		
		li	$v0,	10
		syscall
		
		
		move	$a0,	$v0
		li	$v0,	1
		syscall
		
		la	$a0,	value_comingBack
		li	$v0,	4
		syscall
		
		jal print_map 
		
		move	$a0,	$v0
		li	$v0,	1
		syscall
		
		li	$a0,	' '
		li	$v0,	11
		syscall

		jal print_player_info 
		
		la	$t1,	player	
		lbu	$t2,	0($t1)
		lbu	$t3,	1($t1)
		
		#bltz	$t3,	game_over
		
		la	$a0,	map
		move	$a1,	$t2
		move	$a2,	$t3
	
		jal reveal_area						# part - 5
		

		li 	$s0, 	0  # move = 0
		
		la	$t7,	player
		

game_loop:  # while player is not dead and move == 0:

	
		lbu	$t8,	2($t7)
		
		blez	$t8,	failed

		la 	$a0, 	your_move_str
		li 	$v0, 	4
		syscall

		li 	$v0, 	12  # read 
		syscall

		move	$s1, 	$v0  # store input
		li 	$s0, 0  # move = 0

		li 	$a0, '\n'
		li 	$v0,	11
		syscall

# handle input: w, a, s or d
# map w, a, s, d  to  U, L, D, R and call player_turn()

		la	$a0,	map
		la	$a1,	player
		move	$a2,	$s1
		
		jal	player_turn

		move	$s0,	$v0
		
		move	$a0,	$v0
		li 	$v0,	1
		syscall
		
		beq	$a0,	-1,	won

# if move == 0, call reveal_area()  Otherwise, exit the loop.

		#beqz	$s0,	reveal	
reveal:
		la	$t1,	player	
		lbu	$t2,	0($t1)
		lbu	$t3,	1($t1)
		
		#bltz	$t3,	game_over
		
		la	$a0,	map
		move	$a1,	$t2
		move	$a2,	$t3
	
		jal reveal_area						# part - 5
		
		li	$a0,	' '
		li	$v0,	11
		syscall

		jal print_map 

		li	$a0,	' '
		li	$v0,	11
		syscall

		jal print_player_info 
		
		j game_loop

game_over:
		la,	$v0,	flood_fill
		li	$v0,	4
		syscall	
		
		la	$a0,	map
		li	$a1,	2
		li	$a2,	2
		la	$a3,	visited
		
		jal	flood_fill_reveal

		jal print_map 
		
		move	$a0,	$v0
		li	$v0,	1
		syscall

		jal print_player_info
		li $a0, '\n'
		li $v0, 11
		syscall

# choose between (1) player dead, (2) player escaped but lost, (3) player escaped and won

		la	$t7,	player
	
		lbu	$t8,	2($t7)
		
		blez	$t8,	game_over

won:

		#la	$a0,	map
		#li	$v0,	4
		#syscall
		
		la	$a0,	player
		li	$v0,	4
		syscall
		
		la,	$v0,	flood_fill
		li	$v0,	4
		syscall	
		
		la	$a0,	map
		li	$a1,	2
		li	$a2,	2
		la	$a3,	visited
		
		jal	flood_fill_reveal

		jal print_map 
		
		move	$a0,	$v0
		li	$v0,	1
		syscall

		
		
		
		j exit
		#la $a0, you_won_str
		#li $v0, 4
		#syscall
		
		j exit
failed:
		la $a0, you_failed_str
		li $v0, 4
		syscall
		j exit

player_dead:
		la $a0, you_died_str
		li $v0, 4
		syscall

exit:
		li $v0, 10
		syscall

.include "hw4.asm"
