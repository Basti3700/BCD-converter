module display_controller (
  input clk, // clock
  input rst, // reset
  input ready, // input indicating if display is ready for new data
  input [7:0] data, // input data to display
  input reverse_order,
  input [4:0] delay,
  output reg [6:0] segments, // output segments for 7-segment display
  output reg [2:0] digit_hundreds, // output for hundreds digit of display
  output reg [3:0] digit_tens, // output for tens digit of display
  output reg [3:0] digit_units, // output for units digit of display
  output reg [1:0] client_number // output send to banc_register
);

  reg [2:0] digit_count; // variable to keep track of which digit is being displayed
  reg [7:0] number_to_display;

  

  

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      segments <= 7'b0000000;
      digit_hundreds <= 3'b000;
      digit_tens <= 4'b0000;
      digit_units <= 4'b0000;
      digit_count <= 3'b000;
      number_to_display <= 8'b00000000;
    end
    else begin
      if (ready) begin
        number_to_display <= data;
      end

      if (digit_count == 3'b000) begin
        segments <= number_to_display[6:0];
        digit_hundreds <= number_to_display[7:5];
      end
      else if (digit_count == 3'b001) begin
        segments <= number_to_display[4:0];
        digit_tens <= number_to_display[7:4];
      end
      else if (digit_count == 3'b010) begin
        segments <= number_to_display[2:0];
        digit_units <= number_to_display[7:4];
      end

      if (digit_count < 3'b010) begin
        digit_count <= digit_count + 1;
      end
      else begin
        digit_count <= 3'b000;
      end
    end
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      client_number <= 2'b00;
    end
    else begin
      if (ready) begin
        if (reverse_order) begin
          case (digit_count)
            3'b000: client_number <= 2'b01;
            3'b001: client_number <= 2'b10;
            3'b010: client_number <= 2'b11;
          endcase
        end
        else begin
          case (digit_count)
            3'b000: client_number <= 2'b00;
            3'b001: client_number <= 2'b01;
            3'b010: client_number <= 2'b10;
          endcase
        end
      end
    end
  end

endmodule

