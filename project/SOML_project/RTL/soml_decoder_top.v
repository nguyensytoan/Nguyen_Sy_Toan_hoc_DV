module soml_decoder_top #(
    parameter Q = 22,
    parameter N = 32
)
(
    input  wire clk,
    input  wire rst,     // Nối với Switch (Active Low hoặc High tùy board, logic bên dưới giả sử input này là Active High reset)
    
    // UART PINS (Nối ra chân FPGA)
    input  wire GPIO_RX, 
    output wire GPIO_TX,

    // DEBUG OUTPUT (Có thể nối ra LED để kiểm tra)
    output wire output_valid,
    output wire signed [11:0] signal_out_12bit,
    output wire [4:0] Smin_index,
    output wire signed [N-1:0] s_I_1, s_Q_1, s_I_2, s_Q_2
);

    // =================================================================
    // 1. KẾT NỐI UART TOP
    // =================================================================
    wire [31:0] uart_data_in;
    wire        uart_valid;
    wire [11:0] result_msg;
    wire        result_ready;
    
 
    wire sys_rst_n = !rst; 
                           

    uart_top uart_inst (
        .CLOCK_50(clk),
        .sw_0(!rst),         
        .GPIO_RX(GPIO_RX),
        .GPIO_TX(GPIO_TX),
        .o_data_32bit(uart_data_in),
        .o_valid(uart_valid),
        .message(result_msg),
        .message_ready(result_ready)
    );

    // =================================================================
    // 2. RAM VÀ TÍN HIỆU NỘI BỘ
    // =================================================================
    reg signed [N-1:0] h_mem_real [0:3][0:3];
    reg signed [N-1:0] h_mem_imag [0:3][0:3];
    reg signed [N-1:0] y_mem1_r [0:3];
    reg signed [N-1:0] y_mem1_i [0:3];
    reg signed [N-1:0] y_mem2_r [0:3];
    reg signed [N-1:0] y_mem2_i [0:3];

    reg start_hq_calc;
    
    // FSM States
    localparam S_IDLE = 2'd0;
    localparam S_LOAD = 2'd1;
    localparam S_CALC = 2'd2;
    reg [1:0] state;

    
    reg [5:0] recv_count; // Đếm từ 0 đến 47

    // =================================================================
    // 3. LOGIC NẠP DỮ LIỆU THÔNG MINH (FSM CHÍNH)
    // =================================================================
    
    
    wire is_imag = recv_count[0]; 
    wire [1:0] h_row = recv_count[4:3]; 
    wire [1:0] h_col = recv_count[2:1]; 
    wire [2:0] y_idx = recv_count[3:1]; 

    always @(posedge clk) begin
        if (rst) begin
            state <= S_IDLE;
            recv_count <= 0;
            start_hq_calc <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    state <= S_LOAD; 
                    recv_count <= 0;
                    start_hq_calc <= 0;
                end

                S_LOAD: begin
                    if (uart_valid) begin
                        // --- NẠP MA TRẬN H (0 đến 31) ---
                        if (recv_count < 32) begin
                            if (!is_imag) h_mem_real[h_row][h_col] <= uart_data_in;
                            else          h_mem_imag[h_row][h_col] <= uart_data_in;
                        end 
                        // --- NẠP VECTOR Y (32 đến 47) ---
                        else if (recv_count < 48) begin
                            if (y_idx < 4) begin // Y1 (0-3)
                                if (!is_imag) y_mem1_r[y_idx] <= uart_data_in;
                                else          y_mem1_i[y_idx] <= -uart_data_in;
                            end else begin       // Y2 (4-7)
                                if (!is_imag) y_mem2_r[y_idx-4] <= uart_data_in;
                                else          y_mem2_i[y_idx-4] <= -uart_data_in;
                            end
                        end

                        
                        if (recv_count == 47) begin
                            state <= S_CALC;
                            start_hq_calc <= 1'b1; // Kích hoạt bộ tính toán
                        end else begin
                            recv_count <= recv_count + 1;
                        end
                    end
                end

                S_CALC: begin
                    start_hq_calc <= 0; 
                    if (output_valid) begin
                         state <= S_IDLE; 
                    end
                end
            endcase
        end
    end

    // =================================================================
    // 4. CÁC MODULE TÍNH TOÁN (Giữ nguyên logic của bạn)
    // =================================================================
    
    reg signed [0 :N*8-1] H_row0_r, H_row0_i, H_row1_r, H_row1_i;
    reg signed [0 :N*8-1] H_row2_r, H_row2_i, H_row3_r, H_row3_i;
    wire hq_done, hq_valid, all_16_hq_done;
    wire signed [N-1:0] hq_r, hq_i;

    always @(posedge clk) begin  
        if(rst) begin
            H_row0_r <= 0; H_row0_i <= 0;
            H_row1_r <= 0; H_row1_i <= 0;
            H_row2_r <= 0; H_row2_i <= 0;
            H_row3_r <= 0; H_row3_i <= 0;
        end
        else if(start_hq_calc) begin
            
            H_row0_r <= {h_mem_real[0][0], h_mem_real[0][0], h_mem_real[1][0], h_mem_real[1][0],h_mem_real[2][0], h_mem_real[2][0], h_mem_real[3][0], h_mem_real[3][0]};
            H_row0_i <= {h_mem_imag[0][0], h_mem_imag[0][0], h_mem_imag[1][0], h_mem_imag[1][0],h_mem_imag[2][0], h_mem_imag[2][0], h_mem_imag[3][0], h_mem_imag[3][0]};
            H_row1_r <= {h_mem_real[0][1], h_mem_real[0][1], h_mem_real[1][1], h_mem_real[1][1],h_mem_real[2][1], h_mem_real[2][1], h_mem_real[3][1], h_mem_real[3][1]};
            H_row1_i <= {h_mem_imag[0][1], h_mem_imag[0][1], h_mem_imag[1][1], h_mem_imag[1][1],h_mem_imag[2][1], h_mem_imag[2][1], h_mem_imag[3][1], h_mem_imag[3][1]};
            H_row2_r <= {h_mem_real[0][2], h_mem_real[0][2], h_mem_real[1][2], h_mem_real[1][2],h_mem_real[2][2], h_mem_real[2][2], h_mem_real[3][2], h_mem_real[3][2]};
            H_row2_i <= {h_mem_imag[0][2], h_mem_imag[0][2], h_mem_imag[1][2], h_mem_imag[1][2],h_mem_imag[2][2], h_mem_imag[2][2], h_mem_imag[3][2], h_mem_imag[3][2]};
            H_row3_r <= {h_mem_real[0][3], h_mem_real[0][3], h_mem_real[1][3], h_mem_real[1][3],h_mem_real[2][3], h_mem_real[2][3], h_mem_real[3][3], h_mem_real[3][3]};
            H_row3_i <= {h_mem_imag[0][3], h_mem_imag[0][3], h_mem_imag[1][3], h_mem_imag[1][3],h_mem_imag[2][3], h_mem_imag[2][3], h_mem_imag[3][3], h_mem_imag[3][3]};
        end
    end

    matrix_multiplier  #(.N(N), .Q(Q)) hq_calc_inst(
        .clk(clk), .rst(rst), .start(start_hq_calc),
        .H_row0_r(H_row0_r), .H_row0_i(H_row0_i),
        .H_row1_r(H_row1_r), .H_row1_i(H_row1_i),
        .H_row2_r(H_row2_r), .H_row2_i(H_row2_i),
        .H_row3_r(H_row3_r), .H_row3_i(H_row3_i),
        .hq_one_matrix_done(hq_done), .all_16_hq_done(all_16_hq_done),
        .Hq_valid(hq_valid), .Hq_out_r(hq_r), .Hq_out_i(hq_i)
    );

    wire signed [N-1:0] Dh_out;
    wire Dh_result_valid;
    wire [N-1:0] inversDh;
    wire div_ovr, invDh_valid;

    Dh_cal #(.N(N), .Q(Q)) dh_calc_inst(
          .clk(clk), .rst(rst),
          .Dh_en(hq_valid), .in_real(hq_r), .in_im(hq_i),
          .Dh_out(Dh_out), .Dh_result_valid(Dh_result_valid)
    );

    delay_module #(.N(N)) invDh_Valid_inst(
        .clk(clk), .rst(rst), .in(Dh_result_valid), .number(N+1), .out(invDh_valid)
    );      
    
    fxp_div_pipe #( .WIIA(N-Q), .WIFA(Q), .WIIB(N-Q), .WIFB(Q), .WOI(N-Q), .WOF(Q), .ROUND(0)) invDh_inst(
        .rstn(!rst), .clk(clk),
        .dividend(32'd1<<Q), .divisor(Dh_out),
        .out(inversDh), .overflow(div_ovr)
    );

    wire g_valid;
    wire signed [N-1:0] Ga1_c0_r, Ga1_c0_i, Ga1_c1_r, Ga1_c1_i;
    wire signed [N-1:0] Ga2_c0_r, Ga2_c0_i, Ga2_c1_r, Ga2_c1_i;
    wire signed [N-1:0] Gb1_c0_r, Gb1_c0_i, Gb1_c1_r, Gb1_c1_i;
    wire signed [N-1:0] Gb2_c0_r, Gb2_c0_i, Gb2_c1_r, Gb2_c1_i;

    g_matrix_calculator #(.N(N)) g_matrix_inst(
        .clk(clk), .rst(rst),
        .Hq_in_valid(hq_valid), .Hq_in_r(hq_r), .Hq_in_i(hq_i),
        .G_valid(g_valid),
        .Ga1_c0_r(Ga1_c0_r), .Ga1_c0_i(Ga1_c0_i), .Ga1_c1_r(Ga1_c1_r), .Ga1_c1_i(Ga1_c1_i),
        .Ga2_c0_r(Ga2_c0_r), .Ga2_c0_i(Ga2_c0_i), .Ga2_c1_r(Ga2_c1_r), .Ga2_c1_i(Ga2_c1_i),
        .Gb1_c0_r(Gb1_c0_r), .Gb1_c0_i(Gb1_c0_i), .Gb1_c1_r(Gb1_c1_r), .Gb1_c1_i(Gb1_c1_i),
        .Gb2_c0_r(Gb2_c0_r), .Gb2_c0_i(Gb2_c0_i), .Gb2_c1_r(Gb2_c1_r), .Gb2_c1_i(Gb2_c1_i)
    );

   
    wire signed [N-1:0] y_r0_r, y_r0_i, y_r1_r, y_r1_i;
    reg [1:0] cnt_y;

    always @(posedge clk) begin
        if(rst) cnt_y <= 0;
        else if (g_valid) cnt_y <= cnt_y + 1;
    end

    assign y_r0_r = (g_valid)? y_mem1_r[cnt_y] : 0;
    assign y_r0_i = (g_valid)? y_mem1_i[cnt_y] : 0;
    assign y_r1_r = (g_valid)? y_mem2_r[cnt_y] : 0;
    assign y_r1_i = (g_valid)? y_mem2_i[cnt_y] : 0;

    
    wire signed [N-1:0] ga1_r, ga1_i, ga2_r, ga2_i, gb1_r, gb1_i, gb2_r, gb2_i;
    
    trace_calculator #(.N(N)) traceGa1 (.clk(clk),.rst(rst),.cal_en(g_valid),.y_r0_r(y_r0_r),.y_r0_i(y_r0_i),.y_r1_r(y_r1_r),.y_r1_i(y_r1_i),.g_c0_r(Ga1_c0_r),.g_c0_i(Ga1_c0_i),.g_c1_r(Ga1_c1_r),.g_c1_i(Ga1_c1_i),.trace_result_r(ga1_r),.trace_result_i(ga1_i));
    trace_calculator #(.N(N)) traceGa2 (.clk(clk),.rst(rst),.cal_en(g_valid),.y_r0_r(y_r0_r),.y_r0_i(y_r0_i),.y_r1_r(y_r1_r),.y_r1_i(y_r1_i),.g_c0_r(Ga2_c0_r),.g_c0_i(Ga2_c0_i),.g_c1_r(Ga2_c1_r),.g_c1_i(Ga2_c1_i),.trace_result_r(ga2_r),.trace_result_i(ga2_i));
    trace_calculator #(.N(N)) traceGb1 (.clk(clk),.rst(rst),.cal_en(g_valid),.y_r0_r(y_r0_r),.y_r0_i(y_r0_i),.y_r1_r(y_r1_r),.y_r1_i(y_r1_i),.g_c0_r(Gb1_c0_r),.g_c0_i(Gb1_c0_i),.g_c1_r(Gb1_c1_r),.g_c1_i(Gb1_c1_i),.trace_result_r(gb1_r),.trace_result_i(gb1_i));
    trace_calculator #(.N(N)) traceGb2 (.clk(clk),.rst(rst),.cal_en(g_valid),.y_r0_r(y_r0_r),.y_r0_i(y_r0_i),.y_r1_r(y_r1_r),.y_r1_i(y_r1_i),.g_c0_r(Gb2_c0_r),.g_c0_i(Gb2_c0_i),.g_c1_r(Gb2_c1_r),.g_c1_i(Gb2_c1_i),.trace_result_r(gb2_r),.trace_result_i(gb2_i));

    
    wire signed [N-1:0] ga1_r_delay, ga2_r_delay, gb1_i_delay, gb2_i_delay;
    delay_module #(.N(N)) delay_ga1(.clk(clk),.rst(rst),.in(ga1_r),.number(6'd22),.out(ga1_r_delay));
    delay_module #(.N(N)) delay_ga2(.clk(clk),.rst(rst),.in(ga2_r),.number(6'd22),.out(ga2_r_delay));
    delay_module #(.N(N)) delay_gb1(.clk(clk),.rst(rst),.in(gb1_i),.number(6'd22),.out(gb1_i_delay));
    delay_module #(.N(N)) delay_gb2(.clk(clk),.rst(rst),.in(gb2_i),.number(6'd22),.out(gb2_i_delay));

    wire signed [N-1:0] xI1_out_tmp, xI2_out_tmp, xQ1_out_tmp, xQ2_out_tmp;
    wire ovr_xi1, ovr_xi2, ovr_xq1, ovr_xq2;

    qmult #(.Q(Q), .N(N)) xi1_cal(.i_multiplicand(ga1_r_delay), .i_multiplier(inversDh), .o_result(xI1_out_tmp), .ovr(ovr_xi1));
    qmult #(.Q(Q), .N(N)) xi2_cal(.i_multiplicand(ga2_r_delay), .i_multiplier(inversDh), .o_result(xI2_out_tmp), .ovr(ovr_xi2));
    qmult #(.Q(Q), .N(N)) xq1_cal(.i_multiplicand(gb1_i_delay), .i_multiplier(inversDh), .o_result(xQ1_out_tmp), .ovr(ovr_xq1));
    qmult #(.Q(Q), .N(N)) xq2_cal(.i_multiplicand(gb2_i_delay), .i_multiplier(inversDh), .o_result(xQ2_out_tmp), .ovr(ovr_xq2));

    wire signed [N-1:0] xI1_out = xI1_out_tmp;
    wire signed [N-1:0] xI2_out = xI2_out_tmp;
    wire signed [N-1:0] xQ1_out = -xQ1_out_tmp;
    wire signed [N-1:0] xQ2_out = -xQ2_out_tmp;

    
    wire signed [N-1:0] dI1, dI2, dQ1, dQ2, Rq;
    wire signed [2:0] m_dI1, m_dI2, m_dQ1, m_dQ2;

    MinFinder #(.N(N),.Q(Q)) dmin_inst(
        .clk(clk), .rst_n(!rst),
        .xI1(xI1_out), .xQ1(xQ1_out), .xI2(xI2_out), .xQ2(xQ2_out),
        .min_dI1(dI1), .min_dQ1(dQ1), .min_dI2(dI2), .min_dQ2(dQ2),
        .Rq(Rq),
        .min_idx_dI1(m_dI1), .min_idx_dQ1(m_dQ1), .min_idx_dI2(m_dI2), .min_idx_dQ2(m_dQ2)
    );

    wire signed [N-1:0] Dh_delay;
    delay_module #(.N(N)) delay_dh(.clk(clk), .rst(rst), .in(Dh_out), .number(6'd33), .out(Dh_delay));

    wire signed [N-1:0] dq_out;
    wire dq_valid;
    delay_module #(.N(N)) delay_valid_inst(.clk(clk), .rst(rst), .in(invDh_valid), .number(6'd2), .out(dq_valid));
    
    dq_cal #(.N(N),.Q(Q)) dq_calculate (
        .clk(clk), .rst(rst),
        .dI1(dI1),.dI2(dI2),.dQ1(dQ1),.dQ2(dQ2), .Rq(Rq), .Dh(Dh_delay),
        .dq_out(dq_out)
    );

    
    wire signed [N-1:0] dq_min;
    wire busy, min_valid;
    wire [2:0] min_dq_m_dI1, min_dq_m_dI2, min_dq_m_dQ1, min_dq_m_dQ2;
    wire [4:0] q_min;

    find_min #(.N(32), .NUM_VALUES(16)) find_min_inst (
        .clk(clk), .rst_n(!rst),
        .dq_out(dq_out), .in_valid(dq_valid),
        .m_dI1(m_dI1), .m_dI2(m_dI2), .m_dQ1(m_dQ1), .m_dQ2(m_dQ2),
        .min_value(dq_min), .min_valid(min_valid), .busy(busy),
        .min_m_dI1(min_dq_m_dI1), .min_m_dI2(min_dq_m_dI2), .min_m_dQ1(min_dq_m_dQ1), .min_m_dQ2(min_dq_m_dQ2),
        .q_min(q_min)
    );

   
    wire [4:0] S_hat_index_out;
    wire tx_signal_out_valid;
    wire [7:0] b1_out;
    wire [3:0] b2_out;
    wire final_out_valid;

    determine_tx_signal #(.N(N), .Q(Q)) determine_tx_signal_inst (
        .clk(clk), .rst_n(!rst),
        .in_valid(min_valid),    
        .m_Imin_1(min_dq_m_dI1), .m_Qmin_1(min_dq_m_dQ1),
        .m_Imin_2(min_dq_m_dI2), .m_Qmin_2(min_dq_m_dQ2),
        .q_min(q_min),              
        .s_hat_I_1(s_I_1), .s_hat_Q_1(s_Q_1),
        .s_hat_I_2(s_I_2), .s_hat_Q_2(s_Q_2),
        .S_hat_index(S_hat_index_out), .out_valid(tx_signal_out_valid)
    );

    output_signal #(.N(32)) output_signal_inst (
        .clk(clk), .rst_n(!rst),
        .in_valid(min_valid),
        .m_Imin_1(min_dq_m_dI1), .m_Qmin_1(min_dq_m_dQ1),
        .m_Imin_2(min_dq_m_dI2), .m_Qmin_2(min_dq_m_dQ2),
        .q_min(q_min),
        .b1(b1_out), .b2(b2_out),
        .out_valid(final_out_valid)
    );

    
    assign Smin_index = S_hat_index_out;
    assign output_valid = final_out_valid;
    assign signal_out_12bit = {b2_out, b1_out};
    
    
    assign result_msg = {b2_out, b1_out};
    assign result_ready = final_out_valid;

endmodule
