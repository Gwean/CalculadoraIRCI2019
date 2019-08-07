.data
float: .space 8

.text

main:

li $v0, 7
syscall

la $t0, float		# En $t0 tengo la direccion del float

s.d $f0, ($t0)		# Se almacena la primera mitad despues de la segunda

addi $t0, $t0, 4	# Avanzo al proximo word

lw $t1, ($t0)

srl  $t1, $t1, 31

li $v0, 10
syscall
