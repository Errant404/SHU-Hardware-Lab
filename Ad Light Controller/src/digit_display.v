module digit_display(
    input wire clk,
    input wire rst_n,
    input wire [3:0] mode,
    output reg [23:0] digit_ctrl // 每个数码管4位，共6个数码管
);

    // 定义一个寄存器来存储6个数码管的值
    reg [3:0] digits [5:0];
    reg [2:0] current_digit; // 当前数码管
    reg [3:0] value;         // 当前数码管的值
    reg [3:0] counter;       // 计数器
    
    integer i;

    // 初始化数码管
    initial begin
        for (i = 0; i < 6; i = i + 1) begin
            digits[i] = 4'd2;
        end
        current_digit = 3'd0;
        value = 4'd0;
        counter = 4'd0;
		i <= 0;
    end

    // 数码管动态变化逻辑
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 6; i = i + 1) begin
                digits[i] <= 4'd0;
            end
        end else begin
            case (mode)
                4'd0: begin 
                   // 直接根据当前寄存器中存储的LED灯和数码管控制信息显示内容
                end
                4'd1: begin // 固定值0101
                    for (i = 0; i < 6; i = i + 1) begin
                        digits[i] <= 4'b0101;
                    end
                end 
                4'd2: begin // 递增，循环
                    for (i = 0; i < 6; i = i + 1) begin
                        if (digits[i] == 4'd9)
                            digits[i] <= 4'd0;
                        else
                            digits[i] <= digits[i] + 4'd1;
                    end
                end
                4'd3: begin // 递减，循环
                    for (i = 0; i < 6; i = i + 1) begin
                        if (digits[i] == 4'd0)
                            digits[i] <= 4'd9;
                        else
                            digits[i] <= digits[i] - 4'd1;
                    end
                end
                4'd4: begin // 循环左移
                    for (i = 0; i < 6; i = i + 1) begin
                        digits[i] <= {digits[i][2:0], digits[i][3]};
                    end
                end
                4'd5: begin // 循环右移
                    for (i = 0; i < 6; i = i + 1) begin
                        digits[i] <= {digits[i][0], digits[i][3:1]};
                    end
                end
                4'd6: begin // 按位取反
                    for (i = 0; i < 6; i = i + 1) begin
                        digits[i] <= 4'd9 - digits[i];
                    end
                end
                4'd7: begin // 循环双左移
                    for (i = 0; i < 6; i = i + 1) begin
                        digits[i] <= {digits[i][1:0], digits[i][3:2]};
                    end
                end
                4'd8: begin // 1、6, 2、5, 3、4数码管进行对闪
                    for (i = 0; i < 3; i = i + 1) begin
                        digits[i] = counter;
                    end
                    for (i = 3; i < 6; i = i + 1) begin 
                        digits[i] = 4'd9 - counter;
                    end

                    if (counter < 4'd9) begin
                        counter <= counter + 4'd1;
                    end else begin
                        counter <= 4'd0;
                    end
                end   
                 4'd9: begin // 从两边向中间，显示依次变化
                    if (counter < 4'd9) begin
                        counter <= counter + 4'd1;
                    end else begin
                        counter <= 4'd0;
                    end

                    digits[0] <= counter;
                    digits[5] <= counter;
                    if (counter > 4'd3) begin
                        digits[1] <= counter - 4'd3;
                        digits[4] <= counter - 4'd3;
                    end else begin
                        digits[1] <= 4'd0;
                        digits[4] <= 4'd0;
                    end
                    if (counter > 4'd7) begin
                        digits[2] <= counter - 4'd7;
                        digits[3] <= counter - 4'd7;
                    end else begin
                        digits[2] <= 4'd0;
                        digits[3] <= 4'd0;
                    end
                end
                4'd10: begin // 从中间向两边，显示依次变化
                    if (counter < 4'd9) begin
                        counter <= counter + 4'd1;
                    end else begin
                        counter <= 4'd0;
                    end

                    digits[2] <= counter;
                    digits[3] <= counter;
                    if (counter > 4'd3) begin
                        digits[1] <= counter - 4'd3;
                        digits[4] <= counter - 4'd3;
                    end else begin
                        digits[1] <= 4'd0;
                        digits[4] <= 4'd0;
                    end
                    if (counter > 4'd7) begin
                        digits[0] <= counter - 4'd7;
                        digits[5] <= counter - 4'd7;
                    end else begin
                        digits[0] <= 4'd0;
                        digits[5] <= 4'd0;
                    end
                end
                4'd11: begin // 从左到右依次闪烁
                    if (current_digit < 3'd5) begin
                        current_digit <= current_digit + 3'd1;
                    end else begin
                        current_digit <= 3'd0;
                        value <= (value == 4'd8) ? 4'd0 : value + 4'd1;
                    end

                    digits[current_digit] <= value + 4'd1;
                end
                4'd12: begin //从右到左依次闪烁
                    if (current_digit < 3'd5) begin
                        current_digit <= current_digit + 3'd1;
                    end else begin
                        current_digit <= 3'd0;
                        value <= (value == 4'd8) ? 4'd0 : value + 4'd1;
                    end
                    digits[5 - current_digit] <= value + 4'd1;
                end
                default: begin
                    for (i = 0; i < 6; i = i + 1) begin
                        digits[i] <= 4'b0000;
                    end
                end
            endcase
        end
    end

    // 将数码管值输出到digit_ctrl
    always @(*) begin
        for (i = 0; i < 6; i = i + 1) begin
            digit_ctrl[i*4 +: 4] = digits[i];
        end
    end

endmodule
