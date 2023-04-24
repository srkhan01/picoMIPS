//-----------------------------------------------------
// File Name   : alu.sv
// Function    : ALU module for picoMIPS
// Version: 1,  ALU with 4 functions, no explicit branching
// Author:  Sayedur Khan
// Last rev. 24 Apr 2023
//-----------------------------------------------------

`include "alucodes.sv"  
`include "global_parameters.sv"

module alu #(
  parameter n = `DATA_BUS_SIZE,
  parameter opcode_size = `OPCODE_SIZE,
  parameter alu_code_size = `ALU_CODE_SIZE) (
  
  input wire signed [n-1:0] a, b, // ALU operands
  input logic [alu_code_size-1:0] func, // ALU function code
  output logic signed [n-1:0] result // ALU result
);       

// 16-bit Signed multipler
logic signed [15:0] multiplyResult;
assign multiplyResult = a * b;

// create an n-bit adder 
// and then build the ALU around the adder
logic[n-1:0] ar,b1; // temp signals
always_comb
begin
   /*if(func==`RSUB)
      b1 = ~b + 1'b1; // 2's complement subtrahend
   else */
   b1 = b;
   ar = a+b1; // n-bit adder
end // always_comb


   
// create the ALU, use signal ar in arithmetic operations
always_comb
begin
  unique case(func)
  	`RB   : result = b;
	`RB_ALT   : result = b; // Alternative B function to allow more than 2 alucodes for this
    `RADD  : begin
	   result = ar; // arithmetic addition
	 end
    /*`RSUB  : begin
	   result = ar; // arithmetic subtraction
	 end   */
	`RMULT  : result = multiplyResult[14:7]; // signed multiplication, only keeping 8 bits as is required
	default: result = a;
   endcase
 end //always_comb
 
 // branching not required as the program counter loops back to the start on overflow

endmodule //end of module ALU


