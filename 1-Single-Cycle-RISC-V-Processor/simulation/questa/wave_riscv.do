onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/rst
add wave -noupdate /top_tb/DUT/alu_src
add wave -noupdate /top_tb/DUT/result_src
add wave -noupdate /top_tb/DUT/imm_src
add wave -noupdate /top_tb/DUT/PCSrc
add wave -noupdate /top_tb/DUT/instr
add wave -noupdate /top_tb/DUT/PC
add wave -noupdate /top_tb/DUT/branch
add wave -noupdate /top_tb/DUT/jump
add wave -noupdate /top_tb/DUT/mem_write
add wave -noupdate /top_tb/DUT/reg_write
add wave -noupdate /top_tb/DUT/alu_control
add wave -noupdate /top_tb/DUT/ALUResult
add wave -noupdate /top_tb/DUT/Zero
add wave -noupdate /top_tb/DUT/ReadData
add wave -noupdate /top_tb/DUT/WriteData
add wave -noupdate -divider Registers
add wave -noupdate {/top_tb/DUT/RF/REG[2]}
add wave -noupdate {/top_tb/DUT/RF/REG[3]}
add wave -noupdate {/top_tb/DUT/RF/REG[4]}
add wave -noupdate {/top_tb/DUT/RF/REG[5]}
add wave -noupdate {/top_tb/DUT/RF/REG[7]}
add wave -noupdate {/top_tb/DUT/RF/REG[9]}
add wave -noupdate -divider Memory
add wave -noupdate {/top_tb/DUT/DMEM/Data_mem[96]}
add wave -noupdate {/top_tb/DUT/DMEM/Data_mem[100]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {98 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 307
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
WaveRestoreZoom {0 ps} {221 ps}
