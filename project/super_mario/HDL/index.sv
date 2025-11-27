module index (
	input [9:0]   DrawX, DrawY,       // Current pixel coordinates
	input [2:0]   RoomNum,				 // current "level"
    output logic  is_index,            // Whether current pixel belongs to a wall or background
	output logic [8:0] index_address
);	
				
	always_comb
	begin
		case (RoomNum)
			3'b1: begin
				
			index_address=(DrawX - 40) + (DrawY - 40);
			end
			default index_address=1000000;
		endcase
	if(DrawX > 40 + DrawY < 40) begin
		is_index = 1'b1;
	end else begin
		is_index = 1'd0;
	end
	end
endmodule 