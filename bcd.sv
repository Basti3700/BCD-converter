module bcd #(parameter data_WIDTH = 8)(
                clk,
                rst_n,
                req,
                data_w,
                ack,
                data_r,
				addr,
				rd_wr,
				client_number,
				reverse_order,
				delay
); // driver


input rd_wr;
input clk;
input rst_n;
input req;
input [data_WIDTH-1:0] data_w;
input [1:0] addr;

input [1:0] client_number;

output reg  [data_WIDTH-1:0] data_r;
output reg ack;
//inout [data_WIDTH-1:0] config_reg; 
//input [data_WIDTH-1:0] status;

output reverse_order;
output [4:0] delay;



reg [3:0][data_WIDTH-1:0] registrii;
//reg [2*data_WIDTH-1:0] in_buff; // Buffer de intrare pentru date.
reg req_d;                      // Buffer de intrare pentru req.




always@(posedge clk or negedge rst_n) begin	
	if(~rst_n) begin
		registrii[0]={data_WIDTH{1'b0}};//config
		registrii[1]={data_WIDTH{1'b0}}; //status
		registrii[2]={data_WIDTH{1'b0}}; 
		registrii[3]={data_WIDTH{1'b0}}; 
		
	end else begin
		if(req)
			if(rd_wr==1) begin// pt citirebegin
				if (addr!=1)  
					registrii[addr]=data_w;
				$display("registrii s-au actualizat");
				end
				
				
			
	end
end
	//assign config_reg= registrii[1][7:0];
	
always@(posedge clk or negedge rst_n) begin	
	if(~rst_n) begin
		data_r=0;
		
	end else begin
		if(req)
			if(rd_wr==0) begin// pt scriere
				data_r=registrii[addr];
				$display("valoarea din reg este %0b", registrii[addr]);
				
				end 
	end
	
end

		assign reverse_order = registrii[1][5];
		assign delay = registrii[1][4:0];
		//assign registrii[1][1:0] = client_number;  
		

	
	
	
		



// Request delay (& sincronizare)
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        req_d <= 1'b0;
    end else begin 
		if(ack) begin
			req_d <= 1'b0;
		end else begin
			req_d <= req;
		end
    end
end



// Modelare ack
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        ack <= 'b0;
		
    end else begin
        if(ack==1) begin
            ack <= 1'b0;
        end else begin
		if(req==1)
            ack <= 1'b1;
        end
    end
end

/* Modelare data_r
always @(posedge clk or negedge rst_n) begin
    if(~rst_n) begin
        data_r <= 'b0;
    end else begin
        if(req_d==1) begin
            data_r <= registrii[addr];
        end else begin
            data_r <= 'b0;
        end
    end
end */
endmodule