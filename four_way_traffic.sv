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

import states::*;

module four_way_traffic (
    input bit clk, rst,
    input state_t start_state,  // User-defined initial state
    output logic [1:0] n_lights, s_lights, e_lights, w_lights
);
    
logic [2:0] count = 3'b000;
state_t state;

always_ff @(posedge clk or negedge rst) begin
    if (!rst) begin
        // Use start_state if valid, otherwise default to NORTH
        state <= (start_state !== 'x) ? start_state : NORTH;
        count <= 3'b000;
    end 
    else begin
        case (state)
            NORTH:    state <= (count == 3'b111) ? NORTH_Y  : NORTH;
            NORTH_Y:  state <= (count == 3'b111) ? SOUTH    : NORTH_Y;
            SOUTH:    state <= (count == 3'b111) ? SOUTH_Y  : SOUTH;
            SOUTH_Y:  state <= (count == 3'b111) ? EAST     : SOUTH_Y;
            EAST:     state <= (count == 3'b111) ? EAST_Y   : EAST;
            EAST_Y:   state <= (count == 3'b111) ? WEST     : EAST_Y;
            WEST:     state <= (count == 3'b111) ? WEST_Y   : WEST;
            WEST_Y:   state <= (count == 3'b111) ? NORTH    : WEST_Y;
            default:  state <= NORTH;
        endcase

        if (count == 3'b111)
            count <= 3'b000;
        else
            count++;
    end
end

always_comb begin
    case(state)
        NORTH:    {n_lights, s_lights, e_lights, w_lights} = {2'b10, 2'b00, 2'b00, 2'b00};
        NORTH_Y:  {n_lights, s_lights, e_lights, w_lights} = {2'b01, 2'b00, 2'b00, 2'b00};
        SOUTH:    {n_lights, s_lights, e_lights, w_lights} = {2'b00, 2'b10, 2'b00, 2'b00};
        SOUTH_Y:  {n_lights, s_lights, e_lights, w_lights} = {2'b00, 2'b01, 2'b00, 2'b00};
        EAST:     {n_lights, s_lights, e_lights, w_lights} = {2'b00, 2'b00, 2'b10, 2'b00};
        EAST_Y:   {n_lights, s_lights, e_lights, w_lights} = {2'b00, 2'b00, 2'b01, 2'b00};
        WEST:     {n_lights, s_lights, e_lights, w_lights} = {2'b00, 2'b00, 2'b00, 2'b10};
        WEST_Y:   {n_lights, s_lights, e_lights, w_lights} = {2'b00, 2'b00, 2'b00, 2'b01};
        default:  {n_lights, s_lights, e_lights, w_lights} = {2'b00, 2'b00, 2'b00, 2'b00};
    endcase
end

endmodule