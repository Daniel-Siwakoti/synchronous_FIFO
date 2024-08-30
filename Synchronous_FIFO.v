module Synchronous_FIFO (
  input clk,
  input rst_n,
  input w_en,
  input r_en,
  input [fifo_width-1:0] data_in,
  output full,
  output empty,
  output reg [fifo_width-1:0] data_out
);

  parameter fifo_depth = 8;
  parameter fifo_width = 16;
  
  reg [$clog2(fifo_depth)-1:0] w_ptr, r_ptr;
  reg [fifo_width-1:0] FIFO [fifo_depth-1:0];

  // Reset FIFO pointers and clear FIFO memory
  integer i;
  always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      data_out <= {fifo_width{1'b0}};
      w_ptr <= {($clog2(fifo_depth)){1'b0}};
      r_ptr <= {($clog2(fifo_depth)){1'b0}};
      
      for (i = 0; i < fifo_depth; i = i + 1) begin
        FIFO[i] <= {fifo_width{1'b0}};
      end
    end
  end
  
  // Write into FIFO
  always @(posedge clk) begin
    if (!full & w_en) begin 
      FIFO[w_ptr] <= data_in;
      w_ptr <= w_ptr + 1'b1;
    end
  end
  
  // Read from FIFO
  always @(posedge clk) begin
    if (!empty & r_en) begin
      data_out <= FIFO[r_ptr];
      r_ptr <= r_ptr + 1'b1;
    end
  end
          
  // Empty Condition
  assign empty = (w_ptr == r_ptr);
  
  // Full Condition
  assign full = (w_ptr[$clog2(fifo_depth)-1] ^ r_ptr[$clog2(fifo_depth)-1]) &
                (w_ptr[$clog2(fifo_depth)-2:0] == r_ptr[$clog2(fifo_depth)-2:0]);

endmodule
