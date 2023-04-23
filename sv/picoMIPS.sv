//------------------------------------
// File Name   : picoMIPS.sv
// Function    : picoMIPS CPU top level encapsulating module, version 2
// Author      : Sayedur Khan
// Ver 2 :  PC , prog memory, regs, ALU and decoder, no RAM
// Last revised: 21 Apr 2023
//------------------------------------

`include "alucodes.sv"
`include "global_parameters.sv"
module picoMIPS
(input wire clk,  
  input wire[9:0] SW, // switches as input, the latter 8 bits will be stored in register 1. SW9 is reset.
  output wire[7:0] LED // LEDs to display result

);       

  parameter n = `DATA_BUS_SIZE;
  parameter program_code_size = `PROGRAM_CODE_SIZE;
  parameter instruction_size = `INSTRUCTION_SIZE;
  parameter opcode_size = `OPCODE_SIZE;
  parameter alu_code_size = `ALU_CODE_SIZE;
  parameter registers_size = `REGISTERS_SIZE;

  wire n_reset; // master reset

  // declarations of local signals that connect CPU modules
  // ALU
  logic [alu_code_size-1:0] alu_func; // ALU function
  wire imm; // immediate operand signal
  //
  wire [n-1:0] alu_a, alu_b, alu_result; // ALU/Registers
 
 // regs
  wire [n-1:0] rd_data, rs_data;  // register data

  wire w; // register write control
  //
  // Program Counter 
  wire pc_inc; // program counter control
  wire [program_code_size-1 : 0] program_address;
  // Program Memory

  wire [instruction_size-1:0] instruction_code;
  
  wire [opcode_size-1:0] opcode;
  wire [registers_size-1:0] r_dest;
  wire [registers_size-1:0] r_source;
  
 initial
  $monitor("picoMIPS monitor: time:%0t, program_address: %h, instruction_code: %h, opcode: %h, alu_result: %h, alu_a: %h, r_dest: %h, rd_data: %h, alu_b: %h, r_source: %h, rs_data: %h", $time, program_address, instruction_code, opcode, alu_result, alu_a, r_dest, rd_data, alu_b, r_source, rs_data);

//------------- code starts here ---------
// module instantiations
program_counter  #(.program_code_size(program_code_size)) 
  pc (
  .clk(clk),
  .n_reset(n_reset),
  .pc_inc(pc_inc),
  .pc_out(program_address) );

program_memory #(.program_code_size(program_code_size),.instruction_size(instruction_size)) 
      pm (.address(program_address),.instruction_code(instruction_code));

decoder #(.opcode_size(opcode_size), .alu_code_size(alu_code_size))  
  D (.opcode(opcode),
          .pc_inc(pc_inc),
		  .alu_func(alu_func),
		  .imm(imm),
		  .w(w),
		  .handshake_switch(SW[8]));

registers   #(.n(n), .registers_size(registers_size))
  gpr(
  .clk(clk),
  .w(w),
  .write_data(alu_result),
  .r_dest(r_dest),  // reg %d number
  .r_source(r_source), // reg %s number
  .rd_data(rd_data),.rs_data(rs_data),
  .inport(SW[7:0]),
  .outport(LED));

alu    #(.n(n), .opcode_size(opcode_size), .alu_code_size(alu_code_size))  
  iu(.a(alu_a),
  .b(alu_b),
  .func(alu_func),
  .result(alu_result)); // ALU result -> destination reg

// wire alu_a to desination register data
assign alu_a = rd_data;
// create MUX for immediate operand
assign alu_b = (imm ? instruction_code[n-1:0] : rs_data);
// connect CPU reset to SW9
assign n_reset = SW[9];

assign opcode = instruction_code[instruction_size-1:instruction_size-3];
assign r_dest = instruction_code[instruction_size-4:instruction_size-6];
assign r_source = instruction_code[instruction_size-7:instruction_size-9];

endmodule
