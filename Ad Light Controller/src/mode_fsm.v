module mode_fsm(
    input wire clk,
    input wire rst_n,
    input wire [3:0] mode_select,
    output reg [3:0] current_mode
);
    
    // 状态转移逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
 			current_mode <= 4'd0;
		end else begin
			current_mode <= mode_select;
		end
	end
endmodule
