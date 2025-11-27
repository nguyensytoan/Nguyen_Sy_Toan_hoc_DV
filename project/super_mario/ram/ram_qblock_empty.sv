module  ram_qblock_empty
(
		input [8:0] read_address,
		output logic [11:0] output_color
);

// mem has width of 4 bits and a total of 400 addresses
logic [3:0] mem [0:399];

logic [11:0] pal [4:0];
assign pal[0] = 12'h808;
assign pal[1] = 12'h000;
assign pal[2] = 12'hE51;
assign pal[3] = 12'hFA4;
assign pal[4] = 12'h810;

assign output_color = pal[mem[read_address]];

initial
begin
	 $readmemh("C:/ece385/final_project/ECE385-HelperTools-master/PNG To Hex/On-Chip Memory/sprite_bytes/qblock_empty.txt", mem);
end

endmodule