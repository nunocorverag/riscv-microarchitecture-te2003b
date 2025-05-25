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

---
## Step 4: ALU Decoder & ALU Operations

The fourth stage of the single-cycle datapath verifies both the **ALU Decoder** and the **ALU** modules, which are essential for performing arithmetic and logical operations depending on the RISC-V instruction format.

---

### 4.1 ALU Decoder

The **ALU Decoder** determines which operation the ALU must perform based on control signals and instruction fields.

#### Modules involved:
- **ALU Decoder**

#### Input Signals:
- `alu_op`: A 2-bit control signal from the main decoder. It indicates the instruction category:
  - `00` → Load/Store (ADD)
  - `01` → Branch (SUB)
  - `10` → R-type or I-type ALU operations
- `funct3`, `funct7[5]`, `opcode[5]`: Fields from the instruction that identify the specific operation.

#### Output Signal:
- `alu_control`: A 3-bit signal that tells the ALU what operation to perform.

#### Operation Mapping:
- `3'b000`: ADD
- `3'b001`: SUB
- `3'b010`: AND
- `3'b011`: OR
- `3'b101`: SLT (Set Less Than)

#### Simulation Waveform

The simulation below demonstrates the correct generation of the `alu_control` signal for different combinations of `alu_op` and instruction fields:

![ALU Decoder Simulation](./simulation_waveforms/step4_alu_decoder.png)

---

### 4.2 ALU (Arithmetic Logic Unit)

The **ALU** executes arithmetic and logical operations between two operands based on the operation selected by `ALUControl`.

#### Modules involved:
- **ALU**

#### Input Signals:
- `SrcA`, `SrcB`: Operands (32-bit values)
- `ALUControl`: Operation selector (3 bits)

#### Output Signals:
- `ALUResult`: The result of the selected operation.
- `Zero`: Set to 1 if the result is 0.

#### Supported Operations:
- `3'b000`: ADD
- `3'b001`: SUB
- `3'b010`: AND
- `3'b011`: OR
- `3'b101`: SLT (signed comparison)
- Any other value results in output = 0

#### Simulation Waveform

The waveform shows how the ALU handles various scenarios, including signed comparisons and bitwise operations:

![ALU Simulation](./simulation_waveforms/step4_alu.png)

---

### Console Verification Output

Below is the console output confirming that all expected `alu_control` and `ALUResult` values match the expected outputs. This validates the correctness of both modules:

![Console ALU Decoder](./simulation_waveforms/step4_console_decoder.png)  
![Console ALU](./simulation_waveforms/step4_console_alu.png)