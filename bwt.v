module bwt(outstring,done_flag, in_string, clk, en, adr, length);

output reg[7:0]outstring;
output reg done_flag=1'b0;
input [7:0]in_string;
input [9:0]length;
input en;
input clk;
input [9:0]adr;

integer i,j,k,m,p,q,n;
reg [9:0]count;
reg [7:0]temp_mem[0:1023];
reg [7:0]mem[0:1023];
reg [9:0]sorted_index[0:1023];                 //memory to store sorted indices
reg [17:0]temp1,temp2;      
reg [9:0]len;                //storing temporray data + index

always@(posedge clk)
begin

temp1 = 18'd0;
temp2 = 18'd0;

if(en)                       //loading the memory with the input values and indices

   begin
  
        temp_mem[adr]=in_string;
       
        mem[adr] = in_string;    
                 
        sorted_index[adr] = adr;   
              //initilaising the sorted_index memory.
 
   end    


else if (en==1'b0 && done_flag == 1'b0)

begin

len[9:0]=length[9:0];

for (p=0;p<1023;p=p+1)
begin
  if (p<(len-1))
    begin
     for(j=0;j<1023;j=j+1)
      begin
       if (j<(len-1))
          begin
    
    temp1[17:0] = {temp_mem[j],sorted_index[j]};
    temp2[17:0] = {temp_mem[j+1],sorted_index[j+1]};

   
    if((temp2[17:10]>temp1[17:10]) && done_flag == 1'b0)
    
        begin
          
             if( (j == (len-2)) && (p == (len-2)))
                 
                  begin
             
                          done_flag = 1'b1;
             
                   end
                   
        temp_mem[j] = temp2[17:10];
        temp_mem[j+1] = temp1[17:10];
        sorted_index[j] = temp2[9:0];
        sorted_index[j+1] = temp1[9:0];

        end
    
    else if((temp2[17:10]<temp1[17:10]) && done_flag == 1'b0)
        begin
            
              if( (j == (len-2)) && (p == (len-2)))
                 
                begin
             
                   done_flag = 1'b1;
             
                end
          
        temp_mem[j] = temp1[17:10];
        temp_mem[j+1] = temp2[17:10];
        sorted_index[j] = temp1[9:0];
        sorted_index[j+1] = temp2[9:0];
 
        end
 
     else if((temp2[17:10] == temp1[17:10] && done_flag == 1'b0))
         
         begin
               
         count[9:0] = (temp2[9:0]>temp1[9:0])?temp1[9:0]:temp2[9:0];
         
         for (n=1;n<=count;n=n+1)
          
          begin
          
          if (mem[temp2[9:0]-n] > mem[temp1[9:0]-n])
          
              begin
            if( (j == (len-2)) && (p == (len-2)))
                 
               begin
             
                   done_flag = 1'b1;
             
               end
                  temp_mem[j] = temp2[17:10];
                  temp_mem[j+1] = temp1[17:10];
                  sorted_index[j] = temp2[9:0];
                  sorted_index[j+1] = temp1[9:0];
                  count[9:0]=10'd0;
                  
 
              end
              
            else if (mem[temp2[9:0]-n] < mem[temp1[9:0]-n])
              
              begin
           if( (j == (len-2)) && (p == (len-2)))
                 
               begin
             
                   done_flag = 1'b1;
             
               end
                temp_mem[j] = temp1[17:10];
                temp_mem[j+1] = temp2[17:10];
                sorted_index[j] = temp1[9:0];
                sorted_index[j+1] = temp2[9:0];
                count[9:0]=10'd0;
 
                
              end
           end         
         end
    end
  end
  end 
  end

  end
  
   if (sorted_index[adr] == (length-1))
   begin
      outstring = mem[0];
      
   end
 else 
   begin
 outstring = mem[sorted_index[adr]+1];
 
   end
  end

endmodule
