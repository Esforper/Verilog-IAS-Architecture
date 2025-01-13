module PC (
    input clk,
    input reset,
    input load_pc,
    input increment_pc, // Yeni: PC'yi bir artırmak için sinyal
    input [7:0] address,
    output reg [7:0] pc_data
    );

    always @(posedge clk or posedge reset) begin
        if (reset)
            pc_data <= 8'd0; // Reset durumunda PC sıfırlanır
        else if (load_pc)
            pc_data <= address; // (jump) Harici bir değer yüklenir
        else if (increment_pc)
            pc_data <= pc_data + 8'd1; // PC bir artırılır
            //PC nin pc_data ile çıkardığı sonucu bir artırır.
    end
endmodule