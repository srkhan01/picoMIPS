//-----------------------------------------------------
// File Name : test_registers.sv
// Function : testbench for pMIPS registers_size x n registers, %0 == 0, %1 == inport, outport <= %2
// Author: Sayedur Khan
// Last rev. 24 Apr 2023
//-----------------------------------------------------
`include "global_parameters.sv"
module test_registers;

parameter n = `DATA_BUS_SIZE;
parameter registers_size = `REGISTERS_SIZE;

// Inputs
logic clk, w;
logic [n-1:0] write_data;
logic [registers_size-1:0] r_dest, r_source;
logic [n-1:0] inport;

// Outputs
wire [n-1:0] rd_data, rs_data;
wire [n-1:0] outport;

registers   #(.n(n), .registers_size(registers_size))
  gpr(
  .clk(clk),
  .w(w),
  .write_data(write_data),
  .r_dest(r_dest),  // reg %d number
  .r_source(r_source), // reg %s number
  .rd_data(rd_data),.rs_data(rs_data),
  .inport(inport),
  .outport(outport));
  
initial
begin
  clk =  0;
  #5ns  forever #5ns clk = ~clk;
end

initial
begin
  inport = 8'b00001011; // input register (1) is set to 11
  r_dest = 1; r_source = 0; 
  w = 0; 
  #11;
  r_dest = 2; r_source = 1; 
  #1 write_data = rs_data; // write 11 to destination register (r2)
  w = 1;

  #10 w = 0; 
  #10;
  write_data = 5; // write 5 to destination register (r3)
  r_dest = 3; 
  w = 1; 

  #10 w = 0; 
  #10; 
  write_data = 24; // write 24 to destination register (r4) 
  r_dest = 4; 
  w = 1; 
  
  #10 w = 0; 
  #9;
  r_source = 3;
  #1 write_data = rs_data; // write source register data (r3=5) to destination register (r2) 
  r_dest = 2; 
  w = 1; 

end

	

endmodule // module test_registers