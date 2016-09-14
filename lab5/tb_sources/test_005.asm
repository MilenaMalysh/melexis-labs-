# Melexis MIPS Project
# Oleg Zaichenko
#
# Test 005
#
# Tests store commands
#
# Commands tested:
#   addi, sll, sw, sh, sb, lw, beq, j, nop
#
# Expected Behavior:
# If successful, it should write the value 0x550000ff to address 4
#
				
				j			main							# jump to main code
				nop											# jump delay slot
				j			except						# jump to exception handler
				nop											# jump delay slot

main:   addi $3, $0, -1          # $3 = 0xffffffff
        addi $4, $0, 8        	 # $4 = 0x8
        sw   $3, 0($4)           # Store 0xffffffff in 0x8
        sb   $0, 1($4)           # store 0x00 in 0x9 (not aligned)
        addi $6, $0, 0x5555      # $6 = 0x5555
        sll  $6, $6, 8           # $4 = 0x00555500
        sh   $6, 2($4)           # store 0x5500 in upper two bytes of 0x8 (at 0xa)
        lw   $5, 0($4)           # load $5 = 0x550000ff
				nop
        sw   $5, 4($0)           # Store 0x550000ff in 0x4 (result for tb)
				addi $1, $0, 1					 # initialize $1 = 1
				sw	 $1, 0($0)					 # should write 1 to address 0 (finish for tb)
loop:   beq  $0, $0, loop        # Infinite Loop
				nop											 # Branch Delay slot

except: # if exception occurs, then finish test
				addi $1, $0, 1					# initialize $1 = 1
				sw	 $1, 0($0)					# should write 1 to address 0 (finish for tb)
				eret