module arbitration (
  input clk, // clock
  input rst, // reset
  input [3:0] client, // input from 4 clients
  input [3:0] v, // input indicating which clients have valid data
  input ready, // input indicating if display is ready for new data
  output reg [7:0] number_to_display // output number to display
);

  reg [1:0] last_visited_number;
  reg [3:0] valid_data;

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      number_to_display <= 8'd0;
      last_visited_number <= 2'd0;
      valid_data <= 4'd0;
    end
    else if (ready) begin
      number_to_display <= client[last_visited_number];
      valid_data <= v[last_visited_number];
      last_visited_number <= (last_visited_number + 1) % 4;
    end
  end

endmodule

