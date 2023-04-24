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
  
  // Loop 1
  
  #10 input_switches = 'd8; // x1 = 8
  #20 handshake_switch = 1; // wait for handshake=1
  #20 handshake_switch = 0; // wait for handshake=0
  
  #20 input_switches = 'd16; // y1 = 16
  #20 handshake_switch = 1; // wait for handshake=1
  #20 handshake_switch = 0; // wait for handshake=0
  
  #200; // wait for at least 9 more clock cycles for x2 to display. We expect a result of 34 or 00100010
  if(LED != 8'b00100010)
	$error("LED output for x2 '%h' wrong. Should be d34", LED);
	
  #20 handshake_switch = 1; // y2 should display. We expect a result of -12 or 11110100
  #20;
  if(LED != 8'b11110100)
	$error("LED output for y2 '%h' wrong. Should be -d12", LED);
  #40; 

  #20 handshake_switch = 0;
  
  // Loop 2
  
  #50;
  
  #10 input_switches = 8'b00001010; // x1 = 10
  #20 handshake_switch = 1; // wait for handshake=1
  #20 handshake_switch = 0; // wait for handshake=0
  
  #20 input_switches = 8'b11110110; // y1 = -10
  #20 handshake_switch = 1; // wait for handshake=1
  #20 handshake_switch = 0; // wait for handshake=0
  
  #200; // wait for at least 9 more clock cycles for x2 to display. We expect a result of 22 or 00010110
  if(LED != 8'b00010110)
	$error("LED output for x2 '%h' wrong. Should be d22", LED);
	
  #20 handshake_switch = 1; // y2 should display. We expect a result of -32 or 11100000
  #20;
  if(LED != 8'b11011111)
	$error("LED output for y2 '%h' wrong. Should be -d33", LED);
  #40; 

  #20 handshake_switch = 0;
  
end
endmodule // module test_picoMIPS