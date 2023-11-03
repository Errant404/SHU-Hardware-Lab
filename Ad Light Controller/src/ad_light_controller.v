module ad_light_controller(
    input wire clk,              // 时钟信号
    input wire rst_n,            // 复位信号，低电平有效
    input wire [3:0] mode_select,      // 模式选择信号
    output wire [23:0] digit_ctrl,// 数码管控制信号（6个数码管，每个数码管4位）
    output wire [15:0] light_ctrl // 灯控制信号
);

    wire [3:0] current_mode;
    
    // 状态机模块实例
    mode_fsm u_mode_fsm(
        .clk(clk),
        .rst_n(rst_n),
        .mode_select(mode_select),
        .current_mode(current_mode)
    );
    
    // 数码管控制模块实例
    digit_display u_digit_display(
        .clk(clk),
        .rst_n(rst_n),
        .mode(current_mode),
        .digit_ctrl(digit_ctrl)
    );
    
    // LED控制模块实例
    led_display u_led_display(
        .clk(clk),
        .rst_n(rst_n),
        .mode(current_mode),
        .light_ctrl(light_ctrl)
    );

endmodule
