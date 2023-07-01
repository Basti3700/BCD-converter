module top #(
    parameter DATA_WIDTH = 8
) (
	 rd_wr,
	 clk,
	 rst_n,
	 req,
	 data_r,
	 addr,
	 data_w,
	 client,
	 v,
	 ready,
	 ack,
	 segments,
     digit_hundreds, // output for hundreds digit of display
     digit_tens, // output for tens digit of display
     digit_units // output for units digit of display
);



    input rd_wr;
	input clk;
	input req;
	input rst_n;
	input [DATA_WIDTH-1:0] data_w;
	input [1:0] addr;
    input [3:0] client; // input from 4 clients
    input [3:0] v; // input indicating which clients have valid data
    input ready; // input indicating if display is ready for new data
	output reg  [DATA_WIDTH-1:0] data_r;
	output reg ack;
    output reg [2:0] digit_hundreds; // output for hundreds digit of display
    output reg [3:0] digit_tens; // output for tens digit of display
    output reg [3:0] digit_units; // output for units digit of display
	output reg [6:0] segments; // output segments for 7-segment display
	
	
	logic out_arbitration;
	logic r_o;
	logic dl;
	logic c_n;
	//wire dataw;




arbitration #(
    .DATA_WIDTH (DATA_WIDTH)
) i_arbitration (
    .clk (clk),
    .rst_n (rst_n),
    .client (client),
    .v (v),
    .ready (ready),
    .number_to_display (out_arbitration)
    
);

display_controller#(
    .DATA_WIDTH (DATA_WIDTH)
) i_display_controller (
    .clk (clk),
    .rst_n (rst_n),
    .ready (ready),
    .data (out_arbitration), //?
    .segments (segments),
    .digit_hundreds (digit_hundreds),
    .digit_tens (digit_tens),
	.client_number (c_n),
    .digit_units (digit_units),
	.reverse_order (r_o),
    .delay (dl)
    
);

bcd #(
    .DATA_WIDTH (DATA_WIDTH)
) i_bcd (
    .rd_wr (rd_wr),
    .clk (clk),
    .rst_n (rst_n),
    .req (req),
    .data_r (data_r),
    .addr (addr),
    .client_number (c_n),
    .data_w (data_w),
    .ack (ack),
    .reverse_order (r_o),
    .delay (dl)
    
);

endmodule