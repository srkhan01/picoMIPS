//-----------------------------------------------------
// File Name : test_program_counter.sv
// Function : picoMIPS Program Counter testbench
// functions: increment, reset and wait
// Author: Sayedur Khan
// Last revised: 20 APR 2023
//-----------------------------------------------------
`include "global_parameters.sv"
module test_pc;

  timeunit 1ns;

  parameter program_code_size = `PROGRAM_CODE_SIZE;
  logic clk, n_reset, pc_inc;
  wire [program_code_size-1 : 0] program_address;

  program_counter  #(.program_code_size(program_code_size)) 
  pc (
    .clk(clk),
    .n_reset(n_reset),
    .pc_inc(pc_inc),
    .pc_out(program_address) );
	
initial
begin
  clk =  0;
  #5ns  forever #5ns clk = ~clk;
end

initial
begin
  n_reset = 1;
  #1 n_reset = 0;
  pc_inc = 0;

  #1 n_reset = 1;

  #10;
  pc_inc = 1;
  #390;
  n_reset = 0;
  #10;
  n_reset = 1;
  #30;
  pc_inc = 0;
end
endmodule // module test_program_counter