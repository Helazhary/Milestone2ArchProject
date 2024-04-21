`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 02:52:45 PM
// Design Name: 
// Module Name: DataMem
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

// ------------------ BYte Addressable Memory-------------------//
module DataMem                                 
(input clk, input MemRead, input MemWrite,input[2:0]fun3,input [7:0] addr, input [31:0] data_in, output [31:0] data_out);

    reg [7:0] mem [0:255];
    
    reg[31:0] temp;
                        
    initial begin
// mem[0]=10;
// mem[1]=13;
// mem[2]=30;
mem[0]=8'd17;
mem[1]=8'd9;
mem[2]=8'd25; 


      

    end

//  Little Indian [mem3][mem2][mem1][mem0]

    always @(posedge clk) begin
        if(MemWrite)begin
        case(fun3)
        3'b000: mem[addr]=data_in[7:0]; //SB
        3'b001:       {mem[addr+1],mem[addr]}=data_in[15:0]; //SH
        3'b010:     {mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]}=data_in;   //SW
        endcase
        end
           
    end
    
    always @(*) begin
        case(fun3)
        3'b000:temp = {{24{mem[addr][7]}}, mem[addr]};      //LB
        3'b001:temp={{16{mem[addr+1][7]}},mem[addr+1],mem[addr]};      //LH
        3'b010:temp={mem[addr+3],mem[addr+2],mem[addr+1],mem[addr]};      //LW
        3'b100:temp= {24'b0, mem[addr]};    //LBU
        3'b101:temp={16'b0, mem[addr+1],mem[addr]};      //LHU
        
        default:temp=0;
       
        endcase

    
    end
     assign data_out = (MemRead)?temp:0;


endmodule 






//-----------------------------------------------------Old Version------------------------------------------------------\\
//module DataMem                                 //[7:0]
//(input clk, input MemRead, input MemWrite,input [5:0] addr, input [31:0] data_in, output [31:0] data_out);
//    reg [31:0] mem [0:63];
 

                        
//    initial begin
//        mem[0]=17;
//        mem[1]=9;
//        mem[2]=25;
//    end



//    always @(posedge clk) begin
//        if(MemWrite)
//            mem[addr]=data_in;
//    end
//    assign data_out = (MemRead)?mem[addr]:0;

//endmodule 
