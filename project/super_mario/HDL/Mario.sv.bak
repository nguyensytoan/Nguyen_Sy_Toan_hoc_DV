//-------------------------------------------------------------------------
//      lab8.sv                                                          --
//      Christine Chen                                                   --
//      Fall 2014                                                        --
//                                                                       --
//      Modified by Po-Han Huang                                         --
//      10/06/2017                                                       --
//                                                                       --
//      Fall 2017 Distribution                                           --
//                                                                       --
//      For use with ECE 385 Lab 8                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module Mario( input               CLOCK_50,
             input        [3:0]  KEY,          //bit 0 is set up as Reset
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
						  ///////// SDRAM /////////
				output             DRAM_CLK,
				output             DRAM_CKE,
				output   [12: 0]   DRAM_ADDR,
				output   [ 1: 0]   DRAM_BA,
				inout    [15: 0]   DRAM_DQ,
				output             DRAM_LDQM,
				output             DRAM_UDQM,
				output             DRAM_CS_N,
				output             DRAM_WE_N,
				output             DRAM_CAS_N,
				output             DRAM_RAS_N,

				/////////KEYBOARD//////
				output logic [3:0] kpc, // column select, active-low
				input logic [3:0] kpr, // rows, active-low w/ pull-ups
				output logic [3:0] ct, // " digit enables
				output logic TX,
				output logic [9:0] num,
				 
				 // LEDs for debugging
				 output logic [17:0] LEDR,
				 //output logic [7:0]  LEDG,
				 ///////// ARDUINO /////////
					inout    [15: 0]   ARDUINO_IO,
					inout              ARDUINO_RESET_N 
                    );
						  
	 //##########################################################
	 //logic Reset_h, blank, sync, VGA_Clk, ischaracter1, ischaracter2, isbarrier, isBrick, is_mario_on_ground, is_luigi_on_ground, is_mario_walking, is_luigi_walking, is_enemy, isPipe, is_question_room1, is_question_room3, empty_question_room1, empty_question_room3, is_question, is_question_empty, is_redupgrade, is_greenupgrade;
	//logic is_game_over, is_logo;
	//logic w_key, a_key, d_key, up_arrow, left_arrow, right_arrow;
	//logic [1:0] mario_health, luigi_health, enemy_health, piranha_health;
	//logic [1:0] mario_walk_count, luigi_walk_count;
	//logic enemy_walk_count;
	//logic [2:0] Level_Mux_Out;
	//logic [2:0] level_num, mario_level_num, luigi_level_num;
	//logic mario_transition, luigi_transition;

//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;

//=======================================================
//  Structural coding
//=======================================================
	assign ARDUINO_IO[10] = SPI0_CS_N;
	assign ARDUINO_IO[13] = SPI0_SCLK;
	assign ARDUINO_IO[11] = SPI0_MOSI;
	assign ARDUINO_IO[12] = 1'bZ;
	assign SPI0_MISO = ARDUINO_IO[12];
	
	assign ARDUINO_IO[9] = 1'bZ; 
	assign USB_IRQ = ARDUINO_IO[9];
		
	//Assignments specific to Circuits At Home UHS_20
	assign ARDUINO_RESET_N = USB_RST;
	assign ARDUINO_IO[7] = USB_RST;//USB reset 
	assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	//Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	assign ARDUINO_IO[6] = 1'b1;
	
	//Assign one button to reset
	assign {Run_h}=~ (KEY[1]);


//======================================================================================================================

//	 // these are the coordinates of characters so that we know when we run into them
//	logic [9:0] mario_x, mario_y, mario_Size_Y;
//	logic [9:0] luigi_x, luigi_y, luigi_Size_Y;
//	logic [9:0] enemy_x, enemy_y, piranha_x, piranha_y, redupgrade_x, redupgrade_y, greenupgrade_x, greenupgrade_y;
//	
//	// life counters for mario and luigi - they each start out with two lives and die at zero
//	logic [1:0] mario_life_counter1, luigi_life_counter1;
//
//	// these are for the color_mapper - so that we can map out the element's pixels onto the screen
//	logic [9:0] mario_address;
//	logic [9:0] luigi_address;
//	logic [8:0] enemy_address;
//	logic [10:0] piranha_address;
//	logic [19:0] game_over_address;
//	logic [17:0] logo_address;
//	logic [10:0] barrier_address;
//	logic [8:0] upgrade_address;
//	logic [8:0] question_room1_address;
//	logic [8:0] question_room3_address;
//	logic [8:0] question_address;
	 //#################################################
	 
	 
	 // assign statements for audio shits
	 assign SRAM_UB_N = 1'b0;
	 assign SRAM_LB_N = 1'b0;
	 assign SRAM_CE_N = 1'b0;
	 assign SRAM_OE_N = 1'b0;
	 assign SRAM_WE_N = 1'b1;
	 
    logic [1:0] isAlive;
	 logic Reset_h, Clk, isBall, isWall, isBrick, onGround, isWalking, isGoomba, isAliveGoomba, isQblock, isCoin, isLogo, isMush, isFball;
	 logic isQblock_r1_1, isQblock_r1_2, isQblock_r2_1;
	 logic isCoin_r1_1, isCoin_r2_1;
	 logic [1:0] walkNum;
	 logic upNum;
	 logic walkNumGoomba;
   // logic [31:0] keycode;
	 logic w_on, a_on, d_on;
	 logic [9:0] draw_x, draw_y;
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
    
    assign Clk = CLOCK_50;
    always_ff @ (posedge Clk) begin
        Reset_h <= ~(KEY[0]);        // The push buttons are active low
    end
    
    logic [1:0] hpi_addr;
    logic [15:0] hpi_data_in, hpi_data_out;
    logic hpi_r, hpi_w, hpi_cs, hpi_reset;
	 
	 logic [1:0] room_num;
	 
	 logic [15:0] logo_address;
	 logic [8:0] wall_address;
	 logic [9:0] mario_address;
	 logic [8:0] goomba_address;
	 logic [8:0] qblock_address, qblock_address_r1_1, qblock_address_r1_2, qblock_address_r2_1;
	 logic [8:0] coin_address, coin_address_r1_1, coin_address_r2_1;
	 logic [8:0] mush_address;
	 logic [8:0] fball_address;
	
    
    // Interface between NIOS II and EZ-OTG chip
    /*hpi_io_intf hpi_io_inst(
                            .Clk(Clk),
                            .Reset(Reset_h),
                            // signals connected to NIOS II
                            .from_sw_address(hpi_addr),
                            .from_sw_data_in(hpi_data_in),
                            .from_sw_data_out(hpi_data_out),
                            .from_sw_r(hpi_r),
                            .from_sw_w(hpi_w),
                            .from_sw_cs(hpi_cs),
                            .from_sw_reset(hpi_reset),
                            // signals connected to EZ-OTG chip
                            .OTG_DATA(OTG_DATA),    
                            .OTG_ADDR(OTG_ADDR),    
                            .OTG_RD_N(OTG_RD_N),    
                            .OTG_WR_N(OTG_WR_N),    
                            .OTG_CS_N(OTG_CS_N),
                            .OTG_RST_N(OTG_RST_N)
    );
     
     // You need to make sure that the port names here match the ports in Qsys-generated codes.
     lab8_soc nios_system(
                             .clk_clk(Clk),         
                             .reset_reset_n(1'b1),    // Never reset NIOS
                             .sdram_wire_addr(DRAM_ADDR), 
                             .sdram_wire_ba(DRAM_BA),   
                             .sdram_wire_cas_n(DRAM_CAS_N),
                             .sdram_wire_cke(DRAM_CKE),  
                             .sdram_wire_cs_n(DRAM_CS_N), 
                             .sdram_wire_dq(DRAM_DQ),   
                             .sdram_wire_dqm(DRAM_DQM),  
                             .sdram_wire_ras_n(DRAM_RAS_N),
                             .sdram_wire_we_n(DRAM_WE_N), 
                             .sdram_clk_clk(DRAM_CLK),
                             .keycode_export(keycode),  
                             .otg_hpi_address_export(hpi_addr),
                             .otg_hpi_data_in_port(hpi_data_in),
                             .otg_hpi_data_out_port(hpi_data_out),
                             .otg_hpi_cs_export(hpi_cs),
                             .otg_hpi_r_export(hpi_r),
                             .otg_hpi_w_export(hpi_w),
                             .otg_hpi_reset_export(hpi_reset)
    );
	 */
	 
	 lab62soc u0 (
		.clk_clk                           (Clk),  //clk.clk
		.reset_reset_n                     (1'b1),           //reset.reset_n
		.altpll_0_locked_conduit_export    (),               //altpll_0_locked_conduit.export
		.altpll_0_phasedone_conduit_export (),               //altpll_0_phasedone_conduit.export
		.altpll_0_areset_conduit_export    (),               //altpll_0_areset_conduit.export
		.key_external_connection_export    (KEY),            //key_external_connection.export

		//SDRAM
		.sdram_clk_clk(DRAM_CLK),                            //clk_sdram.clk
		.sdram_wire_addr(DRAM_ADDR),                         //sdram_wire.addr
		.sdram_wire_ba(DRAM_BA),                             //.ba
		.sdram_wire_cas_n(DRAM_CAS_N),                       //.cas_n
		.sdram_wire_cke(DRAM_CKE),                           //.cke
		.sdram_wire_cs_n(DRAM_CS_N),                         //.cs_n
		.sdram_wire_dq(DRAM_DQ),                             //.dq
		.sdram_wire_dqm({DRAM_UDQM,DRAM_LDQM}),              //.dqm
		.sdram_wire_ras_n(DRAM_RAS_N),                       //.ras_n
		.sdram_wire_we_n(DRAM_WE_N),                         //.we_n

		//USB SPI	
		.spi0_SS_n(SPI0_CS_N),
		.spi0_MOSI(SPI0_MOSI),
		.spi0_MISO(SPI0_MISO),
		.spi0_SCLK(SPI0_SCLK),
		
		//USB GPIO
		.usb_rst_export(USB_RST),
		.usb_irq_export(USB_IRQ),
		.usb_gpx_export(USB_GPX),
		
		//LEDs and HEX
		.hex_digits_export({hex_num_4, hex_num_3, hex_num_1, hex_num_0}),
		.leds_export({hundreds, signs, LEDR}),
		.keycode_export(keycode)
		
	 );
	 
	 //keycode
//	 KeypadTess keypad0 (
//		.CLOCK_50(MAX10_CLK1_50), // rows, active-low w/ pull-ups
//		.reset_n(Reset_h),
//		.kpr(kpr),
//		.kpc(kpc),
//		.ct(ct),
//		.TX(TX),
//		.num(keycode)
//		
//	 );
	 
    
    // Use PLL to generate the 25MHZ VGA_CLK.
    // You will have to generate it on your own in simulation.
    //vga_clk vga_clk_instance(.inclk0(Clk), .c0(VGA_CLK));
    
    // TODO: Fill in the connections for the rest of the modules 
    VGA_controller vga_controller_instance(
														.Clk(CLOCK_50),
														.Reset(Reset_h),
														.VGA_HS(VGA_HS),
														.VGA_VS(VGA_VS),
														.VGA_CLK(VGA_CLK),
														.VGA_BLANK_N(VGA_BLANK_N),
														.VGA_SYNC_N(VGA_SYNC_N),
														.DrawX(draw_x),
														.DrawY(draw_y)
														);
    
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
								.goomba_r3_1_y(goomba_r3_1_y_),
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
										 .DrawX(draw_x),
										 .DrawY(draw_y),
										 .VGA_R(VGA_R),
										 .VGA_G(VGA_G),
										 .VGA_B(VGA_B)
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
							.RoomNum(room_num),
							.is_logo(isLogo),
							.logo_address
							);
	 
    // Display keycode on hex display
    HexDriver hex_inst_0 ({2'b00, isAlive[1:0]}, HEX0);
    HexDriver hex_inst_1 (marioSizeY[3:0], HEX1);
	 HexDriver hex_inst_2 (marioSizeY[7:4], HEX2);
	 HexDriver hex_inst_3 ({2'b00, marioSizeY[9:8]}, HEX3);
	 //HexDriver hex_inst_4 ({2'b00, Clk_counter_out[9:8]}, HEX4);
	// HexDriver hex_inst_5 (score[3:0], HEX5);
	 //HexDriver hex_inst_6 (score[7:4], HEX6);
	 //HexDriver hex_inst_7 ({2'b00, score[9:8]}, HEX7);
	 
endmodule
