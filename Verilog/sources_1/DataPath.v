`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 04:08:35 PM
// Design Name: 
// Module Name: DataPath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
`include "defines.v"


module DataPath(input clk, rst, input [1:0] led_sel, input[3:0]SSD_sel, output reg[15:0] LED, output reg[12:0] ssd);


     wire [31:0]pc_out; 
    wire [31:0]pc_in, pc_mux1_out;
    
    //----------------------------------------------------------------------
    wire  [31:0]Inst;
    //----------------------------------------------------------------------
    wire Branch, MemRead ,MemtoReg ,MemWrite ,ALUSrc ,RegWrite, AUIPCsel;
    wire Jal,Jalr;//Jumping-Tawfik
    wire cf, zf, vf, sf;
    wire [1:0] ALUOp;


    //----------------------------------------------------------------------
    wire [3:0]ALU_selection;
    //----------------------------------------------------------------------

    wire [31:0] r_data1, r_data2;
    //----------------------------------------------------------------------
    wire [31:0] immediate, new_imm;
    //----------------------------------------------------------------------
    wire [31:0] jump_inst_sum;
    wire  jump_inst_cout;

    wire [31:0] pc_update_sum;
    wire  pc_update_cout;
    //----------------------------------------------------------------------
    wire[31:0] alu_in2;
    wire[31:0] alu_in1;
    wire[31:0] alu_out;

    //----------------------------------------------------------------------

    wire [31:0] mem_data_out;
    wire [31:0] reg_write_data, RF_data_in;
    //-----------------------------system instructions--------------------------------
    wire ecall;
    wire [31:0] pc_mux2_out;


    nbit_mux #(32) mx_pc(.a(pc_in),.b(pc_out),.s(ecall),.c(pc_mux2_out)); //PC MUX for ecall Hussein

    NBitReg #(32)pc(.clk(clk), .rst(rst),.Load(1), .D(pc_mux2_out),.Q(pc_out));
   

    InstMem IM(.addr(pc_out[7:2]), .data_out(Inst));
    
    nbit_mux #(32) mx_RF_writedata(.a(reg_write_data),.b(pc_out+4),.s(Jal|Jalr),.c(RF_data_in)); // Write-data MUX    //Jumping-Tawfik
    
    N_bit_RegFile#(32) nbrf(.r_addr1(Inst[19:15]), .r_addr2(Inst[24:20]),.w_addr(Inst[11:7]), .w_data(RF_data_in),.w_en(RegWrite),.clk(clk), .rst(rst), .r_data1(r_data1), .r_data2(r_data2));//Jumping-Tawfik

    ImmGen immgen(.IR(Inst), .gen_out(immediate));// A big error lives here
    nBit_Shift_Left#(32) n_bit_shifter(.num(immediate), .res(new_imm));//Can use shifter module here


    nbit_mux #(32) mxalu(.a(r_data2),.b(immediate),.s(ALUSrc),.c(alu_in2)); //ALU _ MUX
    nbit_mux #(32) mxAUIPCalu(.a(r_data1), .b(pc_out), .s(AUIPCsel), .c(alu_in1)); //ALU_MUX for AUIPC

    CU cu( .inst(Inst), .Branch(Branch), .MemRead(MemRead) ,.MemtoReg(MemtoReg) ,.MemWrite(MemWrite) ,.ALUSrc(ALUSrc) ,.RegWrite(RegWrite), . ALUOp(ALUOp), .AUIPCsel(AUIPCsel), .Jal(Jal),.Jalr(Jalr),.ecall(ecall));//system call Hussein
    ALU_CU alucu(.ALUop(ALUOp), .inst(Inst), .ALU_selection(ALU_selection) );



    FullAdder #(32)fa(.a(pc_out), .b(new_imm),  .addsub(0), .c_in(0), .sum(jump_inst_sum), .c_out(jump_inst_cout)); // beq case
    FullAdder #(32)fa2(.a(4), .b(pc_out),  .addsub(0), .c_in(0), .sum(pc_update_sum), .c_out(pc_update_cout)); // normal case

        

    nbit_mux #(32) imm_reg_mx(.a({pc_update_sum}),.b({jump_inst_sum}),.s((zf && Branch)),.c(pc_mux1_out)); //PC_MUX
    
   nbit_mux #(32) jmp_mux(.a(pc_mux1_out),.b(alu_out),.s(Jalr),.c(pc_in)); //Mux after PC_mux  to check jalr //Jumping-Tawfik     
    
 
    
                                                                        
    N_Bit_ALU #(32) alu( .a(alu_in1), .b(alu_in2), .alufn(ALU_selection), .zf(zf), .cf(cf), .vf(vf), .sf(sf), .r(alu_out) );
     
    
    
    //Byte addressable data mem
    DataMem datamem ( .clk(clk), .fun3(Inst[14:12]), .MemRead(MemRead),  .MemWrite(MemWrite), .addr(alu_out[7:0]),  .data_in(r_data2),  .data_out(mem_data_out));

    nbit_mux #(32) mem_alu_mx(.a(alu_out),.b(mem_data_out),.s(MemtoReg),.c(reg_write_data)); //MEM_TO_REG MUX








    //---------------------------------------------------------------------------------------------------------------------------------------

    always @(led_sel)begin
        case(led_sel)
            2'b00:LED= Inst[15:0];
            2'b01:LED= Inst[31:16];
            2'b10:LED= {2'b00, ALUOp,ALU_selection,Branch, MemRead ,MemtoReg ,MemWrite ,ALUSrc ,RegWrite,zf,(zf && Branch)}; //modify to account for  AUIPCsel
            default LED=0;
        endcase
    end


    always @(SSD_sel)begin
        case(SSD_sel)
            4'b0000: ssd={24'b0,pc_out}; //to fit the 32-bit output (ssd)
            4'b0001: ssd={24'b0,pc_out+1};
            4'b0010: ssd={24'b0,jump_inst_sum};
            4'b0011: ssd={24'b0,pc_in};
            4'b0100: ssd= r_data1;
            4'b0101: ssd= r_data2;
            4'b0110: ssd= reg_write_data;
            4'b0111: ssd=immediate;
            4'b1000: ssd=new_imm;
            4'b1001: ssd=alu_in2;
            4'b1010: ssd=alu_out;
            4'b1011: ssd=mem_data_out;

        endcase
    end


endmodule
