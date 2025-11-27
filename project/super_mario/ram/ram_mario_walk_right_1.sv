module  ram_mario_walk_right_1
(
		input [8:0] read_address,
		output logic [11:0] output_color
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem [0:440];

logic [11:0] pal [6:0];
assign pal[0] = 12'h808;
assign pal[1] = 12'hF30;
assign pal[2] = 12'hE93;
assign pal[3] = 12'hE93;
assign pal[4] = 12'h27B;
assign pal[5] = 12'hFA4;
assign pal[6] = 12'hA70;

assign output_color = pal[mem[read_address]];

initial
begin
	 $readmemh("C:/ece385/final_project/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/mario_walk_right_1.txt", mem);
end

endmodule