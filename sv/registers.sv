//-----------------------------------------------------
// File Name : registers.sv
// Function : picoMIPS 32 x n registers, %0 == 0
// Version 1 :
// Author: Sayedur Khan
// Last rev. 21 Apr 2023
//-----------------------------------------------------
`include "global_parameters.sv"
module registers #(
  parameter n = `DATA_BUS_SIZE,
  parameter registers_size = `REGISTERS_SIZE) (
  
  input wire clk, w, // clk and write control
  input wire [n-1:0] write_data,
  input wire [registers_size-1:0] r_dest, r_source,
  input wire [n-1:0] inport,
  
  output logic [n-1:0] rd_data, rs_data,
  output logic [n-1:0] outport);

  // Declare n-bit registers 

  logic [n-1:0] gpr [registers_size-1:0];

  // write process, dest reg is r_dest
  always_ff @ (posedge clk) begin
	if (w) begin
	  if(r_dest == 3'b010)
	    outport <= write_data; // write output data to outport
	  else begin
		gpr[r_dest] <= write_data;
		$strobe("GPR at time %0t: Wrote %h to gpr[%h]: %h", $time, write_data, r_dest, gpr[r_dest]);
	  end
	end
  end

  // read process, output 0 if %0 is selected
  always_comb begin
    unique case(r_dest)
  	  3'b000: rd_data =  {n{1'b0}};
      3'b001: rd_data = inport;
	  3'b010: rd_data = outport;
	  default: rd_data = gpr[r_dest];
    endcase
   
    unique case(r_source)
  	  3'b000: rs_data =  {n{1'b0}};
      3'b001: rs_data = inport;
	  3'b010: rs_data = outport;
	  default: rs_data = gpr[r_source];
	endcase
	/*
    if (r_dest==3'b000) // reg 0
	  rd_data =  {n{1'b0}};
    else if (r_dest==3'b001) // reg 1 (input port)
	  rd_data = inport;
    else
	  rd_data = gpr[r_dest];
 
    if (r_source==3'b000)
	  rs_data =  {n{1'b0}};
    else if (r_source==3'b001) // reg 1 (input port)
	  rs_data = inport;
    else
	  rs_data = gpr[r_source];*/
  end	

  // 	Register 1 is an input port
  //assign outport = gpr[2]; // 	Register 2 is an output port
	

endmodule // module registers