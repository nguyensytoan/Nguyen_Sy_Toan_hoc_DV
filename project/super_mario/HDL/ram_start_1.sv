module  ram_start_1
(
		input [17:0] read_address,
		output logic [11:0] output_color
);

// mem has width of 4 bits and a total of 400 addresses
/*
logic [3:0] mem [0:61951];

logic [11:0] pal [5:0];
assign pal[0] = 12'h808;
assign pal[1] = 12'h000;
assign pal[2] = 12'hFCC;
assign pal[3] = 12'h940;
assign pal[4] = 12'h0AE;
assign pal[5] = 12'hFFF;
*/
logic [3:0] mem [0:61951];

logic [11:0] pal [4:0];
assign pal[0] = 12'h808;
assign pal[1] = 12'h000;
assign pal[2] = 12'hFCC;
assign pal[3] = 12'h940;
assign pal[4] = 12'h0AE;
assign output_color = pal[mem[read_address]];

initial
begin
	  $readmemh("C:/ece385/final_project/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/mario_logo.txt", mem);

	 //$readmemh("C:/ece385/final_project/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/ver_copy.txt", mem);
end

endmodule 