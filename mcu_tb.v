module mcu_tb();
    reg clk, reset, play_button, next_button, song_done;
    wire play, reset_player;
    wire [1:0] song;

    mcu dut(
        .clk(clk),
        .reset(reset),
        .play_button(play_button),
        .next_button(next_button),
        .play(play),
        .reset_player(reset_player),
        .song(song),
        .song_done(song_done)
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
        play_button = 1'b1;
        #12
        play_button = 1'b0;
        #12
        $display(play, ", expected 0");
        $display(song, ", expected 0");
        
        next_button = 1'b1;
        #12
        next_button = 1'b0;
        play_button = 1'b1;
        #12
        $display(play, ", expected 1");
        $display(song, ", expected 1");
        
        play_button = 1'b0;
        next_button = 1'b1;
        #12
        play_button = 1'b1;
        #12
        $display(play, ", expected 1");
        $display(song, ", expected 2");
        
        play_button = 1'b0;
        next_button = 1'b1;
        #12
        play_button = 1'b1;
        #12
        $display(play, ", expected 1");
        $display(song, ", expected 3");
        
        play_button = 1'b0;
        #12
        $display(play, ", expected 0");
        $display(song, ", expected 3");
//        play_button = 1'b1;
//        // song_done = 1'b0;
//        #15
//        $display(play, ", expected 1");
//        play_button = 1'b0;
//        #15
//        $display(song, ", expected 0");
//        $display(play, ", expected 0");
        

//        next_button = 1'b1;
//        #15
//        next_button = 1'b0;
//        play_button = 1'b1;
//        #15
//        play_button = 1'b0;
//        #15
//        $display(play, ", expected 0"); // fucked
//        $display(reset_player, ", expected 0");
//        $display(song, ", expected 1"); // fucked
//        // $display(song_done, ", expected 0"); 
        
//        play_button = 1'b1;
//        #15
//        $display(play, ", expected 1");
//        $display(song, ", expected 0"); // fucked
        
//        play_button = 1'b0;
//        #15
//        play_button = 1'b1;
//        #15
//        $display(play, ", expected 1");
//        $display(song, ", expected 1");
        
        
    end

endmodule
