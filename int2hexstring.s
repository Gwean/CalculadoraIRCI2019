.data
msg1: .asciiz "Entre un numero:"
msg2: .asciiz "El numero en hexa es: 0x"
msg3: .asciiz "00000000\n"
hexa: .ascii "0123456789ABCDEF"

.text
main: li $v0, 4
      la $a0, msg1
      syscall
      li $v0, 5
      syscall
      addi $a0, $v0, 0
      la $a1, msg3
      jal i2hs
      li $v0, 4
      la $a0, msg2
      syscall
      li $v0, 4
      la $a0, msg3
      li $a1, 0
      syscall
      li $v0, 10
      syscall

i2hs: sw  $a1, 0($sp)
      sw  $a0, -4($sp)
      la   $t1, hexa
      li   $t2, 8
      addi $a1, $a1, 7
L1:   andi $t0, $a0, 0xf
      add  $t3, $t0, $t1      
      lb   $t4, 0($t3)
      sb   $t4, 0($a1)
      srl  $a0, $a0, 4
      addi $a1, $a1, -1
      addi $t2, $t2, -1
      beqz $t2, E1
      j L1
E1:   lw  $a1, 0($sp)
      lw  $a0, -4($sp)
      jr $ra
      
