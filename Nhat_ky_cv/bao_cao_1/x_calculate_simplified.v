/*
 * Module: x_calculate_simplified
 * Chức năng: Quản lý nạp ma trận H, sau đó khởi động
 * chuỗi pipeline để tính Hq và Dh.
 */
module x_calculate_simplified #(
    parameter Q = 16,
    parameter N = 32
)
(
    // --- Interface ---
    input clk,
    input rst,
    input start_new_q,      // Xung bắt đầu một phiên tính toán mới
    input [3:0] q_index,

    // --- Giao diện nạp ma trận H ---
    input H_in_valid,
    input signed [N-1:0] H_in_r,
    input signed [N-1:0] H_in_i,

    // --- Đầu ra ---
    output reg q_calc_done,         // Báo hiệu tính xong Hq và Dh cho một q_index
    output wire signed [N-1:0] Dh_out, // Kết quả Dh
    output wire Dh_result_valid     // Tín hiệu valid cho Dh_out
);

//----------------------------------------------------------------
// 1. FSM State Definitions
//----------------------------------------------------------------
localparam S_IDLE = 2'd0;
localparam S_LOAD = 2'd1;
localparam S_CALC = 2'd2;

reg [1:0] state, next_state;

//----------------------------------------------------------------
// 2. Internal Signals and RAM
//----------------------------------------------------------------
// Tín hiệu điều khiển
reg start_hq_calc; // Xung để khởi động module tính toán Hq

// RAM để lưu trữ ma trận H (4x4)
reg signed [N-1:0] h_mem_real [0:3][0:3];
reg signed [N-1:0] h_mem_imag [0:3][0:3];

// Bộ đếm để nạp dữ liệu vào RAM
reg [1:0] load_row_cnt;
reg [1:0] load_col_cnt;

// Dây nối giữa các module con
wire hq_one_matrix_done; // Tín hiệu báo Hq đã tính xong
wire hq_valid;           // Xung báo một phần tử của Hq hợp lệ
wire signed [N-1:0] hq_r, hq_i;
wire [1:0] i_counter;    // Địa chỉ hàng để đọc H_mem
wire [1:0] k_counter;    // Địa chỉ cột để đọc H_mem

//----------------------------------------------------------------
// 3. Sub-module Instantiation (Pipeline Hq -> Dh)
//----------------------------------------------------------------

// GIAI ĐOẠN 1: Tính toán Hq
matrix_multiplier #(.N(N), .Q(Q)) hq_calc_inst (
    .clk(clk),
    .rst(rst),
    .start(start_hq_calc),
    .q_index(q_index),
    .H_in_valid(1'b1), // Luôn hợp lệ vì đọc từ RAM nội bộ
    .i_counter(i_counter),
    .k_counter(k_counter),
    .H_in_r(h_mem_real[i_counter][k_counter]),
    .H_in_i(h_mem_imag[i_counter][k_counter]),
    .hq_one_matrix_done(hq_one_matrix_done), // Output báo xong
    .all_16_hq_done(), // Không sử dụng
    .Hq_out_valid(hq_valid), // Output: xung valid cho từng phần tử Hq
    .Hq_out_r(hq_r),
    .Hq_out_i(hq_i)
);

// GIAI ĐOẠN 2: Tính toán Dh
// Đầu vào của module này là đầu ra của module Hq
Dh_cal #(.N(N), .Q(Q)) dh_calc_inst (
    .clk(clk),
    .rst(rst),
    .Dh_en(hq_valid), // Kích hoạt khi có một phần tử Hq mới
    .in_real(hq_r),
    .in_im(hq_i),
    .Dh_out(Dh_out),
    .Dh_result_valid(Dh_result_valid)
);

//----------------------------------------------------------------
// 4. FSM Logic
//----------------------------------------------------------------

// --- Logic tổ hợp (Combinational): Xác định trạng thái kế tiếp ---
wire load_H_done = (load_row_cnt == 2'b11 && load_col_cnt == 2'b11);

always @(*) begin
    next_state = state; // Mặc định giữ nguyên trạng thái
    case(state)
        S_IDLE: begin
            if (start_new_q) begin
                next_state = S_LOAD;
            end
        end
        S_LOAD: begin
            // Chuyển trạng thái khi đã nhận đủ 16 giá trị H
            if (H_in_valid && load_H_done) begin
                next_state = S_CALC;
            end
        end
        S_CALC: begin
            // Khi module Hq báo đã tính xong, quay về IDLE
            if (hq_one_matrix_done) begin
                next_state = S_IDLE;
            end
        end
        default: begin
            next_state = S_IDLE;
        end
    endcase
end

// --- Logic tuần tự (Sequential): Cập nhật trạng thái và các thanh ghi ---
always @(posedge clk or rst) begin
    if (rst) begin
        state         <= S_IDLE;
        load_row_cnt  <= 2'b0;
        load_col_cnt  <= 2'b0;
        start_hq_calc <= 1'b0;
        q_calc_done   <= 1'b0;
    end else begin
        state <= next_state;
        q_calc_done <= 1'b0; // Mặc định là 0

        // Logic hoạt động trong từng trạng thái
        if (state == S_IDLE) begin
            if (start_new_q) begin
                // Reset bộ đếm khi chuẩn bị vào S_LOAD
                load_row_cnt <= 2'b0;
                load_col_cnt <= 2'b0;
            end
        end

        // Tạo xung start_hq_calc khi chuyển từ S_LOAD sang S_CALC
        if (state == S_LOAD && next_state == S_CALC) begin
            start_hq_calc <= 1'b1;
        end else begin
            start_hq_calc <= 1'b0;
        end

        // Logic nạp dữ liệu vào RAM
        if (state == S_LOAD) begin
            if (H_in_valid) begin
                h_mem_real[load_row_cnt][load_col_cnt] <= H_in_r;
                h_mem_imag[load_row_cnt][load_col_cnt] <= H_in_i;

                if (load_col_cnt == 2'b11) begin
                    load_col_cnt <= 2'b0;
                    load_row_cnt <= load_row_cnt + 1;
                end else begin
                    load_col_cnt <= load_col_cnt + 1;
                end
            end
        end
        
        // Kéo cờ 'done' lên 1 xung khi tính toán xong
        if (state == S_CALC && hq_one_matrix_done) begin
            q_calc_done <= 1'b1;
        end
    end
end

endmodule