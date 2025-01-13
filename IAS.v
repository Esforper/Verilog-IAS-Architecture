module IAS (
    input clk,
    input reset,
    input [7:0] opcode,
    input [7:0] address,
    input [7:0] data_in,
    output [7:0] data_out
);
    wire load_ac, load_mq, load_pc, load_ir;
    wire mem_read, mem_write, increment_pc;
    wire [7:0] ac_data, mq_data, pc_data, ir_data, mem_data;
    wire add_enable, store_ac_enable;

    // Modülleri bağla
    AC ac(clk, reset, load_ac, add_enable,  mem_data, ac_data);
    MQ mq(clk, reset, load_mq, mem_data, mq_data);
    PC pc(clk, reset, load_pc, increment_pc, address, pc_data);
    IR ir(clk, reset, load_ir, mem_data, ir_data);
    // control_unit cu(clk, reset, opcode, load_ac, load_mq, load_pc, load_ir, mem_read, mem_write, increment_pc, add_enable, store_enable);
    control_unit cu(clk, reset, opcode, load_ac, load_mq, load_pc, load_ir, mem_read, mem_write, increment_pc, add_enable, store_ac_enable);
    memory mem(clk, mem_read, mem_write, address, (store_ac_enable == 1) ? ac_data : data_in, mem_data);
    assign data_out = ac_data; // Örneğin, sonuç AC üzerinden verilir
    
    
    
    // memory mem(
    //     .clk(clk), 
    //     .mem_read(mem_read), 
    //     .mem_write(mem_write), 
    //     .address(address), 
    //     .data_in(store_enable ? ac_data : data_in), 
    //     .mem_data(mem_data)
    // );

    // Çıkış
    
    //assign data_in = ac_data; // Örneğin, sonuç AC üzerinden verilir

    // assign data_in = (load_ac) ? ac_data :
    //              (load_mq) ? mq_data :
    //              (load_pc) ? pc_data :
    //              (load_ir) ? ir_data : 8'b0;
endmodule
