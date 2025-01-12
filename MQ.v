module MQ (
    input clk,
    input reset,
    input load_mq,
    input [7:0] mem_data,
    output reg [7:0] mq_data
    );
        always @(posedge clk or posedge reset) begin
            if (reset)
                mq_data <= 8'd0;
            else if (load_mq)
                mq_data <= mem_data;
    end
endmodule
