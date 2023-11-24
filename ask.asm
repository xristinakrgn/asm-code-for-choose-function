# NAME: CHRISTINA KARAGIANNI, A.M.: 3220067	
	
	.text
	.globl _start # changed it to start to show that it can be done with or without the "main" label
_start:
	# set maximum values for n and k
	li $t7, 12 # n! exceeds the max amount that a 32-bit int can represent for n >= 13, therefore max n = 12
	li $t8, 12 # n = k = 12 (bc n! should be <= (2^31 - 1) = 2147483647 and k! also)
	# prints a message for the user to see the max values of n and k
	la $a0, m1
	li $v0, 4 # prints the string "m1"
	syscall
	move $a0, $t7 
	li $v0, 1 # prints (int) value of $a0 (31)
	syscall
	la $a0, m2
	li $v0, 4 # prints the string "m2"
	syscall
	move $a0, $t8
	li $v0, 1 # prints (int) value of $a0 (2147483647)
	syscall
	la $a0, m3
	li $v0, 4 # prints the string "m3"
	syscall

	# n
	la $a0, enter_n 
	li $v0, 4 # prints the string "enter_n"
	syscall
	li $v0, 5 # reads int (n)
	syscall
	move $t0, $v0  # $t0 = n
	
	bgt $t0, $t7, overflow_n # if n > 31 then we have overflow for n
	j input_k # else continue with k's input
	
	overflow_n:
		la $a0, ovfl_n 
		li $v0, 4 # prints the string "ovfl_n"
		syscall
		j exit # jump to exit label
	
	input_k: # a label is added for k's input so that we can easily access it if there is no overflow for n
		# k
		la $a0, enter_k
		li $v0, 4 # prints the string "enter_k"
		syscall
		li $v0, 5 # reads int (k)
		syscall
		move $t1, $v0  # $t1 = k
		
	bgt $t1, $t8, overflow_k # if k > 2147483647 then we have overflow for k
	j if_statement # else jump to if_statement

	overflow_k:
		la $a0, ovfl_k
		li $v0, 4 # prints the string "ovfl_k"
		syscall
		j exit # jump to exit label
	
	if_statement:
		bge $t0, $t1, check_k # if n >= k then check_k bc we have to also have k >= 0
		j else_statement # else jump to else_statement
	
	else_statement: # there's a label so that i can reuse this part of the code later
		la $a0, valid_msg
		li $v0, 4 # prints the string "valid_msg"
		syscall
		j exit # jump to exit label
	
	check_k:
		bge $t1, $zero, factorials # if k>=0 then we can follow if's path
		j else_statement # else jump to else_statement
	
	factorials:
		li $t2, 1 # Factorial_n = 1
		li $t3, 1 # Factorial_k = 1
		li $t4, 1 # Factorial_n_k = 1
		li $t5, 1 # i = 1 
		sub $t6, $t0, $t1 # $t6 = (n - k)
			
	n_loop:
		bgt $t5, $t0, loop1 # the 1st for-loop ends only if i>n and goes to the next
		mul $t2, $t2, $t5 # Factorial_n *= i
		addi $t5, $t5, 1 # i+=1
		j n_loop # it is a loop so we have to jump back to the start of it
				
	loop1:
		li $t5, 1 # change i back to i = 1 in case it got into loop_n
	k_loop:
		bgt $t5, $t1, loop2 # the 2nd for-loop ends only if i>k and goes to the next
		mul $t3, $t3, $t5 # Factorial_k *= i
		addi $t5, $t5, 1 # i+=1
		j k_loop # it is a loop so we have to jump back to the start of it

	loop2:
		li $t5, 1 # change i back to i = 1 in case it got into loop_n or loop_k
	n_k_loop:
		bgt $t5, $t6, final_result # the 3rd for-loop ends only if i>(n-k) and then results are printed
		mul $t4, $t4, $t5 # Factorial_n_k *= i
		addi $t5, $t5, 1 # i+=1
		j n_k_loop # it is a loop so we have to jump back to the start of it
		
	final_result:
		la $a0, f1
		li $v0, 4 # prints str "f1"
		syscall
		move $a0, $t0 
		li $v0, 1 # prints (int) value of $a0 (n)
		syscall
		la $a0, f2
		li $v0, 4 # prints str "f2"
		syscall
		move $a0, $t1
		li $v0, 1 # prints (int) value of $a0 (k)
		syscall
		la $a0, f3
		li $v0, 4 # prints str "f3"
		syscall
		mul $t3, $t3, $t4 # Factorial_k = Factorial_k * Factorial_n_k
		div $t2, $t2, $t3 # Factorial_n = Factorial_n / Factorial_k
		move $a0, $t2 
		li $v0, 1 # prints (int) value of $a0 (Factorial_n)
		syscall
		la $a0, f4
		li $v0, 4 # prints str "f4"
		syscall
			
	exit:
		li $v0, 10 # exit call
		syscall
		
	.data # assigns values to the str variables in this case
m1:         .asciiz "Maximum value for n is "
m2:         .asciiz " and for k it is "
m3:         .asciiz ". \n\n"
enter_n:    .asciiz "Enter number of objects in the set (n): " 
ovfl_n:		.asciiz "Input exceeds maximum value for n.\n\n"
enter_k:    .asciiz "Enter number to be chosen (k): "
ovfl_k:		.asciiz "Input exceeds maximum value for k.\n\n"
valid_msg:  .asciiz "Please enter n >= k >= 0\n\n"
f1:         .asciiz "C("
f2:         .asciiz ", "
f3:         .asciiz ") = "
f4:         .asciiz "\n\n"