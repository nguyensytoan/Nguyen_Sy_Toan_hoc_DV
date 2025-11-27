// UART.sv - ELEX 7660 Term Project
// Navtej Heir and Andrew Ydendberg 2017-03-25
module UART (input logic [9:0] DataIn,
	input logic clk,
	output logic TX
	);
	logic [9:0] Data_Next;
	logic [3:0] Count = 4'h00;
	always_ff@(posedge clk) begin
		if(Count != 10) begin
			TX <= Data_Next[Count];
			Count <= Count + 1;
		end
		else begin
			Count <= 0;
			Data_Next <= DataIn;
		end
	end
	
endmodule
