# Implement the matrix multiplication algorithm for rectangular matrices. Matrixes size can be specified in any way.

      .data
Matrix1: .float  120.1, 1.2352, 2.11, -3.14,    7.348, -1.9, 5.336, 6.732  # array of Matrix 4x2
Matrix2: .float  34.4, 56.812,-8.93    3.62, 63.817, -6.75    -4.365, 61.89,-11.08,    25.478, -12.7, 31.77  # array of Matrix 3x4
Matrix3:  .float  0:120   # reserved 120 elements

H_1: .word  4    # size of Matrix1 by horizontal
V_1: .word  2    # size of Matrix1 by Vertical

H_2: .word  3    # size of Matrix2 by horizontal
V_2: .word  4    # size of Matrix2 by Vertical

Text_intro: .asciiz "\n Matrix Multiplication Algorithm: \n"
Text_Matrix1: .asciiz "\n First Matrix is: \n"
Text_Matrix2: .asciiz "\n Second Matrix is: \n"
Text_result: .asciiz "\n  Matrix 3 = (Matrix 1) x (Matrix 2): \n"
Text_End: .asciiz " \n"      # end of print numbers
space:.asciiz  "	"           # space to insert between numbers
#==============================================================
      .text
#-----------------------------
      la   $a0, Text_intro    # load address of print heading
      li   $v0, 4             # specify Print String service
      syscall                 # print heading
#-----------------------------
      la   $a0, Text_Matrix1  # load address of print heading
      li   $v0, 4             # specify Print String service
      syscall                 # print heading
#-----------------------------
      la   $t0, Matrix1          # load address of printed value
      lw   $t1, H_1              # load horizontal size of matrix
      lw   $t2, V_1              # load vertical size of matrix
      jal Print_float_Matrix     # Print Matrix of values (t1 x t2)
#-----------------------------
      la   $a0, Text_Matrix2    # load address of print heading
      li   $v0, 4               # specify Print String service
      syscall                   # print heading
#-----------------------------
      la   $t0, Matrix2          # load address of printed value
      lw   $t1, H_2              # load horizontal size of matrix
      lw   $t2, V_2              # load vertical size of matrix
      jal Print_float_Matrix     # Print Matrix of values (t1 x t2)
#-----------------------------

      jal Multiply_Matrixes       # call the procedure of Matrixes Multiplication:  Matrix3 = Matrix1 x Matrix2
 
#-----------------------------
      la   $a0, Text_result   # load address of print heading
      li   $v0, 4             # specify Print String service
      syscall                 # print heading
#-----------------------------
      la   $t0, Matrix3          # load address of printed value
      lw   $t1, H_2              # load horizontal size of matrix
      lw   $t2, V_1              # load vertical size of matrix
      jal Print_float_Matrix     # Print Matrix of values (t1 x t2)
#-----------------------------
      li   $v0, 10            # system call for exit
      syscall                 # we are out of here.

#===================================================================
Print_float_Matrix:                 # Print Matrix of values (t1 x t2)
                                    # $t0 = address of matrix;
                                    # $t1 = H    horizontal size of matrix;
                                    # $t2 = V    vertical size of matrix.
#-----------------------------
L_print2:
      move $t3,$t1            # use the temporary register t3
  L_print1:
      lwc1 $f12,0($t0)        # load pinted value
      li   $v0, 2             # specify Print Float service
      syscall                 # print current value
#-----------------------------
      la   $a0, space         # load address of spacer for syscall
      li   $v0, 4             # specify Print String service
      syscall                 # output string
#-----------------------------
      addi $t0, $t0, 4        # increment address of printed value
      subi $t3, $t3, 1        # decrement loop counter
   bgtz $t3, L_print1         # repeat print if not finished
#-----------------------------
      la   $a0, Text_End      # load address of spacer for syscall
      li   $v0, 4             # specify Print String service
      syscall                 # output string
#-----------------------------
      subi $t2, $t2, 1        # decrement loop counter
 bgtz $t2, L_print2           # repeat print if not finished
#-----------------------------
      la   $a0, Text_End      # load address of spacer for syscall
      li   $v0, 4             # specify Print String service
      syscall                 # output string
#-----------------------------
      jr   $ra                # return
#-----------------------------------------------------------------

Multiply_Matrixes:           # Matrix3 = Matrix1 x Matrix2

      lw  $t1,H_2            # t4 = H_2 x 4,
      mul $t4,$t1,4          # calculate the offset between elements of Matrix2 (in column)

      la $t5, Matrix3        # address of result Matrix
      la $a1, Matrix1        # address of the FIRST Matrix
      lw $t6, V_1            # ROW1 counter
L_product3:      
      la $a2, Matrix2        # address of the SECOND Matrix
      lw $t3, H_2            # COLUMN2 counter

 L_product2:      
      lw     $t1, H_1          # load size of array as the loop counter
      move   $t0, $a1          # load address of printed value
      move   $t2, $a2          # load address of printed value
      sub.s  $f3 , $f3, $f3    # f3 = 0.0
     
   L_product1:               # calculate the multiplication ROW1 by COLUMN2:
      lwc1 $f0,0($t0)        # load floating value1 f0 = Array1[t0]
      lwc1 $f2,0($t2)        # load floating value2 f2 = Array2[t2]

      mul.s $f1,$f0,$f2      # f1 = f0 x f2
      add.s $f3,$f3,$f1      # f3 = f3 + f1

      addi $t0, $t0, 4        # increment address of ROW
      add $t2, $t2, $t4       # address of the next element in COLUMN
      subi $t1, $t1, 1        # decrement loop counter
    bgtz $t1, L_product1      # repeat loop if not finished

      swc1 $f3,($t5)          # Store the result in Matrix3
      add $t5,$t5,4           # Get next address in Matrix3
#-----------------------------
      addi $a2,$a2,4          # Go to the next column in Matrix2
      subi $t3,$t3,1          # decrement COLUMN2 counter
  bgtz $t3,L_product2         # continue loop
#-----------------------------
      lw  $t1,H_1            # t2 = H_1 x 4
      mul $t2,$t1,4          # calculate the offset between elements of Matrix1 (in column)
      add $a1,$a1,$t2        # calculate the begin address of the next ROW1
      subi $t6,$t6,1         # decrement ROW1 counter
 bgtz $t6,L_product3         # repeat until it is not finished

      jr   $ra                # return
#-----------------------------------------------------------------
