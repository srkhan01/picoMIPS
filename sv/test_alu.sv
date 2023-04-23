//---------------------------------------------------------
// File Name   : test_alu.sv
// Function    : testbench for alu with multiplier 
// Author: Sayedur Khan
// ver 1:  
// Last revised: 21 Apr 2023
//---------------------------------------------------------

`include "alucodes.sv"  
`include "global_parameters.sv"
//---------------------------------------------------------
module test_alu;

  timeunit 1ns;

  parameter n = `DATA_BUS_SIZE;
  parameter alu_code_size = `ALU_CODE_SIZE;

  logic [alu_code_size-1:0] alu_func; // ALU function
  logic signed [n-1:0] alu_a, alu_b; // ALU inputs and output result
  wire signed [n-1:0] result; 

  alu    #(.n(n))  iu(.a(alu_a),.b(alu_b),
       .func(alu_func),
       .result(result)); // ALU result -> destination reg

initial
begin
	alu_a = 8'b00000000; 
	alu_b = 8'b00000011; 
	alu_func = `RB;
	if(result != 8'b00000011) 
		$error("Result '%d' is incorrect. Should be 3", result);
	// Integer Addition
	#2;
	alu_a = 3; 
	alu_b = 16; 
	alu_func = `RADD;
	#5 
	if(result != 8'b00010011) 
		$error("Result '%d' is incorrect. Should be 19", result);
		
	// Integer Subtraction
	#10;
	alu_a = 8; 
	alu_b = 20; 
	alu_func = `RSUB;
	#5 
	if(result != 8'b11110100) 
		$error("Result '%d' is incorrect. Should be -12", result);
		
	// Testing multiplication values in example data set (1). Chagne the nums
	
	// Positive Multiplication
	#10;
	alu_a = 8'b01100000; // = 0.75 in fixed point notation
	alu_b = 8; 
	alu_func = `RMULT;
	#5 
	if(result != 8'b00000110) 
		$error("Result '%d' is incorrect. Should be 6", result);
	
	#10;
	alu_a = 8'b01000000; // = 0.5
	alu_b = 16; 
	alu_func = `RMULT;
	#5 
	if(result != 8'b00001000) 
		$error("Result '%d' is incorrect. Should be 8.", result);
		
	// Negative Signed Multiplication
	#10;
	alu_a = 8'b11000000; // = -0.5
	alu_b = 8; 
	alu_func = `RMULT;
	#5 
	if(result != 8'b11111100) 
		$error("Result '%d' is incorrect. Should be -4.", result);
	
end

endmodule //module test_alu --------------------------------