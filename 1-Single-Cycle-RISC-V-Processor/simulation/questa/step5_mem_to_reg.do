onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/rst
add wave -noupdate /top_tb/PCSrc
add wave -noupdate /top_tb/immSrc
add wave -noupdate /top_tb/ALUSrc
add wave -noupdate /top_tb/alu_op
add wave -noupdate /top_tb/MemWrite
add wave -noupdate /top_tb/RegWrite
add wave -noupdate /top_tb/MemToReg
add wave -noupdate -radix binary /top_tb/instr_in
add wave -noupdate /top_tb/DUT/ReadData
add wave -noupdate /top_tb/DUT/immExt
add wave -noupdate -divider {Register File}
add wave -noupdate -radix binary /top_tb/DUT/RF/A1
add wave -noupdate -radix binary /top_tb/DUT/RF/A2
add wave -noupdate -radix binary /top_tb/DUT/RF/A3
add wave -noupdate /top_tb/DUT/RF/WE3
add wave -noupdate /top_tb/DUT/RF/WD3
add wave -noupdate /top_tb/DUT/RF/RD1
add wave -noupdate /top_tb/DUT/RF/RD2
add wave -noupdate -radix hexadecimal /top_tb/DUT/RF/REG
add wave -noupdate {/top_tb/DUT/RF/REG[0]}
add wave -noupdate {/top_tb/DUT/RF/REG[1]}
add wave -noupdate {/top_tb/DUT/RF/REG[3]}
add wave -noupdate {/top_tb/DUT/RF/REG[2]}
add wave -noupdate -divider data_memory
add wave -noupdate /top_tb/DUT/DMEM/WE
add wave -noupdate /top_tb/DUT/DMEM/A
add wave -noupdate /top_tb/DUT/DMEM/WD
add wave -noupdate /top_tb/DUT/DMEM/RD
add wave -noupdate -radix hexadecimal /top_tb/DUT/DMEM/Data_mem
add wave -noupdate {/top_tb/DUT/DMEM/Data_mem[9]}
add wave -noupdate {/top_tb/DUT/DMEM/Data_mem[8]}
add wave -noupdate -divider ALU
add wave -noupdate /top_tb/DUT/ALU_UNIT/SrcA
add wave -noupdate /top_tb/DUT/ALU_UNIT/SrcB
add wave -noupdate /top_tb/DUT/ALU_UNIT/ALUControl
add wave -noupdate /top_tb/DUT/ALU_UNIT/ALUResult
add wave -noupdate /top_tb/DUT/ALU_UNIT/Zero
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {91104 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 244
configure wave -valuecolwidth 100
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
WaveRestoreZoom {0 ps} {94500 ps}
