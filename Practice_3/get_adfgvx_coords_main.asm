.text
.globl main
main:
li $a0, 5
li $a1, 6

jal get_adfgvx_coords

move $a0, $v0

li $v0, 11
syscall

li $a0, ' '
syscall

move $a0, $v1
syscall
li $a0, '\n'
syscall

li $v0, 10
syscall

.include "hw3.asm"
