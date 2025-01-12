module testbench;
    reg clk, reset;
    reg [7:0] opcode, address, data_in;
    wire [7:0] data_out;

    // IAS modülünü instantiate et
    IAS ias(
        .clk(clk),
        .reset(reset),
        .opcode(opcode),
        .address(address),
        .data_in(data_in),
        .data_out(data_out)
    );

    // Clock sinyali oluştur
    always begin
        #5 clk = ~clk;  // Saat sinyali her 5 birimde bir tersine döner
    end
    
    initial begin
        // Dump dosyasını oluştur
        $dumpfile("simulation.vcd");
        $dumpvars(0, testbench);


        
        // İlk ayarlar
        clk = 0;
        reset = 1;
        opcode = 8'd0;
        address = 8'd0;
        data_in = 8'd0;

        // Reset işlemi
        #10 reset = 0;
        $display("Reset işlemi tamamlandı.");

        // Monitor ile izlenecek sinyalleri ekleyin
        $monitor("Time: %0t | opcode: %d | address: %d | data_in: %d | mem_write: %d | mem_read: %d | AC: %d | data_out: %d | ias.mem.mem[1]: %d | ias.mem.mem[2]: %d | ias.mem.mem[3]: %d | add_enable: %d | load_ac: %d | load_mq: %d | load_pc: %d | load_ir: %d", 
                $time, opcode, address, data_in, ias.mem.mem_write, ias.mem.mem_read, ias.ac.ac_data, data_out, ias.mem.mem[1], ias.mem.mem[2], ias.mem.mem[3], ias.ac.add_enable, ias.cu.load_ac, ias.cu.load_mq, ias.cu.load_pc, ias.cu.load_ir);

        /*
        // Test 1: Belleğe veri yazma (manüel yükleme)
        
        // Belleğe veri yazma (manüel yükleme)
        $display("Load testi");
        $display("Bellege veri yukleniyor...");
        ias.mem.mem[1] = 8'd150; // Belleğin 1. adresine 150 değerini yükle
        #10;
        // Load işlemi
        $display("Load islemi basliyor...");
        opcode = 8'd1; // Load komutu
        address = 8'd1; // 1. adresteki veriyi yükle

        #30; // FETCH, DECODE ve EXECUTE için yeterli süre bekle
        $display("AC degeri kontrol ediliyor...");
        $display("Beklenen AC Degeri: 150, Gercek AC Degeri: %d", data_out);

        // Test sonucu değerlendirme
        if (data_out == 8'd150) begin
            $display("Test Basarili: Bellekten dogru veri yüklendi.");
        end else begin
            $display("Test Basarisiz: Beklenen deger 150, ancak %d alindi.", data_out);
        end
        */


        /*

        // İlk ayarlar
        clk = 0;
        reset = 1;
        opcode = 8'd0;
        address = 8'd0;
        data_in = 8'd0;

        // Reset işlemi
        #10 reset = 0;



        // Test 2: Store İşlemi
        // 1. Belleğe veri yükle
        $display("Store testi");
        $display("Bellege veri yukleniyor...");
        address = 8'd1;       // Belleğin 1. adresine veri yazılacak
        data_in = 8'd123;     // Yazılacak veri 123
        opcode = 8'd1;        // Load komutu (örnek)
        #20;                  // FETCH, DECODE, EXECUTE işlemleri için bekle

        // 2. Load edilen veriyi AC'ye yaz
        $display("AC'ye veri yükleniyor...");
        #20;                  // Load işleminin bitmesini bekle

        // 3. Store komutunu çalıştır
        $display("Store islemi basliyor...");
        opcode = 8'd2;        // Store komutu
        address = 8'd2;       // AC'deki veri, 2. adrese yazılacak
        #40;                  // FETCH, DECODE, EXECUTE ve WRITE_BACK işlemleri için bekle

        // 4. Store işlemini kontrol et
        $display("Store islemi kontrol ediliyor...");
        $display("Beklenen Bellek [2] Degeri: 123, Gercek Deger: %d", ias.mem.mem[2]);
        
        //$monitor("Time: %0t | opcode: %d | address: %d | data_in: %d | mem_write: %d | mem_read: %d | AC: %d | Mem[2]: %d", 
        //$time, opcode, address, data_in, ias.mem.mem_write, ias.mem.mem_read, ias.ac.ac_data, ias.mem.mem[2]);

        if (ias.mem.mem[2] == 8'd123) begin
            $display("Test Basarili: Dogru deger bellege yazildi.");
        end else begin
            $display("Test Basarisiz: Beklenen deger 123, ancak %d alindi.", ias.mem.mem[2]);
        end
        
        */


        /*
        // İlk ayarlar
        clk = 0;
        reset = 1;
        opcode = 8'd0;
        address = 8'd0;
        data_in = 8'd0;

        // Reset işlemi
        #10 reset = 0;
        */

        // Test 3: ADD işlemi
        //Testte 25 ve 50 değerlerini toplayıp 75 değerini elde etmeye çalışıyoruz.

        $display("ADD testi.");
        // Belleğe 1. değeri yaz
        $display("Belleğe veri yazılıyor...");
        address = 8'd1;
        data_in = 8'd25; // İlk değer
        opcode = 8'd2; // STORE komutu
        #40;

        // Belleğe 2. değeri yaz
        address = 8'd2;
        data_in = 8'd50; // İkinci değer
        opcode = 8'd2; // STORE komutu
        #40;

        // İlk değeri AC'ye yükle (LOAD işlemi)
        $display("AC'ye veri yükleniyor...");
        opcode = 8'd1; // LOAD komutu
        address = 8'd1;
        #40;

        // İkinci değeri AC ile topla (ADD işlemi)
        $display("AC ile veri toplanıyor...");
        opcode = 8'd3; // ADD komutu
        address = 8'd2;
        #40;        //en az 30 gerekiyor.

    

        // // Sonucu bellek 3'e yaz (STORE işlemi)
        // $display("Sonuç bellek 3'e yazılıyor...");
        // opcode = 8'd2; // STORE komutu
        // address = 8'd3; // Bellek 3'e yazılacak
        // #40;

        // AC'den belleğe yazma (STORE_AC)
        $display("AC'deki veri belleğe yazılıyor...");
        opcode = 8'd6;  // Yeni STORE_AC opcode
        address = 8'd3; // Bellek adresi
        #40; // Verilerin yazılması için bekle


        // Sonuç kontrolü: Bellek 3'ün verisini kontrol et
        $display("Sonuc Kontrolu...");
        $display("Bellek[3] Beklenen Degeri: 75, Gercek Degeri: %d", ias.mem.mem[3]);

        if (ias.mem.mem[3] == 8'd75) begin
            $display("Test Basarili: Bellek[3]'e dogru deger yazildi.");
        end else begin
            $display("Test Başarısız: Beklenen değer 75, ancak %d alındı.", ias.mem.mem[3]);
        end

        // Simülasyonu bitir
        #10;
        $finish;
    end

endmodule
