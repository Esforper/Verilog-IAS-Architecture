module IR (
    input clk,
    input reset,
    input load_ir,
    input [7:0] mem_data,
    output reg [7:0] ir_data
    );
    always @(posedge clk or posedge reset) begin
        if (reset)
            ir_data <= 8'd0;
        else if (load_ir)
            ir_data <= mem_data;
    end
endmodule