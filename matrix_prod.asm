# Name: Matheus Obando da Silva
# Registration: 1815310018
# 
# Description: Multiply two 4X4 Matrices
# Status: Finished (13/09/2019 - 04:01 AM)

.data # Initialized data section

bspace: .asciiz  " " # Blank space
nline: .asciiz "\n" # Break row
matrix_1: .word 5 8 1 3 0 2 4 5 7 8 1 2 3 4 0 5
matrix_2: .word 1 1 8 5 2 3 4 0 7 3 2 5 2 1 0 0
product: .word 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
order: .word 4 # Square matrices order (4X4)

.text # Logical section (where the code is writed) 

.globl _main

_main:

lw $s0, order
#mul $s1, $s0, $s0
mult $s0, $s0
mflo $s1
 
multiply:

li $t0, 0 # Initialize i counter register
li $t1, 0 # Initialize j counter register
li $t2, 0 # Initialize k counter register
la $t3, matrix_1 # Get matrix_1 address
la $t4, matrix_2 # Get matrix_2 address
la $t5, product # Get produt matrix address
li $t6, 0 # Auxiliar register

start_i:

beq $t0, $s1, end_i
li $t1, 0

start_j:
beq $t1, $s0, end_j
li $t2, 0

# Line:
#mul $t6, $t0, $s0
mult $t0, $s0
mflo $t6
add $t3, $t3, $t6

# Column:
#mul $t6, $t1, $s0
mult $t1, $s0
mflo $t6
add $t4, $t4, $t6

start_k:

beq $t2, $s0, end_k

# Multiplication algorithm:

# Load matrix_1 current element:
lw $s3, 0($t3)

# Load matrix_2 current element:
lw $s4, 0($t4)

# Multiply the two values and storage on a new register
#mul $s5, $s4, $s3
mult $s4, $s3
mflo $s5
add $a0, $a0, $s5
addi $t3, $t3, 4
add $t4, $t4, $s1
addi $t2, $t2, 1

j start_k # Loop

end_k:

# Set product value on the product matrix
sw $a0, 0($t5) 
addi $t5 $t5, 4
addi $t1, $t1, 1
li $a0, 0
la $t3, matrix_1 # get matrix_1 address
la $t4, matrix_2 # get matrix_2 address

j start_j # Loop

end_j:

addi $t0, $t0, 4
j start_i # Loop

end_i:

print:

li $t0, 0 # Initialize i counter register
li $t1, 0 # Initialize j counter register 
la $t2, product # Load array first address (la = load address)

start_i2:

beq $t0, $s0, end_i2 # end loop section and jump to the final section

start_j2:

beq $t1, $s0, end_j2 # End loop iteration (jump to _exit section)

# Write the new array value:
lw $t3, 0($t2) # Get the current initial adress of register $t1
addi $t2, $t2, 4 # Move 4 bytes on the matrix memory address
		
li $v0, 1 
move  $a0, $t3 # Move $t3 register content to $a0 register
syscall
	
# Write the blank spaces
li $v0, 4 
la $a0, bspace 
syscall
	
addi $t1, $t1, 1	
j start_j2 # Loop

end_j2:

# Break row on the output
li $v0, 4
la $a0, nline
li $t1, 0
syscall
	    
addi $t0, $t0, 1 # Increment the i counter
j start_i2 # Loop

end_i2:

_exit:

li $v0, 10 # System call 10 (system exit)
syscall # Finish program execution
