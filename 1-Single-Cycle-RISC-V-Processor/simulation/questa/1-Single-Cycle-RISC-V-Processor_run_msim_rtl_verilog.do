transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor {C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor/immediate_generator.v}
vlog -vlog01compat -work work +incdir+C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor {C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor/top.v}
vlog -vlog01compat -work work +incdir+C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor {C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor/register_file.v}
vlog -vlog01compat -work work +incdir+C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor {C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor/program_counter.v}
vlog -vlog01compat -work work +incdir+C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor {C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor/alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor {C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor/alu_decoder.v}
vlog -vlog01compat -work work +incdir+C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor {C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor/instruction_memory.v}

vlog -vlog01compat -work work +incdir+C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor {C:/Users/gnuno/Documents/Academic/Tec/Sem-4-2025/TE2003B-System-Design-on-Chip/riscv-microarchitecture-te2003b/1-Single-Cycle-RISC-V-Processor/alu_decoder_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L fiftyfivenm_ver -L rtl_work -L work -voptargs="+acc"  alu_decoder_tb

add wave *
view structure
view signals
run -all
