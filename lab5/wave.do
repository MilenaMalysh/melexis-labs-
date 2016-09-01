onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_mips/mips_instance/clk
add wave -noupdate -radix hexadecimal /tb_mips/mips_instance/prog_counter
add wave -noupdate -radix hexadecimal /tb_mips/mips_instance/instruction
add wave -noupdate /tb_mips/mips_instance/we_are_jumping
add wave -noupdate -radix hexadecimal /tb_mips/mips_instance/jump_address
add wave -noupdate /tb_mips/mips_instance/immediate
add wave -noupdate /tb_mips/mips_instance/ext_imm16
add wave -noupdate /tb_mips/mips_instance/reg_a_addr
add wave -noupdate /tb_mips/mips_instance/reg_b_addr
add wave -noupdate /tb_mips/mips_instance/reg_write_addr
add wave -noupdate /tb_mips/mips_instance/alu_a
add wave -noupdate -radix binary /tb_mips/mips_instance/alu_b
add wave -noupdate -radix binary /tb_mips/mips_instance/alu_out
add wave -noupdate /tb_mips/mips_instance/reg_a
add wave -noupdate /tb_mips/mips_instance/reg_b
add wave -noupdate /tb_mips/mips_instance/reg_write_data
add wave -noupdate /tb_mips/mips_instance/reg_we
add wave -noupdate /tb_mips/mips_instance/mem_we
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2185000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 247
configure wave -valuecolwidth 251
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {2170565 ps} {2202257 ps}
