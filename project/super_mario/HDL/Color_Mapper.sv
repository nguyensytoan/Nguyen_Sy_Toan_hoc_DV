//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Po-Han Huang  10-06-2017                               --
//                                                                       --
//    Fall 2017 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 8                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------

// color_mapper: Decide which color to be output to VGA for each pixel.
module  Color_Mapper ( 
							  input 			 		is_logo,//is_index,			  // if this is a 0 we're gonna draw the logo, otherwise nah lol
							  input					is_giant,
							  input		  [15:0] logo_address,giant_address,	  // if there is a logo, gotta decide its sprite colors with this address.
							  input		  [1:0]	is_alive,			  // Mario's health - 0 if dead
																				  //	(calculated in ball.sv)
							  input					is_alive_goomba,	  // Whether goomba at current DrawX/Y is alive or not
							  input              is_ball,            // Whether current pixel belongs to ball 
                                                              //   or background (computed in ball.sv)
							  input					is_wall,				  // Whether current pixel is a collision wall or not
																				  // 	 (calculated in wall.sv)
							  input					is_brick,			  // Whether current pixel belongs to brick
																				  // 	 or ground	(computed in wall.sv)
							  input					is_qblock,//is_q_block,			  // Whether current pixel belongs to qblock
																				  //   or background (computed in qblock.sv)
							  input					blink_num,//blink_num_q,			  // Blink # for qblock animation - calculated in qblock.sv
							  input					is_coin,				  // Whether current pixel belongs to coin
																				  // 	 or background (computed in coin.sv)
							  input					is_mush,				  // Whether current pixel belongs to mushroom
																				  //   or background (computed in mush.sv)
							  input			[1:0] spin_num,			  // Spin # for coin spin animation - calculated in coin.sv
							  input					is_empty,//is_empty_q,			  // Whether block is empty or not - calculated in qblock.sv
							  input					is_goomba,			  // Whether current pixel belongs to goomba
																				  // 	 or background (computed in goomba.sv)
							  input					is_fball,is_fball_1,
														is_fball_2,is_fball_3,			  // Whether current pixel belongs to fball
														is_fball_4,is_fball_5,						  // 	 or background (computed in fball.sv)
														is_fball_6,is_fball_7,is_fball_8,
							  
							  input					up_num,up_num_1,			  // Whether fireball is oriented up or down - calculated in fball.sv
														up_num_2,up_num_3,up_num_4,
														up_num_5,up_num_6,up_num_7,up_num_8,
							  input					on_ground,			  // Whether mario is on the ground or not (computed in ball.sv)
							  input					is_walking,			  // Whether mario is moving left/right on the ground or not.
							  input 			[1:0] walk_num,			  // walk animation of mario walking
							  input					walk_num_goomba,	  // walk animation of goomba
							  input			[9:0] mario_address,		  // if mario is here, gotta decide its sprite colors with this address
							  input			[8:0]	goomba_address,	  // if a goomba is here, gotta decide its sprite colors with this address
							  input			[8:0] wall_address,		  // if there is a wall, gotta decide its sprite colors with this address
							  input			[8:0] qblock_address,	  // if there is a qblock, gotta decide its sprite colors with this address
							  //input			[8:0] q_block_address,
							  
							  input			[8:0] coin_address,		  // if there is a coin, gotta decide its sprite colors with this address
							  input			[8:0] mush_address,		  // if there is a mush, gotta decide its sprite colors with this address
							  input			[8:0]	fball_address,		  // if there is a fball, gotta decide its sprite colors with this address
							  input			[8:0]	fball_address_1,
							  input			[8:0]	fball_address_2,
							  input			[8:0]	fball_address_3,
							  input			[8:0]	fball_address_4,
							  input			[8:0]	fball_address_5,
							  input			[8:0]	fball_address_6,
							  input			[8:0]	fball_address_7,
							  input			[8:0]	fball_address_8,
			
                       output logic [3:0] VGA_R, VGA_G, VGA_B // VGA RGB output
                     );
    
    logic [3:0] Red, Green, Blue;
	 logic [11:0] output_color_logo,
					 
					  //output_color_start,
					  output_color_ground,
					  output_color_brick,
					  output_color_mario_still, 
					  output_color_mario_jump, 
					  output_color_mario_walk_1, 
					  output_color_mario_walk_2,
					  output_color_mario_walk_3,
					  output_color_mario_big_still,
					  output_color_mario_big_jump,
					  output_color_mario_big_walk_1,
					  output_color_mario_big_walk_2,
					  output_color_mario_big_walk_3,
					  output_color_mario_dead,
					  output_color_goomba_walk_1,
					  output_color_goomba_walk_2,
					  output_color_goomba_squished,
					  
					  output_color_qblock_blink_1,
					  output_color_qblock_blink_2,
					 // output_color_q_block_blink_1,
					  //output_color_q_block_blink_2,
					  
					  output_color_qblock_empty,
					  //output_color_q_block_empty,
					  output_color_coin_spin_1,
					  output_color_coin_spin_2,
					  output_color_coin_spin_3,
					  output_color_coin_spin_4,
					  output_color_mush,
					  output_color_fball_up,
					  output_color_fball_down,
					  output_color_fball_up_1,
					  output_color_fball_down_1,
					  output_color_fball_up_2,
					  output_color_fball_down_2,
					  output_color_fball_up_3,
					  output_color_fball_down_3,
					  output_color_fball_up_4,
					  output_color_fball_down_4,
					  output_color_fball_up_5,
					  output_color_fball_down_5,
					  output_color_fball_up_6,
					  output_color_fball_down_6,
					  output_color_fball_up_7,
					  output_color_fball_down_7,
					  output_color_fball_up_8,
					  output_color_fball_down_8,
					  output_color_giant;
    
    // Output colors to VGA
    assign VGA_R = Red;
    assign VGA_G = Green;
    assign VGA_B = Blue;
    
	 // sprite modules
		 // logo sprite
		 ram_logo logo(.read_address(logo_address), .output_color(output_color_logo));
		 
		 //ram_start_1 start_1(.read_address(start_address), .output_color(output_color_start));
		 // ground tiles
		 ram_tile_ground ground_tiles(.read_address(wall_address), .output_color(output_color_ground));
		 ram_tile_brick  brick_tiles(.read_address(wall_address), .output_color(output_color_brick));
	 
		 // mario sprites
		 ram_mario_still_right mario_still(.read_address(mario_address), .output_color(output_color_mario_still));
		 ram_mario_jump_right mario_jump(.read_address(mario_address), .output_color(output_color_mario_jump));
		 ram_mario_walk_right_1 mario_walk_1(.read_address(mario_address), .output_color(output_color_mario_walk_1));
		 ram_mario_walk_right_2 mario_walk_2(.read_address(mario_address), .output_color(output_color_mario_walk_2));
		 ram_mario_walk_right_3 mario_walk_3(.read_address(mario_address), .output_color(output_color_mario_walk_3));
		 
		 ram_mario_big_still_right mario_big_still(.read_address(mario_address), .output_color(output_color_mario_big_still));
		 ram_mario_big_jump_right mario_big_jump(.read_address(mario_address), .output_color(output_color_mario_big_jump));
		 ram_mario_big_walk_right_1 mario_big_walk_1(.read_address(mario_address), .output_color(output_color_mario_big_walk_1));
		 ram_mario_big_walk_right_2 mario_big_walk_2(.read_address(mario_address), .output_color(output_color_mario_big_walk_2));
		 ram_mario_big_walk_right_3 mario_big_walk_3(.read_address(mario_address), .output_color(output_color_mario_big_walk_3));
		 
		 ram_mario_dead mario_dead(.read_address(mario_address), .output_color(output_color_mario_dead));
		 
		 // goomba sprites
		 ram_goomba_walk_1 goomba_walk_1(.read_address(goomba_address), .output_color(output_color_goomba_walk_1));
		 ram_goomba_walk_2 goomba_walk_2(.read_address(goomba_address), .output_color(output_color_goomba_walk_2));
		 ram_goomba_squished goomba_squished(.read_address(goomba_address), .output_color(output_color_goomba_squished));
		 
		 // qblock sprites
		 ram_qblock_blink_1 qblock_blink_1(.read_address(qblock_address), .output_color(output_color_qblock_blink_1));
		 ram_qblock_blink_2 qblock_blink_2(.read_address(qblock_address), .output_color(output_color_qblock_blink_2));
		 ram_qblock_empty qblock_empty(.read_address(qblock_address), .output_color(output_color_qblock_empty));
		 
		 //Q_block
		 //ram_q_block_blink_1 q_block_blink_1(.read_address(q_block_address), .output_color(output_color_q_block_blink_1));
		 
		 // coin sprites
		 ram_coin_spin_1 coin_spin_1(.read_address(coin_address), .output_color(output_color_coin_spin_1));
		 ram_coin_spin_2 coin_spin_2(.read_address(coin_address), .output_color(output_color_coin_spin_2));
		 ram_coin_spin_3 coin_spin_3(.read_address(coin_address), .output_color(output_color_coin_spin_3));
		 ram_coin_spin_4 coin_spin_4(.read_address(coin_address), .output_color(output_color_coin_spin_4));
	 
		 // mush sprites
		 ram_mush mush(.read_address(mush_address), .output_color(output_color_mush));
		 
		 // fball sprites
		 ram_fball_up fball_up(.read_address(fball_address), .output_color(output_color_fball_up));
		 ram_fball_down fball_down(.read_address(fball_address), .output_color(output_color_fball_down));
		 
		 ram_fball_up fball_up_1(.read_address(fball_address_1), .output_color(output_color_fball_up_1));
		 ram_fball_down fball_down_1(.read_address(fball_address_1), .output_color(output_color_fball_down_1));
		 
		 ram_fball_up fball_up_2(.read_address(fball_address_2), .output_color(output_color_fball_up_2));
		 ram_fball_down fball_down_2(.read_address(fball_address_2), .output_color(output_color_fball_down_2));
		 
		 ram_fball_up fball_up_3(.read_address(fball_address_3), .output_color(output_color_fball_up_3));
		 ram_fball_down fball_down_3(.read_address(fball_address_3), .output_color(output_color_fball_down_3));
	 
	    ram_fball_up fball_up_4(.read_address(fball_address_4), .output_color(output_color_fball_up_4));
		 ram_fball_down fball_down_4(.read_address(fball_address_4), .output_color(output_color_fball_down_4));
    
		 ram_fball_up fball_up_5(.read_address(fball_address_5), .output_color(output_color_fball_up_5));
		 ram_fball_down fball_down_5(.read_address(fball_address_5), .output_color(output_color_fball_down_5));
	 
		 ram_fball_up fball_up_6(.read_address(fball_address_6), .output_color(output_color_fball_up_6));
		 ram_fball_down fball_down_6(.read_address(fball_address_6), .output_color(output_color_fball_down_6));
		
		 ram_fball_up fball_up_7(.read_address(fball_address_7), .output_color(output_color_fball_up_7));
		 ram_fball_down fball_down_7(.read_address(fball_address_7), .output_color(output_color_fball_down_7));
		
		 ram_fball_up fball_up_8(.read_address(fball_address_8), .output_color(output_color_fball_up_8));
		 ram_fball_down fball_down_8(.read_address(fball_address_8), .output_color(output_color_fball_down_8));
		 //them
		 ram_giant giant(.read_address(giant_address), .output_color(output_color_giant));
		// Assign color based on is_ball signal
    always_comb
    begin
        if (is_logo == 1'b1)
		  begin
				Red = output_color_logo[11:8];
				Green = output_color_logo[7:4];
				Blue = output_color_logo[3:0];
		  end
		  /*
		  else if(is_index == 1'b1) begin
				Red =4'hF;
				Green =4'hF;
				Blue=4'hF;
			end
			*/
		  else if (is_giant == 1'b1)
		  begin
			if (output_color_giant == 12'h808)
							begin
								Red = 4'h0; 
								Green = 4'h8;
								Blue = 4'hc;
							end
				else begin 
				Red = output_color_giant[11:8];
				Green = output_color_giant[7:4];
				Blue = output_color_giant[3:0];
				end
		  end
		  
		  else if (is_ball == 1'b1) 
        begin
		      if (is_alive == 2'd0)
				begin
					if (output_color_mario_dead == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else 
					begin
						Red = output_color_mario_dead[11:8];
						Green = output_color_mario_dead[7:4];
						Blue = output_color_mario_dead[3:0];
					end
				end
				else if (is_alive == 2'd2) // 2 health
				begin
					if (on_ground == 1'b1) // mario is on the ground					
					begin
						//draw mario moving
						if (is_walking == 1'b1)
						begin
							if (walk_num == 3'd1)
							begin
								if (output_color_mario_big_walk_1 == 12'h808)
								begin
									Red = 4'h0; 
									Green = 4'h8;
									Blue = 4'hc;
								end
								else 
								begin
									Red = output_color_mario_big_walk_1[11:8];
									Green = output_color_mario_big_walk_1[7:4];
									Blue = output_color_mario_big_walk_1[3:0];
								end
							end
							else if (walk_num == 3'd2)
							begin
								if (output_color_mario_big_walk_2 == 12'h808)
								begin
									Red = 4'h0; 
									Green = 4'h8;
									Blue = 4'hc;
								end
								else 
								begin
									Red = output_color_mario_big_walk_2[11:8];
									Green = output_color_mario_big_walk_2[7:4];
									Blue = output_color_mario_big_walk_2[3:0];
								end
							end
							else
							begin
								if (output_color_mario_big_walk_3 == 12'h808)
								begin
									Red = 4'h0; 
									Green = 4'h8;
									Blue = 4'hc;
								end
								else 
								begin
									Red = output_color_mario_big_walk_3[11:8];
									Green = output_color_mario_big_walk_3[7:4];
									Blue = output_color_mario_big_walk_3[3:0];
								end
							end
						end
						// draw mario still
						else
						begin
							if (output_color_mario_big_still == 12'h808)
							begin
								Red = 4'h0; 
								Green = 4'h8;
								Blue = 4'hc;
							end
							else 
							begin
								Red = output_color_mario_big_still[11:8];
								Green = output_color_mario_big_still[7:4];
								Blue = output_color_mario_big_still[3:0];
							end
						end
					end
					else // mario is not on the ground (in the air)
					begin
						// draw mario jumping
						if (output_color_mario_big_jump == 12'h808)
						begin
							Red = 4'h0; 
							Green = 4'h8;
							Blue = 4'hc;
						end
						else 
						begin
							Red = output_color_mario_big_jump[11:8];
							Green = output_color_mario_big_jump[7:4];
							Blue = output_color_mario_big_jump[3:0];
						end
					end
				end
				else // one health
				begin
					if (on_ground == 1'b1) // mario is on the ground					
					begin
						//draw mario moving
						if (is_walking == 1'b1)
						begin
							if (walk_num == 3'd1)
							begin
								if (output_color_mario_walk_1 == 12'h808)
								begin
									Red = 4'h0; 
									Green = 4'h8;
									Blue = 4'hc;
								end
								else 
								begin
									Red = output_color_mario_walk_1[11:8];
									Green = output_color_mario_walk_1[7:4];
									Blue = output_color_mario_walk_1[3:0];
								end
							end
							else if (walk_num == 3'd2)
							begin
								if (output_color_mario_walk_2 == 12'h808)
								begin
									Red = 4'h0; 
									Green = 4'h8;
									Blue = 4'hc;
								end
								else 
								begin
									Red = output_color_mario_walk_2[11:8];
									Green = output_color_mario_walk_2[7:4];
									Blue = output_color_mario_walk_2[3:0];
								end
							end
							else
							begin
								if (output_color_mario_walk_3 == 12'h808)
								begin
									Red = 4'h0; 
									Green = 4'h8;
									Blue = 4'hc;
								end
								else 
								begin
									Red = output_color_mario_walk_3[11:8];
									Green = output_color_mario_walk_3[7:4];
									Blue = output_color_mario_walk_3[3:0];
								end
							end
						end
						// draw mario still
						else
						begin
							if (output_color_mario_still == 12'h808)
							begin
								Red = 4'h0; 
								Green = 4'h8;
								Blue = 4'hc;
							end
							else 
							begin
								Red = output_color_mario_still[11:8];
								Green = output_color_mario_still[7:4];
								Blue = output_color_mario_still[3:0];
							end
						end
					end
					else // mario is not on the ground (in the air)
					begin
						// draw mario jumping
						if (output_color_mario_jump == 12'h808)
						begin
							Red = 4'h0; 
							Green = 4'h8;
							Blue = 4'hc;
						end
						else 
						begin
							Red = output_color_mario_jump[11:8];
							Green = output_color_mario_jump[7:4];
							Blue = output_color_mario_jump[3:0];
						end
					end
				end
		  end
		  else if (is_mush == 1'b1)
		  begin
				if (output_color_mush == 12'h808)
				begin
					Red = 4'h0; 
					Green = 4'h8;
					Blue = 4'hc;
				end
				else
				begin
					Red = output_color_mush[11:8];
					Green = output_color_mush[7:4];
					Blue = output_color_mush[3:0]; 
				end
		  end
		  else if (is_fball == 1'b1)
		  begin
				if (up_num == 1'b1)
				begin
					if (output_color_fball_up == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_up[11:8];
						Green = output_color_fball_up[7:4];
						Blue = output_color_fball_up[3:0];
					end
				end
				else
				begin
					if (output_color_fball_down == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_down[11:8];
						Green = output_color_fball_down[7:4];
						Blue = output_color_fball_down[3:0];
					end
				end
		  end
		  // them
		  else if (is_fball_1 == 1'b1)
		  begin
				if (up_num_1 == 1'b1)
				begin
					if (output_color_fball_up_1 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_up_1[11:8];
						Green = output_color_fball_up_1[7:4];
						Blue = output_color_fball_up_1[3:0];
					end
				end
				else
				begin
					if (output_color_fball_down_1 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_down_1[11:8];
						Green = output_color_fball_down_1[7:4];
						Blue = output_color_fball_down_1[3:0];
					end
				end
		  end
		  
		  else if (is_fball_2 == 1'b1)
		  begin
				if (up_num_2 == 1'b1)
				begin
					if (output_color_fball_up_2 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_up_2[11:8];
						Green = output_color_fball_up_2[7:4];
						Blue = output_color_fball_up_2[3:0];
					end
				end
				else
				begin
					if (output_color_fball_down_2 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_down_2[11:8];
						Green = output_color_fball_down_2[7:4];
						Blue = output_color_fball_down_2[3:0];
					end
				end
		  end
		  
		  else if (is_fball_3 == 1'b1)
		  begin
				if (up_num_3 == 1'b1)
				begin
					if (output_color_fball_up_3 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_up_3[11:8];
						Green = output_color_fball_up_3[7:4];
						Blue = output_color_fball_up_3[3:0];
					end
				end
				else
				begin
					if (output_color_fball_down_3 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_down_3[11:8];
						Green = output_color_fball_down_3[7:4];
						Blue = output_color_fball_down_3[3:0];
					end
				end
		  end
		  else if (is_fball_4 == 1'b1)
		  begin
				if (up_num_4 == 1'b1)
				begin
					if (output_color_fball_up_4 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_up_4[11:8];
						Green = output_color_fball_up_4[7:4];
						Blue = output_color_fball_up_4[3:0];
					end
				end
				else
				begin
					if (output_color_fball_down_4 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_down_4[11:8];
						Green = output_color_fball_down_4[7:4];
						Blue = output_color_fball_down_4[3:0];
					end
				end
		  end
		  else if (is_fball_5 == 1'b1)
		  begin
				if (up_num_5 == 1'b1)
				begin
					if (output_color_fball_up_5 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_up_5[11:8];
						Green = output_color_fball_up_5[7:4];
						Blue = output_color_fball_up_5[3:0];
					end
				end
				else
				begin
					if (output_color_fball_down_5 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_down_5[11:8];
						Green = output_color_fball_down_5[7:4];
						Blue = output_color_fball_down_5[3:0];
					end
				end
		  end
		  else if (is_fball_6 == 1'b1)
		  begin
				if (up_num_6 == 1'b1)
				begin
					if (output_color_fball_up_6 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_up_6[11:8];
						Green = output_color_fball_up_6[7:4];
						Blue = output_color_fball_up_6[3:0];
					end
				end
				else
				begin
					if (output_color_fball_down_6 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_down_6[11:8];
						Green = output_color_fball_down_6[7:4];
						Blue = output_color_fball_down_6[3:0];
					end
				end
		  end
		  else if (is_fball_7 == 1'b1)
		  begin
				if (up_num_7 == 1'b1)
				begin
					if (output_color_fball_up_7 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_up_7[11:8];
						Green = output_color_fball_up_7[7:4];
						Blue = output_color_fball_up_7[3:0];
					end
				end
				else
				begin
					if (output_color_fball_down_7 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_down_7[11:8];
						Green = output_color_fball_down_7[7:4];
						Blue = output_color_fball_down_7[3:0];
					end
				end
		  end
		  else if (is_fball_8 == 1'b1)
		  begin
				if (up_num_8 == 1'b1)
				begin
					if (output_color_fball_up_8 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_up_8[11:8];
						Green = output_color_fball_up_8[7:4];
						Blue = output_color_fball_up_8[3:0];
					end
				end
				else
				begin
					if (output_color_fball_down_8 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_fball_down_8[11:8];
						Green = output_color_fball_down_8[7:4];
						Blue = output_color_fball_down_8[3:0];
					end
				end
		  end
		  //
		  else if (is_goomba == 1'b1)
		  begin
				if (is_alive_goomba == 1'b0)
				begin
					if (output_color_goomba_squished == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_goomba_squished[11:8];
						Green = output_color_goomba_squished[7:4];
						Blue = output_color_goomba_squished[3:0]; 
					end
				end
				else
				begin
					if (walk_num_goomba == 1'b0)
					begin
						if (output_color_goomba_walk_1 == 12'h808)
						begin
							Red = 4'h0; 
							Green = 4'h8;
							Blue = 4'hc;
						end
						else
						begin
							Red = output_color_goomba_walk_1[11:8];
							Green = output_color_goomba_walk_1[7:4];
							Blue = output_color_goomba_walk_1[3:0]; 
						end
					end
					else
					begin
						if (output_color_goomba_walk_2 == 12'h808)
						begin
							Red = 4'h0; 
							Green = 4'h8;
							Blue = 4'hc;
						end
						else
						begin
							Red = output_color_goomba_walk_2[11:8];
							Green = output_color_goomba_walk_2[7:4];
							Blue = output_color_goomba_walk_2[3:0]; 
						end
					end
				end
		  end
		  else if (is_coin == 1'b1)
		  begin
				if (spin_num == 2'd0)
				begin
					if (output_color_coin_spin_1 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_coin_spin_1[11:8];
						Green = output_color_coin_spin_1[7:4];
						Blue = output_color_coin_spin_1[3:0]; 
					end
				end
				else if (spin_num == 2'd1)
				begin
					if (output_color_coin_spin_2 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_coin_spin_2[11:8];
						Green = output_color_coin_spin_2[7:4];
						Blue = output_color_coin_spin_2[3:0]; 
					end
				end
				else if (spin_num == 2'd2)
				begin
					if (output_color_coin_spin_3 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_coin_spin_3[11:8];
						Green = output_color_coin_spin_3[7:4];
						Blue = output_color_coin_spin_3[3:0]; 
					end
				end
				else
				begin
					if (output_color_coin_spin_4 == 12'h808)
					begin
						Red = 4'h0; 
						Green = 4'h8;
						Blue = 4'hc;
					end
					else
					begin
						Red = output_color_coin_spin_4[11:8];
						Green = output_color_coin_spin_4[7:4];
						Blue = output_color_coin_spin_4[3:0]; 
					end
				end
		  end
		  else if (is_qblock == 1'b1)
		  begin
				if (is_empty == 1'b0)
				begin
					if (blink_num == 1'b1)
					begin
						// draw sprite
						Red = output_color_qblock_blink_1[11:8];
						Green = output_color_qblock_blink_1[7:4];
						Blue = output_color_qblock_blink_1[3:0];
					end
					else 
					begin
						// draw sprite
						Red = output_color_qblock_blink_2[11:8];
						Green = output_color_qblock_blink_2[7:4];
						Blue = output_color_qblock_blink_2[3:0];
					end
				end
				else
				begin
					// draw sprite
					Red = output_color_qblock_empty[11:8];
					Green = output_color_qblock_empty[7:4];
					Blue = output_color_qblock_empty[3:0];
				end
		  end
		  //ertyuiodfghjiogh
		  /*
		  else if (is_q_block == 1'b1)
		  begin
				if (is_empty_q == 1'b0)
				begin
					if (blink_num_q == 1'b1)
					begin
						// draw sprite
						Red = output_color_q_block_blink_1[11:8];
						Green = output_color_q_block_blink_1[7:4];
						Blue = output_color_q_block_blink_1[3:0];
					end
					else 
					begin
						// draw sprite
						Red = output_color_q_block_blink_2[11:8];
						Green = output_color_q_block_blink_2[7:4];
						Blue = output_color_q_block_blink_2[3:0];
					end
				end
				else
				begin
					// draw sprite
					Red = output_color_q_block_empty[11:8];
					Green = output_color_q_block_empty[7:4];
					Blue = output_color_q_block_empty[3:0];
				end
		  end
		  */
		  //rtyuiopdfghjkl;
		  else if (is_wall == 1'b1)
		  begin
				if (is_brick == 1'b0)
				begin
					// draw sprite
					Red = output_color_ground[11:8];
					Green = output_color_ground[7:4];
					Blue = output_color_ground[3:0];
				end
				else
				begin
					// draw sprite
					Red = output_color_brick[11:8];
					Green = output_color_brick[7:4];
					Blue = output_color_brick[3:0];
				end
        end
		  
		  else 
        begin
            // Mario blue background
            Red = 4'h0; 
            Green = 4'h8;
            Blue = 4'hc;
				//41ACF3
        end
    end 
    
endmodule 
