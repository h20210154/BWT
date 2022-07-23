//Name : Mayank
//BITS ID : 2021H1400154P
//Name : Urvi Barapatre
//BITS ID : 2021H1400161P

`timescale 1ns / 1ps

module bwt_tb();

reg enable,clock;
reg [9:0]address;
reg [8*1023:0]input_string;
reg [7:0]character;
reg [9:0]length;
reg dummy;
wire [7:0]out_string;
wire done_flag_t;
integer fd,i,j,k,fd2;
bwt uut (.clk(clock), .en(enable), .adr(address), .in_string(character), .outstring(out_string), .length(length), .done_flag(done_flag_t));

initial
begin

    clock=1'b0;
    forever #6 clock=~clock;
    
end

initial
begin

enable = 1'b1;

fd = $fopen("D:\\string1.txt", "r");        //reading of file with the string.
    
    while (! $feof (fd)) 

        begin   
 
            $fgets(input_string, fd);  
            $display("\n input string when data is loading %s", input_string);  

        end
        
$fclose(fd);  


length = 10'b0000000000;
for (k=0; input_string[k+:7] != 8'b00000000; k = k+8)           //lenth of the string
begin 

     length = length+10'b0000000001; 

end

$display ("\nlength of string in binary is %b\n length of string in decimal %d ", length, length);
$display ("\n Number of Bits in the string in decimal is %d ", k);
$display("\n Final input string %s", input_string);

address=10'b0;
for(i=0;i<=length*8-1;i=i+8)
begin

    character = input_string[i+:7];
    $display("character is %s,  %0s    %b", character,input_string  ,address);
    #12 address=address+1'b1;
    
end

#1 enable = 1'b0;
fd2 = $fopen("D:\\string_write.txt", "w");



while(!done_flag_t == 1)
 begin
 #12 dummy = dummy +1;      //for delay
 end
 
address=length-1;

if (done_flag_t == 1'b1)
   begin
   
       for (j=0; j<=length; j=j+1)
        begin
        $display ("bwt string is %s ",out_string);
        $fwrite(fd2,"%s",out_string);
        #12 address = address -1;
   end

$fclose(fd2);
    end
 
end

endmodule
