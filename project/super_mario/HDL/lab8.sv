

module lab8( 
				input              CLOCK_50,
            input    [1:0]     KEY,    // bit 0 is set up as Reset
				
				///////// HEX /////////
				output   [ 7: 0]   HEX0,
				output   [ 7: 0]   HEX1,
				output   [ 7: 0]   HEX2,
				output   [ 7: 0]   HEX3,
				output   [ 7: 0]   HEX4,
				output   [ 7: 0]   HEX5,
               ///////// VGA /////////
				output             VGA_HS,
				output             VGA_VS,
				output   [ 3: 0]   VGA_R,
				output   [ 3: 0]   VGA_G,
				output   [ 3: 0]   VGA_B,
				////////ESP32 INTERFACE//////////
				input              sw_1    , // Recieve enable
				//input 				 sw1, sw2,
				input   logic      uart_rxd, // UART Recieve pin.
				output  logic      uart_txd, // UART transmit pin.

				////// LEDs for debugging/////
				output logic [7:0] LEDR
);
						  

	//=======================================================
	//  REG/WIRE declarations
	//=======================================================
	// Signals for drawing to the display. 
	wire [31:0] draw_x, draw_y;
	wire [3:0]     red, green, blue;

	// Timing signals - don't touch these.
	wire           h_sync, v_sync;
	wire           disp_ena;
	wire           vga_clk;
	
	//======================================================================================================================

   logic [1:0] isAlive;
	logic Reset_h,Run_h, Clk, isBall, isWall, isBrick, onGround, isWalking, isGoomba, isAliveGoomba, isQblock,/*isQ_block,*/ isCoin, isLogo, isMush, isFball, isFball_1,isGiant;
	logic isQblock_r1_1, isQblock_r1_2, isQblock_r2_1;
	
	logic isIndex;
	
	logic isFball_2,isFball_3,isFball_4,isFball_5,isFball_6,isFball_7,isFball_8; 
	//logic isQ_block_r1_1, isQ_block_r1_2, isQ_block_r2_1;
	
	logic isCoin_r1_1, isCoin_r2_1;
	logic isCoin_r2_2,isCoin_r2_3,isCoin_r2_4;
	logic isCoin_r1_2,isCoin_r1_3,isCoin_r1_4,isCoin_r1_5,
			isCoin_r6_1,isCoin_r6_2,isCoin_r6_3,isCoin_r6_4,isCoin_r6_5,isCoin_r6_6;
	
	logic [1:0] walkNum;
	logic upNum;
	logic upNum_1;
	logic upNum_2, unNum_3, unNum_4, unNum_5, unNum_6, unNum_7, unNum_8;
	
	logic walkNumGoomba;
   logic [7:0] keycode;
	logic w_on, a_on, d_on;
	
	logic [9:0] score;
	logic blinkNum, blinkNum_r1_1, blinkNum_r1_2, blinkNum_r2_1;
	//logic blinkNum_q, blinkNum_q_r1_1, blinkNum_q_r1_2, blinkNum_q_r2_1;
	
	logic [1:0] spinNum, spinNum_r1_1, spinNum_r2_1,spinNum_r2_2,
					spinNum_r2_3,spinNum_r2_4,
					spinNum_r1_2,spinNum_r1_3,spinNum_r1_4,spinNum_r1_5,
					spinNum_r6_1,spinNum_r6_2,spinNum_r6_3,spinNum_r6_4,spinNum_r6_5;//,spinNum_r6_6;
	logic isEmpty, isEmpty_r1_1, isEmpty_r1_2, isEmpty_r2_1;
	
	//logic isEmpty_q, isEmpty_q_r1_1, isEmpty_q_r1_2, isEmpty_q_r2_1;
	
	// coordinates for collisions
	logic [9:0] marioX, marioY, marioSizeY;
	// goombas
	logic [9:0] goomba_r1_1_x_, goomba_r1_1_y_;
	logic [9:0] goomba_r1_2_x_, goomba_r1_2_y_;
	logic [9:0] goomba_r2_1_x_, goomba_r2_1_y_;
	logic [9:0] goomba_r3_1_x_, goomba_r3_1_y_;
	
	logic [9:0] goomba_r4_1_x_, goomba_r4_1_y_;
	logic [9:0] goomba_r4_2_x_, goomba_r4_2_y_;
	logic [9:0] goomba_r4_3_x_, goomba_r4_3_y_;
	logic [9:0] goomba_r4_4_x_, goomba_r4_4_y_;
	
	logic [9:0] goomba_r5_1_x_, goomba_r5_1_y_;
	logic [9:0] goomba_r5_2_x_, goomba_r5_2_y_;
	logic [9:0] goomba_r5_3_x_, goomba_r5_3_y_;
	
		
	// coins
	logic [9:0] coin_r1_1_x_, coin_r1_1_y_;
	logic [9:0] coin_r2_1_x_, coin_r2_1_y_;
	
	logic [9:0] coin_r2_2_x_, coin_r2_2_y_,
					coin_r2_3_x_, coin_r2_3_y_,
					coin_r2_4_x_, coin_r2_4_y_;
					
	logic [9:0] coin_r1_2_x_,coin_r1_2_y_,
					coin_r1_3_x_,coin_r1_3_y_,
					coin_r1_4_x_,coin_r1_4_y_,
					coin_r1_5_x_,coin_r1_5_y_,
					
					coin_r6_1_x_,coin_r6_1_y_,
					coin_r6_2_x_,coin_r6_2_y_,
					coin_r6_3_x_,coin_r6_3_y_,
					coin_r6_4_x_,coin_r6_4_y_,
					coin_r6_5_x_,coin_r6_5_y_;
					//coin_r6_6_x_,coin_r6_6_y_;
					
	// mushrooms
	logic [9:0] mush_r1_1_x_, mush_r1_1_y_;
		
	// fireballs
	logic [9:0] fball_r3_1_x_, fball_r3_1_y_;
	logic [9:0] fball_r3_2_x_, fball_r3_2_y_;
	
	logic [9:0] fball_r2_1_x_, fball_r2_1_y_;
	logic [9:0] fball_r2_2_x_, fball_r2_2_y_;
	
	logic [9:0] fball_r7_1_x_, fball_r7_1_y_;
	logic [9:0] fball_r7_2_x_, fball_r7_2_y_;
	logic [9:0] fball_r7_3_x_, fball_r7_3_y_;
	logic [9:0] fball_r7_4_x_, fball_r7_4_y_;
	logic [9:0] fball_r7_5_x_, fball_r7_5_y_;
	// debuggy bois
	logic on_ground_hex;

	//=======================================================
	//  Structural coding
	//=======================================================

	//Assign one button to reset
	assign {Run_h}=~ (KEY[1]);



    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    logic [2:0] room_num;
	 
	 logic [15:0] logo_address,giant_address;
	 
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 
	 
	 logic [8:0] wall_address,index_address;
	 logic [9:0] mario_address;
	 logic [8:0] goomba_address;
	 logic [8:0] qblock_address, qblock_address_r1_1, qblock_address_r1_2, qblock_address_r2_1;
	 //logic [8:0] q_block_address, q_block_address_r1_1, q_block_address_r1_2, q_block_address_r2_1;
	 logic [8:0] coin_address, coin_address_r1_1, coin_address_r2_1,coin_address_r2_2,
					 coin_address_r2_3,coin_address_r2_4;
					 
	 logic [8:0] coin_address_r1_2,coin_address_r1_3,coin_address_r1_4,coin_address_r1_5,
					 coin_address_r6_1,coin_address_r6_2,coin_address_r6_3,coin_address_r6_4,coin_address_r6_5;//,coin_address_r6_6;
	 
	 logic [8:0] mush_address;
	 logic [8:0] fball_address, fball_address_1, fball_address_2, fball_address_3;
	 logic [8:0] fball_address_4, fball_address_5, fball_address_6, fball_address_7, fball_address_8;
	
     // Register VGA output signals for timing purposes
	always @(posedge vga_clk) begin
		if (disp_ena == 1'b1) begin
			VGA_R <= red;
			VGA_B <= blue;
			VGA_G <= green;
		end else begin
			VGA_R <= 4'd0;
			VGA_B <= 4'd0;
			VGA_G <= 4'd0;
		end
		VGA_HS <= h_sync;
		VGA_VS <= v_sync;
	end
    
	// Instantiate PLL to convert the 50 MHz clock to a 25 MHz clock for timing.
	pll vgapll_inst (
		 .inclk0    (CLOCK_50),
		 .c0        (vga_clk)
	);

	// Instantite VGA controller
	VGA_controller control (
		.pixel_clk  (vga_clk),
		.reset_n    (Reset_h),
		.h_sync     (h_sync),
		.v_sync     (v_sync),
		.disp_ena   (disp_ena),
		.column     (draw_x),
		.row        (draw_y)
		);
 
	// KEYBOARD UART
	impl_top uart0(
		         .clk(CLOCK_50)     , // Top level system clock input.
		         .sw_0(~Reset_h)    , // Resett.
		         .sw_1(sw_1)   , // Recieve enable.
					.uart_rxd(uart_rxd), // UART Recieve pin.
		          .uart_txd(uart_txd), // UART transmit pin.
					.led(keycode)
		);
		assign LEDR = keycode;

    // Which signal should be frame_clk? - VGA_VS???
    ball ball_instance(
							 .Clk(CLOCK_50),
							 .Reset(Reset_h),
							 .frame_clk(VGA_VS),
							 .DrawX(draw_x),
							 .DrawY(draw_y),
							 .w_on(w_on),
							 .a_on(a_on),
							 .d_on(d_on),
							 .goomba_r1_1_x(goomba_r1_1_x_), // we are legit gonna pass in every goomba coordinate, every coin coordinate, mushroom, etc.
							 .goomba_r1_1_y(goomba_r1_1_y_),
							 .goomba_r1_2_x(goomba_r1_2_x_),
							 .goomba_r1_2_y(goomba_r1_2_y_),
							 .goomba_r2_1_x(goomba_r2_1_x_),
							 .goomba_r2_1_y(goomba_r2_1_y_),
							 .goomba_r3_1_x(goomba_r3_1_x_),
							 .goomba_r3_1_y(goomba_r3_1_y_),
							 
							 .goomba_r4_1_x(goomba_r4_1_x_),
							 .goomba_r4_1_y(goomba_r4_1_y_),
							 .goomba_r4_2_x(goomba_r4_2_x_),
							 .goomba_r4_2_y(goomba_r4_2_y_),
							 .goomba_r4_3_x(goomba_r4_3_x_),
							 .goomba_r4_3_y(goomba_r4_3_y_),
							 .goomba_r4_4_x(goomba_r4_4_x_),
							 .goomba_r4_4_y(goomba_r4_4_y_),
							 
							 .goomba_r5_1_x(goomba_r5_1_x_),
							 .goomba_r5_1_y(goomba_r5_1_y_),
							 .goomba_r5_2_x(goomba_r5_2_x_),
							 .goomba_r5_2_y(goomba_r5_2_y_),
							 .goomba_r5_3_x(goomba_r5_3_x_),
							 .goomba_r5_3_y(goomba_r5_3_y_),
							 
							 .fball_r3_1_x(fball_r3_1_x_),
							 .fball_r3_1_y(fball_r3_1_y_),
							 
							 .fball_r3_2_x(fball_r3_2_x_),
							 .fball_r3_2_y(fball_r3_2_y_),
							 
							 .fball_r2_1_x(fball_r2_1_x_),
							 .fball_r2_1_y(fball_r2_1_y_),
							 
							 .fball_r2_2_x(fball_r2_2_x_),
							 .fball_r2_2_y(fball_r2_2_y_),
							 
							 .fball_r7_1_x(fball_r7_1_x_),
							 .fball_r7_1_y(fball_r7_1_y_),
							 .fball_r7_2_x(fball_r7_2_x_),
							 .fball_r7_2_y(fball_r7_2_y_),
							 .fball_r7_3_x(fball_r7_3_x_),
							 .fball_r7_3_y(fball_r7_3_y_),
							 .fball_r7_4_x(fball_r7_4_x_),
							 .fball_r7_4_y(fball_r7_4_y_),
							 .fball_r7_5_x(fball_r7_5_x_),
							 .fball_r7_5_y(fball_r7_5_y_),
							 
							 .coin_r1_1_x(coin_r1_1_x_),
							 .coin_r1_1_y(coin_r1_1_y_),
							 .coin_r2_1_x(coin_r2_1_x_),
							 .coin_r2_1_y(coin_r2_1_y_),
							 
							 .coin_r2_2_x(coin_r2_2_x_),
							 .coin_r2_2_y(coin_r2_2_y_),
							 .coin_r2_3_x(coin_r2_3_x_),
							 .coin_r2_3_y(coin_r2_3_y_),
							 .coin_r2_4_x(coin_r2_4_x_),
							 .coin_r2_4_y(coin_r2_4_y_),
							 
							 .coin_r1_2_x(coin_r1_2_x_),
							 .coin_r1_2_y(coin_r1_2_y_),
							 .coin_r1_3_x(coin_r1_3_x_),
							 .coin_r1_3_y(coin_r1_3_y_),
							 .coin_r1_4_x(coin_r1_4_x_),
							 .coin_r1_4_y(coin_r1_4_y_),
							 .coin_r1_5_x(coin_r1_5_x_),
							 .coin_r1_5_y(coin_r1_5_y_),
							 
							 .coin_r6_2_x(coin_r6_2_x_),
							 .coin_r6_2_y(coin_r6_2_y_),
							 .coin_r6_3_x(coin_r6_3_x_),
							 .coin_r6_3_y(coin_r6_3_y_),
							 .coin_r6_4_x(coin_r6_4_x_),
							 .coin_r6_4_y(coin_r6_4_y_),
							 .coin_r6_5_x(coin_r6_5_x_),
							 .coin_r6_5_y(coin_r6_5_y_),
							// .coin_r6_6_x(coin_r6_6_x_),
							 //.coin_r6_6_y(coin_r6_6_y_),
							 .coin_r6_1_x(coin_r6_1_x_),
							 .coin_r6_1_y(coin_r6_1_y_),
							 
							 .mush_r1_1_x(mush_r1_1_x_),
							 .mush_r1_1_y(mush_r1_1_y_),
							 .Ball_X_Pos(marioX),
							 .Ball_Y_Pos(marioY),
							 .Ball_Size_Y(marioSizeY),
							 .is_ball(isBall),
							 .is_ball_1(isBall_1),
							 .on_ground_hex,
							 .mario_address,
							 .on_ground(onGround),
							 .is_walking(isWalking),
							 .walk_num(walkNum),
							 .is_alive(isAlive),
							 .scoreCnt(score),
							 .roomNum(room_num)
							 );
							 
	 goomba_controller gc(
								.Clk(CLOCK_50),
								.Reset(Reset_h),
								.frame_clk(VGA_VS),
								.roomNum(room_num),
								.DrawX(draw_x),
								.DrawY(draw_y),
								.mario_x(marioX),
								.mario_y(marioY),
								.mario_size_y(marioSizeY),
								.is_alive_mario(isAlive),
								.is_goomba(isGoomba),
								.walk_num_goomba(walkNumGoomba),
								.is_alive_goomba(isAliveGoomba),
								.goomba_address,
								.goomba_r1_1_x(goomba_r1_1_x_),
								.goomba_r1_1_y(goomba_r1_1_y_),
								.goomba_r1_2_x(goomba_r1_2_x_),
								.goomba_r1_2_y(goomba_r1_2_y_),
								.goomba_r2_1_x(goomba_r2_1_x_),
								.goomba_r2_1_y(goomba_r2_1_y_),
								.goomba_r3_1_x(goomba_r3_1_x_),
								.goomba_r3_1_y(goomba_r3_1_y_),
								
								.goomba_r4_1_x(goomba_r4_1_x_),
								.goomba_r4_1_y(goomba_r4_1_y_),
								.goomba_r4_2_x(goomba_r4_2_x_),
								.goomba_r4_2_y(goomba_r4_2_y_),
								.goomba_r4_3_x(goomba_r4_3_x_),
								.goomba_r4_3_y(goomba_r4_3_y_),
								.goomba_r4_4_x(goomba_r4_4_x_),
								.goomba_r4_4_y(goomba_r4_4_y_),
								
								.goomba_r5_1_x(goomba_r5_1_x_),
								.goomba_r5_1_y(goomba_r5_1_y_),
								.goomba_r5_2_x(goomba_r5_2_x_),
								.goomba_r5_2_y(goomba_r5_2_y_),
								.goomba_r5_3_x(goomba_r5_3_x_),
								.goomba_r5_3_y(goomba_r5_3_y_)
					
);
							 
	 keycode_reader key_presses(
										.keycode(keycode),
										.w_on(w_on),
										.a_on(a_on),
										.d_on(d_on)
										);
							 
	 wall wall_instance(
								.DrawX(draw_x),
								.DrawY(draw_y),
								.RoomNum(room_num),
								.is_wall(isWall),
								.is_brick(isBrick),
								.wall_address
							 );

    
    Color_Mapper color_instance(
										 .is_logo(isLogo),
										 .is_giant(isGiant),
										 .logo_address,
										 .giant_address,
										 .is_alive(isAlive),
										 .is_alive_goomba(isAliveGoomba),
										 .is_ball(isBall),
										 .is_wall(isWall),
										 .is_brick(isBrick),
										 
										 .is_qblock(isQblock),
										 .blink_num(blinkNum),
										 .is_empty(isEmpty),
										 
										 //.is_q_block(isQ_block),
										 //.blink_num_q(blinkNum_q),
										 //.is_empty_q(isEmpty_q),
										 
										 .is_coin(isCoin),
										 .is_mush(isMush),
										 .spin_num(spinNum),
										 .is_goomba(isGoomba),
										 .is_fball(isFball),
										 .up_num(upNum),
										 
										 .is_fball_1(isFball_1),
										 .up_num_1(upNum_1),
										 
										 .is_fball_2(isFball_2),
										 .up_num_2(upNum_2),
										 
										 .is_fball_3(isFball_3),
										 .up_num_3(upNum_3),
										 
										 .is_fball_4(isFball_4),
										 .up_num_4(upNum_4),
										 .is_fball_5(isFball_5),
										 .up_num_5(upNum_5),
										 .is_fball_6(isFball_6),
										 .up_num_6(upNum_6),
										 .is_fball_7(isFball_7),
										 .up_num_7(upNum_7),
										 .is_fball_8(isFball_8),
										 .up_num_8(upNum_8),
										 
										 .on_ground(onGround),
										 .is_walking(isWalking),
										 .walk_num(walkNum),
										 .walk_num_goomba(walkNumGoomba),
										 .mario_address,
										 .goomba_address,
										 .wall_address,
										 .qblock_address,
										 //.q_block_address,
										 .coin_address,
										 .mush_address,
										 .fball_address,
										 .fball_address_1,
										 .fball_address_2,
										 .fball_address_3,
										 .fball_address_4,
										 .fball_address_5,
										 .fball_address_6,
										 .fball_address_7,
										 .fball_address_8,
										 .VGA_R(red),
										 .VGA_G(green),
										 .VGA_B(blue)
										 );
		
	 
	 fball fball_r3_1 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(2'd3),
							.startX(229),
							.startY(490),
							.Fball_x(490),
							.is_fball(isFball),
							.up_num(upNum), //if it's a 1 it's up, otherwise sprite should be drawn down
							.fball_address(fball_address),
							.Fball_X_Pos(fball_r3_1_x_),
							.Fball_Y_Pos(fball_r3_1_y_)
							);
							
	fball fball_r3_2 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(2'd3),
							.startX(519),
							.startY(280),
							.Fball_x(280),
							.is_fball(isFball_1),
							.up_num(upNum_1), //if it's a 1 it's up, otherwise sprite should be drawn down
							.fball_address(fball_address_1),
							.Fball_X_Pos(fball_r3_2_x_),
							.Fball_Y_Pos(fball_r3_2_y_)
							);
							
	fball fball_r2_1 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd2),
							.startX(360),
							.startY(490),
							.Fball_x(490),
							.is_fball(isFball_2),
							.up_num(upNum_2), //if it's a 1 it's up, otherwise sprite should be drawn down
							.fball_address(fball_address_2),
							.Fball_X_Pos(fball_r2_1_x_),
							.Fball_Y_Pos(fball_r2_1_y_)
							);
    fball fball_r2_2 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd2),
							.startX(460),
							.startY(490),
							.Fball_x(490),
							.is_fball(isFball_3),
							.up_num(upNum_3), //if it's a 1 it's up, otherwise sprite should be drawn down
							.fball_address(fball_address_3),
							.Fball_X_Pos(fball_r2_2_x_),
							.Fball_Y_Pos(fball_r2_2_y_)
							);
							
	 fball fball_r7_1 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd7),
							.startX(160),
							.startY(490),
							.Fball_x(490),
							.is_fball(isFball_4),
							.up_num(upNum_4), //if it's a 1 it's up, otherwise sprite should be drawn down
							.fball_address(fball_address_4),
							.Fball_X_Pos(fball_r7_1_x_),
							.Fball_Y_Pos(fball_r7_1_y_)
							);
							
		fball fball_r7_2 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd7),
							.startX(220),
							.startY(460),
							.Fball_x(460),
							.is_fball(isFball_5),
							.up_num(upNum_5), //if it's a 1 it's up, otherwise sprite should be drawn down
							.fball_address(fball_address_5),
							.Fball_X_Pos(fball_r7_2_x_),
							.Fball_Y_Pos(fball_r7_2_y_)
							);	
		fball fball_r7_3 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd7),
							.startX(300),
							.startY(420),
							.Fball_x(420),
							.is_fball(isFball_6),
							.up_num(upNum_6), //if it's a 1 it's up, otherwise sprite should be drawn down
							.fball_address(fball_address_6),
							.Fball_X_Pos(fball_r7_3_x_),
							.Fball_Y_Pos(fball_r7_3_y_)
							);	
		fball fball_r7_4 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd7),
							.startX(400),
							.startY(400),
							.Fball_x(400),
							.is_fball(isFball_7),
							.up_num(upNum_7), //if it's a 1 it's up, otherwise sprite should be drawn down
							.fball_address(fball_address_7),
							.Fball_X_Pos(fball_r7_4_x_),
							.Fball_Y_Pos(fball_r7_4_y_)
							);	
		fball fball_r7_5 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd7),
							.startX(480),
							.startY(490),
							.Fball_x(490),
							.is_fball(isFball_8),
							.up_num(upNum_8), //if it's a 1 it's up, otherwise sprite should be drawn down
							.fball_address(fball_address_8),
							.Fball_X_Pos(fball_r7_5_x_),
							.Fball_Y_Pos(fball_r7_5_y_)
							);			
	 qblock qblock_r1_1 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x), 
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd1),
							.posX(40),
							.posY(120),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_qblock(isQblock_r1_1), // *
							.blink_num(blinkNum_r1_1), // *
							.is_empty(isEmpty_r1_1), // *
							.qblock_address(qblock_address_r1_1) // *
					 );
					 /*
     q_block q_block_r1_1(
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x), 
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd7),
							.posX(100),
							.posY(240),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_q_block(isQ_block_r1_1), // *
							.blink_num(blinkNum_q_r1_1), // *
							.is_empty_q(is_Empty_q_r1_1), // *
							.q_block_address(q_block_address_r1_1) // *
					 );
					 */
	 coin coin_r1_1 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd1),
							.qblock_empty(isEmpty_r1_1),
							.startX(40),
							.startY(100),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r1_1), // *
							.spin_num(spinNum_r1_1), // *
							.Coin_X_Pos(coin_r1_1_x_),
							.Coin_Y_Pos(coin_r1_1_y_),
							.coin_address(coin_address_r1_1) // *
						 );
	/*	
	 qblock qblock_r1_2 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x), 
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd7),
							.posX(60),
							.posY(360),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_qblock(isQblock_r1_2), // *
							.blink_num(blinkNum_r1_2), // *
							.is_empty(isEmpty_r1_2), // *
							.qblock_address(qblock_address_r1_2) // *
					 );
					 */
					 /*
	q_block q_block_r1_2 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x), 
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd7),
							.posX(100),
							.posY(240),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_q_block(isQ_block_r1_2), // *
							.blink_num(blinkNum_q_r1_2), // *
							.is_empty_q(is_Empty_q_r1_2), // *
							.q_block_address(q_block_address_r1_2) // *
					 );
					 */
	 // mushroom code here
	 /*
	 mush mush_r1_1(
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd7),
							.qblock_empty(isEmpty_r1_2),
							.startX(60),
							.startY(360),
							.marioX(marioX),
							.marioY(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_mush(isMush),
							.Mush_X_Pos(mush_r1_1_x_),
							.Mush_Y_Pos(mush_r1_1_y_),
							.mush_address(mush_address)
						);
						 */
	 qblock qblock_r2_1 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x), 
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd2),
							.posX(60),
							.posY(180),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_qblock(isQblock_r2_1), // *
							.blink_num(blinkNum_r2_1), // *
							.is_empty(isEmpty_r2_1), // *
							.qblock_address(qblock_address_r2_1) // *
					 );
					 
	 coin coin_r2_1 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd2),
							.qblock_empty(isEmpty_r2_1),
							.startX(60),
							.startY(160),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r2_1), // *
							.spin_num(spinNum_r2_1), // *
							.Coin_X_Pos(coin_r2_1_x_),
							.Coin_Y_Pos(coin_r2_1_y_),
							.coin_address(coin_address_r2_1) // *
						 );
	coin coin_r2_2 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd2),
							.qblock_empty(1),
							.startX(160),
							.startY(240),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r2_2), // *
							.spin_num(spinNum_r2_2), // *
							.Coin_X_Pos(coin_r2_2_x_),
							.Coin_Y_Pos(coin_r2_2_y_),
							.coin_address(coin_address_r2_2) // *
						 );
	coin coin_r2_3 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd2),
							.qblock_empty(1),
							.startX(140),
							.startY(240),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r2_3), // *
							.spin_num(spinNum_r2_3), // *
							.Coin_X_Pos(coin_r2_3_x_),
							.Coin_Y_Pos(coin_r2_3_y_),
							.coin_address(coin_address_r2_3) // *
						 );
	coin coin_r2_4 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd2),
							.qblock_empty(1),
							.startX(180),
							.startY(240),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r2_4), // *
							.spin_num(spinNum_r4_2), // *
							.Coin_X_Pos(coin_r2_4_x_),
							.Coin_Y_Pos(coin_r2_4_y_),
							.coin_address(coin_address_r2_4) // *
						 );
	coin coin_r1_2 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd1),
							.qblock_empty(1),
							.startX(100),
							.startY(240),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r1_2), // *
							.spin_num(spinNum_r1_2), // *
							.Coin_X_Pos(coin_r1_2_x_),
							.Coin_Y_Pos(coin_r1_2_y_),
							.coin_address(coin_address_r1_2) // *
						 );
	coin coin_r1_3 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd1),
							.qblock_empty(1),
							.startX(140),
							.startY(240),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r1_3), // *
							.spin_num(spinNum_r1_3), // *
							.Coin_X_Pos(coin_r1_3_x_),
							.Coin_Y_Pos(coin_r1_3_y_),
							.coin_address(coin_address_r1_3) // *
						 );
	coin coin_r1_4 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd1),
							.qblock_empty(1),
							.startX(200),
							.startY(200),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r1_4), // *
							.spin_num(spinNum_r1_4), // *
							.Coin_X_Pos(coin_r1_4_x_),
							.Coin_Y_Pos(coin_r1_4_y_),
							.coin_address(coin_address_r1_4) // *
						 );
  coin coin_r1_5 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd1),
							.qblock_empty(1),
							.startX(240),
							.startY(200),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r1_5), // *
							.spin_num(spinNum_r1_5), // *
							.Coin_X_Pos(coin_r1_5_x_),
							.Coin_Y_Pos(coin_r1_5_y_),
							.coin_address(coin_address_r1_5) // *
						 );
	coin coin_r6_1 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd6),
							.qblock_empty(1),
							.startX(260),
							.startY(140),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r6_1), // *
							.spin_num(spinNum_r6_1), // *
							.Coin_X_Pos(coin_r6_1_x_),
							.Coin_Y_Pos(coin_r6_1_y_),
							.coin_address(coin_address_r6_1) // *
						 );
		coin coin_r6_2 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd6),
							.qblock_empty(1),
							.startX(280),
							.startY(180),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r6_2), // *
							.spin_num(spinNum_r6_2), // *
							.Coin_X_Pos(coin_r6_2_x_),
							.Coin_Y_Pos(coin_r6_2_y_),
							.coin_address(coin_address_r6_2) // *
						 );
		coin coin_r6_3 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd6),
							.qblock_empty(1),
							.startX(260),
							.startY(220),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r6_3), // *
							.spin_num(spinNum_r6_3), // *
							.Coin_X_Pos(coin_r6_3_x_),
							.Coin_Y_Pos(coin_r6_3_y_),
							.coin_address(coin_address_r6_3) // *
						 );
		coin coin_r6_4 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd6),
							.qblock_empty(1),
							.startX(280),
							.startY(240),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r6_4), // *
							.spin_num(spinNum_r6_4), // *
							.Coin_X_Pos(coin_r6_4_x_),
							.Coin_Y_Pos(coin_r6_4_y_),
							.coin_address(coin_address_r6_4) // *
						 );
		coin coin_r6_5 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd6),
							.qblock_empty(1),
							.startX(520),
							.startY(160),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r6_5), // *
							.spin_num(spinNum_r6_5), // *
							.Coin_X_Pos(coin_r6_5_x_),
							.Coin_Y_Pos(coin_r6_5_y_),
							.coin_address(coin_address_r6_5) // *
						 );
						/* 
				coin coin_r6_6 (
							.Clk(CLOCK_60),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(3'd6),
							.qblock_empty(1),
							.startX(100),
							.startY(300),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_coin(isCoin_r6_6), // *
							.spin_num(spinNum_r6_6), // *
							.Coin_X_Pos(coin_r6_6_x_),
							.Coin_Y_Pos(coin_r6_6_y_),
							.coin_address(coin_address_r6_6) // *
						 );
				*/		 
	 always_comb // - for qblocks and coins sprite drawing - gotta pick which signals are going into color mapper
	 begin
			// Qblock
			if (isQblock_r1_1)
			begin
				isQblock = isQblock_r1_1;
				blinkNum = blinkNum_r1_1;
				isEmpty = isEmpty_r1_1;
				qblock_address = qblock_address_r1_1;
			end
			else if (isQblock_r1_2)
			begin
				isQblock = isQblock_r1_2;
				blinkNum = blinkNum_r1_2;
				isEmpty = isEmpty_r1_2;
				qblock_address = qblock_address_r1_2;
			end
			else if (isQblock_r2_1)
			begin
				isQblock = isQblock_r2_1;
				blinkNum = blinkNum_r2_1;
				isEmpty = isEmpty_r2_1;
				qblock_address = qblock_address_r2_1;
			end
			else // don't care
			begin
				isQblock = 1'b0;
				blinkNum = 1'b0;
				isEmpty = 1'b0;
				qblock_address = 8'd0;
			end
			
			// Coin
			if (isCoin_r1_1)
			begin
				isCoin = isCoin_r1_1;
				spinNum = spinNum_r1_1;
				coin_address = coin_address_r1_1;
			end
			else if (isCoin_r2_1)
			begin
				isCoin = isCoin_r2_1;
				spinNum = spinNum_r2_1;
				coin_address = coin_address_r2_1;
			end
			else if (isCoin_r2_2)
			begin
				isCoin = isCoin_r2_2;
				spinNum = spinNum_r2_2;
				coin_address = coin_address_r2_2;
			end
			else if (isCoin_r2_3)
			begin
				isCoin = isCoin_r2_3;
				spinNum = spinNum_r2_3;
				coin_address = coin_address_r2_3;
			end
			else if (isCoin_r2_4)
			begin
				isCoin = isCoin_r2_4;
				spinNum = spinNum_r2_4;
				coin_address = coin_address_r2_4;
			end
			else if (isCoin_r1_2)
			begin
				isCoin = isCoin_r1_2;
				spinNum = spinNum_r1_2;
				coin_address = coin_address_r1_2;
			end
			else if (isCoin_r1_3)
			begin
				isCoin = isCoin_r1_3;
				spinNum = spinNum_r1_3;
				coin_address = coin_address_r1_3;
			end
			else if (isCoin_r1_4)
			begin
				isCoin = isCoin_r1_4;
				spinNum = spinNum_r1_4;
				coin_address = coin_address_r1_4;
			end
			else if (isCoin_r1_5)
			begin
				isCoin = isCoin_r1_5;
				spinNum = spinNum_r1_5;
				coin_address = coin_address_r1_5;
			end
			else if (isCoin_r6_1)
			begin
				isCoin = isCoin_r6_1;
				spinNum = spinNum_r6_1;
				coin_address = coin_address_r6_1;
			end
			else if (isCoin_r6_2)
			begin
				isCoin = isCoin_r6_2;
				spinNum = spinNum_r6_2;
				coin_address = coin_address_r6_2;
			end
			else if (isCoin_r6_3)
			begin
				isCoin = isCoin_r6_3;
				spinNum = spinNum_r6_3;
				coin_address = coin_address_r6_3;
			end
			else if (isCoin_r6_4)
			begin
				isCoin = isCoin_r6_4;
				spinNum = spinNum_r6_4;
				coin_address = coin_address_r6_4;
			end
			else if (isCoin_r6_5)
			begin
				isCoin = isCoin_r6_5;
				spinNum = spinNum_r6_5;
				coin_address = coin_address_r6_5;
			end
			/*else if (isCoin_r6_6)
			begin
				isCoin = isCoin_r6_6;
				spinNum = spinNum_r6_6;
				coin_address = coin_address_r6_6;
			end
			*/
			else // don't care
			begin
				isCoin = 1'b0;
				spinNum = 2'd0;
				coin_address = 8'd0;
			end
	 end
	 /*
	 always_comb // - for qblocks and coins sprite drawing - gotta pick which signals are going into color mapper
	 begin
			// Qblock
			if (isQ_block_r1_1)
			begin
				isQ_block = isQ_block_r1_1;
				blinkNum_q = blinkNum_q_r1_1;
				isEmpty_q = isEmpty_q_r1_1;
				q_block_address = q_block_address_r1_1;
			end
			else if (isQ_block_r1_2)
			begin
				isQ_block = isQ_block_r1_2;
				blinkNum_q = blinkNum_q_r1_2;
				isEmpty_q = isEmpty_q_r1_2;
				q_block_address = q_block_address_r1_2;
			end
			else if (isQ_block_r2_1)
			begin
				isQ_block = isQ_block_r2_1;
				blinkNum_q = blinkNum_q_r2_1;
				isEmpty_q = isEmpty_q_r2_1;
				q_block_address = q_block_address_r2_1;
			end
			else // don't care
			begin
				isQ_block = 1'b0;
				blinkNum_q = 1'b0;
				isEmpty_q = 1'b0;
				q_block_address = 8'd0;
			end
			
			/*
			// Coin
			if (isCoin_r1_1)
			begin
				isCoin = isCoin_r1_1;
				spinNum = spinNum_r1_1;
				coin_address = coin_address_r1_1;
			end
			else if (isCoin_r2_1)
			begin
				isCoin = isCoin_r2_1;
				spinNum = spinNum_r2_1;
				coin_address = coin_address_r2_1;
			end
			else // don't care
			begin
				isCoin = 1'b0;
				spinNum = 2'd0;
				coin_address = 8'd0;
			end
			
	 end
	 */
	 logo title_logo  (
							.DrawX(draw_x),
							.DrawY(draw_y),
							.RoomNum(room_num),
							.is_logo(isLogo),
							.logo_address(logo_address)
							);
							
	 modu_giant title_start(
		.DrawX(draw_x),
		.DrawY(draw_y),
		.RoomNum(room_num),
		.is_giant(isGiant),
		.giant_address(giant_address)
		);
		/*
			index tem(
			.DrawX(draw_x),
			.DrawY(draw_y),
			.RoomNum(room_num),
			.is_index(isIndex),
			.index_address			
	 );		
		*/
		
    // Display keycode on hex display
    HexDriver hex_inst_0 ({2'b00, isAlive[1:0]}, HEX0);
    HexDriver hex_inst_1 (marioSizeY[3:0], HEX1);
	 HexDriver hex_inst_2 (marioSizeY[7:4], HEX2);
	 HexDriver hex_inst_5 (score[3:0], HEX3);
	 HexDriver hex_inst_6 (score[7:4], HEX4);
	 HexDriver hex_inst_7 ({2'b00, score[9:8]}, HEX5);
	 
endmodule
