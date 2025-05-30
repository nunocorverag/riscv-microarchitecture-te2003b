# RISC-V Execution Table - Complete Program

| PC     | Instruction (hex) | Instruction ASM       | Operation                            | Registers Read                | Modified Register   | Final Value (hex) | Control Signals                                                     |
|--------|--------------------|------------------------|------------------------------------|-------------------------------|---------------------|-------------------|---------------------------------------------------------------------|
| 0x00   | 00500113           | addi x2, x0, 5         | x2 = 0 + 5                         | x0 = 0x0                      | x2                  | 0x5               | reg_write=1, alu_src=1, result_src=00, imm_src=00, alu_control=000  |
| 0x04   | 00C00193           | addi x3, x0, 12        | x3 = 0 + 12                        | x0 = 0x0                      | x3                  | 0xC               | reg_write=1, alu_src=1, result_src=00, imm_src=00, alu_control=000  |
| 0x08   | FF718393           | addi x7, x3, -9        | x7 = 12 + (-9)                     | x3 = 0xC                      | x7                  | 0x3               | reg_write=1, alu_src=1, result_src=00, imm_src=00, alu_control=000  |
| 0x0C   | 0023E233           | or x4, x7, x2          | x4 = 0x3 \| 0x5                    | x7 = 0x3, x2 = 0x5            | x4                  | 0x7               | reg_write=1, alu_src=0, result_src=00, alu_control=011              |
| 0x10   | 0041F2B3           | and x5, x3, x4         | x5 = 0xC & 0x7                     | x3 = 0xC, x4 = 0x7            | x5                  | 0x4               | reg_write=1, alu_src=0, result_src=00, alu_control=010              |
| 0x14   | 004282B3           | add x5, x5, x4         | x5 = 0x4 + 0x7                     | x5 = 0x4, x4 = 0x7            | x5                  | 0xB               | reg_write=1, alu_src=0, result_src=00, alu_control=000              |
| 0x18   | 02728863           | beq x5, x7, 48         | if (0xB == 0x3) → no branch        | x5 = 0xB, x7 = 0x3            | -                   | -                 | branch=1, alu_src=0, imm_src=10, alu_control=001, PCSrc=0           |
| 0x1C   | 0041A233           | slt x4, x3, x4         | x4 = (0xC < 0x7) ? 1 : 0           | x3 = 0xC, x4 = 0x7            | x4                  | 0x0               | reg_write=1, alu_src=0, result_src=00, alu_control=101              |
| 0x20   | 00020463           | beq x4, x0, 8          | if (0x0 == 0x0) → PC += 8          | x4 = 0x0, x0 = 0x0            | -                   | -                 | branch=1, alu_src=0, imm_src=10, alu_control=001, PCSrc=1           |
| 0x24   | 00000293           | addi x5, x0, 0         | SKIPPED due to branch              | -                             | -                   | -                 | -                                                                   |
| 0x28   | 0023A233           | slt x4, x7, x2         | x4 = (0x3 < 0x5) ? 1 : 0           | x7 = 0x3, x2 = 0x5            | x4                  | 0x1               | reg_write=1, alu_src=0, result_src=00, alu_control=101              |
| 0x2C   | 005203B3           | add x7, x4, x5         | x7 = 0x1 + 0xB                     | x4 = 0x1, x5 = 0xB            | x7                  | 0xC               | reg_write=1, alu_src=0, result_src=00, alu_control=000              |
| 0x30   | 402383B3           | sub x7, x7, x2         | x7 = 0xC - 0x5                     | x7 = 0xC, x2 = 0x5            | x7                  | 0x7               | reg_write=1, alu_src=0, result_src=00, alu_control=001              |
| 0x34   | 0471AA23           | sw x7, 84(x3)          | mem[0xC + 84] = 0x7                | x7 = 0x7, x3 = 0xC            | -                   | mem[0x60]=0x7     | mem_write=1, alu_src=1, imm_src=01, alu_control=000                 |
| 0x38   | 06002103           | lw x2, 96(x0)          | x2 = mem[0x60]                     | x0 = 0x0                      | x2                  | 0x7               | reg_write=1, alu_src=1, result_src=01, imm_src=00, alu_control=000  |
| 0x3C   | 005104B3           | add x9, x2, x5         | x9 = 0x7 + 0xB                     | x2 = 0x7, x5 = 0xB            | x9                  | 0x12              | reg_write=1, alu_src=0, result_src=00, alu_control=000              |
| 0x40   | 008001EF           | jal x3, 8              | x3 = 0x44, PC = 0x40 + 8           | -                             | x3                  | 0x44              | reg_write=1, jump=1, result_src=10, imm_src=11, PCSrc=1             |
| 0x44   | 00100113           | addi x2, x0, 1         | SKIPPED due to jump                | -                             | -                   | -                 | -                                                                   |
| 0x48   | 00910133           | add x2, x2, x9         | x2 = 0x7 + 0x12                    | x2 = 0x7, x9 = 0x12           | x2                  | 0x19              | reg_write=1, alu_src=0, result_src=00, alu_control=000              |
| 0x4C   | 0221A023           | sw x2, 32(x3)          | mem[0x44 + 32] = 0x19              | x2 = 0x19, x3 = 0x44          | -                   | mem[0x64]=0x19    | mem_write=1, alu_src=1, imm_src=01, alu_control=000                 |
| 0x50   | 00210063           | beq x2, x2, 0          | always true → infinite loop        | x2 = 0x19, x2 = 0x19          | -                   | -                 | branch=1, alu_src=0, imm_src=10, alu_control=001, PCSrc=1           |

## Register Changes Summary:

| Register | Initial Value | Final Value | Changes                      |
|----------|---------------|-------------|------------------------------|
| x0       | 0x0           | 0x0         | No changes (hardwired to 0)  |
| x2       | 0x0           | 0x19        | 0x0 → 0x5 → 0x7 → 0x19       |
| x3       | 0x0           | 0x44        | 0x0 → 0xC → 0x44             |
| x4       | 0x0           | 0x1         | 0x0 → 0x7 → 0x0 → 0x1        |
| x5       | 0x0           | 0xB         | 0x0 → 0x4 → 0xB              |
| x7       | 0x0           | 0x7         | 0x0 → 0x3 → 0xC → 0x7        |
| x9       | 0x0           | 0x12        | 0x0 → 0x12                   |

## Memory Changes:

| Address (hex) | Address (dec) | Value (hex) | Modified by instruction     |
|---------------|---------------|-------------|-----------------------------|
| 0x60          | 96            | 0x7         | sw x7, 84(x3) at PC 0x34    |
| 0x64          | 100           | 0x19        | sw x2, 32(x3) at PC 0x4C    |

## Execution Flow:

1. **Instructions 0x00-0x18**: Basic arithmetic and logical operations
2. **PC 0x18**: Branch not taken (0xB ≠ 0x3)
3. **PC 0x20**: Branch taken (0x0 == 0x0), jumps to PC 0x28
4. **PC 0x24**: Instruction skipped due to branch
5. **PC 0x28-0x3C**: More arithmetic operations and memory access
6. **PC 0x40**: Jump and link, jumps to PC 0x48 and saves return address
7. **PC 0x44**: Instruction skipped due to jump
8. **PC 0x48-0x50**: Final operations and infinite loop

## Notes:
- Instruction at PC 0x24 is skipped due to branch taken at PC 0x20
- Instruction at PC 0x44 is skipped due to jump from PC 0x40
- Program ends in an infinite loop at PC 0x50
- Memory values calculated correctly: 84₁₀ = 0x54₁₆, 96₁₀ = 0x60₁₆, 32₁₀ = 0x20₁₆