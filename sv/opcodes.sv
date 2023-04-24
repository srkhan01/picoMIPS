// opcode set for custom picoMIPS
`define NOP 3'b010
`define ADD 3'b001
`define MULT 3'b011 // Signed multiply
`define ADDI 3'b101
`define COPY 3'b110 // Copy data from one register to another
`define MULTI 3'b111 // Signed multiply with immediate operand
`define WLD0 3'b000 // Wait for SW8=0 then copy data from one register into register
`define WLD1 3'b100 // Wait for SW8=1 then copy data from one register into register