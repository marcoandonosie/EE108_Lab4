module sine_reader(
    input clk,
    input reset,
    input [19:0] step_size,
    input generate_next,

    output sample_ready,
    output wire [15:0] sample
);
    wire signed [21:0] cur_addr; // {quadrant. address, precision}
    wire signed [21:0] cur_addr_temp;
    wire signed [21:0] next_addr; 
    wire signed [15:0] sample_out; // reg to go into sine_rom
    
    // initialize DFF 
    dffre #(.WIDTH(22)) counter (.clk(clk), .r(reset), .d(next_addr), .q(cur_addr), .en(generate_next));
    
    // increment the current address: if we are in quadrants 00 or 10, increment your
    // address through the ROM, else, decrement your address through the ROM
    
    assign next_addr = (reset) ? 22'd0 : cur_addr + {2'b00, step_size}; // keep incrementing the address by the step size to change the quadrant naturally
    
    assign cur_addr_temp = (cur_addr[20]) ? {cur_addr[21:20], ~cur_addr[19:0]} : cur_addr; // for quadrants 01 and 11, invert bits       
                                        
    // step through sine ROM, only taking first 10 bits of cur_addr as our address
    sine_rom rom_instance (.clk(clk), .addr(cur_addr_temp[19:10]), .dout(sample_out));
    
    // need to invert the output depending on the quadrant + we can only output a sample
    // when generate_next is high
     assign sample = (cur_addr[21]) ? 
                   -sample_out : sample_out;

     
    // delay sample_ready by two clock cycles 
    wire d1 = generate_next; // 1'b1; //(generate_next);
    wire q1; 
    
    dffr dff1 (.clk(clk), .r(reset), .d(d1), .q(q1));
    dffr dff2 (.clk(clk), .r(reset), .d(q1), .q(sample_ready)); 
   

endmodule