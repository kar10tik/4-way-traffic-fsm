`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05.07.2024 21:19:40
// Design Name: 
// Module Name: four_way_traffic
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


module four_way_traffic(
    input logic clk, rst, output reg[1:0] n_lights = 2'b00,
    s_lights = 2'b00, e_lights = 2'b00, w_lights = 2'b00);
    
logic [2:0] state = 3'b000, count = 3'b000;
parameter [2:0] north = 3'b000, north_y = 3'b001,
south = 3'b010, south_y = 3'b011, east = 3'b100,
east_y = 3'b101, west = 3'b110, west_y = 3'b111;
    
always @(negedge rst)
begin
if (rst) begin
    state <= north;
    count <= 3'b000;
    end
end

always @(posedge clk) begin
    case(state)
        north: begin 
            if (count == 3'b111) begin
                count <= 3'b000;
                state <= north_y; end
            else begin
                state <= north; 
                count++; end
        end
        north_y: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= south;
            end
            else begin
                state <= north_y; 
                count++; end
        end
        south: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= south_y;
            end
            else begin
                state <= south; 
                count++; end
        end
        south_y: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= east;
            end
            else begin
                state <= south_y; 
                count++; end
        end
        east: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= east_y;
            end
            else begin
                state <= east; 
                count++; end
        end
        east_y: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= west;
            end
            else begin
                state <= east_y; 
                count++; end
        end
        west: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= west_y;
            end
            else begin
                state <= west; 
                count++; end
        end
        west_y: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= north;
            end
            else begin
                state <= west_y; 
                count++; end
        end
        default: begin 
            state <= north;
            count <= 3'b000; end        
    endcase
end

    
always @(state)
begin
    case(state)
        north: begin
            n_lights = 2'b10; 
            s_lights = 2'b00;
            e_lights = 2'b00;
            w_lights = 2'b00; end
        north_y: begin
            n_lights = 2'b01; 
            s_lights = 2'b00;
            e_lights = 2'b00;
            w_lights = 2'b00; end
        south: begin
            n_lights = 2'b00; 
            s_lights = 2'b10;
            e_lights = 2'b00;
            w_lights = 2'b00; end
         south_y: begin
            n_lights = 2'b00; 
            s_lights = 2'b01;
            e_lights = 2'b00;
            w_lights = 2'b00; end
         east: begin
            n_lights = 2'b00; 
            s_lights = 2'b00;
            e_lights = 2'b10;
            w_lights = 2'b00; end
         east_y: begin
            n_lights = 2'b00; 
            s_lights = 2'b00;
            e_lights = 2'b01;
            w_lights = 2'b00; end
         west: begin
            n_lights = 2'b00; 
            s_lights = 2'b00;
            e_lights = 2'b00;
            w_lights = 2'b10; end
         west_y: begin
            n_lights = 2'b00; 
            s_lights = 2'b00;
            e_lights = 2'b00;
            w_lights = 2'b01; end
    endcase
end
endmodule
