//-----------------------------------------------------
// File Name : test_picoMIPS4test.sv
// Function : picoMIPS testbench
// Author: Sayedur Khan
// Last revised: 20 APR 2023
//-----------------------------------------------------
module test_picoMIPS;

  timeunit 1ns;

  // Inputs
  logic clk;
  
  logic reset_switch;
  logic handshake_switch; // SW9 for reset and SW8 for handshake
  logic [7:0] input_switches; // SW7-0 for program input
  wire [9:0] SW;
  assign SW = {reset_switch, handshake_switch, input_switches}; // SW wire combines all switches

  // Outputs
  wire [7:0] LED;

  picoMIPS
  pmtest (
    .clk(clk),
    .SW(SW),
    .LED(LED));
	
initial begin
  clk =  0;
  #5ns  forever #5ns clk = ~clk;
end

initial begin
  input_switches = 0;
  reset_switch = 1;
  handshake_switch = 0;
  #2 reset_switch = 0; // reset
  
  #5 reset_switch = 1; // stop reset
  
  #10 input_switches = 'd8; // x1
  #20 handshake_switch = 1; // wait for handshake=1
  #20 handshake_switch = 0; // wait for handshake=0
  
  #20 input_switches = 'd16; // y1
  #20 handshake_switch = 1; // wait for handshake=1
  #20 handshake_switch = 0; // wait for handshake=0
  
  #100 // wait for at least 5 more clock cycles for x2 to display
  #20 handshake_switch = 1;
  
  #100 // wait for at least 6 more clock cycles for y2 to display
  #20 handshake_switch = 0;
  
end
endmodule // module test_picoMIPS