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
    input logic clk, rst,
    output logic [1:0] n_lights, s_lights, e_lights, w_lights
);
    
logic [2:0] count = 3'b000;
typedef enum logic [2:0] {
    NORTH = 3'b000, NORTH_Y = 3'b001,
    SOUTH = 3'b010, SOUTH_Y = 3'b011,
    EAST = 3'b100, EAST_Y = 3'b101,
    WEST = 3'b110, WEST_Y = 3'b111
} state_t;

state_t state;

always_ff @(posedge clk or negedge rst) begin
    if (rst) begin
    state <= NORTH;
    count <= 3'b000;
    end
    else begin
    case(state)
        NORTH: begin 
            if (count == 3'b111) begin
                count <= 3'b000;
                state <= NORTH_Y; end
            else begin
                state <= NORTH; 
                count++; end
        end
        NORTH_Y: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= SOUTH;
            end
            else begin
                state <= NORTH_Y; 
                count++; end
        end
        SOUTH: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= SOUTH_Y;
            end
            else begin
                state <= SOUTH; 
                count++; end
        end
        SOUTH_Y: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= EAST;
            end
            else begin
                state <= SOUTH_Y; 
                count++; end
        end
        EAST: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= EAST_Y;
            end
            else begin
                state <= EAST; 
                count++; end
        end
        EAST_Y: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= WEST;
            end
            else begin
                state <= EAST_Y; 
                count++; end
        end
        WEST: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= WEST_Y;
            end
            else begin
                state <= WEST; 
                count++; end
        end
        WEST_Y: begin
        if (count == 3'b111) begin
                count <= 3'b000;
                state <= NORTH;
            end
            else begin
                state <= WEST_Y; 
                count++; end
        end
        default: begin 
            state <= NORTH;
            count <= 3'b000; end        
    endcase
    end
end

    
always @(state)
begin
    case(state)
        NORTH: begin
            n_lights = 2'b10; 
            s_lights = 2'b00;
            e_lights = 2'b00;
            w_lights = 2'b00; end
        NORTH_Y: begin
            n_lights = 2'b01; 
            s_lights = 2'b00;
            e_lights = 2'b00;
            w_lights = 2'b00; end
        SOUTH: begin
            n_lights = 2'b00; 
            s_lights = 2'b10;
            e_lights = 2'b00;
            w_lights = 2'b00; end
         SOUTH_Y: begin
            n_lights = 2'b00; 
            s_lights = 2'b01;
            e_lights = 2'b00;
            w_lights = 2'b00; end
         EAST: begin
            n_lights = 2'b00; 
            s_lights = 2'b00;
            e_lights = 2'b10;
            w_lights = 2'b00; end
         EAST_Y: begin
            n_lights = 2'b00; 
            s_lights = 2'b00;
            e_lights = 2'b01;
            w_lights = 2'b00; end
         WEST: begin
            n_lights = 2'b00; 
            s_lights = 2'b00;
            e_lights = 2'b00;
            w_lights = 2'b10; end
         WEST_Y: begin
            n_lights = 2'b00; 
            s_lights = 2'b00;
            e_lights = 2'b00;
            w_lights = 2'b01; end
          
    endcase
end
endmodule
