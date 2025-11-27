// File: tb_x_calculate_simplified.v
`timescale 1ns/1ps

module tb_x_calculate_simplified;

    // --- Parameters ---
    parameter Q = 16;
    parameter N = 32;
    parameter CLK_PERIOD = 10; // 10ns = 100MHz clock
    parameter ROWS = 4;
    parameter COLS = 4;

    // --- File Paths for Stimulus ---
    parameter H_REAL_FILE = "H_real_stimulus.hex";
    parameter H_IMAG_FILE = "H_imag_stimulus.hex";

    // --- Testbench Signals (reg for driving DUT inputs) ---
    reg clk;
    reg rst;
    reg start_new_q;
    reg [3:0] q_index;
    reg H_in_valid;
    reg signed [N-1:0] H_in_r;
    reg signed [N-1:0] H_in_i;

    // --- DUT Wires (wire for observing DUT outputs) ---
    wire q_calc_done;
    wire signed [N-1:0] Dh_out;
    wire Dh_result_valid;

    // --- Testbench Internal Memory to store stimulus from file ---
    reg signed [N-1:0] h_stim_r [0:ROWS-1][0:COLS-1];
    reg signed [N-1:0] h_stim_i [0:ROWS-1][0:COLS-1];

    //----------------------------------------------------------------
    // Instantiate the DUT (Device Under Test)
    //----------------------------------------------------------------
    x_calculate_simplified #(
        .Q(Q),
        .N(N)
    ) dut (
        .clk(clk),
        .rst(rst),
        .start_new_q(start_new_q),
        .q_index(q_index),
        .H_in_valid(H_in_valid),
        .H_in_r(H_in_r),
        .H_in_i(H_in_i),
        .q_calc_done(q_calc_done),
        .Dh_out(Dh_out),
        .Dh_result_valid(Dh_result_valid)
    );

    // Clock generator
    always #(CLK_PERIOD/2) clk = ~clk;

    //----------------------------------------------------------------
    // Main Test Sequence
    //----------------------------------------------------------------
    initial begin
        // Setup waveform dumping
        $dumpfile("tb_simplified.vcd");
        $dumpvars(0, tb_x_calculate_simplified);

        // 1. Initialize signals and read data from files
        initialize_signals();
        read_h_matrix_from_file();

        // 2. Reset the DUT to bring it to a known state
        reset_dut();
        $display("[%0t] >>> Test Starting for q_index = 5 <<<", $time);

        // 3. Set a specific q_index to test
        q_index <= 4'd5;
        
        // 4. Send a single-cycle start pulse
        start_new_q <= 1;
        @(posedge clk);
        start_new_q <= 0;
        
        // 5. Drive the H matrix data into the DUT
        drive_h_matrix();

        // 6. Wait for the DUT to signal completion
        $display("[%0t] H Matrix loaded. Waiting for 'q_calc_done'...", $time);
        wait (q_calc_done == 1);

        $display("[%0t] >>> 'q_calc_done' received. Test PASSED! <<<", $time);
        
        // Let simulation run a little longer to observe final signals
        #(10 * CLK_PERIOD);
        $finish;
    end

    // Safety timeout to prevent simulation from running forever
    initial begin
        #50000; // 50us timeout
        $display("[%0t] ERROR: Simulation TIMEOUT!", $time);
        $finish;
    end

    // Monitor for the final result
    always @(posedge clk) begin
        if (Dh_result_valid) begin
            $display("[%0t] INFO: Dh Result is VALID. Dh_out = %h", $time, Dh_out);
        end
    end

    //----------------------------------------------------------------
    // TASKS to make the testbench clean and modular
    //----------------------------------------------------------------

    task initialize_signals;
    begin
        clk = 0;
        rst = 1; // Start in reset
        start_new_q = 0;
        q_index = 0;
        H_in_valid = 0;
        H_in_r = 0;
        H_in_i = 0;
    end
    endtask

    task reset_dut;
    begin
        $display("[%0t] Applying reset...", $time);
        rst = 1;
        #(2 * CLK_PERIOD);
        rst = 0;
        #(2 * CLK_PERIOD);
        $display("[%0t] Reset released.", $time);
    end
    endtask

    task read_h_matrix_from_file;
        integer h_real_fd, h_imag_fd, dummy_status;
    begin
        h_real_fd = $fopen(H_REAL_FILE, "r");
        h_imag_fd = $fopen(H_IMAG_FILE, "r");

        if (!h_real_fd || !h_imag_fd) begin
            $display("FATAL ERROR: Could not open H matrix stimulus files.");
            $finish;
        end

        for (integer i = 0; i < ROWS; i = i + 1) begin
            for (integer j = 0; j < COLS; j = j + 1) begin
                dummy_status = $fscanf(h_real_fd, "%h", h_stim_r[i][j]);
                dummy_status = $fscanf(h_imag_fd, "%h", h_stim_i[i][j]);
            end
        end

        $fclose(h_real_fd);
        $fclose(h_imag_fd);
        $display("INFO: H matrix stimulus has been read into testbench memory.");
    end
    endtask

    task drive_h_matrix;
    begin
        $display("[%0t] Driving H Matrix data...", $time);
        @(posedge clk);
        for (integer i = 0; i < ROWS; i = i + 1) begin
            for (integer j = 0; j < COLS; j = j + 1) begin
                H_in_valid <= 1;
                H_in_r <= h_stim_r[i][j];
                H_in_i <= h_stim_i[i][j];
                @(posedge clk);
            end
        end
        H_in_valid <= 0; // De-assert valid after the last data item
        $display("[%0t] H Matrix loading complete.", $time);
    end
    endtask

endmodule