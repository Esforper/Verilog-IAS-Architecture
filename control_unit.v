module control_unit (
    input clk,
    input reset,
    input [7:0] opcode,
    output reg load_ac, load_mq, load_pc, load_ir,
    output reg mem_read, mem_write,
    output reg increment_pc, // PC artırma sinyali
    output reg add_enable, // Toplama işlemi için sinyal
    output reg store_ac_enable  // AC'deki veriyi belleğe yazma sinyali
    // output reg store_enable  // AC'deki veriyi belleğe yazma sinyali
);
    // Durum tanımları
    parameter FETCH = 2'b00, DECODE = 2'b01, EXECUTE = 2'b10, WRITE_BACK = 2'b11;
    reg [1:0] state;
    reg [7:0] ir_reg;  // IR kayıt için ekledim

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            load_ac <= 0; load_mq <= 0; load_pc <= 0; load_ir <= 0;
            mem_read <= 0; mem_write <= 0; increment_pc <= 0; add_enable <= 0; 
            store_ac_enable <= 0; // Yeni sinyal
            // store_enable <= 0;
            state <= FETCH;
            // Tüm sinyalleri sıfırla
            
            ir_reg <= 0;
            //$display("log 2 : control_unit reset success - State: %b",state); // İşlemden önce opcode ve state");
        end else begin
            //$display("Log 3 : (after else begin) Opcode: %d, State: %b", opcode, state);
            case (state)
                FETCH: begin
                    mem_read <= 1;     // Bellekten komut oku
                    load_ir <= 1;      // IR'ye yükle
                    increment_pc <= 1; // PC'yi artır
                    state <= DECODE;   // Sonraki durum
                    //$display("log 4: fetch bitti - State: %b",state); // İşlemden önce opcode ve state
                end
                DECODE: begin
                    // Fetch aşamasını bitir
                    mem_read <= 0;
                    load_ir <= 0;
                    increment_pc <= 0;
                    ir_reg <= opcode; // Opcode IR'ye yüklendi
                    state <= EXECUTE; // Opcode'u işle
                    //$display("Log 5 : Decode bitti - State: %b",state); // İşlemden önce opcode ve state
                end
                    EXECUTE: begin
                    //$display("Log 6 : Opcode: %d, State: %b, Before Operation", opcode, state); // İşlemden önce opcode ve state
                    case (opcode)
                        8'd1: begin // Load
                            //$display("Log 7 : Opcode: %d, State: %b, Operation: Load start", opcode, state); // Burada işlemi de yazdırıyoruz
                            mem_read <= 1;  // Bellekten okuma işlemi başlat
                            load_ac <= 1;   // AC'yi yükle
                            //$display("Log 8 : Opcode: %d, State: %b, Operation: Load end / mem_read: %d , load_ac: %d  ", opcode, state, mem_read, load_ac); // Burada işlemi de yazdırıyoruz
                        end
                        8'd2: begin // Store
                            //$display("Log 9 : Opcode: %d, State: %b, Operation: Store", opcode, state);
                            mem_write <= 1;  // Belleğe yazma işlemi başlat
                            // store_enable <= 1; 
                        end
                        8'd3: begin // Add
                            //$display("Log 10 : Opcode: %d, State: %b, Operation: Add start", opcode, state);
                            mem_read <= 1;   // Bellekten veri oku
                            add_enable <= 1; // Toplama işlemini başlat
                        end

                        8'd4: begin // Sub
                            //$display("Log 12 : Opcode: %d, State: %b, Operation: Sub start", opcode, state);
                            mem_read <= 1;   // Bellekten veri oku
                            load_ac <= 1;    // Çıkarma sonucu AC'ye yazılacak
                        end
                        8'd5: begin // Jump
                            //$display("Log 13 : Opcode: %d, State: %b, Operation: Jump", opcode, state);
                            load_pc <= 1;   // PC'yi yükle
                            increment_pc <= 0; // Jump sırasında PC artırılmaz
                        end
                         8'd6: begin // STORE_AC (Yeni komut)
                            mem_write <= 1;       // Belleğe yazma işlemi başlat
                            store_ac_enable <= 1; // AC'deki veriyi yazma
                        end
                        default: ; // No operation
                    endcase
                    //$display("After Operation: mem_read: %b, load_ac: %b", mem_read, load_ac); // Debugging the signals
                    state <= WRITE_BACK;
                end

                WRITE_BACK: begin
                    // Tüm sinyalleri sıfırla ve FETCH'e dön
                    load_ac <= 0; load_mq <= 0; load_pc <= 0; load_ir <= 0;
                    mem_read <= 0; mem_write <= 0; increment_pc <= 0; add_enable <= 0; 
                    store_ac_enable <= 0; // Yeni sinyal sıfırlama
                    // store_enable <= 0;
                    state <= FETCH;
                end
            endcase
        end
    end
endmodule
