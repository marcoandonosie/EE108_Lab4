`define WIDTH 9
`define PAUSE0 9'd1
`define SONG0 9'd2
`define PAUSE1 9'd4
`define SONG1 9'd8
`define PAUSE2 9'd16
`define SONG2 9'd32
`define PAUSE3 9'd64
`define SONG3 9'd128
`define MASTER_PAUSE 9'd256

module mcu(
    input clk,
    input reset,
    input play_button,
    input next_button,
    output play, 
    output reset_player,
    output [1:0] song,
    input song_done
);
    // Implementation goes here!
    wire [`WIDTH - 1:0] state;
    wire [`WIDTH - 1:0] next;
    reg [`WIDTH - 1:0] next1;
    
    dffr #(`WIDTH) state_reg(
        .clk(clk), 
        .r(reset),
        .d(next), .q(state));
   
    reg [8:0] save_song;
    
    always @(*) begin
        case(state)
            `PAUSE0: next1 = play_button ? `SONG0 : (next_button ? `PAUSE1 : `PAUSE0);
            `SONG0: begin
                next1 = play_button ? `MASTER_PAUSE : (next_button || song_done ? `PAUSE1 : `SONG0);
                if (play_button == 1'b1) begin
                    save_song = `SONG0;
                end
            end  
            `PAUSE1: next1 = play_button ? `SONG1 : (next_button ? `PAUSE2 : `PAUSE1);
            `SONG1: begin
                next1 = play_button ? `MASTER_PAUSE : (next_button || song_done ? `PAUSE2 : `SONG1);
                if (play_button == 1'b1) begin
                    save_song = `SONG1;
                end
            end 
            `PAUSE2: next1 = play_button ? `SONG2 : (next_button ? `PAUSE3 : `PAUSE2);
            `SONG2: begin
                next1 = play_button ? `MASTER_PAUSE : (next_button || song_done ? `PAUSE3 : `SONG2);
                if (play_button == 1'b1) begin
                    save_song = `SONG2;
                end
            end
            `PAUSE3: next1 =  play_button ? `SONG3 : (next_button ? `PAUSE0 : `PAUSE3);
            `SONG3: begin
                next1 = play_button ? `MASTER_PAUSE : (next_button || song_done ? `PAUSE0 : `SONG3);
                if (play_button == 1'b1) begin
                    save_song = `SONG3;
                end
            end
            `MASTER_PAUSE: begin
                if (play_button == 1'b1) begin
                    next1 = save_song;
                end
                else if (next_button == 1'b1) begin
                    // case where in master pause but skip to next song
                    case(save_song)
                        `SONG0: next1 = `PAUSE1;
                        `SONG1: next1 = `PAUSE2;
                        `SONG2: next1 = `PAUSE3;
                        `SONG3: next1 =  `PAUSE0;
                    endcase
                end
                else begin
                    next1 = `MASTER_PAUSE;
                end
            end
            default: next1 = `PAUSE0;
        endcase 
    end // song nd play not updating properly
    
    assign next = reset ? `PAUSE0 : next1;
    
    // assign song output
    reg [1:0] song_temp;
    always @(*) begin
        case(save_song)
            `SONG0: song_temp = 2'b00;
            `SONG1: song_temp = 2'b01;
            `SONG2: song_temp = 2'b10;
            `SONG3: song_temp = 2'b11;
            default: song_temp = 2'b00;
        endcase
    end
    assign song = song_temp;
    
    // assign play output
    reg play_temp;
    always @(*) begin
        case(state)
            `PAUSE0: play_temp = 1'b0;
            `PAUSE1: play_temp = 1'b0;
            `PAUSE2: play_temp = 1'b0;
            `PAUSE3: play_temp = 1'b0;
            `MASTER_PAUSE: play_temp = 1'b0;
            default: play_temp = 1'b1;
        endcase
    end
    assign play = play_temp;
    
    // assign reset_player
    reg reset_player_temp;
    always @(*) begin
        if (next_button == 1'b1) begin
            reset_player_temp = 1'b1;
        end
        else begin
            reset_player_temp = 1'b0;
        end
    end
    assign reset_player = reset_player_temp;

endmodule