`define SONG_BEGIN 2'd0 //fix corresponding indexes here later
`define NOTE_ONGOING 2'd1
`define NOTE_DONE 2'd2
`define SONG_DONE 2'd3
`define width_address 5
`define width_state 2


module song_reader(
    input clk,
    input reset,
    input play,
    input [1:0] song,
    input note_done,
    output song_done,
    output [5:0] note,
    output [5:0] duration,
    output new_note
);

   
    //set the note index (0-31) as the state
    wire [4:0] address;
    reg [4:0] next_address_1;
    wire [4:0] next_address;
    wire [1:0] state;
    reg [1:0] next_state_1;
    wire [1:0] next_state;

//state register DFF
    dffre #(`width_state) address_reg( //sorts through FSM
        .clk (clk),
        .r (reset), .en(play),
        .d (next_state), .q (state)
);

    //counter (address) register DFF
    dffre #(`width_address) counter_reg( //increments on counter only when we're in the increment address state
        .clk (clk),
        .r (reset), .en(play),
        .d (next_address), .q (address)
);

   
    //FSM  
 always @(*) begin
     case(state)
         `SONG_BEGIN: next_state_1 = `NOTE_ONGOING;
         `NOTE_ONGOING: next_state_1 = (note_done) ? (address == 5'd31 ? `SONG_DONE : `NOTE_DONE) : `NOTE_ONGOING;
         `NOTE_DONE: next_state_1 = (note_done && address == 5'd31) ? `SONG_DONE : `NOTE_ONGOING;
         `SONG_DONE: next_state_1 = `SONG_DONE;
         default: next_state_1 = `SONG_BEGIN;
     endcase
 end
   
    assign next_state = reset ? `SONG_BEGIN : next_state_1; //assign next state IF no reset
    
    
    reg new_note1;
    reg song_done1;

always @(*) begin
    if (state == `SONG_BEGIN) begin //am I understanding reset properly?
        next_address_1 = 5'd0;
        new_note1 = 1; // 0
        song_done1 = 0;
    end else if (state == `NOTE_ONGOING) begin
        next_address_1 = address;
        new_note1 = 0;
        song_done1 = 0;
    end else if (state == `NOTE_DONE) begin
        next_address_1 = address + 1;
        new_note1 = 1; //if note is DONE, send this signal next cycle; check timing
        song_done1 = 0;
    end else if (state == `SONG_DONE) begin
        next_address_1 = 5'd0;
        new_note1 = 0; // change back to zero?
        song_done1 = 1;
        end
    end
    
    assign next_address = reset ? 5'd0 : next_address_1;

    //assign next_address = (state == 'NOTE_DONE) ? + 1 : address;
    //assign new_note = ('NEW_NOTE) 1 : 0;
    assign song_done = song_done1;
    assign new_note = new_note1;

   
    wire [11:0] rom_output;
    wire [6:0] full_address = {song, address};
    song_rom rom_instance(.clk(clk), .addr(full_address), .dout(rom_output));
    assign note = rom_output[5:0];
    assign duration = rom_output[11:6];
    
endmodule






--------------------------
`define SONG_BEGIN 2'd0 //fix corresponding indexes here later
`define NOTE_ONGOING 2'd1
`define NOTE_DONE 2'd2
`define SONG_DONE 2'd3
`define width_address 5
`define width_state 2


module song_reader(
    input clk,
    input reset,
    input play,
    input [1:0] song,
    input note_done,
    output song_done,
    output [5:0] note,
    output [5:0] duration,
    output new_note
);

   
    //set the note index (0-31) as the state
    wire [4:0] address;
    reg [4:0] next_address_1;
    wire [4:0] next_address;
    wire [1:0] state;
    reg [1:0] next_state_1;
    wire [1:0] next_state;

//state register DFF
    dffre #(`width_state) address_reg( //sorts through FSM
        .clk (clk),
        .r (reset), .en(play),
        .d (next_state), .q (state)
);

    //counter (address) register DFF
    dffre #(`width_address) counter_reg( //increments on counter only when we're in the increment address state
        .clk (clk),
        .r (reset), .en(play),
        .d (next_address), .q (address)
);

   
    //FSM  
 always @(*) begin
     case(state)
         `SONG_BEGIN: next_state_1 = `NOTE_ONGOING;
         `NOTE_ONGOING: next_state_1 = (note_done) ? (address == 5'd31 ? `SONG_DONE : `NOTE_DONE) : `NOTE_ONGOING;
         `NOTE_DONE: next_state_1 = (note_done && address == 5'd31) ? `SONG_DONE : `NOTE_ONGOING;
         `SONG_DONE: next_state_1 = state;
         default: next_state_1 = state;
     endcase
 end
   
    assign next_state = reset ? `SONG_BEGIN : next_state_1; //assign next state IF no reset
    
    
    reg new_note1;
    reg song_done1;

always @(*) begin
    if (state == `SONG_BEGIN) begin //am I understanding reset properly?
        next_address_1 = 5'd0;
        new_note1 = 0;
        song_done1 = 0;
    end else if (state == `NOTE_ONGOING) begin
        next_address_1 = address;
        new_note1 = 0;
        song_done1 = 0;
    end else if (state == `NOTE_DONE) begin
        next_address_1 = address + 1;
        new_note1 = 1; //if note is DONE, send this signal next cycle; check timing
        song_done1 = 0;
    end else if (state == `SONG_DONE) begin
        next_address_1 = 5'd0;
        new_note1 = 0;
        song_done1 = 1;
        end
    end
    
    assign next_address = reset ? 5'd0 : next_address_1;

    //assign next_address = (state == 'NOTE_DONE) ? + 1 : address;
    //assign new_note = ('NEW_NOTE) 1 : 0;
    assign song_done = song_done1;
    assign new_note = new_note1;

   
    wire [11:0] rom_output;
    wire [6:0] full_address = {song, address};
    song_rom rom_instance(.clk(clk), .addr(full_address), .dout(rom_output));
    assign note = rom_output[11:6];
    assign rom_output = address[5:0];
    
endmodule
