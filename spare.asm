# Program calculates the value of scalar product ov vectors

      .data
Array1: .float  120.1, 1.2352, 2.11, -3.14, 7.348, -1.9, 5.336  # array of real values
Array2: .float  34.4, 56.812, 3.62, 63.817, -4.365, 61.89, 25.478  # array of real values

Size_of_Arrays: .word  7    # size of "array1"

Text_intro: .asciiz "\n The Scalar Product of 2 vectors: \n"
Text_result: .asciiz "\n The Result of Scalar Product is: "
Text_Done: .asciiz "\n Finished...\n"
Text_End: .asciiz " \n"      # end of print numbers
space:.asciiz  " "           # space to insert between numbers
#==============================================================
      .text
#-----------------------------
      la   $a0, Text_intro    # load address of print heading
      li   $v0, 4             # specify Print String service
      syscall                 # print heading
#-----------------------------
      la   $t0, Array1          # load address of printed value
      lw   $t1, Size_of_Arrays  # load size of array
      jal Print_float_Array     # Print array of values

      la   $t0, Array2          # load address of printed value
      lw   $t1, Size_of_Arrays  # load size of array
      jal Print_float_Array     # Print array of values
#-----------------------------
# calculate the scalar product of vectors:
      la   $t0, Array1          # load address of printed value
      lw   $t1, Size_of_Arrays  # load size of array as the loop counter
      la   $t2, Array2          # load address of printed value
      sub.s $f3 , $f3, $f3      # f3 = 0.0
L_product1:      
      lwc1 $f0,0($t0)        # load floating value1 f0 = Array1[t0]
      lwc1 $f2,0($t2)        # load floating value2 f2 = Array2[t2]

      mul.s $f1,$f0,$f2      # f1 = f0 x f2
      add.s $f3,$f3,$f1      # f3 = f3 + f1

      addi $t0, $t0, 4        # increment address of value1
      addi $t2, $t2, 4        # increment address of value2
      subi $t1, $t1, 1        # decrement loop counter
   bgtz $t1, L_product1       # repeat loop if not finished
      
#-----------------------------
      la   $a0, Text_result   # load address of print heading
      li   $v0, 4             # specify Print String service
      syscall                 # print heading
#-----------------------------
      mov.s $f12,$f3          # moving value f3 to f12 for service usage
      li   $v0, 2             # specify Print Float service
      syscall                 # print current value
#-----------------------------
      la   $a0, Text_Done   # load address of print heading
      li   $v0, 4             # specify Print String service
      syscall                 # print heading
#-----------------------------
      li   $v0, 10            # system call for exit
      syscall                 # we are out of here.

#===================================================================
Print_float_Array:                 # Print array of floating values
#-----------------------------
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
      subi $t1, $t1, 1        # decrement loop counter
   bgtz $t1, L_print1         # repeat print if not finished
#-----------------------------
      la   $a0, Text_End      # load address of spacer for syscall
      li   $v0, 4             # specify Print String service
      syscall                 # output string
#-----------------------------
      jr   $ra                # return
#-----------------------------------------------------------------

