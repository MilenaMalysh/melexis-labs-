# Melexis MIPS Project
# Oleg Zaichenko
#
# Test 008
#
# Store/Load exception test.
#
# Commands tested:
#   addi, add, lui, sw, beq, bne, mfc0, mtc0, eret, j, nop
#
# Expected Behavior:
# If successful, it should write the value 0x00000004 to address 4
#

				j			main							# jump to main code
				nop											# jump delay slot
				j			except						# jump to exception handler
				nop											# jump delay slot
				
main:   addi $3, $0, 0					# initialize $3 = 0 
        sh $0, 3($0)            # misaligned halfword write (store exception occurs)
        lh $2, 3($0)            # misaligned halfword load (load exception occurs)
        
        sw $0, 2($0)            # misaligned word write (store exception occurs)
        lw $2, 2($0)            # misaligned word read (load exception occurs)
        
        sh $0, 2($0)            # halfaligned halfword write (should succeed)
        lh $2, 2($0)            # halfaligned halfword write (should succeed)
                
        sw    $3, 4($0)         # should write 0x00000004 to address 4 (result for tb)
				addi  $1, $0, 1					# initialize $1 = 1
				sw	  $1, 0($0)					# should write 1 to address 0 (finish for tb)
end:    beq   $0, $0, end       # loop forever
        nop											# branch delay slot

except: mfc0  $4, $13           # get the cause register
				add		$5, $0, $4				# $5 = $4 save cause register value 
				
        andi  $4, 0x18          # check store and load exceptions (bit 3 and bit 4)
				beq		$4, $0, illegal_exception
				nop 										# branch delay slot
				
        addi  $3, $3, 1         # $1++
        j     exit       				# jump to exit
        nop 										# branch delay slot
				
illegal_exception:              # do if another exception occurs
				andi  $5, 0x01          # check external interrupt (bit 0)
        bne		$5, $0, exit_int	# if external interrupt occurs, then don't change exception address
				nop 										# branch delay slot
				
exit:		mfc0  $7, $14           # get the exception address
				addi  $7, $7, 4         # choose next intsruction
				mtc0	$7, $14						# change exception address
exit_int:				
        eret                    # Return from exception
