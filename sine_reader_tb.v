module sine_reader_tb();

    reg clk, reset, generate_next;
    reg [19:0] step_size;
    wire sample_ready;
    wire [15:0] sample;
    sine_reader reader(
        .clk(clk),
        .reset(reset),
        .step_size(step_size),
        .generate_next(generate_next),
        .sample_ready(sample_ready),
        .sample(sample)
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
    step_size = 20'd100;
    
    repeat(50000) begin
        #5 generate_next = 1'b0;
        #25 generate_next = 1'b1;
    end
    step_size = 20'd50;
    
    repeat(50000) begin
        #5 generate_next = 1'b0;
        #25 generate_next = 1'b1;
    end
    
    end

endmodule
