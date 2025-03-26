package states;

typedef enum logic [2:0] {
    NORTH = 3'b000, NORTH_Y = 3'b001,
    SOUTH = 3'b010, SOUTH_Y = 3'b011,
    EAST = 3'b100, EAST_Y = 3'b101,
    WEST = 3'b110, WEST_Y = 3'b111
} state_t;

endpackage: states