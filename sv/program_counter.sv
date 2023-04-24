//-----------------------------------------------------
// File Name : program_counter.sv
// Function : picoMIPS Program Counter
// functions: increment, reset and wait
// Author: Sayedur Khan
// Last revised: 24 Apr 2023
//-----------------------------------------------------
`include "global_parameters.sv"
module program_counter #(parameter program_code_size = `PROGRAM_CODE_SIZE) 
(input wire clk, n_reset, pc_inc,
 output logic [program_code_size-1:0] pc_out
);

logic [program_code_size-1:0] inc_amount;

// If pc_inc == 1, then increment by 1 otherwise increment by 0.
assign inc_amount = {{(program_code_size-1){1'b0}}, pc_inc};

/*always_comb
	if (pc_inc)
		inc_amount = {{(program_code_size-1){1'b0}}, 1'b1};
	else 
		inc_amount = {(program_code_size){1'b0}};
*/

always_ff @ ( posedge clk or negedge n_reset) // async reset
	if (~n_reset)  // ACTIVE LOW RESET
		pc_out <= {program_code_size{1'b0}};
	else // INCREMENT
		pc_out <= pc_out + inc_amount; 
	 
endmodule // module program_counter