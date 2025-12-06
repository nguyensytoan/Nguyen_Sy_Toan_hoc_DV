module system_top (
    input  wire       CLOCK_50,
    input  wire       sw_0,      // Switch Reset (Gạt lên = Chạy, Xuống = Reset)
    
    // UART External Pins
    input  wire       GPIO_RX,
    output wire       GPIO_TX,

    // LED hiển thị trạng thái
    output wire [9:0] LEDR
);

    // Xử lý tín hiệu Reset: Nếu sw_0 = 1 (Chạy) -> rst = 0. Nếu sw_0 = 0 -> rst = 1.
    // Dựa vào logic trong code soml_decoder (input rst active high)
    wire sys_rst;
    assign sys_rst = sw_0; 

    // --- Dây nối giữa UART và Decoder ---
    // Data H
    wire [31:0] w_H_in_r;
    wire [31:0] w_H_in_i;
    wire        w_H_in_valid;

    // Data Y
    wire [31:0] w_Y_in_r;
    wire [31:0] w_Y_in_i;
    wire        w_Y_in_valid;

    // Control & Result
    wire        w_start_decoder;
    wire        w_decoder_done;
    wire [11:0] w_signal_out_12bit;
    
    // Unused outputs of decoder (nếu không cần dùng thì để open)
    wire signed [31:0] s_I_1, s_Q_1, s_I_2, s_Q_2;
    wire [4:0] Smin_index;

    // =========================================================
    // 1. INSTANCE UART CONTROLLER
    // =========================================================
    uart_top uart_inst (
        .CLOCK_50(CLOCK_50),
        .sw_0(sys_rst),
        
        .GPIO_RX(GPIO_RX),
        .GPIO_TX(GPIO_TX),
        .LEDR(LEDR),

        // Outputs to Decoder
        .H_re_out(w_H_in_r),
        .H_im_out(w_H_in_i),
        .H_out(w_H_in_valid),
        
        .Y_re_out(w_Y_in_r),
        .Y_im_out(w_Y_in_i),
        .Y_out(w_Y_in_valid),

        .start(w_start_decoder),

         //Inputs from Decoder
        .start_12bit(w_decoder_done),
        .val_12bit_to_send(w_signal_out_12bit)
    );

    // =========================================================
    // 2. INSTANCE SOML DECODER (CORE TÍNH TOÁN)
    // =========================================================
    soml_decoder_top #(
        .Q(22),
        .N(32)
    ) decoder_inst (
        .clk(CLOCK_50),
        .rst(sys_rst),
        .start(w_start_decoder), // Tín hiệu Start từ UART

        // Nạp H
        .H_in_valid(w_H_in_valid),
        .H_in_r(w_H_in_r),
        .H_in_i(w_H_in_i),

        // Nạp Y
        .Y_in_valid(w_Y_in_valid),
        .Y_in_r(w_Y_in_r),
        .Y_in_i(w_Y_in_i),

        // Outputs
        .s_I_1(s_I_1), .s_Q_1(s_Q_1), // Các symbol output (nếu cần debug)
        .s_I_2(s_I_2), .s_Q_2(s_Q_2),
        .Smin_index(Smin_index),
        
        .output_valid(w_decoder_done),      // Báo data sẵn sàng cho UART
        .signal_out_12bit(w_signal_out_12bit) // Dữ liệu trả về
    );

endmodule
