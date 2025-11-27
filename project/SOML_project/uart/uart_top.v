module uart_top (
    input  wire        CLOCK_50,
    input  wire        sw_0,        
    input  wire        GPIO_RX,
    output wire        GPIO_TX,

    output reg [31:0]  o_data_32bit,
    output reg         o_valid,

    input  wire [11:0] message,        
    input  wire        message_ready   
);

    // =================================================================
    // 1. THAM SỐ & KẾT NỐI UART CƠ BẢN
    // =================================================================
    localparam CLK_FREQ = 50000000;
    localparam BAUD_RATE = 9600; 

    wire        rx_data_ready;
    wire [7:0]  rx_data;
    wire        reset_n = sw_0; 

    // --- UART RX ---
    async_receiver #( .ClkFrequency(CLK_FREQ), .Baud(BAUD_RATE) ) 
    rx_inst (
        .clk(CLOCK_50), 
        .RxD(GPIO_RX), 
        .RxD_data_ready(rx_data_ready), 
        .RxD_data(rx_data),
        .RxD_idle(), .RxD_endofpacket()
    );

    // --- UART TX ---
    reg        tx_start;
    reg [7:0]  tx_data;
    wire       tx_busy;

    async_transmitter #( .ClkFrequency(CLK_FREQ), .Baud(BAUD_RATE) ) 
    tx_inst (
        .clk(CLOCK_50), 
        .TxD_start(tx_start), 
        .TxD_data(tx_data), 
        .TxD(GPIO_TX), 
        .TxD_busy(tx_busy)
    );

    // =================================================================
    // 2. RX FSM: GHÉP 4 BYTES -> 32 BIT
    // =================================================================
    reg [1:0] byte_cnt;
    reg [31:0] tmp_data;

    always @(posedge CLOCK_50) begin
        
        o_valid <= 1'b0; 
        
        if (!reset_n) begin
            byte_cnt <= 0;
            tmp_data <= 0;
        end else if (rx_data_ready) begin
           
            case (byte_cnt)
                2'd0: tmp_data[7:0]   <= rx_data;
                2'd1: tmp_data[15:8]  <= rx_data;
                2'd2: tmp_data[23:16] <= rx_data;
                2'd3: begin
                    tmp_data[31:24] <= rx_data;
                    o_data_32bit <= {rx_data, tmp_data[23:16], tmp_data[15:8], tmp_data[7:0]};
                    o_valid <= 1'b1; 
                    byte_cnt <= 0;   
                end
            endcase
            
            if (byte_cnt != 3) byte_cnt <= byte_cnt + 1;
        end
    end

    // =================================================================
    // 3. TX FSM: GỬI KẾT QUẢ 12-BIT VỀ MÁY TÍNH
    // =================================================================
    localparam TX_IDLE    = 3'd0;
    localparam TX_SEND_HI = 3'd1;
    localparam TX_WAIT_HI = 3'd2;
    localparam TX_SEND_LO = 3'd3;
    localparam TX_WAIT_LO = 3'd4;
    
    reg [2:0] tx_state;
    reg [11:0] saved_msg;

    always @(posedge CLOCK_50) begin
        if (!reset_n) begin
            tx_state <= TX_IDLE;
            tx_start <= 0;
            tx_data  <= 0;
        end else begin
            case (tx_state)
                TX_IDLE: begin
                    tx_start <= 0;                   
                    if (message_ready && !tx_busy) begin
                        saved_msg <= message;
                        tx_state <= TX_SEND_HI;
                    end
                end
               
                TX_SEND_HI: begin
                    tx_data  <= {4'b0000, saved_msg[11:8]};
                    tx_start <= 1;
                    tx_state <= TX_WAIT_HI;
                end
                
                TX_WAIT_HI: begin
                    tx_start <= 0;                   
                    if (!tx_busy && !tx_start) tx_state <= TX_SEND_LO; 
                end
               
                TX_SEND_LO: begin
                    tx_data  <= saved_msg[7:0];
                    tx_start <= 1;
                    tx_state <= TX_WAIT_LO;
                end
              
                TX_WAIT_LO: begin
                    tx_start <= 0;
                    if (!tx_busy && !tx_start) tx_state <= TX_IDLE;
                end
            endcase
        end
    end
endmodule
