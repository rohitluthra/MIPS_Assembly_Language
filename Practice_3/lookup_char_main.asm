.data
adfgvx_grid: .asciiz "QWE3RT0YU2IO4PLK9J1HGF5DSAZ86XCVB7NM"
row_char: .byte 'A'
col_char: .byte '9'

.text
.globl main
main:
la $a0, adfgvx_grid
lbu $a1, row_char
lbu $a2, col_char

jal lookup_char

move $a0, $v0
li $v0, 1
syscall

li $a0, ' '
li $v0, 11
syscall

move $a0, $v1
li $v0, 11
syscall

li $a0, '\n'
li $v0, 11
syscall

li $v0, 10
syscall

.include "hw3.asm"
