`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Institute: IIT ROPAR 
// Author: Yogesh Chhabra
// EntryNo: 2017csb1120

// Create Date: 12.11.2018 14:04:33
// Design Name: Catch the Light 
// Module Name: main
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


module main(
    input clk1,
    input [15:0] sw,
    input clr1,
    output reg [15:0] led,
    output [6:0] a_to_g,
    output [3:0] an1,
    input modeBtn,
    input startbtn,//, //connected with middle push btn
    input hscorebtn
   // input dp1
    );
	integer i;
    reg modeFlag,gameOn,reset_flag,gameOn_flag,firstCycle_flag,score_flag;
    reg reset,mode;
    reg pressed;
    wire[19:0] scoreBcd;
    reg [7:0] score;
    reg [7:0] highscore;
    reg [5:0] count;
    reg [3:0]rand;
    wire [3:0]rand2;
    reg [3:0]rand_;
    wire [3:0]rand2_;
    wire turnOn;
    //reg pressed_flag;
	initial begin
	   mode=0;
		gameOn=0;
		modeFlag=0;
		gameOn_flag=0;
		reset_flag=0;
		score=0;
		highscore=0;
		count=0;
		firstCycle_flag=0;
		//pressed_flag=0;
	end
    always @(*)begin
    pressed=0;
	for(i=0;i<16;i=i+1)
		if(sw[i]==1 && pressed==0)
			pressed=1;
    end  



    binToBcd b(.B2(score),.bcdout2(scoreBcd));  //for score conversion into bcd for display
    seg7decimal dis(
    .x(scoreBcd),
    .clk(clk1),
    .clr(clr1),
    .a2g(a_to_g),
    .an(an1)//,
    //.dp(dp1) 
    );    // bcd score passed to 7 segment for display
    SapnaModule s(.rand(rand2), .rand_(rand2_),.reset(reset),.pressed(pressed),.clock(clk1));   //gives a random number the random number that changes when pressed is made 1
    RishabhModule r(.reset1(reset),.turnOn(turnOn),.clk(clk1));    // gives a signal turnOn after intervals Led is turned on when turnOn signal is on and score is also increases only at this point
	always @(posedge clk1)begin
	    if(modeBtn==1) begin
	       if(mode==0 && modeFlag==0) begin
	           mode=1;         //mode=0 is single led mode, mode=2 is double led mode
	           modeFlag=1;
	       end
	       else if(mode==1 && modeFlag==0) begin
               mode=0;
               modeFlag=1;
           end
	    
	    end
		else if(startbtn==1) begin
			if(gameOn==0 && gameOn_flag==0) begin
				gameOn=1;
				gameOn_flag=1;
				score=0;
				count=0;
				reset=0;
				reset_flag=0;
				firstCycle_flag=0;
			end
			else if(gameOn==1 && gameOn_flag==0) begin
				gameOn=0;
				gameOn_flag=1;
			end
		end
		else if(hscorebtn==1) begin
                if(highscore<score)
                  highscore=score;
                else
                    score=highscore;
		      
		end
		else begin
		    modeFlag=0;
			gameOn_flag=0;
			if(gameOn==1) begin
			     if(reset==0 && reset_flag==0) begin
			         reset=1;
			         reset_flag=1;
			     end
			     else begin
			     reset=0;
				// here startbtn is off and gameOn is on
				//check if turnOn is on
                    if(turnOn==1) begin
                        // In the firrst cycle get a random number in rand
                        if(firstCycle_flag==0) begin
                            firstCycle_flag=1;
                            rand=rand2;
                            rand_=rand2_;
                            score_flag=0;
                            count=count+1;
                        end
                        else begin
                            led=16'b0000000000000000;
                            led[rand]=1;
                            if(mode==0) begin //single led mode
                                if(sw[rand]==1) begin
                                    for(i=0;i<16;i=i+1) begin
                                        if(sw[i]==1)
                                            if(i!=rand)
                                                score_flag=1;
                            
                                    end
                                    if(score_flag==0) begin
                                        score=score+1;
                                        score_flag=1;
                                    end
                                end
                            end
                            else begin //double led mode
                                led[rand_]=1;
                                if(sw[rand]==1 && sw[rand_]==1) begin
                                    for(i=0;i<16;i=i+1) begin
                                        if(sw[i]==1)
                                            if(i!=rand && i!=rand_)
                                                score_flag=1;
                            
                                    end
                                    if(score_flag==0) begin
                                        score=score+1;
                                        score_flag=1;
                                    end
                                end
                            end
                        end
                    end
                    
                    else begin
                        firstCycle_flag=0;
                        led=16'b0000000000000000;
                    end
				end
				// I need to get a random number in rand in the first cycle	
				
				if(count>30)
					gameOn=0; 
			end
			else
				led=16'b0000000000000000;
		end
    
	end    
    
endmodule





