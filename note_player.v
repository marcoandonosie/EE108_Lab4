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
    
    wire [19:0] step_size; // is this the right size?
    
    // where to include load new note?????
    // call frequency rom to get step size
    frequency_rom rom_instance (.clk(clk), .addr(note_to_load), .dout(step_size)); // is note right address????? size wise
    
    // take output of rom and send it into sine_reader along with gen_next_sample
    // do the ternary operators make sense?
    sine_reader sine_instance (.clk(clk), .reset(reset), .step_size(load_new_note ? step_size : 20'd0), .generate_next(generate_next_sample), .sample_ready(play_enable ? new_sample_ready : 1'b0), .sample(sample_out));
    
    // don't send new sample ready if play enable is low?
    
    wire [5:0] count_duration; // this is state var
    wire [5:0] next;
    reg [5:0] next1;
    reg check_done;
    
    dffr #(6) state_reg( // 6 is width
        .clk(clk), 
        .r(reset),
        .d(next), .q(count_duration));
    
    always @(*) begin
        if (play_enable == 1'b1) begin
            if (beat == 1'b1) begin
                next1 = count_duration + 1;
            end
            else if (count_duration == duration_to_load) begin
                // set note to done
                check_done = 1'b1;
                // reset count dur
                next1 = 5'd0;
            end
            else begin
            end
        end
    end
    assign next = reset ? 5'd0 : next1;
    
    // set note to done
    assign done_with_note = check_done;

endmodule
