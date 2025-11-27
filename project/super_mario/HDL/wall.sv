module wall (
            input [9:0]   DrawX, DrawY,       // Current pixel coordinates
				input [2:0]   RoomNum,				 // current "level"
            output logic  is_wall,            // Whether current pixel belongs to a wall or background
				output logic  is_brick,				 // 1 for brick, 0 for ground
				output logic [8:0] wall_address	 // address for color mapper to figure out what color the wall pixel should be
				);
	
	parameter [4:0] wall_dim = 5'd20;
	
	always_comb 
	begin
		case (RoomNum)
			3'd0: // start screen room
				begin
					// ground tiles
					
						if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// this is the border around the level
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 620 >= 0) && (DrawX - 620 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// end of level border code
						else
						begin
							is_wall = 1'b0;
							is_brick = 1'b0;
						end
				end
			3'd1: // first room
				begin
					// non ground tiles
						
						//khoi1
						if ( (DrawX - 80 >= 0) && (DrawX - 80 < 4*wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 100 >= 0) && (DrawX - 100 < 3*wall_dim) && (DrawY - 400 >= 0) && (DrawY - 400 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 120 >= 0) && (DrawX - 120 < 2*wall_dim) && (DrawY - 380 >= 0) && (DrawY - 380 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 240 >= 0) && (DrawX - 240 < 4*wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 240 >= 0) && (DrawX - 240 < 3*wall_dim) && (DrawY - 400 >= 0) && (DrawY - 400 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 240 >= 0) && (DrawX - 240 < 2*wall_dim) && (DrawY - 380 >= 0) && (DrawY - 380 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 220 >= 0) && (DrawX - 220 < 4*wall_dim) && (DrawY - 300 >= 0) && (DrawY - 300 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
		
						else if ( (DrawX - 200 >= 0) && (DrawX - 200 < 4*wall_dim) && (DrawY - 220 >= 0) && (DrawY - 220 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 100 >= 0) && (DrawX - 100 < 4*wall_dim) && (DrawY - 260 >= 0) && (DrawY - 260 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 20 >= 0) && (DrawX - 20 < 4*wall_dim) && (DrawY - 180 >= 0) && (DrawY - 180 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 40 >= 0) && (DrawX - 40 < wall_dim) && (DrawY - 120 >= 0) && (DrawY - 120 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 360 >= 0) && (DrawX - 360 < 4*wall_dim) && (DrawY - 260 >= 0) && (DrawY - 260 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						//
						
					// ground tiles
						// this is the border around the level
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 620 >= 0) && (DrawX - 620 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// end of level border code
						else if ( (DrawX - 400 >= 0) && (DrawX - 400 < wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 520 >= 0) && (DrawX - 520 < 2*wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < 2*wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 540 >= 0) && (DrawX - 540 < wall_dim) && (DrawY - 400 >= 0) && (DrawY - 400 < wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 8*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 8*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// gap for testing between 
						else if ( (DrawX - 240 >= 0) && (DrawX - 240 < 22*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 240 >= 0) && (DrawX - 240 < 22*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else
						begin
							is_wall = 1'b0;
							is_brick = 1'b0;
						end
				end
			3'd2: //second room
				begin
					// non ground tiles
						if ( (DrawX - 100 >= 0) && (DrawX - 100 < 6*wall_dim) && (DrawY - 340 >= 0) && (DrawY - 340 < wall_dim) ) 
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 160 >= 0) && (DrawX - 160 < wall_dim) && (DrawY - 300 >= 0) && (DrawY - 300 < wall_dim) ) 
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 200 >= 0) && (DrawX - 200 < 3*wall_dim) && (DrawY - 240 >= 0) && (DrawY - 240 < wall_dim) ) 
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 60 >= 0) && (DrawX - 60 < 4*wall_dim) && (DrawY - 240 >= 0) && (DrawY - 240 < wall_dim) ) 
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 60 >= 0) && (DrawX - 60 < 2*wall_dim) && (DrawY - 180 >= 0) && (DrawY - 180 < wall_dim) ) 
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 240 >= 0) && (DrawX - 240 <8*wall_dim) && (DrawY - 180 >= 0) && (DrawY - 180 < wall_dim) ) 
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 440 >= 0) && (DrawX - 440 <wall_dim) && (DrawY - 20 >= 0) && (DrawY - 20 < 12*wall_dim) ) 
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 60 >= 0) && (DrawX - 60 <wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) ) 
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
					// ground tiles
						// this is the border around the level
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 620 >= 0) && (DrawX - 620 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// end of level border code
					
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 8*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 8*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// hole 
						else if ( (DrawX - 300 >= 0) && (DrawX - 300 < 2*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 300 >= 0) && (DrawX - 300 < 2*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 400 >= 0) && (DrawX - 400 < 2*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 400 >= 0) && (DrawX - 400 < 2*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 500 >= 0) && (DrawX - 500 < 7*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 500 >= 0) && (DrawX - 500 < 7*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else
						begin
							is_wall = 1'b0;
							is_brick = 1'b0;
						end
				end
			3'd3: // third room
				begin
					// ground tiles
						// this is the border around the level
						if ( (DrawX - 0 >= 0) && (DrawX - 0 < 23*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 520 >= 0) && (DrawX - 520 < 7*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 620 >= 0) && (DrawX - 620 < wall_dim) && (DrawY - 100 >= 0) && (DrawY - 100 < 19*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 5*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 5*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// design
						else if ( (DrawX - 140 >= 0) && (DrawX - 140 < wall_dim) && (DrawY - 380 >= 0) && (DrawY - 380 < 6*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 160 >= 0) && (DrawX - 160 < wall_dim) && (DrawY - 380 >= 0) && (DrawY - 380 < 6*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 140 >= 0) && (DrawX - 140 < wall_dim) && (DrawY - 20 >= 0) && (DrawY - 20 < 15*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 160 >= 0) && (DrawX - 160 < wall_dim) && (DrawY - 20 >= 0) && (DrawY - 20 < 15*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						//final
						else if ( (DrawX - 260 >= 0) && (DrawX - 260 < wall_dim) && (DrawY - 360 >= 0) && (DrawY - 360 < 7*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 260 >= 0) && (DrawX - 260 < wall_dim) && (DrawY - 20 >= 0) && (DrawY - 20 < 14*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 280 >= 0) && (DrawX - 280 < wall_dim) && (DrawY - 360 >= 0) && (DrawY - 360 < 7*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 280 >= 0) && (DrawX - 280 < wall_dim) && (DrawY - 20 >= 0) && (DrawY - 20 < 14*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
	
						else if ( (DrawX - 360 >= 0) && (DrawX - 360 < wall_dim) && (DrawY - 380 >= 0) && (DrawY - 380 < 10*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 360 >= 0) && (DrawX - 360 < wall_dim) && (DrawY - 20 >= 0) && (DrawY - 20 < 11*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 440 >= 0) && (DrawX - 440 < wall_dim) && (DrawY - 320 >= 0) && (DrawY - 320 < 9*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 440 >= 0) && (DrawX - 440 < wall_dim) && (DrawY - 20 >= 0) && (DrawY - 20 < 12*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 480 >= 0) && (DrawX - 480 < wall_dim) && (DrawY - 280 >= 0) && (DrawY - 280 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 560 >= 0) && (DrawX - 560 < wall_dim) && (DrawY - 260 >= 0) && (DrawY - 260 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 480 >= 0) && (DrawX - 480 < wall_dim) && (DrawY - 180 >= 0) && (DrawY - 180 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 560 >= 0) && (DrawX - 560 < wall_dim) && (DrawY - 140 >= 0) && (DrawY - 140 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 580 >= 0) && (DrawX - 580 < 2*wall_dim) && (DrawY - 100 >= 0) && (DrawY - 100 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// design 
						else
						begin
							is_wall = 1'b0;
							is_brick = 1'b0;
						end
				end
				
				// check tao phong
				3'd4: // Phòng 4
	begin
		if ( (DrawX - 80 >= 0) && (DrawX - 80 < wall_dim) && (DrawY - 400 >= 0) && (DrawY - 400 < 2*wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 60 >= 0) && (DrawX - 60 < wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 100 >= 0) && (DrawX - 100 < wall_dim) && (DrawY - 380 >= 0) && (DrawY - 380 < 3*wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 120 >= 0) && (DrawX - 120 < wall_dim) && (DrawY - 360 >= 0) && (DrawY - 360 < 4*wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 140 >= 0) && (DrawX - 140 < wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 260 >= 0) && (DrawX - 260 < 7*wall_dim) && (DrawY - 260 >= 0) && (DrawY - 260 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 380 >= 0) && (DrawX - 380 < wall_dim) && (DrawY - 240 >= 0) && (DrawY - 240 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 260 >= 0) && (DrawX - 260 < wall_dim) && (DrawY - 240 >= 0) && (DrawY - 240 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 320 >= 0) && (DrawX - 320 < wall_dim) && (DrawY - 200 >= 0) && (DrawY - 200 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 300 >= 0) && (DrawX - 300 < wall_dim) && (DrawY - 160 >= 0) && (DrawY - 160 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		
		else if ( (DrawX - 380 >= 0) && (DrawX - 380 < 8*wall_dim) && (DrawY - 160 >= 0) && (DrawY - 160 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 380 >= 0) && (DrawX - 380 < wall_dim) && (DrawY - 140 >= 0) && (DrawY - 140 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 520 >= 0) && (DrawX - 520 < wall_dim) && (DrawY - 140 >= 0) && (DrawY - 140 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		
		else if ( (DrawX - 380 >= 0) && (DrawX - 380 < wall_dim) && (DrawY - 280 >= 0) && (DrawY - 280 < 8*wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 360 >= 0) && (DrawX - 360 < wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 320 >= 0) && (DrawX - 320 < wall_dim) && (DrawY - 380 >= 0) && (DrawY - 380 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 240 >= 0) && (DrawX - 240 < wall_dim) && (DrawY - 340 >= 0) && (DrawY - 340 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 200 >= 0) && (DrawX - 200 < wall_dim) && (DrawY - 280 >= 0) && (DrawY - 280 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 460 >= 0) && (DrawX - 460 < 8*wall_dim) && (DrawY - 240 >= 0) && (DrawY - 240 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		// Các viên nền (ground tiles)
		
		else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 620 >= 0) && (DrawX - 620 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
					//them
					
					else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						//them
						// end of level border code
						
						else if ( (DrawX - 400 >= 0) && (DrawX - 400 < wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 520 >= 0) && (DrawX - 520 < 2*wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < 2*wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 540 >= 0) && (DrawX - 540 < wall_dim) && (DrawY - 400 >= 0) && (DrawY - 400 < wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 10*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 10*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						// gap for testing between 
						else if ( (DrawX - 260 >= 0) && (DrawX - 260 < 21*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 260 >= 0) && (DrawX - 260 < 21*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else
						begin
							is_wall = 1'b0;
							is_brick = 1'b0;
						end
				end
3'd5: // Phòng 5
	begin
		// Các viên gạch (brick tiles)
		  // khoi1
		if ( (DrawX - 0 >= 0) && (DrawX - 0 < 2*wall_dim) && (DrawY - 360 >= 0) && (DrawY - 360 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 80 >= 0) && (DrawX - 80 < wall_dim) && (DrawY - 320 >= 0) && (DrawY - 320 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 20 >= 0) && (DrawX - 20 < wall_dim) && (DrawY - 260 >= 0) && (DrawY - 260 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 80 >= 0) && (DrawX - 80 < wall_dim) && (DrawY - 220 >= 0) && (DrawY - 220 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 20 >= 0) && (DrawX - 20 < wall_dim) && (DrawY - 160 >= 0) && (DrawY - 160 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 80 >= 0) && (DrawX - 80 < wall_dim) && (DrawY - 120 >= 0) && (DrawY - 120 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 100 >= 0) && (DrawX - 100 < wall_dim) && (DrawY - 120 >= 0) && (DrawY - 120 < 11*wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		
		else if ( (DrawX - 120 >= 0) && (DrawX - 120 < 22*wall_dim) && (DrawY - 120 >= 0) && (DrawY - 120 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		  //khoi2
		else if ( (DrawX - 120 >= 0) && (DrawX - 120 < wall_dim) && (DrawY - 100 >= 0) && (DrawY - 100 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 300 >= 0) && (DrawX - 300 < wall_dim) && (DrawY - 100 >= 0) && (DrawY - 100 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 520 >= 0) && (DrawX - 520 < wall_dim) && (DrawY - 100 >= 0) && (DrawY - 100 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		// them12
		else if ( (DrawX - 600 >= 0) && (DrawX - 600 < wall_dim) && (DrawY - 180 >= 0) && (DrawY - 180 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		//
		else if ( (DrawX - 460 >= 0) && (DrawX - 460 < 8*wall_dim) && (DrawY - 200 >= 0) && (DrawY - 200 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 460 >= 0) && (DrawX - 460 < wall_dim) && (DrawY - 180 >= 0) && (DrawY - 180 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 420 >= 0) && (DrawX - 420 < 10*wall_dim) && (DrawY - 280 >= 0) && (DrawY - 280 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		else if ( (DrawX - 420 >= 0) && (DrawX - 420 < wall_dim) && (DrawY - 260 >= 0) && (DrawY - 260 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b0;
		end
		  //khoi 3
		  /*else if ( (DrawX - 140 >= 0) && (DrawX - 140 < wall_dim) && (DrawY - 160 >= 0) && (DrawY - 160 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end*/
		else if ( (DrawX - 240 >= 0) && (DrawX - 240 < 6*wall_dim) && (DrawY - 360 >= 0) && (DrawY - 360 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 240 >= 0) && (DrawX - 240 < wall_dim) && (DrawY - 320 >= 0) && (DrawY - 320 < 2*wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 360 >= 0) && (DrawX - 360 < wall_dim) && (DrawY - 320 >= 0) && (DrawY - 320 < 3*wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 120 >= 0) && (DrawX - 120 < 2*wall_dim) && (DrawY - 220 >= 0) && (DrawY - 220 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		else if ( (DrawX - 200 >= 0) && (DrawX - 200 < wall_dim) && (DrawY - 240 >= 0) && (DrawY - 240 < wall_dim) )
		begin
			is_wall = 1'b1;
			is_brick = 1'b1;
		end
		// Các viên nền (ground tiles)
		else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )// noc
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 620 >= 0) && (DrawX - 620 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )// canh vuong
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )// canh vuong
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// end of level border code
						else if ( (DrawX - 400 >= 0) && (DrawX - 400 < wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 520 >= 0) && (DrawX - 520 < 2*wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < 2*wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 540 >= 0) && (DrawX - 540 < wall_dim) && (DrawY - 400 >= 0) && (DrawY - 400 < wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 5*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 5*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// gap for testing between 
						else if ( (DrawX - 580 >= 0) && (DrawX - 580 < 5*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 580 >= 0) && (DrawX - 580 < 5*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else
						begin
							is_wall = 1'b0;
							is_brick = 1'b0;
						end
				end
3'd6: // Phòng 6
	begin

		if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 620 >= 0) && (DrawX - 620 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						// end of level border code
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 4*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 4*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 4*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 80 >= 0) && (DrawX - 80 < wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < 3*wall_dim) )
						begin	
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 100 >= 0) && (DrawX - 100 < wall_dim) && (DrawY - 400 >= 0) && (DrawY - 400 < 4*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 120 >= 0) && (DrawX - 120 < wall_dim) && (DrawY - 380 >= 0) && (DrawY - 380 < 5*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 140 >= 0) && (DrawX - 140 < wall_dim) && (DrawY - 360 >= 0) && (DrawY - 360 < 6*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 160 >= 0) && (DrawX - 160 < wall_dim) && (DrawY - 340 >= 0) && (DrawY - 340 < 7*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 180 >= 0) && (DrawX - 180 < wall_dim) && (DrawY - 320 >= 0) && (DrawY - 320 < 8*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 200 >= 0) && (DrawX - 200 < wall_dim) && (DrawY - 300 >= 0) && (DrawY - 300 < 9*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 220 >= 0) && (DrawX - 220 < wall_dim) && (DrawY - 280 >= 0) && (DrawY - 280 < 10*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 240 >= 0) && (DrawX - 240 < wall_dim) && (DrawY - 120 >= 0) && (DrawY - 120 < 18*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 20 >= 0) && (DrawX - 20 < 5*wall_dim) && (DrawY - 200 >= 0) && (DrawY - 200 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 180 >= 0) && (DrawX - 180 < 2*wall_dim) && (DrawY - 160 >= 0) && (DrawY - 160 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 160 >= 0) && (DrawX - 160 < wall_dim) && (DrawY - 240 >= 0) && (DrawY - 240 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						// gap for testing between 
						else if ( (DrawX - 300 >= 0) && (DrawX - 300 < 19*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 300 >= 0) && (DrawX - 300 < 19*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 300 >= 0) && (DrawX - 300 < 15*wall_dim) && (DrawY - 420 >= 0) && (DrawY - 420 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 300 >= 0) && (DrawX - 300 < 14*wall_dim) && (DrawY - 400 >= 0) && (DrawY - 400 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 300 >= 0) && (DrawX - 300 < 13*wall_dim) && (DrawY - 380 >= 0) && (DrawY - 380 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 300 >= 0) && (DrawX - 300 < 12*wall_dim) && (DrawY - 360 >= 0) && (DrawY - 360 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 300 >= 0) && (DrawX - 300 < 11*wall_dim) && (DrawY - 340 >= 0) && (DrawY - 340 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 300 >= 0) && (DrawX - 300 < 3*wall_dim) && (DrawY - 280 >= 0) && (DrawY - 280 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 360 >= 0) && (DrawX - 360 < 5*wall_dim) && (DrawY - 220 >= 0) && (DrawY - 220 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						else if ( (DrawX - 520 >= 0) && (DrawX - 520 < 5*wall_dim) && (DrawY - 180 >= 0) && (DrawY - 180 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 300 >= 0) && (DrawX - 300 < wall_dim) && (DrawY - 20 >= 0) && (DrawY - 20 < 13*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else
						begin
							is_wall = 1'b0;
							is_brick = 1'b0;
						end
				end



				// check tao phong
				
				3'd7: // start screen room
				begin
					// ground tiles
												if ( (DrawX - 0 >= 0) && (DrawX - 0 < 32*wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 620 >= 0) && (DrawX - 620 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 23*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < wall_dim) && (DrawY - 0 >= 0) && (DrawY - 0 < 23*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						//them
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 4*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 0 >= 0) && (DrawX - 0 < 4*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 100 >= 0) && (DrawX - 100 < wall_dim) && (DrawY - 400 >= 0) && (DrawY - 400 < 4*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 180 >= 0) && (DrawX - 180 < wall_dim) && (DrawY - 360 >= 0) && (DrawY - 360 < 6*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						
						else if ( (DrawX - 260 >= 0) && (DrawX - 260 < wall_dim) && (DrawY - 340 >= 0) && (DrawY - 340 < 7*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 340 >= 0) && (DrawX - 340 < wall_dim) && (DrawY - 320 >= 0) && (DrawY - 320 < 8*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 420 >= 0) && (DrawX - 420 < wall_dim) && (DrawY - 320 >= 0) && (DrawY - 320 < 8*wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 520 >= 0) && (DrawX - 520 < 6*wall_dim) && (DrawY - 460 >= 0) && (DrawY - 460 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 520 >= 0) && (DrawX - 520 < 5*wall_dim) && (DrawY - 440 >= 0) && (DrawY - 440 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 520 >= 0) && (DrawX - 520 < 5*wall_dim) && (DrawY - 320 >= 0) && (DrawY - 320 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b0;
						end
						else if ( (DrawX - 60 >= 0) && (DrawX - 60 < wall_dim) && (DrawY - 360 >= 0) && (DrawY - 360 < wall_dim) )
						begin
							is_wall = 1'b1;
							is_brick = 1'b1;
						end
						// end of level border code
						else
						begin
							is_wall = 1'b0;
							is_brick = 1'b0;
						end
				end
				
			default: 
				begin
					is_wall = 1'b0; // needs to be changed
					is_brick = 1'b0;
				end
		endcase
		
		if (is_wall == 1'b1)
		begin
			wall_address = (DrawX % wall_dim) + (DrawY % wall_dim) * wall_dim;
		end
		else
		begin
			wall_address = 9'b0; // don't care
		end
	end
endmodule
