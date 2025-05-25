onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/clk
add wave -noupdate /top_tb/rst
add wave -noupdate /top_tb/PCSrc
add wave -noupdate -divider top_pc
add wave -noupdate /top_tb/DUT/PCSrc_in
add wave -noupdate /top_tb/DUT/PCSrc
add wave -noupdate /top_tb/DUT/PC
add wave -noupdate /top_tb/DUT/PCTarget
add wave -noupdate /top_tb/DUT/PCPlus4
add wave -noupdate /top_tb/DUT/PCNext
add wave -noupdate -divider top_instr
add wave -noupdate -radix binary /top_tb/DUT/instr
add wave -noupdate -divider program_counter
add wave -noupdate /top_tb/DUT/PC_REG/pc
add wave -noupdate /top_tb/DUT/PC_REG/pcNext
add wave -noupdate -divider instruction_memory
add wave -noupdate /top_tb/DUT/IM/A
add wave -noupdate /top_tb/DUT/IM/RD
add wave -noupdate -divider register_file
add wave -noupdate -radix binary /top_tb/DUT/RF/A1
add wave -noupdate /top_tb/DUT/RF/A2
add wave -noupdate /top_tb/DUT/RF/A3
add wave -noupdate /top_tb/DUT/RF/WE3
add wave -noupdate /top_tb/DUT/RF/WD3
add wave -noupdate /top_tb/DUT/RF/RD1
add wave -noupdate /top_tb/DUT/RF/RD2
add wave -noupdate /top_tb/DUT/RF/REG
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 242
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
WaveRestoreZoom {9947 ps} {44873 ps}
