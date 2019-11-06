.data			# HAY que agregar esto al .data
dbl: .space 8

.text

main:			# Esto es solo un ejemplo

li $v0, 7
syscall

la $a0, dbl		# En $a0 tengo la direccion del double
s.d $f0, ($a0)		# Cuidado, se almacena la primera mitad despues
			# de la segunda

li $v0, 10
syscall

# $a0 -> direccion del double
# $a1 -> donde quiero el signo
sgn:
	addi $sp, $sp, -8
	sw   $a0, 4($sp)
	sw   $a1, 0($sp)	# Apilo en el stack
	addi $a0, $a0, 4	# Avanzo a la primer mitad del double
	lw $a1, ($a0)		# Consigo en $a1 la primer mitad
	srl  $t1, $t1, 31	# Llevo el primer bit, el signo, al final
	lw   $a0, 4($sp)
	lw   $a1, 0($sp)
	addi $sp, $sp, 8	# Popeo en el stack
	jr $ra
