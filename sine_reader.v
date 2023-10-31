module sine_reader(
    input clk,
    input reset,
    input [19:0] step_size,
    input generate_next,

    output sample_ready,
    output wire [15:0] sample
);
    wire [19:0] cur_addr;
    reg [19:0] next_addr; 
    wire [15:0] sample_out; // reg to go into sine_rom
    reg [19:0] next_value; // used to calculate next_addr within case statement
    reg [9:0] END_OF_ROM = 10'd1023;
    reg [9:0] ROM_BEGINNING = 10'd0;
    reg [1:0] QUAD;
    

    
    // initialize DFF 
    dffr #(.WIDTH(22)) counter (.clk(clk), .r(reset), .d({next_addr, QUAD}), .q({cur_addr, QUAD}));
    
    // increment the current address: if we are in quadrants 00 or 10, increment your
    // address through the ROM, else, decrement your address through the ROM
    
    always @ (*) begin
        case(QUAD)
            2'b00: begin
                next_value = cur_addr + step_size;
                if (next_value[19:9] > END_OF_ROM) begin
                    // go backwards from the end of the rom
                    // and change to the second quadrant
                    next_addr = END_OF_ROM - (next_value - END_OF_ROM);
                    QUAD = 2'b01;
                    end
                else begin
                    next_addr = next_value;
                    end
             end
            2'b01: begin
                next_value = cur_addr - step_size; // ARE THESE VALUES SIGNED OR UNSIGNED
                if (next_value[19:9] < ROM_BEGINNING) begin
                    // if next address is past rom beginning
                    // change to third quadrant
                    next_addr = 19'd0 - next_value;
                    QUAD = 2'b10;
                    end
                 else begin
                    next_addr = next_value;
                    end
            end
            2'b10: begin
               next_value = cur_addr + step_size;
                if (next_value[19:9] > END_OF_ROM) begin
                    // go backwards from the end of the rom
                    // and change to the 4th quadrant
                    next_addr = END_OF_ROM - (next_value - END_OF_ROM);
                    QUAD = 2'b11;
                    end
                else begin
                    next_addr = next_value;
                    end
             end
             2'b11: begin
             next_value = cur_addr - step_size; // ARE THESE VALUES SIGNED OR UNSIGNED
                if (next_value[19:9] < ROM_BEGINNING) begin
                    // if next address is past rom beginning
                    // change to first quadrant
                    next_addr = 0 - next_value;
                    QUAD = 2'b00;
                    end
                 else begin
                    next_addr = next_value;
                    end
             end
             default: begin // INITIAL STATE
             QUAD = 2'b00;
             next_addr = ROM_BEGINNING + step_size;
             end
            endcase
            end
                    
    // step through sine ROM, only taking first 10 bits of cur_addr as our address
    sine_rom rom_instance (.clk(clk), .addr(next_addr[19:11]), .dout(sample_out));
    
    // need to invert the output depending on the quadrant + we can only output a sample
    // when generate_next is high
     assign sample = (QUAD == 2'b10 || QUAD == 2'b11) ? 
                    15'd0 - sample_out : sample_out;
     

     assign sample_ready = (generate_next);
     
  

endmodule
