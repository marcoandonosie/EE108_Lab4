module song_reader_tb();

    reg clk, reset, play, note_done;
    reg [1:0] song;
    wire [5:0] note;
    wire [5:0] duration;
    wire song_done, new_note;

    song_reader dut(
        .clk(clk),
        .reset(reset),
        .play(play),
        .song(song),
        .song_done(song_done),
        .note(note),
        .duration(duration),
        .new_note(new_note),
        .note_done(note_done)
    );

    // Clock and reset
    initial begin
        clk = 1'b0;
        reset = 1'b1;
        repeat (4) #5 clk = ~clk;
        reset = 1'b0;
        forever #5 clk = ~clk;
    end

    // Tests
    initial begin
        #33
        song = 2'd0;
        note_done = 1'd1;
        #10
        note_done = 1'd0;
        //testing to see if address increments by one; should print note at address 00 00001
        $display ("Playing a note of song %d, which is note %d duration %d", song, note, duration);
        $display ("expected song 00, note 1, duration 8");
        
        note_done = 1'd1;
        #10
        note_done = 1'd0;
        //should be at address 00 00002; testing address incrementing 
        $display ("Playing a note of song %d, which is note %d duration %d", song, note, duration);
        $display ("expected song 00, note 51, duration 12");
        #10

        note_done = 1'd1;
        #10
        note_done = 1'd0;
        #10
        note_done = 1'd1;
        #10
        note_done = 1'd0;
        //should be at address 00 00004; testing address incrementing 
        $display ("Playing a note of song %d, which is note %d duration %d", song, note, duration);
        $display ("expected song 00, note 52, duration 12");

        //testing the reset button; should reset to first note address of song 0
        reset = 1'b1;
        #10
        reset ' 1'b0
        $display ("Playing a note of song %d, which is note %d duration %d", song, note, duration);
        $display ("expected song 00, note 49, duration 12");
        
        
        //testing change song, should be in 01 00000
        song = 2'b01;
        $display ("Playing a note of song %d, which is note %d duration %d", song, note, duration);
        $display ("expected song 00, note 35, duration 36");

        #10
        //testing pause, nothing should change 
        play = 1'b0;
        #10
        $display("Playing a note of song %d, which is note %d duration %d", song, note, duration);
        $display ("expected song 00, note 35, duration 36");

        play = 1'b1;
        //testing fourth song
        #10
        song = 2'd3 
        $display("Playing a note of song %d, which is note %d duration %d", song, note, duration);
        $display ("expected song 00, note 40, duration 20");
    end

endmodule
