.data			# incluir esto en el .data del codigo
hexa: .ascii "0123456789ABCDEF"
res: .asciiz "00000000\n"	# Colocar tantos 0s como digitos
				# hexadecimales tenga la respuesta.

dbl: .space 8

.text			# incluir esto en el .text del codigo

# $a0 -> Numero a convertir.
# $a1 -> String respuesta res.
# $a2 -> Cantidad de digitos hexadecimales de la respuesta.
w2h: addi $sp, $sp, -12	# Para documentacion completa ver 
				# int2hexstring.s
      sw  $a2, 0($sp)
      sw  $a1, 4($sp)
      sw  $a0, 8($sp)
      la   $t1, hexa
      addi $t2, $a2, 0	# li   $t2, 8
      addi $a1, $a1, 7
L1:   andi $t0, $a0, 0xf
      add  $t0, $t1, $t0
      lb   $t0, ($t0)
      sb   $t0, ($a1)
      srl  $a0, $a0, 4
      addi $a1, $a1, -1
      addi $t2, $t2, -1
      beqz $t2, E1
      j L1
E1:   lw  $a2, 0($sp)
      lw  $a1, 4($sp)
      lw  $a0, 8($sp)
      addi $sp, $sp, 12
      jr $ra

# $a0 -> direccion del double
# $a1 -> donde quiero el signo
sgn:	addi $sp, $sp, -8
	sw   $a0, 4($sp)
	sw   $a1, 0($sp)	# Apilo en el stack
	addi $a0, $a0, 4	# Avanzo a la primer mitad del double
	lw $a1, ($a0)		# Consigo en $a1 la primer mitad
	srl  $t1, $t1, 31	# Llevo el primer bit, el signo, al final
	lw   $a0, 4($sp)
	lw   $a1, 0($sp)
	addi $sp, $sp, 8	# Popeo en el stack
	jr $ra
