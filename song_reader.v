`define SONG_BEGIN 4'b0001 //fix corresponding indexes here later
`define NOTE_ONGOING 4'b0010
`define NOTE_DONE 4'b0100
`define SONG_DONE 4'b1000


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

//state register DFF
    dffre #(.WIDTH(2)) address_reg( //sorts through FSM
        .clk (clk),
        .r (rst), .en(enable_signal),
        .d (next_state), .q (state)
);

    //counter (address) register DFF
    dffre #(.WIDTH(5)) counter_reg( //increments on counter only when we're in the increment address state
        .clk (clk),
        .r (rst), .en(enable_signal),
        .d (next_address), .q (address)
);
   
    //set the note index (0-31) as the state
    wire [4:0] address, next_address;
    wire [1:0] state, next_state;

   
    //FSM  
 always @(*) begin
     case(state)
         'SONG_BEGIN: 'NOTE_ONGOING;
         'NOTE_ONGOING: (note_done) ? (note_done && address == 5'd31) ? 'SONG_DONE : 'NOTE_DONE) : 'NOTE_ONGOING;
         'NOTE_DONE: (note_done && address == 5'd31) ? 'SONG_DONE : 'NOTE_ONGOING;
         'SONG_DONE: state;
         default: state;
     endcase
 end
   
    assign next_state = reset ? `SONG_BEGIN : state; //assign next state IF no reset


always @(*) begin
    if (state == 'SONG_BEGIN) begin //am I understanding reset properly?
        next_address = 5'd0;
        new_note = 0;
        song_done = 0;
    end else if (state == 'NOTE_ONGOING) begin
        next_address = address;
        new_note = 0;
        song_done = 0;
    end else if (state == 'NOTE_DONE) begin
        next_address == address + 1;
        new_note = 1; //if note is DONE, send this signal next cycle; check timing
        song_done = 0;
    end else if (state == 'SONG_DONE) begin
        next_address = 5'd0;
        new_note = 0;
        song_done = 1;
        end
    end

    assign next_address = (State == increment) ? + 1 : address;
    assign new_note = ('NEW_NOTE) 1 : 0;


   
    wire [11:0] rom_output;
    assign address =  song_rom instance1 (.clk(clk), .addr(address), .dout(rom_output));
    assign note = rom_output[11:6];
    assign duration = address[5:0];

    //implement case where play is 0, and we turn off enable












    //below this is MOOT!!!!!!!
   
     case 1: (note != 5'd31) begin
            if (note_done) begin
                next_state = state + 1;
                new_note = 1;
                song_done = 0;
            end
        case 2: 31st note //should I do BEGINNING of 32nd note instead for song_done?
            if (note_done) begin
                next_state = 5'd0 //this doesnt matter!
                song_done = 1; //set output finally to 0!
                new_note =
            end
        default: no note change. Keep outputting the same note.
            next_state = state;
                song_done = 0
                new_note = 0
            end
        endcase
            end

         //Counter
         
           
   
    always @(*) begin
        case 1: any other note
            if (note_done) begin
                next_state = state + 1;
                new_note = 1;
                song_done = 0;
            end
        case 2: 31st note //should I do BEGINNING of 32nd note instead for song_done?
            if (note_done) begin
                next_state = 5'd0 //this doesnt matter!
                song_done = 1; //set output finally to 0!
                new_note =
            end
        default: no note change. Keep outputting the same note.
            next_state = state;
                song_done = 0
                new_note = 0
   

            assign next_state = rst ? 5'd0 : next;






             always @(*) begin
     case 1: (note != 5'd31) begin
            if (note_done) begin
                next_state = state + 1;
                new_note = 1;
                song_done = 0;
            end
        case 2: 31st note //should I do BEGINNING of 32nd note instead for song_done?
            if (note_done) begin
                next_state = 5'd0 //this doesnt matter!
                song_done = 1; //set output finally to 0!
                new_note =
            end
        default: no note change. Keep outputting the same note.
            next_state = state;
                song_done = 0
                new_note = 0
            end
        endcase
            end




           
            case0: after a RESET or just left a between-song pause
                address becomes {song, 5'b00000}; //beginning of inputted song choice
            //address =
                    if duration NOT 0, next_state is ALWAYS the same //only enter this once per song
            case1: same note; keep playing;
            //address = (note_done == 1'b1) ? address : address + 1;
                stay here if  note_done is NOT 1; if it is, then next_state = state
            case2: different note, same song; //note_done == 1
                next_state = song_address + 1
            case3: end note, different song; //if song_address[4:0] = 5'd31 AND note_done == 1
                enter 'END_SONG state // in another loop, if we enter this state, assign song_done = 1; else song_done = 0
            default: next_state = 4'b;
        endcase
    end




endmodule
