.data

double: .space 8  # double number;
buffer: .space 8   # void* buffer; 
chars: .ascii "0123456789ABCDEF"  # const char* chars = "0123456789ABCDEF";

hexamsg: .asciiz "Hexa: "
signomsg: .asciiz "Signo: "
exponentemsg: .asciiz "Exponente: "
excesomsg: .asciiz "En exceso: "
mantisamsg: .asciiz "Mantisa: "

menos: .asciiz "-"
mas: .asciiz "+"

endl: .asciiz "\n" # #define endl "\n"
.text

# $a0 -> partida
#################################
revprint:                       #
  move $t4, $a1                 #
  revprint_loop:                # while (i >= 0) {
    blt $t4, 0, revprint_return #
    lb $t0, buffer($t4)         #   int byte = loadbyte(buffer + i);
    and $t1, $t0, 0xf           #   int lower = byte & 0xf // 15
    srl $t0, $t0, 4             #   
    and $t2, $t0, 0xf           #   int upper = (byte >> 4) & 0xf;
    li $v0, 11                  #
    lb $a0, chars($t2)          # 
    syscall                     #   cout << chars[upper];
    lb $a0, chars($t1)          # 
    syscall                     #   cout << chars[lower];
    sub $t4, $t4, 1             #   i--;
    j revprint_loop             #
  revprint_return:              # }
  li $v0, 4                     #
  la $a0, endl                  #
  syscall                       # cout << endl;
  jr $ra                        #
#################################

###############################
hexa:                         #
  sub $sp, $sp, 4             #
  sw $ra, 0($sp)              #
  li $v0, 4                   #
  la $a0, hexamsg             #
  syscall                     # cout << "hexa: ";
  li $t4, 4                   #
  lw $t0, double($t4)         # 
  sw $t0, buffer($t4)         # buffer[1] = number[1];
  lw $t0, double($0)          # 
  sw $t0, buffer($0)          # buffer[0] = number[0];
  li $a1, 7                   #
  jal revprint                # revprint(7)
  lw $ra, 0($sp)              #
  add $sp, $sp, 4             #
  jr $ra                      # return;
###############################

###########################
signo:                    #
  li $v0, 4               #
  la $a0, signomsg        #
  syscall                 # cout << "signo: ";
  li $t0, 4               #
  lw $t0, double($t0)     # int signo = loadword(number + 4)
  srl $t0, $t0, 31        # signo >> 31 
  bne $t0, $0, signo_neg  # if (signo == 0) {
    la $a0, mas           #   
    syscall               #   cout << "+";
    j signo_return        #   return;
  signo_neg:              # }
  la $a0, menos           # 
  syscall                 # cout << "-";
                          #
  signo_return:           #
  la $a0, endl            #
  syscall                 # cout << endl;
	jr $ra                  # return;
###########################

#########################
exponente:              #
  sub $sp, $sp, 4       #
  sw $ra, 0($sp)        #
  li $v0, 4             #
  la $a0, exponentemsg  #
  syscall               # cout << "exponente: ";
  li $t0, 4             #
  lw $t0, double($t0)   # int exponente = loadword(number + 4)
  srl $t0, $t0, 20      # exponente >> 20
  and $t0, $t0, 0x7ff   # exponente &= 0x7ff // 0111 1111 1111
  sub $t0, $t0, 0x3ff   # exponente -= 0x1ff // 0001 1111 1111
  sw $t0, buffer($0)    # buffer[0] = exponente;
  li $a1, 3             #
  jal revprint          # revprint(3);
  lw $ra, 0($sp)        #
  add $sp, $sp, 4       #
	jr $ra                # return;
#########################

#######################
exceso:               #
  sub $sp, $sp, 4     #
  sw $ra, 0($sp)      #
  li $v0, 4           #
  la $a0, excesomsg   #
  syscall             # cout << "exceso: ";
  li $t0, 4           #
  lw $t0, double($t0) # int exceso = loadword(number + 4)
  srl $t0, $t0, 20    # exceso >> 20
  and $t0, $t0, 0x7ff # exceso &= 0x7ff // 0111 1111 1111
  sw $t0, buffer($0)  # buffer[0] = exceso;
                      #
  li $a1, 1           #
  jal revprint        # revprint(1)
  lw $ra, 0($sp)      #
  add $sp, $sp, 4     #
	jr $ra              # return;
#######################

#########################
mantisa:                #
  sub $sp, $sp, 4       #
  sw $ra, 0($sp)        #
  li $v0, 4             #
  la $a0, mantisamsg    #
  syscall               # cout << "exceso: ";
  li $t4, 4             #
  lw $t0, double($t4)   # 
  and $t0, $t0, 0xfffff #
  sw $t0, buffer($t4)   # buffer[1] = number[1] & 0xfffff;
  lw $t0, double($0)    # 
  sw $t0, buffer($0)    # buffer[0] = number[0];
                        #
  li $a1, 6             # 
  jal revprint          # revprint(6)
  lw $ra, 0($sp)        #
  add $sp, $sp, 4       #
	jr $ra                # return;
#########################

#####################
main:			          #
				            #
li $v0, 7		        #
syscall			        #
				            #
s.d $f0, double($0)	# cin >> number;
				            #
jal hexa            # hexa(&number);
jal signo           # signo(&number);
jal exponente       # exponente(&number);
jal exceso          # exceso(&number);
jal mantisa         # mantisa(&number);
				            #
li $v0, 10		      #
syscall			        # return 0;
#####################
