`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.08.2024 19:41:28
// Design Name: 
// Module Name: four_way_traffic_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module four_way_traffic_tb;
    logic CLK = 1'b0, RST = 1'b1; 
    logic [1:0] N_LIGHTS, S_LIGHTS, E_LIGHTS, W_LIGHTS;

    // Instantiate DUT
    four_way_traffic fwt (
        .clk(CLK), .rst(RST),
        .n_lights(N_LIGHTS), .s_lights(S_LIGHTS),
        .e_lights(E_LIGHTS), .w_lights(W_LIGHTS)
    );

    // Generate clock signal
    always #5 CLK = ~CLK;

    // Test sequence
    initial begin

        $display("Reset");
        #5 RST = 1'b0;

        $monitor("Time = %0t, State: N=%b, S=%b, E=%b, W=%b", 
                 $time, N_LIGHTS, S_LIGHTS, E_LIGHTS, W_LIGHTS);

        #200;
        $display("Simulation complete");
        $stop;
    end

endmodule