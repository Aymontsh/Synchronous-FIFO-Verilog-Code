/*
// Module: FIFO.v
// Description: Synchronous FIFO Verilog code //
// Owner : Mohamed Ayman
// Version : 1.0
// Date : 16 Feb 2022
*/
module FIFO 
#(parameter data_width =32,parameter addr_width=4)
(input clk,//CLK
input EN,
input rd_en,//enable for reading
input wr_en,//enable for writing
input [data_width-1:0] data_in, //input data
input reset ,//reset 
output reg [data_width-1:0] data_out ,
output reg empty ,
output reg full ,
output reg [addr_width-1:0] data_counter//To count how many data slots full in FIFO
);
//memory 
reg [data_width-1:0] memory [2**addr_width-1:0];//array 2_D to implement FIFO memory  
//pointer
reg [addr_width-1:0] rd_counter;
reg [addr_width-1:0] wr_counter; 

always @ (posedge clk or posedge reset)
begin
    if (EN == 1'b0);
    else 
    begin
        if (reset)
        begin
            rd_counter <= 4'b0000;
            wr_counter <= 4'b0000;
            data_counter <= 4'b0000;
            data_out <= 0; //initializing data_out with zero to avoid X value
        end
        else
        begin
        if (data_counter == 4'b0000)
        begin 
            empty <= 1'b1;
            full <= 1'b0;
        end
        //full will happened when data_counte = size of the memory (15) or when rd_counter = wr_counter + 1
        else if (data_counter == 2**addr_width-1 || rd_counter == wr_counter + 4'b0001) 
        begin 
            empty <= 1'b0;
            full <= 1'b1;
        end
        else
        begin
            if ( rd_counter == wr_counter + 4'b0001 )
            begin
                empty <= 1'b0;
                full <= 1'b0;
            end
            else
            begin
                empty <= 1'b0;
                full <= 1'b0;
            end
        end
        end
    end
end
always @ (posedge clk or posedge reset)
begin
    if (wr_en == 1'b1 && full != 1'b1 )
    begin
        if ((rd_counter <= wr_counter))
        begin 
            wr_counter <= wr_counter + 4'b0001;
            if (wr_counter > 2**addr_width-1 )
            begin
                wr_counter <= 4'b0000;
            end
        end
        else 
        begin
            if (rd_counter != wr_counter + 4'b0001)
            begin
            wr_counter <= wr_counter + 4'b0001;
            if (wr_counter > 2**addr_width-1 )
            begin
                wr_counter <= 4'b0000;
            end              
            end
        end
        end
            if ( rd_en == 1'b1 && data_counter != 1'b0 )
        begin 
            rd_counter <= rd_counter + 4'b0001 ;
            if (rd_counter > 2**addr_width-1 )
            begin
                rd_counter <= 4'b0000;
            end            
        end
end

always @ (posedge clk or posedge reset)
begin
    if (EN == 1'b0);
    else 
    begin
        if (reset)
        begin
            rd_counter <= 4'b0000;
            wr_counter <= 4'b0000;
            data_counter <= 4'b0000;
            data_out <= 0; //initializing data_out with zero to avoid X value 
        end
        else 
        begin
        if (wr_en == 1'b1 && full != 1'b1)
        begin 
            memory[wr_counter] <= data_in;
        end
        if ( rd_en == 1'b1 && data_counter != 1'b0 )
        begin 
            data_out <= memory[rd_counter];
        end
    end
end
end


always @ (*)
begin
            if (rd_counter > wr_counter)
        begin
            if(full != 1'b1)
            begin
                data_counter = rd_counter - wr_counter;
            end
        end     
        else
        begin
            data_counter = wr_counter - rd_counter;
        end 
end
endmodule