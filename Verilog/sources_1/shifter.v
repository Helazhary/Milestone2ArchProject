`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/28/2024 04:00:37 PM
// Design Name: 
// Module Name: shifter
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


module shifter( input  signed     [31:0] a,  input[4:0]  shamt,  // 5 bits in rs2
                input       [1:0]  type,   
                output reg  [31:0] r);   
//`                ALU_SRL         00
//                  ALU_SRA        10
//                  ALU_SLL        01



wire [31:0] zeros = 32'd0;

always @ * begin 
  case(type) 
    2'b01 : r = a << shamt; 
    2'b00 : r = a >> shamt; 
    2'b10 : r = a >>> shamt;   
    default : r = zeros;
  endcase
end

endmodule