module note_player(
    input clk,
    input reset,
    input play_enable,  // When high we play, when low we don't.
    input [5:0] note_to_load,  // The note to play
    input [5:0] duration_to_load,  // The duration of the note to play
    input load_new_note,  // Tells us when we have a new note to load
    output done_with_note,  // When we are done with the note this stays high.
    input beat,  // This is our 1/48th second beat
    input generate_next_sample,  // Tells us when the codec wants a new sample
    output [15:0] sample_out,  // Our sample output
    output new_sample_ready  // Tells the codec when we've got a sample
);
    
    wire [19:0] step_size_freq_rom;
    
    // call frequency rom to get step size
    frequency_rom rom_instance (.clk(clk), .addr(note_to_load), .dout(step_size_freq_rom));
    
//    // flip flop here (in case of load_note being low)
//    wire [19:0] current_step_size_1; 
//    wire [19:0] next_step_size_1;
//    dffr #(.WIDTH(20)) delay_1(
//        .clk(clk), 
//        .r(reset),
//        .d(next_step_size_1), .q(current_step_size_1)); // was initally play_enable
        
//    assign next_step_size_1 = reset ? 20'd0 : step_size_freq_rom;
    
//    // need to add flip flop here
//    wire [19:0] current_step_size; 
//    wire [19:0] next_step_size;
//    dffre #(.WIDTH(20)) delay_2(
//        .clk(clk), 
//        .r(reset),
//        .d(next_step_size), .q(current_step_size), .en(load_new_note)); // load_note instead of play_enable?
        
//    assign next_step_size = reset ? 20'd0 : step_size_freq_rom; // was initially step-size-freq-rom
    
    wire [19:0] next_step_size; //(generate_next);
    wire [19:0] cur_step_size_1;
    wire [19:0] cur_step_size;
    dffr #(.WIDTH(20)) dff1 (.clk(clk), .r(reset), .d(next_step_size), .q(cur_step_size_1));
    dffre #(.WIDTH(20)) dff2 (.clk(clk), .r(reset), .d(cur_step_size_1), .q(cur_step_size), .en(play_enable)); 
    assign next_step_size = reset ? 20'd0 : step_size_freq_rom;
   
    
    // take output of rom and send it into sine_reader along with gen_next_sample
    wire new_sample;
    // current_step_size or current_step_size_1 == zeros in high test bench
    // current step_size
    sine_reader reader(.clk(clk), .reset(reset), .step_size(cur_step_size), .generate_next(generate_next_sample), .sample_ready(new_sample), .sample(sample_out));
    
    // don't send new sample ready if play enable is low
//    assign new_sample_ready = play_enable ? new_sample : 1'b0;
    
    wire [5:0] count_duration; // this is state var
    wire [5:0] next;
    reg [5:0] next1;
    reg check_done;
    
    dffre #(.WIDTH(6)) state_reg( // 6 is width
        .clk(clk), 
        .r(reset),
        .d(next), .q(count_duration), .en(play_enable));
    
    always @(*) begin
            if (count_duration == duration_to_load) begin
                // set note to done
                check_done = 1'b1;
                
                // reset count dur
                next1 = 5'd0;
            end
            else if (beat == 1'b1 && new_sample_ready == 1'b1) begin
                next1 = count_duration + 1;
                check_done = 1'b0;
            end
            else begin
                check_done = 1'b0;
                next1 = count_duration;
            end
    end
    assign next = reset ? 6'd0 : next1;
    
    // set note to done
    assign done_with_note = check_done;

endmodule









// module note_player(
//     input clk,
//     input reset,
//     input play_enable,  // When high we play, when low we don't.
//     input [5:0] note_to_load,  // The note to play
//     input [5:0] duration_to_load,  // The duration of the note to play
//     input load_new_note,  // Tells us when we have a new note to load
//     output done_with_note,  // When we are done with the note this stays high.
//     input beat,  // This is our 1/48th second beat
//     input generate_next_sample,  // Tells us when the codec wants a new sample
//     output [15:0] sample_out,  // Our sample output
//     output new_sample_ready  // Tells the codec when we've got a sample
// );
    
//     wire [19:0] step_size; // is this the right size?
    
//     // where to include load new note?????
//     // call frequency rom to get step size
//     frequency_rom rom_instance (.clk(clk), .addr(note_to_load), .dout(step_size)); // is note right address????? size wise
    
//     // need to add flip flop here
//     wire [19:0] out; 
//     wire [19:0] next_in;
//     dffr #(6) delay_1(
//         .clk(clk), 
//         .r(reset),
//         .d(next_in), .q(out));
        
//     assign next_in = step_size;
    
//     // take output of rom and send it into sine_reader along with gen_next_sample
//     // does the ternary operator make sense?
//     wire new_sample;
//     // load_new_note ? 
//     sine_reader reader(.clk(clk), .reset(reset), .step_size(step_size), .generate_next(generate_next_sample), .sample_ready(new_sample), .sample(sample_out));
    
//     // don't send new sample ready if play enable is low
//     assign new_sample_ready = play_enable ? new_sample : 1'b0;
    
//     wire [5:0] count_duration; // this is state var
//     wire [5:0] next;
//     reg [5:0] next1;
//     reg check_done;
    
//     dffr #(6) state_reg( // 6 is width
//         .clk(clk), 
//         .r(reset),
//         .d(next), .q(count_duration));
    
// //    always @(*) begin
// //        if (play_enable == 1'b1) begin
// //            if (count_duration == duration_to_load) begin
// //                // set note to done
// //                check_done = 1'b1;
// //                // reset count dur
// //                next1 = 5'd0;
// //            end
// //            else if (beat == 1'b1) begin
// //                next1 = count_duration + 1;
// //                check_done = 1'b0;
// //            end
// //            else begin
// //                check_done = 1'b0;
// //            end
// //        end
// //    end
// //    assign next = reset ? 5'd0 : next1;
    
// //    // set note to done
// //    assign done_with_note = check_done;

// endmodule
