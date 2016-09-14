# Melexis MIPS Project
# Oleg Zaichenko
#
# Test 006
#
# Tests load commands
#
# Commands tested:
#   addi, lui, sw, lw, lh, lb, lhu, lbu, beq, bne, ori, nop
#
# Expected Behavior:
# If successful, it should write the value 0x00000005 to address 4
#

				j			main							# jump to main code
				nop											# jump delay slot
				j			except						# jump to exception handler
				nop											# jump delay slot
				
main:   addi $4, $0, 0x18        # $4 = 0x18
        addi $5, $0, 0           # $5 = 0
        lui  $3, 0x1234          #
        ori  $3, $3, 0xabcd      # $3 = 0x1234abcd
        sw   $3, 0($4)           # Store 0x1234abcd in 0x18
        lw   $6, 0($4)           # load $6 = 0x1234abcd
        bne  $6, $3, b1          # if ($6 == $3) => pass
        nop                      # branch delay slot
        addi $5, $5, 1           # $5++ - test pass count
b1:     lh   $6, 0($4)           # $6 = 0xffffabcd
        lui  $7, 0xffff          # $7 = 0xffff0000
        or   $7, $7, $3          # $7 = 0xffffabcd
        bne  $7, $6, b2          # if ($6 == $7) => pass
        nop                      # branch delay slot
        addi $5, $5, 1           # $5++ - test pass count
b2:     lb   $6, 1($4)           # load $6 = 0xffffffab = -85
        addi $7, $0, -85         # $7 = -85
        bne  $7, $6, b3          # if ($6 == $7) => pass
        nop                      # branch delay slot
        addi $5, $5, 1           # $5++ - test pass count
b3:     lbu  $6, 1($4)           # load $6 = 0x000000ab
        addi $7, $0, 0xab        # $7 = 0xab
        bne  $7, $6, b4          # if ($6 == $7) => pass
        nop                      # branch delay slot
        addi $5, $5, 1           # $5++ - test pass count
b4:     lhu  $6, 2($4)           # load $6 = 0x00001234
        addi $7, $0, 0x1234      # $7 = 0x1234
        bne  $7, $6, b5          # if ($6 == $7) => pass
        nop                      # branch delay slot
        addi $5, $5, 1           # $5++ - test pass count
b5:     sw   $5, 4($0)           # Store 0x00000005 in 0x4 (result for tb)
				addi $1, $0, 1					 # initialize $1 = 1
				sw	 $1, 0($0)					 # should write 1 to address 0 (finish for tb)
loop:   beq  $0, $0, loop        # Infinite Loop
        nop

except: # if exception occurs, then finish test
				addi $1, $0, 1					# initialize $1 = 1
				sw	 $1, 0($0)					# should write 1 to address 0 (finish for tb)
				eret