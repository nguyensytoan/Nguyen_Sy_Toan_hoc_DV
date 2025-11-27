module  ram_trap
(
		input [8:0] read_address,
		output logic [11:0] output_color
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem [0:440];

logic [11:0] pal [3:0];
assign pal[0] = 12'h808;
assign pal[1] = 12'hFFF;
assign pal[2] = 12'hF30;
assign pal[3] = 12'hFA4;

assign output_color = pal[mem[read_address]];

initial
begin
	 $readmemh("C:/ece385/final_project/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/trap1.txt", mem);
end

endmodule