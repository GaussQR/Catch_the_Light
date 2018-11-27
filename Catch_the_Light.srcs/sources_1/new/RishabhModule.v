


module RishabhModule(
    input wire reset1 ,               // clk 
    output reg turnOn,
    input clk);
  
    reg [5:0] cnt;  //  counter
    
    reg [28:0] clkdiv;       // 28 bits
    
    initial begin
            turnOn=0;            // initial value of turnOn
            cnt=0;
            clkdiv=0;
           end
    always @(posedge clk)
    begin
        clkdiv<=clkdiv+1;
        if (cnt<6) begin 
            if ((clkdiv == 29'b1111111111111111111111111111 ))
                    cnt<=cnt+1;
            if(clkdiv[28]==1) turnOn<=1;
            else turnOn<=0;
        end
        else if (cnt<12) begin 
            if ((clkdiv == 29'b0111111111111111111111111111 ))
                    cnt<=cnt+1;
            if(clkdiv[27]==1) turnOn<=1;
            else turnOn<=0;
        end
        else if (cnt<20) begin 
            if ((clkdiv == 29'b1111111111111111111111111111 ))
                    cnt<=cnt+1;
            if(clkdiv[26]==1) turnOn<=1;
            else turnOn<=0;
        end
     end 
endmodule 
/*        else if ((clkdiv == 28'b0111111111111111111111111111) & (cnt<11 & cnt>5))         
            begin
                cnt<=cnt+1;
                clkdiv<=0;
                turnOn<=1;
            end
        else if ( (clkdiv == 28'b0011111111111111111111111111) & (cnt<21 & cnt>10))
            begin
                cnt<=cnt+1;
                clkdiv<=0;
                turnOn<=1;
            end
            
    end
 
*/
