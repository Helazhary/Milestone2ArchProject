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

// mem[0]=8'd17;
// mem[1]=8'd9;
// mem[2]=8'd25; 

mem[0]=32'd0;
mem[1]=32'd1;
mem[2]=32'd2;
mem[3]=32'd3;
mem[4]=32'd4;
mem[5]=32'd5;
mem[6]=32'd6;
mem[7]=32'd7;
mem[8]=32'd8;
mem[9]=32'd9;
mem[10]=32'd10;
mem[11]=32'd11;
mem[12]=32'd12;
mem[13]=32'd13;
mem[14]=32'd14;
mem[15]=32'd15;
mem[16]=32'd16;
mem[17]=32'd17;
mem[18]=32'd18;
mem[19]=32'd19;
mem[20]=32'd20;
mem[21]=32'd21;
mem[22]=32'd22;
mem[23]=32'd23;
mem[24]=32'd24;
mem[25]=32'd25;
mem[26]=32'd26;
mem[27]=32'd27;
mem[28]=32'd28;
mem[29]=32'd29;
mem[30]=32'd30;
mem[31]=32'd31;
mem[32]=32'd32;
mem[33]=32'd33;
mem[34]=32'd34;
mem[35]=32'd35;
mem[36]=32'd36;
mem[37]=32'd37;
mem[38]=32'd38;
mem[39]=32'd39;
mem[40]=32'd40;
mem[41]=32'd41;
mem[42]=32'd42;
mem[43]=32'd43;
mem[44]=32'd44;
mem[45]=32'd45;
mem[46]=32'd46;
mem[47]=32'd47;
mem[48]=32'd48;
mem[49]=32'd49;
mem[50]=32'd50;
mem[51]=32'd51;
mem[52]=32'd52;
mem[53]=32'd53;
mem[54]=32'd54;
mem[55]=32'd55;
mem[56]=32'd56;
mem[57]=32'd57;
mem[58]=32'd58;
mem[59]=32'd59;
mem[60]=32'd60;
mem[61]=32'd61;
mem[62]=32'd62;
mem[63]=32'd63;


      

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
