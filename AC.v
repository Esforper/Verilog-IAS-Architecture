module AC (
    input clk,
    input reset,
    input load_ac,
    input add_enable, // Bellekteki değeri AC'ye eklemek için
    input [7:0] mem_data,
    output reg [7:0] ac_data
);
    always @(posedge clk or posedge reset) begin
    if (reset) begin
        ac_data <= 8'd0; // Reset durumunda AC sıfırlanır
    end else if (load_ac) begin
        ac_data <= mem_data; // Bellekten alınan değer AC'ye yüklenir
    end else if (add_enable) begin
        //$display("AC toplama icerisi ac_data: %d, Mem: %d", ac_data, mem_data);
        ac_data <= ac_data + mem_data; // Bellekten alınan değer AC'ye eklenir
        //$display("AC toplama sonu ac_data: %d, Mem: %d", ac_data, mem_data);
    end
end

endmodule
