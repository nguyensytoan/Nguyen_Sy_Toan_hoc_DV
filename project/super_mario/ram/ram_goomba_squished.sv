module  ram_goomba_squished
(
		input [8:0] read_address,
		output logic [11:0] output_color
);

// mem has width of 3 bits and a total of 400 addresses
logic [3:0] mem [0:440];

logic [11:0] pal [3:0];
assign pal[0] = 12'h808;
assign pal[1] = 12'h222;
assign pal[2] = 12'hE51;
assign pal[3] = 12'hFDB;

assign output_color = pal[mem[read_address]];

initial
begin
	 $readmemh("C:/ece385/final_project/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/goomba_squished.txt", mem);
end

endmodule