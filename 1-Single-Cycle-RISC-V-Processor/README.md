# Single-Cycle RISC-V Processor

## Step 1: Instruction Fetch

The first stage in the single-cycle datapath is the **Instruction Fetch**. During this step, the processor reads the instruction from the instruction memory at the address specified by the Program Counter (PC).

### Modules involved:

- **Program Counter (PC):** Holds the address of the current instruction. It updates on each clock cycle to point to the next instruction address.
- **Instruction Memory:** A read-only memory module that outputs the instruction stored at the address provided by the PC.

### Process overview:

- The PC provides the current instruction address to the instruction memory.
- The instruction memory returns the 32-bit instruction located at that address.
- The PC is then updated to the next address, depending on `PCSrc` to determine if it should proceed to the next sequential instruction or jump to a target address.

### Simulation Waveform

The waveform below shows the behavior of the PC and instruction fetch signals during simulation.

![Instruction Fetch Waveform](./simulation_waveforms/step1_instruction_fetch.png)

## Step 2: Read source operand (rs1) from RF

The second stage in the single-cycle datapath is the **Register Read**. In this step, the processor reads the first source operand (`rs1`) from the register file, based on the instruction that was just fetched.

### Modules involved:

- **Register File:** Contains 32 general-purpose registers, each 32 bits wide. It supports two simultaneous reads and one write.

### Process overview:

- The instruction bits `[19:15]` specify the address of source register `rs1`.
- This address (`A1`) is fed into the register file.
- The register file outputs the 32-bit value stored at that register (`RD1`), which will later be used by the ALU or memory stages.

### Simulation Waveform

The waveform below shows the values being read from `rs1`, as well as how the address `A1` is derived from the instruction bits.

![Register Read Waveform](./simulation_waveforms/step2_register_read_rs1.png)

## Step 3: Immediate Extension

The third stage in the single-cycle datapath is **Immediate Extension**. This step involves extracting and sign-extending the immediate field of the instruction, depending on its format.

### Modules involved:

- **Immediate Generator:** Based on the value of `immSrc`, this module takes the appropriate bits of the instruction and produces a 32-bit sign-extended immediate value.

### Process overview:

- The instruction bits `[31:0]` are passed as `extend_in`.
- The `immSrc` signal determines the instruction type:
  - `00`: I-type
  - `01`: S-type
  - `10`: B-type
  - `11`: J-type
- The immediate generator extracts the immediate fields and sign-extends them to 32 bits.

### Instruction Type Examples

**I-type**  
Instruction: `00000000110000000000000110010011`  
`immSrc = 00`  
Immediate field: 
- `instr[31] = 0`
- `instr[31:20] = 000000001100`  
`immExt = {{20{0}}, 000000001100}`  
➡ `immExt = 00000000000000000000000000001100`

![Immediate Extension - I-type](./simulation_waveforms/step3_immediate_i.png)

---

**S-type**  
Instruction: `11111111011100011000001110010011`  
`immSrc = 01`  
Immediate field: 
- `instr[31] = 1`
- `instr[31:25] = 1111111`
- `instr[11:7] = 00111`  
`immExt = {{20{1}}, 1111111, 00111}`  
➡ `immExt = 11111111111111111111111111100111`

![Immediate Extension - S-type](./simulation_waveforms/step3_immediate_s.png)

---

**B-type**  
Instruction: `00000000001000111110001000110011`  
`immSrc = 10`  
Immediate field:
- `instr[31] = 0`
- `instr[7] = 0`
- `instr[30:25] = 000000`
- `instr[11:8] = 0010`  
`immExt = {{19{0}}, 0, 0, 000000, 0010, 0}`  
➡ `immExt = 00000000000000000000000000000100`

![Immediate Extension - B-type](./simulation_waveforms/step3_immediate_b.png)

---

**J-type**  
Instruction: **`00000000010000011111001010110011`**  
`immSrc = 11`  
Immediate field:
- `instr[31] = 0`
- `instr[19:12] = 00011111`
- `instr[20] = 0`
- `instr[30:21] = 0000000010`  
`immExt = {{12{0}}, 00011111, 0, 0000000010, 0}`  
➡ `immExt = 00000000000000011111000000000100`

![Immediate Extension - J-type](./simulation_waveforms/step3_immediate_j.png)