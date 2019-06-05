# Write a program that sorts the given sequence of integers using bubble-sort algorithm.

      .data
Array1: .word   120,0,2,-3,7,-1,5  # array of integer values
Size_of_Array1: .word  7    # size of "array1"

Text_intro: .asciiz "\n Buble-sort algorythm \n"
Text_result: .asciiz "\n Result of sorting: \n"
Text_Done: .asciiz "\n Finished...\n"
Text_End: .asciiz " \n"      # end of print numbers
space:.asciiz  " "           # space to insert between numbers
#==============================================================
      .text
#-----------------------------
      la   $a0, Text_intro    # load address of print heading
      li   $v0, 4             # specify Print String service
      syscall                 # print heading
      
      jal Print_Array1        # Print array of integer values
#-----------------------------

      jal Buble_sort_Array1   # call sorting algorythm
      
#-----------------------------
      la   $a0, Text_result   # load address of print heading
      li   $v0, 4             # specify Print String service
      syscall                 # print heading
#-----------------------------
      jal Print_Array1        # Print array of integer values
      
#-----------------------------
      li   $v0, 10            # system call for exit
      syscall                 # we are out of here.

#===================================================================
Print_Array1:                 # Print array of integers
      la   $t0, Array1        # load address of printed value
      lw $t1, Size_of_Array1  # load size of array as the loop counter
#-----------------------------
  L_print1:
      lw $a0,0($t0)           # load pinted value
      li   $v0, 1             # specify Print Integer service
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

Buble_sort_Array1:  # Sorting algorythm
# Buble-sort algorythm:  $t0 - address of the first number, $t1 - loop counter, $a0, $a1, $t2 - temporary values

      la   $t0, Array1        # load address of the first number
      move $t2, $t0           # copy begin address to temporary value
      lw $t1, Size_of_Array1  # load size of array as the loop counter
      subi $t1, $t1, 1        # decrement loop counter

 L_sort1:                     # begin sort loop: compare two numbers:
      lw $a0,0($t0)           # a0 = first number
      lw $a1,4($t0)           # a1 = second number

   ble $a0,$a1,NO_sort2       # if the numbers are sorted, then continue sorting.
      
      sw $a1,0($t0)           # first number = a1
      sw $a0,4($t0)           # second number = a0
      
   beq $t0, $t2, NO_sort2     # if the first number is on the beginning of array, then continue sorting,

      subi $t0, $t0, 4        # else take the previous element
      addi $t1, $t1, 1        # and increment loop counter
      b L_sort1               # then compare previous elements

   NO_sort2:                  # continue sorting:
      addi $t0, $t0, 4        # increment address of the first number
      subi $t1, $t1, 1        # decrement loop counter
      
 bgtz $t1, L_sort1            # repeat sort loop if not finished
      jr   $ra                # return
#-----------------------------------------------------------------
