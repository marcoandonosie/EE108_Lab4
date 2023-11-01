






// module sine_reader(
//     input clk,
//     input reset,
//     input [19:0] step_size,
//     input generate_next,

//     output sample_ready,
//     output wire [15:0] sample
// );
//     wire [21:0] cur_addr; // {address, presicision, quadrant}
//     reg [21:0] next_addr; 
//     wire [15:0] sample_out; // reg to go into sine_rom
//     reg signed [19:0] next_value; // used to calculate next_addr within case statement
//     reg [19:0] END_OF_ROM = {10'd1023, 10'd0};
//     reg [19:0] ROM_BEGINNING = 20'd0;
    
    

    
//     // initialize DFF 
//     dffr #(.WIDTH(22)) counter (.clk(clk), .r(reset), .d(next_addr), .q(cur_addr));
    
//     // increment the current address: if we are in quadrants 00 or 10, increment your
//     // address through the ROM, else, decrement your address through the ROM
    
//     always @ (*) begin
//         if (cur_addr[1:0] == 2'b00 || cur_addr[1:0] == 2'b10) begin // quad 1 or 3: increment through ROM
//             next_value = cur_addr[21:2] + step_size;
//             if (next_value > END_OF_ROM) begin // handles case where we go past the end of the ROM
//                 next_addr[21:2] = END_OF_ROM - (next_value - END_OF_ROM); 
//                 next_addr[1:0] = (cur_addr[1:0] == 2'b00) ? 2'b01 : 2'b11;
//              end else begin // regular case of decrementing address thru rom
//                 next_addr[21:2] = next_value;
//                 next_addr[1:0] = cur_addr[1:0]; 
//              end
//        end else 
//        if (cur_addr[1:0] == 2'b01 || cur_addr[1:0] == 2'b11) begin // quad 2  or 4: decrement through ROM
//             next_value = cur_addr[21:2] - step_size;
//             if (next_value < ROM_BEGINNING) begin // handles case where we go past the begining of ROM
//                 next_addr[21:2] = ROM_BEGINNING - next_value;
//                 next_addr[1:0] = (cur_addr[1:0] == 2'b01) ? 2'b10 : 2'b00;
//             end else begin // regular case of decrementing address thru rom
//                 next_addr[21:2] = next_value;
//                 next_addr[1:0] = cur_addr[1:0]; 
//                 end
//        end else begin // INITIAL STATE
//             next_addr[21:2] = ROM_BEGINNING + step_size;
//             next_addr[1:0] = 2'b00;
//        end
//      end
                                  
//     // step through sine ROM, only taking first 10 bits of cur_addr as our address
//     sine_rom rom_instance (.clk(clk), .addr(cur_addr[21:2]), .dout(sample_out));
    
//     // need to invert the output depending on the quadrant + we can only output a sample
//     // when generate_next is high
//      assign sample = (cur_addr[1:0] == 2'b10|| cur_addr[1:0] == 2'b11) ? 
//                     15'd0 - sample_out : sample_out;
     

//      assign sample_ready = (generate_next);
     
  

// endmodule
