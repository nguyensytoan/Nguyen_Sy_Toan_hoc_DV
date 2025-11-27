/*
module start_game(
	input [9:0]   DrawX, DrawY,       // Current pixel coordinates
	input [2:0]   RoomNum,				 // current "level"
	output logic  is_start,				 // Whether current pixel belongs to logo or background
	output logic  [15:0] start_address 
);
	always_comb
	begin
		case (RoomNum)
				3'd7: // start screen room
					begin
					   if ((DrawX >= 144) && (DrawX < 496) && (DrawY >= 40) && (DrawY < 238))
						//if ((DrawX >= 144) && (DrawX < 320) && (DrawY >= 40) && (DrawY < 139))
							is_start = 1'b1;
						else
							is_start = 1'b0;
					end
				default:
					is_start = 1'b0;
		endcase
		
		if (is_start == 1'b1)
			start_address = ((DrawX - 144) >> 1) + ((DrawY - 40) >> 1) * 176;
			 //start_address = (DrawX - 144) + (DrawY - 40) * 176;
		else
			start_address = 14'd0; // don't care
	end
			
endmodule 
*/
module start_game (
					input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [2:0]   RoomNum,				 // current "level"
					output logic  is_start,				 // Whether current pixel belongs to logo or background
					output logic  [15:0] start_address // address for color mapper to figure out what color the logo pixel should be
				);
	always_comb
	begin
		case (RoomNum)
				3'd7 : // start screen room
					begin
						if ( (DrawX >= 144) && (DrawX < 496) && (DrawY >= 40) && (DrawY < 216) )
							is_start = 1'b1;
						else
							is_start = 1'b0;
					end
				default:
					is_start = 1'b0;
		endcase
		
		if (is_start == 1'b1)
			start_address = (DrawX - 144) + (DrawY - 40) * 352;
		else
			start_address = 14'd0; // don't care
	end
			
endmodule
