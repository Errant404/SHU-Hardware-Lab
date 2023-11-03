module led_display(
    input wire clk,
    input wire rst_n,
    input wire [3:0] mode,
    output reg [15:0] light_ctrl
);

    integer counter;
	integer i;

    // LED动态变化逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin 
            light_ctrl <= 16'd0;
            counter <= 3'd0;
        end else begin
            case (mode)
                4'd0: begin 
                    // 直接根据当前寄存器中存储的LED灯和数码管控制信息显示内容
                end
                4'd1: light_ctrl <= 16'b0101010101010101;
                4'd2: light_ctrl <= light_ctrl + 16'd1;
                4'd3: light_ctrl <= light_ctrl - 16'd1;
                4'd4: light_ctrl <= {light_ctrl[14:0], light_ctrl[15]};
                4'd5: light_ctrl <= {light_ctrl[0], light_ctrl[15:1]};
                4'd6: light_ctrl <= ~light_ctrl;
                4'd7: light_ctrl <= {light_ctrl[7:0], light_ctrl[15:8]};
                4'd8: begin // 将LED灯分成4个部分，1和4，2和3部分对闪，即4为1的按位取反，3为2的按位取反
                    light_ctrl[15:12] <= ~light_ctrl[3:0];
                    light_ctrl[11:8] <= ~light_ctrl[7:4];
                    light_ctrl[7:4] <= ~light_ctrl[11:8];
                    light_ctrl[3:0] <= ~light_ctrl[15:12];
                end
                4'd9: begin //整体从两边往中间亮
                    light_ctrl <= 16'b0000000000000000;
                    for (i = 0; i <= 7; i = i + 1) begin
						if (i <= counter) begin
                        	light_ctrl[i] <= 1'b1;
                        	light_ctrl[15-i] <= 1'b1;
						end
                    end
                    counter <= counter + 1;
                    if (counter == 7) begin
                        counter <= 0;
                    end
                end
                4'd10: begin //整体从中间往两边亮 
                    light_ctrl <= 16'b0000000000000000;
                    for (i = 0; i <= 7; i = i + 1) begin
						if (i <= counter) begin
	                        light_ctrl[7-i] <= 1'b1;
	                        light_ctrl[8+i] <= 1'b1;
						end
                    end
                    counter <= counter + 1;
                    if (counter == 7) begin
                        counter <= 0;
                    end
                end 
                4'd11: begin //
                    case (counter)
                        3'd0: light_ctrl <= 16'b0000000000000000;
                        3'd1: light_ctrl <= 16'b0000111100001111;
                        3'd2: light_ctrl <= 16'b1111000011110000;
                        3'd3: light_ctrl <= 16'b0000111100001111;
                        3'd4: light_ctrl <= 16'b1111000011110000;
                        3'd5: light_ctrl <= 16'b0000000000000000;
                        3'd6: light_ctrl <= 16'b1111111111111111;
                        default: light_ctrl <= 16'b0000000000000000;
                    endcase
                    counter <= counter + 1;
                    if (counter == 6) begin
                        counter <= 0;
                    end
                end
                4'd12: begin
                    light_ctrl = 16'b0000000000000000;

                    // 左半边灯从两边向中间依次亮
                    for (i = 0; i <= 3; i = i + 1) begin
						if (i <= counter) begin
	                        light_ctrl[4 + i] = 1'b1;
	                        light_ctrl[3 - i] = 1'b1;
						end
                    end

                    // 右半边灯从中间向两边依次亮
                    for (i = 0; i <= 3; i = i + 1) begin
						if (i <= counter) begin 
	                        light_ctrl[8 + i] = 1'b1;
	                        light_ctrl[15 - i] = 1'b1;
						end
                    end

                    counter <= counter + 1;
                    if (counter == 3) begin
                        counter <= 0;
                    end
                end
                default: light_ctrl <= 16'b0000000000000000;
            endcase
        end
    end

endmodule
