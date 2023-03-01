module clockdiv( input clk,input rst,output clk_en );
	reg [1:0] clk_count;
	always @ (posedge clk, posedge rst)
	begin
		if (rst) clk_count <= 0;
		else
			clk_count <= clk_count+1'b1;
	end
assign clk_en = &clk_count;
endmodule
