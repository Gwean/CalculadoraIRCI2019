.data
msg3: .asciiz "0000000000000000\n"
hexa: .ascii "0123456789ABCDEF"
.align 2
aux:  .space 4              # word auxiliar para pasar valores de registro f a normal y viceversa

.text
main:
      li $v0, 7             #
      syscall               # Lee double
    
      li $t0, 0
      la $a1, msg3($t0)     # Carga direccion del string respuesta en $a1
      swc1 $f0, aux($zero)  # Guarda primeros 4 bytes en memoria
      lw $a0, aux($zero)    # Extrae valor como word para trabajar
      jal w2h               # Llamada a la funcion sobre primer mitad
      
      li $t0, 8
      la $a1, msg3($t0)     # Carga direccion de la segunda mitad del string respuesta en $a1
      swc1 $f1, aux($zero)  # Guarda segundos 4 bytes en memoria
      lw $a0, aux($zero)    # Extrae valor como word para trabajar
      jal w2h               # Llamada a la funcion sobre segunda mitad

      li $v0, 4             #
      la $a0, msg3          #
      syscall               # Imprime el msg3
      
exit: li $v0, 10            #
      syscall               # Exit

# $a1 string respuesta
w2h:  addi $sp, $sp, -8     # Se reserva memoria del stack
      sw  $a1, 0($sp)       # Guarda msg3* en el stack
      sw  $a0, 4($sp)       # Guarda el numero ingresado
      la   $t1, hexa        # Guarda 0123456789ABCDEF* en $t1
      li   $t2, 8           # Guarda un 8 en t2 (contador)
      addi $a1, $a1, 7      # Nos movemos 7 lugares -> (byte menos significativo de msg3)
L1:   andi $t0, $a0, 0xf    # Le hace un & con 1111. Es decir, agarra los primero 4 bits y los almacena en t0 \|/
      add  $t0, $t1, $t0    # Mueve el puntero al numero hexa deseado (en forma de char)
      lb   $t0, ($t0)       # Carga el hexa deseado (desde RAM)
      sb   $t0, ($a1)       # Lo guarda en la respuesta (en RAM)
      srl  $a0, $a0, 4      # Shiftea a los siguientes 4 bits del numero ingresado
      addi $a1, $a1, -1     # Movemos puntero a siguiente caracter respuesta (1 byte a la izquierda)
      addi $t2, $t2, -1     # Decrementamos contador
      beqz $t2, E1          # Cuando pasaron 32 bits (4 * 8) cortamos
      j L1
E1:   lw  $a1, 0($sp)       # Carga los argumentos del stack
      lw  $a0, 4($sp)
      addi $sp, $sp, 8
      jr $ra
