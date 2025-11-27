module keycode_reader(
    input [7:0] keycode,
    output logic w_on, a_on, d_on
    );

    // Phân tích từng nhóm 2 bit để kiểm tra trạng thái của các phím
    assign w_on = (keycode[7:0]  == 8'd1);//phai bang 1
    assign a_on = (keycode[7:0]  == 8'd8);//phai bang 8
    assign d_on = (keycode[7:0]  == 8'd4);

endmodule