//-----------------------------------------------------
// File Name : prog.sv
// Function : Program memory [program_code_size x instruction_size] - reads from file prog.hex
// Author: Sayedur Khan, 
// Last rev. 24 Apr 2023
//-----------------------------------------------------
`include "global_parameters.sv"
module program_memory #(parameter program_code_size = `PROGRAM_CODE_SIZE, instruction_size = `INSTRUCTION_SIZE) // program_code_size - address width, instruction_size - instruction width
(input wire [program_code_size-1:0] address,
output logic [instruction_size-1:0] instruction_code); 

// program memory declaration, note: 1<<n is same as 2^n
  logic [instruction_size-1:0] prog_memory [(1<<program_code_size)-1:0];

// get memory contents from file
initial
  $readmemh("prog.hex", prog_memory);
  
// program memory read 
always_comb
  instruction_code = prog_memory[address];
  
endmodule // end of module program_memory
