

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
	logic Reset_h,Run_h, Clk, isBall, isWall, isBrick, onGround, isWalking, isGoomba, isAliveGoomba, isQblock, isCoin, isLogo, isMush, isFball;
	logic isQblock_r1_1, isQblock_r1_2, isQblock_r2_1;
	logic isCoin_r1_1, isCoin_r2_1;
	logic [1:0] walkNum;
	logic upNum;
	logic walkNumGoomba;
   logic [7:0] keycode;
	logic w_on, a_on, d_on;
	
	logic [9:0] score;
	logic blinkNum, blinkNum_r1_1, blinkNum_r1_2, blinkNum_r2_1;
	logic [1:0] spinNum, spinNum_r1_1, spinNum_r2_1;
	logic isEmpty, isEmpty_r1_1, isEmpty_r1_2, isEmpty_r2_1;
	 
	// coordinates for collisions
	logic [9:0] marioX, marioY, marioSizeY;
	// goombas
	logic [9:0] goomba_r1_1_x_, goomba_r1_1_y_;
	logic [9:0] goomba_r1_2_x_, goomba_r1_2_y_;
	logic [9:0] goomba_r2_1_x_, goomba_r2_1_y_;
	logic [9:0] goomba_r3_1_x_, goomba_r3_1_y_;
		
	// coins
	logic [9:0] coin_r1_1_x_, coin_r1_1_y_;
	logic [9:0] coin_r2_1_x_, coin_r2_1_y_;
	 
	// mushrooms
	logic [9:0] mush_r1_1_x_, mush_r1_1_y_;
		
	// fireballs
	logic [9:0] fball_r3_1_x_, fball_r3_1_y_;
	
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
    logic [1:0] room_num;
	 
	 logic [15:0] logo_address;
	 
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 
	 
	 logic [8:0] wall_address;
	 logic [9:0] mario_address;
	 logic [8:0] goomba_address;
	 logic [8:0] qblock_address, qblock_address_r1_1, qblock_address_r1_2, qblock_address_r2_1;
	 logic [8:0] coin_address, coin_address_r1_1, coin_address_r2_1;
	 logic [8:0] mush_address;
	 logic [8:0] fball_address;
	
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
		         .sw_0(Reset_h)    , // Resett.
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
							 .fball_r3_1_x(fball_r3_1_x_),
							 .fball_r3_1_y(fball_r3_1_y_),
							 .coin_r1_1_x(coin_r1_1_x_),
							 .coin_r1_1_y(coin_r1_1_y_),
							 .coin_r2_1_x(coin_r2_1_x_),
							 .coin_r2_1_y(coin_r2_1_y_),
							 .mush_r1_1_x(mush_r1_1_x_),
							 .mush_r1_1_y(mush_r1_1_y_),
							 .Ball_X_Pos(marioX),
							 .Ball_Y_Pos(marioY),
							 .Ball_Size_Y(marioSizeY),
							 .is_ball(isBall),
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
								.goomba_r3_1_y(goomba_r3_1_y_)
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
										 .logo_address,
										 .is_alive(isAlive),
										 .is_alive_goomba(isAliveGoomba),
										 .is_ball(isBall),
										 .is_wall(isWall),
										 .is_brick(isBrick),
										 .is_qblock(isQblock),
										 .blink_num(blinkNum),
										 .is_empty(isEmpty),
										 .is_coin(isCoin),
										 .is_mush(isMush),
										 .spin_num(spinNum),
										 .is_goomba(isGoomba),
										 .is_fball(isFball),
										 .up_num(upNum),
										 .on_ground(onGround),
										 .is_walking(isWalking),
										 .walk_num(walkNum),
										 .walk_num_goomba(walkNumGoomba),
										 .mario_address,
										 .goomba_address,
										 .wall_address,
										 .qblock_address,
										 .coin_address,
										 .mush_address,
										 .fball_address,
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
							.startX(239),
							.startY(490),
							.is_fball(isFball),
							.up_num(upNum), //if it's a 1 it's up, otherwise sprite should be drawn down
							.fball_address(fball_address),
							.Fball_X_Pos(fball_r3_1_x_),
							.Fball_Y_Pos(fball_r3_1_y_)
							);
    
	 qblock qblock_r1_1 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x), 
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(2'd1),
							.posX(100),
							.posY(360),
							.mario_x(marioX),
							.mario_y(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_qblock(isQblock_r1_1), // *
							.blink_num(blinkNum_r1_1), // *
							.is_empty(isEmpty_r1_1), // *
							.qblock_address(qblock_address_r1_1) // *
					 );

	 coin coin_r1_1 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(2'd1),
							.qblock_empty(isEmpty_r1_1),
							.startX(100),
							.startY(340),
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
	 qblock qblock_r1_2 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x), 
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(2'd1),
							.posX(120),
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
					 
	 // mushroom code here
	 mush mush_r1_1(
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x),
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(2'd1),
							.qblock_empty(isEmpty_r1_2),
							.startX(130),
							.startY(347),
							.marioX(marioX),
							.marioY(marioY),
							.mario_size_y(marioSizeY),
							.is_alive_mario(isAlive),
							.is_mush(isMush),
							.Mush_X_Pos(mush_r1_1_x_),
							.Mush_Y_Pos(mush_r1_1_y_),
							.mush_address(mush_address)
						);
						 
	 qblock qblock_r2_1 (
							.Clk(CLOCK_50),
							.Reset(Reset_h),
							.frame_clk(VGA_VS),
							.DrawX(draw_x), 
							.DrawY(draw_y),
							.roomNum(room_num),
							.myRoomNum(2'd2),
							.posX(120),
							.posY(360),
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
							.myRoomNum(2'd2),
							.qblock_empty(isEmpty_r2_1),
							.startX(120),
							.startY(340),
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
			else // don't care
			begin
				isCoin = 1'b0;
				spinNum = 2'd0;
				coin_address = 8'd0;
			end
	 end
	 logo title_logo  (
							.DrawX(draw_x),
							.DrawY(draw_y),
							.RoomNum(0),
							.is_logo(isLogo),
							.logo_address(logo_address)
							);
	 
    // Display keycode on hex display
    HexDriver hex_inst_0 ({2'b00, isAlive[1:0]}, HEX0);
    HexDriver hex_inst_1 (marioSizeY[3:0], HEX1);
	 HexDriver hex_inst_2 (marioSizeY[7:4], HEX2);
	 HexDriver hex_inst_5 (score[3:0], HEX3);
	 HexDriver hex_inst_6 (score[7:4], HEX4);
	 HexDriver hex_inst_7 ({2'b00, score[9:8]}, HEX5);
	 
endmodule
