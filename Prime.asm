#  Write a program that finds all primary numbers from some specified range.

      .data
Array1: .word   0:120  # array of integer values for prime numbers
Size_of_Array1: .word  100    # size of "Array1"

Text_intro: .asciiz "\n  Prime Numbers: \n"
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
      la $t0, Array1          # load address of current prime value
      lw $t1, Size_of_Array1  # load MAX SIZE of array for main loop

      li $t2,2                # FIRST prime
      sw $t2,($t0)            # save to Array.
      addi $t0,$t0,4          # Next element.
      li $t2,3                # SECOND prime
      sw $t2,($t0)            # save to Array.
      li $t4,2                # we have 2 primes in Array
      sub $t1, $t1, $t4       # 2 main loops has been done
#---------------------------- loop for supposition new primes:
 Next_prime:
      addi $t2,$t2,2          # suppose, that the net prime is odd

      la $t5,Array1           # load the BEGIN ADDRESS of testing
      subi $t6,$t4,1          # CURRENT counter of prime divisor not includes first prime
      
   Loop_Test_Prime:
      addi $t5,$t5,4          # Address of next prime (as the divisor)
      
      ld $t3($t5)             # load divisor
      div $t2,$t3             # Prime is a number which is not divided on another prime without remainder
      mfhi $t3                # load the remainder
  beq $t3, 0, Next_prime      # test the remainder to suppose the next prime

      subi $t6, $t6, 1        # decrement CURRENT loop counter and
    bgtz $t6, Loop_Test_Prime # branch if it greater than zero
#-----------------------------
      addi $t0,$t0,4          # Get next element of Array,
      sw $t2,($t0)            # store NEW PRIME in it.
      addi $t4,$t4,1          # Increment NUMBER of primes in Array,
      subi $t1, $t1, 1        # decrement loop counter and
   bgtz $t1, Next_prime       # repeat untill the Array is not filled.

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
