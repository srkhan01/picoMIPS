//---------------------------------------------------------
// File Name   : test_program_memory.sv
// Function    : testbench for picoMIPS program memory 
// Author: Sayedur Khan
// ver 1:  
// Last revised: 21 Apr 2023
//---------------------------------------------------------
`include "global_parameters.sv"
//---------------------------------------------------------
module test_program_memory;

  timeunit 1ns;

  parameter program_code_size = `PROGRAM_CODE_SIZE;
  parameter instruction_size = `INSTRUCTION_SIZE;

  // Inputs
  logic [program_code_size-1:0] address;
  
  // Outputs
  wire [instruction_size-1:0] instruction_code;

  program_memory  #(
	.program_code_size(program_code_size),
	.instruction_size(instruction_size))
    pm (
	.address(address),
	.instruction_code(instruction_code));
	
  // memory
  logic [instruction_size-1:0] memory [ (1<<program_code_size)-1:0];

initial begin

  // load program from hex file
  $readmemh("prog.hex", memory);
  
  // iterate through the program
  for(int i = 0; i < (1<<program_code_size); i++) begin
    #4
    address = i;
	#1
	$display("memory[%h] = %h, instruction_code = %h", address, memory[address], instruction_code);
  end
  
end
endmodule //module test_program_memory --------------------------------