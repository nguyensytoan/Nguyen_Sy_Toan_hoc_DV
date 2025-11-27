module modu_giant (
					input [9:0]   DrawX, DrawY,       // Current pixel coordinates
					input [2:0]   RoomNum,				 // current "level"
					output logic  is_giant,				 // Whether current pixel belongs to logo or background
					output logic  [11:0] giant_address // address for color mapper to figure out what color the logo pixel should be
				);
	always_comb
	begin
		case (RoomNum)
				3'd7: // start screen room
					begin
						if ( (DrawX >= 560) && (DrawX < 582) && (DrawY >= 379) && (DrawY < 400) )
							is_giant = 1'b1;
						else
							is_giant = 1'b0;
					end
				default:
					is_giant = 1'b0;
		endcase
		
		if (is_giant == 1'b1)
			giant_address = (DrawX - 560) + (DrawY - 379) * 21;
		else
			giant_address = 12'd0; // don't care
	end
			
endmodule
