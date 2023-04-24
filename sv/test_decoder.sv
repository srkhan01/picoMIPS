//---------------------------------------------------------
// File Name   : test_decoder.sv
// Function    : testbench for picoMIPS instruction decoder 
// Author: Sayedur Khan
// ver 1:  //  NOP, ADD, MULT, ADDI, COPY, MULTI, WLD0, WLD1
// Last revised: 24 Apr 2023
//---------------------------------------------------------
// TODO
`include "alucodes.sv"
`include "opcodes.sv"
`include "global_parameters.sv"
//---------------------------------------------------------
module test_decoder;

  timeunit 1ns;

  parameter opcode_size = `OPCODE_SIZE;
  
  // Inputs
  logic [opcode_size-1:0] opcode; 
  logic sw8; // handshake switch
  
  // Outputs
  wire pc_inc, imm, w;
  wire [1:0] alu_func; // ALU function


  decoder  D (
	.opcode(opcode),
	.pc_inc(pc_inc),
	.alu_func(alu_func),
	.imm(imm),
	.w(w),
	.handshake_switch(sw8));

initial begin
  sw8 = 0; // handshake switch (sw[8]) begins in 0 position
  
  #2 
  #10 opcode = `WLD1; // wait for handshake = 1 then load
  #5 sw8 = 1;
  
  #10 opcode = `ADD;
  #10 opcode = `MULT;
  #10 opcode = `ADDI;
  #10 opcode = `COPY;
  #10 opcode = `MULTI;
  #10 opcode = `WLD0;
  #5 sw8 = 0;
  #10 opcode = `NOP;
end
endmodule //module decoder --------------------------------