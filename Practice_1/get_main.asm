.data
.data
v0: .asciiz "v0: "
v1: .asciiz "v1: "

hash_table:
.word 7
.word 2
.word 1, ams, cs, hepl, yuo, you, 0
.word CSE101, Applied_Mathematics, 0, 0, OK_thanks, thanks, you

# There are some extra strings here you can work with. Or add your own!
subtraction: .asciiz "subtraction"
s101: .asciiz "101"
sbu: .asciiz "sbu"
yuo: .asciiz "yuo"
cs: .asciiz "computer science"
u: .asciiz "u"
you: .asciiz "you"
wat: .asciiz "wat"
ams: .asciiz "ams"
help: .asciiz "help"
CSE101: .asciiz "CSE101"
bsu: .asciiz "bsu"
arrgghh: .asciiz "arrgghh"
calss: .asciiz "calss"
thx: .asciiz "thx"
Applied_Mathematics: .asciiz "Applied Mathematics"
hepl: .asciiz "hepl"
OK_thanks: .asciiz "OK thanks"
class: .asciiz "class"
can: .asciiz "can"
kk: .asciiz "kk"
i: .asciiz "i"
thanks: .asciiz "thanks"
usb: .asciiz "usb"

.text
.globl main
main:
la $a0, hash_table
la $a1, s101
jal get
move $t0, $v0
move $t1, $v1

la $a0, v0
li $v0, 4
syscall

li $v0, 1
move $a0, $t0
syscall

li $a0, '\n'
li $v0, 11
syscall

la $a0, v1
li $v0, 4
syscall
li $v0, 1
move $a0, $t1
syscall
li $a0, '\n'
li $v0, 11
syscall

li $v0, 10
syscall


.include "proj3.asm"
