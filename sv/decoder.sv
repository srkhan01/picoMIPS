//---------------------------------------------------------
// File Name   : decoder.sv
// Function    : picoMIPS instruction decoder 
// Author: Sayedur Khan
// ver 2:  // NOP, ADD, ADDI, SUB, SUBI, MUL, MULI, WAITHS0, WAITHS1
// Last revised: 24 Apr 2023
//---------------------------------------------------------

`include "alucodes.sv"
`include "opcodes.sv"
`include "global_parameters.sv"
//---------------------------------------------------------
module decoder #( 
  parameter opcode_size = `OPCODE_SIZE,
  parameter alu_code_size = `ALU_CODE_SIZE) (

// input signals
  input logic [opcode_size-1:0] opcode, // top 3 bits of instruction
  input wire handshake_switch,

// output signals
//    PC control
  output logic pc_inc,
//    ALU control
  output logic [alu_code_size-1:0] alu_func, 
// imm mux control
  output logic imm,
//   register file control
  output logic w);
   
//------------- code starts here ---------
 
// instruction decoder
always_comb 
begin
  // set default output signal values for NOP instruction
   pc_inc = 1'b1; // PC increments by default
   alu_func = opcode[alu_code_size-1:0]; 
   imm=1'b0; w=1'b0; 
   case(opcode)
		`NOP: ;
		`ADD,`MULT : 
		begin // register-register
			w = 1'b1; // write result to dest register
		end
		`ADDI,`MULTI: 
		begin // register-immediate
			w = 1'b1; // write result to dest register
			imm = 1'b1; // set ctrl signal for imm operand MUX
		end
		`COPY: w = 1'b1; // register-register copy function
		`WLD0: 
		begin
			pc_inc = ~handshake_switch;
			if(pc_inc)
				// Switch has been pulled to correct direction (0)
				w = 1'b1; // register-register copy after switch pull
		end
		`WLD1: 
		begin
			pc_inc = handshake_switch;  
			if(pc_inc) 
				// Switch has been pulled to correct direction (1)
				w = 1'b1; // register-register copy after switch pull			 
		end  
		default:
			$error("unimplemented opcode %h",opcode);
 
  endcase // opcode

end // always_comb


endmodule //module decoder --------------------------------