module goomba_controller (
									input        Clk,                // 50 MHz clock
												    Reset,              // Active-high reset signal
													 frame_clk,          // The clock indicating a new frame (~60Hz)
									input [2:0]	 roomNum,				// current "level"
									input [31:0]  DrawX, DrawY,       // Current pixel coordinates
									input [9:0]  mario_x, mario_y,	// mario's coordinates
									input [9:0]  mario_size_y,			// mario's y size for collisions
									input [1:0]	 is_alive_mario,		// is mario alive?
									output logic is_goomba,   			// signal for checking to see if a coordinate is a goomba
									output logic walk_num_goomba,		// signal for the walk num of the current goomba (animation)
									output logic is_alive_goomba,		// is the goomba alive?
									output logic [8:0] goomba_address,		// index of goomba for sprite drawing
									output logic [9:0] goomba_r1_1_x,      // goomba r1_1 coordinates
															 goomba_r1_1_y,
									output logic [9:0] goomba_r1_2_x,      // goomba r1_2 coordinates
															 goomba_r1_2_y,
									output logic [9:0] goomba_r2_1_x,      // goomba r2_1 coordinates
															 goomba_r2_1_y,
									output logic [9:0] goomba_r3_1_x,		// goomba r3_1 coordinates
															 goomba_r3_1_y,
															 
									output logic [9:0] goomba_r4_1_x,		
															 goomba_r4_1_y,
									output logic [9:0] goomba_r4_2_x,		
															 goomba_r4_2_y,
									output logic [9:0] goomba_r4_3_x,		
															 goomba_r4_3_y,
									output logic [9:0] goomba_r4_4_x,		
															 goomba_r4_4_y,
														 
									output logic [9:0] goomba_r5_1_x,		
															 goomba_r5_1_y,
									output logic [9:0] goomba_r5_2_x,		
															 goomba_r5_2_y,
									output logic [9:0] goomba_r5_3_x,		
															 goomba_r5_3_y
										/*				 
									output logic [9:0] goomba_r5_4_x,		
															 goomba_r5_4_y,
									output logic [9:0] goomba_r5_5_x,		
															 goomba_r5_5_y,
									output logic [9:0] goomba_r5_6_x,		
															 goomba_r5_6_y,
									output logic [9:0] goomba_r5_7_x,		
															 goomba_r5_7_y,
									output logic [9:0] goomba_r5_8_x,		
															 goomba_r5_8_y
															 */
								 );
	
	logic is_goomba_r1_1, is_goomba_r1_2, is_goomba_r2_1, is_goomba_r3_1;
	logic [8:0] goomba_address_r1_1, goomba_address_r1_2, goomba_address_r2_1, goomba_address_r3_1;
	logic walk_num_goomba_r1_1, walk_num_goomba_r1_2, walk_num_goomba_r2_1, walk_num_goomba_r3_1;
	logic isAlive_r1_1, isAlive_r1_2, isAlive_r2_1, isAlive_r3_1;
	
	logic is_goomba_r4_1, is_goomba_r4_2, is_goomba_r4_3, is_goomba_r4_4;
	logic [8:0] goomba_address_r4_1, goomba_address_r4_2, goomba_address_r4_3, goomba_address_r4_4;
	logic walk_num_goomba_r4_1, walk_num_goomba_r4_2, walk_num_goomba_r4_3, walk_num_goomba_r4_4;
	logic isAlive_r4_1, isAlive_r4_2, isAlive_r4_3, isAlive_r4_4;
	
	logic is_goomba_r5_1, is_goomba_r5_2, is_goomba_r5_3;//, is_goomba_r5_4, is_goomba_r5_5, is_goomba_r5_6, is_goomba_r5_7, is_goomba_r5_8;
	logic [8:0] goomba_address_r5_1, goomba_address_r5_2, goomba_address_r5_3;//, goomba_address_r5_4, goomba_address_r5_5, goomba_address_r5_6, goomba_address_r5_7, goomba_address_r5_8;
	logic walk_num_goomba_r5_1, walk_num_goomba_r5_2, walk_num_goomba_r5_3;//, walk_num_goomba_r5_4, walk_num_goomba_r5_5, walk_num_goomba_r5_6, walk_num_goomba_r5_7, walk_num_goomba_r5_8;
	logic isAlive_r5_1, isAlive_r5_2, isAlive_r5_3;//, isAlive_r5_4, isAlive_r5_5, isAlive_r5_6, isAlive_r5_7, isAlive_r5_8;
	
	
	//enemy placements
		//room 1
		//goomba r1_1(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd5), .startX(10'd260), .startY(10'd220), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r1_1), .walk_num_goomba(walk_num_goomba_r1_1), .goomba_address(goomba_address_r1_1), .Goomba_X_Pos(goomba_r1_1_x), .Goomba_Y_Pos(goomba_r1_1_y), .is_alive_goomba(isAlive_r1_1));
		goomba r1_2(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd1), .startX(10'd460), .startY(10'd380), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r1_2), .walk_num_goomba(walk_num_goomba_r1_2), .goomba_address(goomba_address_r1_2), .Goomba_X_Pos(goomba_r1_2_x), .Goomba_Y_Pos(goomba_r1_2_y), .is_alive_goomba(isAlive_r1_2));
		//room 2
		//goomba r2_1(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd2), .startX(10'd460), .startY(10'd380), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r2_1), .walk_num_goomba(walk_num_goomba_r2_1), .goomba_address(goomba_address_r2_1), .Goomba_X_Pos(goomba_r2_1_x), .Goomba_Y_Pos(goomba_r2_1_y), .is_alive_goomba(isAlive_r2_1));
		//room 3
		goomba r3_1(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd5), .startX(10'd580), .startY(10'd180), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r3_1), .walk_num_goomba(walk_num_goomba_r3_1), .goomba_address(goomba_address_r3_1), .Goomba_X_Pos(goomba_r3_1_x), .Goomba_Y_Pos(goomba_r3_1_y), .is_alive_goomba(isAlive_r3_1));
		//room4
		goomba r4_1(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd4), .startX(10'd280), .startY(10'd240), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r4_1), .walk_num_goomba(walk_num_goomba_r4_1), .goomba_address(goomba_address_r4_1), .Goomba_X_Pos(goomba_r4_1_x), .Goomba_Y_Pos(goomba_r4_1_y), .is_alive_goomba(isAlive_r4_1));
		goomba r4_2(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd4), .startX(10'd400), .startY(10'd140), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r4_2), .walk_num_goomba(walk_num_goomba_r4_2), .goomba_address(goomba_address_r4_2), .Goomba_X_Pos(goomba_r4_2_x), .Goomba_Y_Pos(goomba_r4_2_y), .is_alive_goomba(isAlive_r4_2));
		//goomba r4_3(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd4), .startX(10'd300), .startY(10'd400), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r4_3), .walk_num_goomba(walk_num_goomba_r4_3), .goomba_address(goomba_address_r4_3), .Goomba_X_Pos(goomba_r4_3_x), .Goomba_Y_Pos(goomba_r4_3_y), .is_alive_goomba(isAlive_r4_3));
		goomba r4_4(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd4), .startX(10'd480), .startY(10'd400), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r4_4), .walk_num_goomba(walk_num_goomba_r4_4), .goomba_address(goomba_address_r4_4), .Goomba_X_Pos(goomba_r4_4_x), .Goomba_Y_Pos(goomba_r4_4_y), .is_alive_goomba(isAlive_r4_4));
		//room5
		
		//goomba r5_1(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd5), .startX(10'd180), .startY(10'd80), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r5_1), .walk_num_goomba(walk_num_goomba_r5_1), .goomba_address(goomba_address_r5_1), .Goomba_X_Pos(goomba_r5_1_x), .Goomba_Y_Pos(goomba_r5_1_y), .is_alive_goomba(isAlive_r5_1));
	   goomba r5_2(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd5), .startX(10'd300), .startY(10'd80), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r5_2), .walk_num_goomba(walk_num_goomba_r5_2), .goomba_address(goomba_address_r5_2), .Goomba_X_Pos(goomba_r5_2_x), .Goomba_Y_Pos(goomba_r5_2_y), .is_alive_goomba(isAlive_r5_2));
		goomba r5_3(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd5), .startX(10'd340), .startY(10'd80), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r5_3), .walk_num_goomba(walk_num_goomba_r5_3), .goomba_address(goomba_address_r5_3), .Goomba_X_Pos(goomba_r5_3_x), .Goomba_Y_Pos(goomba_r5_3_y), .is_alive_goomba(isAlive_r5_3));
		/*goomba r5_4(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd5), .startX(10'd500), .startY(10'd80), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r5_4), .walk_num_goomba(walk_num_goomba_r5_4), .goomba_address(goomba_address_r5_4), .Goomba_X_Pos(goomba_r5_4_x), .Goomba_Y_Pos(goomba_r5_4_y), .is_alive_goomba(isAlive_r5_4));
		goomba r5_5(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd5), .startX(10'd440), .startY(10'd180), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r5_5), .walk_num_goomba(walk_num_goomba_r5_5), .goomba_address(goomba_address_r5_5), .Goomba_X_Pos(goomba_r5_5_x), .Goomba_Y_Pos(goomba_r5_5_y), .is_alive_goomba(isAlive_r5_5));
		goomba r5_6(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd5), .startX(10'd600), .startY(10'd180), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r5_6), .walk_num_goomba(walk_num_goomba_r5_6), .goomba_address(goomba_address_r5_6), .Goomba_X_Pos(goomba_r5_6_x), .Goomba_Y_Pos(goomba_r5_6_y), .is_alive_goomba(isAlive_r5_6));
		goomba r5_7(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd5), .startX(10'd260), .startY(10'd340), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r5_7), .walk_num_goomba(walk_num_goomba_r5_7), .goomba_address(goomba_address_r5_7), .Goomba_X_Pos(goomba_r5_7_x), .Goomba_Y_Pos(goomba_r5_7_y), .is_alive_goomba(isAlive_r5_7));
		goomba r5_8(.Clk, .Reset, .frame_clk, .DrawX, .DrawY, .roomNum, .myRoomNum(3'd5), .startX(10'd340), .startY(10'd340), .marioX(mario_x), .marioY(mario_y), .mario_size_y, .is_alive_mario, .is_goomba(is_goomba_r5_8), .walk_num_goomba(walk_num_goomba_r5_8), .goomba_address(goomba_address_r5_8), .Goomba_X_Pos(goomba_r5_8_x), .Goomba_Y_Pos(goomba_r5_8_y), .is_alive_goomba(isAlive_r5_8));
*/
	always_comb
	begin
		case(roomNum)
			3'd1:
				begin
					if (is_goomba_r1_1 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r1_1;
						walk_num_goomba = walk_num_goomba_r1_1;
						is_alive_goomba = isAlive_r1_1;
					end
					else if (is_goomba_r1_2 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r1_2;
						walk_num_goomba = walk_num_goomba_r1_2;
						is_alive_goomba = isAlive_r1_2;
					end
					else
					begin
						is_goomba = 1'b0;
						goomba_address = 9'b0;
						walk_num_goomba = 1'b0;
						is_alive_goomba = 1'b0;
					end
				end
			3'd2:
				begin
					if (is_goomba_r2_1 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r2_1;
						walk_num_goomba = walk_num_goomba_r2_1;
						is_alive_goomba = isAlive_r2_1;
					end
					else
					begin
						is_goomba = 1'b0;
						goomba_address = 9'b0;
						walk_num_goomba = 1'b0;
						is_alive_goomba = 1'b0;
					end
				end
			/*3'd3:
				begin
					if (is_goomba_r3_1 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r3_1;
						walk_num_goomba = walk_num_goomba_r3_1;
						is_alive_goomba = isAlive_r3_1;
					end
					else
					begin
						is_goomba = 1'b0;
						goomba_address = 9'b0;
						walk_num_goomba = 1'b0;
						is_alive_goomba = 1'b0;
					end
				end
				*/
				//them
				3'd4:
				begin
					if (is_goomba_r4_1 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r4_1;
						walk_num_goomba = walk_num_goomba_r4_1;
						is_alive_goomba = isAlive_r4_1;
					end
					else if (is_goomba_r4_2 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r4_2;
						walk_num_goomba = walk_num_goomba_r4_2;
						is_alive_goomba = isAlive_r4_2;
					end
					else if (is_goomba_r4_3 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r4_3;
						walk_num_goomba = walk_num_goomba_r4_3;
						is_alive_goomba = isAlive_r4_3;
					end
					else if (is_goomba_r4_4 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r4_4;
						walk_num_goomba = walk_num_goomba_r4_4;
						is_alive_goomba = isAlive_r4_4;
					end
					else
					begin
						is_goomba = 1'b0;
						goomba_address = 9'b0;
						walk_num_goomba = 1'b0;
						is_alive_goomba = 1'b0;
					end
				end
				//them
				3'd5:
				
				begin
					if (is_goomba_r5_1 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r5_1;
						walk_num_goomba = walk_num_goomba_r5_1;
						is_alive_goomba = isAlive_r5_1;
					end
					else if (is_goomba_r5_2 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r5_2;
						walk_num_goomba = walk_num_goomba_r5_2;
						is_alive_goomba = isAlive_r5_2;
					end
					else if (is_goomba_r5_3 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r5_3;
						walk_num_goomba = walk_num_goomba_r5_3;
						is_alive_goomba = isAlive_r5_3;
					end
					else if (is_goomba_r3_1 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r3_1;
						walk_num_goomba = walk_num_goomba_r3_1;
						is_alive_goomba = isAlive_r3_1;
					end
					
					/*
					else if (is_goomba_r5_4 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r5_4;
						walk_num_goomba = walk_num_goomba_r5_4;
						is_alive_goomba = isAlive_r5_4;
					end
					
					if (is_goomba_r5_5 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r5_5;
						walk_num_goomba = walk_num_goomba_r5_5;
						is_alive_goomba = isAlive_r5_5;
					end
					else if (is_goomba_r5_6 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r5_6;
						walk_num_goomba = walk_num_goomba_r5_6;
						is_alive_goomba = isAlive_r5_6;
					end
					else if (is_goomba_r5_7 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r5_7;
						walk_num_goomba = walk_num_goomba_r5_7;
						is_alive_goomba = isAlive_r5_7;
					end
					else if (is_goomba_r5_8 == 1'b1)
					begin
						is_goomba = 1'b1;
						goomba_address = goomba_address_r5_8;
						walk_num_goomba = walk_num_goomba_r5_8;
						is_alive_goomba = isAlive_r5_8;
					end
				*/
					else
					begin
						is_goomba = 1'b0;
						goomba_address = 9'b0;
						walk_num_goomba = 1'b0;
						is_alive_goomba = 1'b0;
					end
				end
				
				//them1
			default:
				begin
					is_goomba = 1'b0;
					goomba_address = 9'b0;
					walk_num_goomba = 1'b0;
					is_alive_goomba = 1'b0;
				end
		endcase
	end
							 
endmodule
