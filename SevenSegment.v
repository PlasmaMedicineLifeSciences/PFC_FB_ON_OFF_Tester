`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Buddika Sumanasena
// 
// Create Date: 03/27/2015 07:00:41 PM
// Design Name: Seven segment driver
// Module Name: SevenSegment
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: This module drives a seven segment unit. Input is 
// 4 bit number. 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module SevenSegment(
		input [3:0] Value,
		output [6:0] seven_segment
    );
    reg a,b,c,d,e,f,g,h;
    always @(Value)
        begin
            case(Value)
                4'b0000:
                begin
                    a<=0;
                    b<=0;
                    c<=0;
                    d<=0;
                    e<=0;
                    f<=0;
                    g<=1;
                end
                4'b0001:
                begin
                    a<=1;
                    b<=0;
                    c<=0;
                    d<=1;
                    e<=1;
                    f<=1;
                    g<=1;
                end
                4'b0010:
                begin
                    a<=0;
                    b<=0;
                    c<=1;
                    d<=0;
                    e<=0;
                    f<=1;
                    g<=0;
                end
                4'b0011:
                begin
                    a<=0;
                    b<=0;
                    c<=0;
                    d<=0;
                    e<=1;
                    f<=1;
                    g<=0;
                end
                4'b0100:
                begin
                    a<=1;
                    b<=0;
                    c<=0;
                    d<=1;
                    e<=1;
                    f<=0;
                    g<=0;
                 end
                 4'b0101:
                 begin
                    a<=0;
                    b<=1;
                    c<=0;
                    d<=0;
                    e<=1;
                    f<=0;
                    g<=0;
                 end
                 4'b0110:
                 begin
                    a<=0;
                    b<=1;
                    c<=0;
                    d<=0;
                    e<=0;
                    f<=0;
                    g<=0;
                 end
                 4'b0111:
                 begin
                    a<=0;
                    b<=0;
                    c<=0;
                    d<=1;
                    e<=1;
                    f<=1;
                    g<=1;
                 end
                 4'b1000:
                 begin
                     a<=0;
                     b<=0;
                     c<=0;
                     d<=0;
                     e<=0;
                     f<=0;
                     g<=0;
                 end
                 4'b1001:
                 begin
                    a<=0;
                    b<=0;
                     c<=0;
                     d<=0;
                    e<=1;
                    f<=0;
                    g<=0;
                end
                default:
                begin
                    a<=1;
                    b<=1;
                    c<=1;
                    d<=1;
                    e<=0;
                    f<=1;
                    g<=1;
                end
            endcase     
        end
assign	 seven_segment={g,f,e,d,c,b,a};
endmodule
