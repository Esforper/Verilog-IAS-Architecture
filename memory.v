module memory (
    input clk,
    input mem_read,
    input mem_write,
    input [7:0] address,
    input [7:0] data_in,
    output reg [7:0] mem_data
    );
    reg [7:0] mem [0:255]; // 256 Byte memory
    always @(posedge clk) begin
        if (mem_read)
            mem_data <= mem[address];
        if (mem_write)
            mem[address] <= data_in;
    end
endmodule
