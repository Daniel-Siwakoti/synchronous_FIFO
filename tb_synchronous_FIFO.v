`timescale 1ns/1ps
`include "Synchronous_FIFO.v"

module Synchronous_FIFO_tb;

  // Parameters
  parameter fifo_depth = 8;
  parameter fifo_width = 16;

  // Testbench Signals
  reg clk;
  reg rst_n;
  reg w_en;
  reg r_en;
  reg [fifo_width-1:0] data_in;
  wire full;
  wire empty;
  wire [fifo_width-1:0] data_out;

  // Instantiate the Synchronous_FIFO module
  Synchronous_FIFO #(
    .fifo_depth(fifo_depth),
    .fifo_width(fifo_width)
  ) uut (
    .clk(clk),
    .rst_n(rst_n),
    .w_en(w_en),
    .r_en(r_en),
    .data_in(data_in),
    .data_out(data_out),
    .full(full),
    .empty(empty)
  );

  // Clock generation
  always #5 clk = ~clk; // 100 MHz clock

  // Integer variable declarations
  integer i;

  // Test sequence
  initial begin
    // Initialize signals
    clk = 0;
    rst_n = 0;
    w_en = 0;
    r_en = 0;
    data_in = 0;

    // Apply reset
    #10;
    rst_n = 1;
    #10;

    // Write to FIFO
    $display("Writing to FIFO...");
    w_en = 1;
    for (i = 0; i < fifo_depth; i = i + 1) begin
      data_in = i;
      #10; // Wait for one clock cycle
      if (full) begin
        $display("FIFO is full during write operation.");
        w_en = 0;
      end
    end
    w_en = 0;
    #10;

    // Attempt to write to full FIFO
    $display("Attempting to write to full FIFO...");
    data_in = 16'hFFFF;
    w_en = 1;
    #10;
    if (full) begin
      $display("FIFO is full. Write operation prevented.");
    end
    w_en = 0;
    #10;

    // Read from FIFO
    $display("Reading from FIFO...");
    r_en = 1;
    for (i = 0; i < fifo_depth; i = i + 1) begin
      #10; // Wait for one clock cycle
      $display("Data read from FIFO: %h", data_out);
      if (empty) begin
        $display("FIFO is empty during read operation.");
        r_en = 0;
      end
    end
    r_en = 0;
    #10;

    // Attempt to read from empty FIFO
    $display("Attempting to read from empty FIFO...");
    r_en = 1;
    #10;
    if (empty) begin
      $display("FIFO is empty. Read operation prevented.");
    end
    r_en = 0;
    #10;

    // Finish simulation
    $finish;
  end

endmodule
