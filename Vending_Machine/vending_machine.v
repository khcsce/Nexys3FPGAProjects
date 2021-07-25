`timescale 1ns / 1ps

	module vending_machine(CARD_IN,VALID_TRAN,ITEM_CODE,KEY_PRESS,DOOR_OPEN,RELOAD,CLK,RESET,
	VEND,INVALID_SEL,FAILED_TRAN,COST
		 );

		input CARD_IN,VALID_TRAN,KEY_PRESS,DOOR_OPEN,RELOAD,CLK,RESET;
		input [3:0] ITEM_CODE;
		output reg VEND,INVALID_SEL,FAILED_TRAN;
		output reg [2:0] COST;

		//internal counter & signal
		reg [3:0] current_state,next_state;
		reg valid;
		reg [3:0] item_counter [19:0]; // 2d 0-19
		reg [2:0] KEY_PRESS_counter,valid_counter,door_counter; // intyernal counter
		reg [3:0] key1_temp, key2_temp; // user input
		reg decrement_counter; //signal to indicate decrement item_counter once

		//paramters (10 states so 4 bit required for state encoding ( instead of actual names we can use s0-s9 also)
		parameter idle=4'b0000,reloading=4'b0001,trans=4'b0010,read_key1=4'b0011,wait_key2=4'b0100;
		parameter read_key2=4'b0101,check_code=4'b0110,wait_trans=4'b0111,vending=4'b1000,check_door=4'b1001;


	// state block ~sequential
	always @ (posedge CLK)
	begin
		if (RESET)
		current_state<=idle;
		else
		current_state<=next_state;
	end

	//next state transition block, depends on input
	always @ (current_state or CARD_IN or VALID_TRAN or ITEM_CODE or KEY_PRESS or DOOR_OPEN or RELOAD or KEY_PRESS_counter or valid_counter or door_counter or valid)
	begin

		next_state<=idle;
		case(current_state)

		//IDLE State
		idle: begin
		if (CARD_IN==1 && RELOAD==0) next_state<=trans;
			else if (RELOAD==1) next_state<=reloading;
		end

		//RELOAD State
		reloading: begin
		if (RELOAD==1) next_state<=reloading;
			else next_state<=idle;
		end

		//Trans State
		trans:begin
		if (KEY_PRESS_counter==0) next_state<=idle;
			else if (KEY_PRESS_counter>0 && KEY_PRESS==0) next_state<=trans;
			else if (KEY_PRESS==1) next_state<=read_key1;
		end

		//read_key1 state
		read_key1:begin
		key1_temp<=ITEM_CODE;
		if (KEY_PRESS==1) next_state<=read_key1;
			else  next_state<=wait_key2;
		end

		//wait_key2 state
		wait_key2: begin
		if (KEY_PRESS_counter>0 && KEY_PRESS==0) next_state<=wait_key2;
			else if (KEY_PRESS_counter==0) next_state<=idle;
			else if (KEY_PRESS_counter>0 && KEY_PRESS==1) next_state<=read_key2;
		end

		//read_key2 state
		read_key2: begin
		key2_temp<=ITEM_CODE;
		if (KEY_PRESS==1) next_state<=read_key2;
			else next_state<=check_code;
		end

		//check_code state
		check_code:begin
		if (valid==0) next_state<=idle;
			else  next_state<=wait_trans;
		end

		//wait_trans
		wait_trans:begin
		if (valid_counter>0 && VALID_TRAN==0) next_state<=wait_trans;
			else if (valid_counter==0 && VALID_TRAN==0) next_state<=idle;
			else if(valid_counter>0 && VALID_TRAN==1) begin next_state<=vending; decrement_counter<=1; end // decrement counter of item selected
		end

		//vending state
		vending:begin
		decrement_counter<=0;
		if (door_counter==0 && DOOR_OPEN==0)  next_state<=idle;
			else if (door_counter>0 && DOOR_OPEN==0) next_state<=vending;
			else if (door_counter>0 && DOOR_OPEN==1)  next_state<=check_door;
		end

		//check_door state
		check_door:begin
		if (DOOR_OPEN==1)  next_state<=check_door;
		else  next_state<=idle;
		end

		endcase
	end


	// item code validility condition 2 and 3
	always @ (key1_temp or key2_temp)
	begin
	if ((key1_temp==0 || key1_temp==1) && (key2_temp>=0 && key2_temp<=9)) 
	begin
		if (key1_temp==0 && key2_temp==0) if  (item_counter[0]>0) valid<=1; else valid<=0;
		else if(key1_temp==0 && key2_temp==1)  if  (item_counter[1]>0) valid<=1; else valid<=0;
		else if(key1_temp==0 && key2_temp==2)  if  (item_counter[2]>0) valid<=1; else valid<=0;
		else if(key1_temp==0 && key2_temp==3)  if  (item_counter[3]>0) valid<=1; else valid<=0;
		else if(key1_temp==0 && key2_temp==4)  if  (item_counter[4]>0) valid<=1; else valid<=0;
		else if(key1_temp==0 && key2_temp==5)  if  (item_counter[5]>0) valid<=1; else valid<=0;
		else if(key1_temp==0 && key2_temp==6)  if  (item_counter[6]>0) valid<=1; else valid<=0;
		else if(key1_temp==0 && key2_temp==7)  if  (item_counter[7]>0) valid<=1; else valid<=0;
		else if(key1_temp==0 && key2_temp==8)  if  (item_counter[8]>0) valid<=1; else valid<=0;
		else if(key1_temp==0 && key2_temp==9)  if  (item_counter[9]>0) valid<=1; else valid<=0;
		else if(key1_temp==1 && key2_temp==0)  if  (item_counter[10]>0) valid<=1; else valid<=0;
		else if(key1_temp==1 && key2_temp==1)  if  (item_counter[11]>0) valid<=1; else valid<=0;
		else if(key1_temp==1 && key2_temp==2)  if  (item_counter[12]>0) valid<=1; else valid<=0;
		else if(key1_temp==1 && key2_temp==3)  if  (item_counter[13]>0) valid<=1; else valid<=0;
		else if(key1_temp==1 && key2_temp==4)  if  (item_counter[14]>0) valid<=1; else valid<=0;
		else if(key1_temp==1 && key2_temp==5)  if  (item_counter[15]>0) valid<=1; else valid<=0;
		else if(key1_temp==1 && key2_temp==6)  if  (item_counter[16]>0) valid<=1; else valid<=0;
		else if(key1_temp==1 && key2_temp==7)  if  (item_counter[17]>0) valid<=1; else valid<=0;
		else if(key1_temp==1 && key2_temp==8)  if  (item_counter[18]>0) valid<=1; else valid<=0;
		else if(key1_temp==1 && key2_temp==9)  if  (item_counter[19]>0) valid<=1; else valid<=0;
	end

	else
	begin
		valid<=0;
	end

	end

	//counters block counter at posedge clock, initialization
	always @ (posedge CLK)
	begin
	if (RESET)
	begin
		//RESET counter values
		KEY_PRESS_counter<=4;
		valid_counter<=4;
		door_counter<=4;
	end
	else 
	begin
	case (current_state)
		idle: begin
		//counter RESET 
		KEY_PRESS_counter<=4;
		valid_counter<=4;
		door_counter<=4;
		end

		trans:begin
		KEY_PRESS_counter<=KEY_PRESS_counter-1; //decrement counter 
		end

		read_key1:begin
		KEY_PRESS_counter<=4; //RESET value for 2nd key press
		end

		wait_key2:begin
		KEY_PRESS_counter<=KEY_PRESS_counter-1; //decrement counter
		end

		wait_trans: begin
		valid_counter<=valid_counter-1; //decrement counter  5 secs for valid transation
		end

		vending: begin
		door_counter<=door_counter-1; //decrement door counter 
		end
		endcase 
	end
	end


	//output block
	always @(current_state or valid or VALID_TRAN or valid_counter or decrement_counter or KEY_PRESS_counter)
	begin

	if (RESET==1)
	begin
		//all outputs are zero and item_counters too
		VEND<=0;
		INVALID_SEL<=0;
		FAILED_TRAN<=0;
		COST<=0;
		item_counter[0]<=0;
		item_counter[1]<=0;
		item_counter[2]<=0;
		item_counter[3]<=0;
		item_counter[4]<=0;
		item_counter[5]<=0;
		item_counter[6]<=0;
		item_counter[7]<=0;
		item_counter[8]<=0;
		item_counter[9]<=0;
		item_counter[10]<=0;
		item_counter[11]<=0;
		item_counter[12]<=0;
		item_counter[13]<=0;
		item_counter[14]<=0;
		item_counter[15]<=0;
		item_counter[16]<=0;
		item_counter[17]<=0;
		item_counter[18]<=0;
		item_counter[19]<=0;
	end

	else begin

	case (current_state)
	idle:begin
		VEND<=0;
		INVALID_SEL<=0;
		FAILED_TRAN<=0;
		COST<=0;
	end
	
	wait_key2:begin
	if(KEY_PRESS_counter==0) INVALID_SEL<=0;
	end
	
	reloading: begin

		item_counter[0]<=10;
		item_counter[1]<=10;
		item_counter[2]<=10;
		item_counter[3]<=10;
		item_counter[4]<=10;
		item_counter[5]<=10;
		item_counter[6]<=10;
		item_counter[7]<=10;
		item_counter[8]<=10;
		item_counter[9]<=10;
		item_counter[10]<=10;
		item_counter[11]<=10;
		item_counter[12]<=10;
		item_counter[13]<=10;
		item_counter[14]<=10;
		item_counter[15]<=10;
		item_counter[16]<=10;
		item_counter[17]<=10;
		item_counter[18]<=10;
		item_counter[19]<=10;
	end

	check_code:begin
	if (valid==0) INVALID_SEL<=1;
	else begin
		// display COST
		if (key1_temp==0 && (key2_temp>=0 && key2_temp<=3)) COST<=1;  		//00,01,02,03
		else if (key1_temp==0 && (key2_temp>=4 && key2_temp<=7)) COST<=2; //04,05,06,07
		else if (key1_temp==0 && (key2_temp>=8 && key2_temp<=9)) COST<=3; //08,09
		else if (key1_temp==1 && (key2_temp>=0 && key2_temp<=1)) COST<=3; //10,11
		else if (key1_temp==1 && (key2_temp>=2 && key2_temp<=5)) COST<=4; //12,13,14,15
		else if (key1_temp==1 && (key2_temp>=6 && key2_temp<=7)) COST<=5; //16,17
		else if (key1_temp==1 && (key2_temp>=8 && key2_temp<=9)) COST<=6; //18,19
	end
	end 

	wait_trans: begin
	if (VALID_TRAN==0 &&  valid_counter==0) FAILED_TRAN<=1;
	end

	vending: begin
	VEND<=1;
	if (decrement_counter==1)
	begin
		if (key1_temp==0 && key2_temp==0) item_counter[0]<=item_counter[0]-1;
		else if(key1_temp==0 && key2_temp==1) item_counter[1]<=item_counter[1]-1;
		else if(key1_temp==0 && key2_temp==2) item_counter[2]<=item_counter[2]-1;
		else if(key1_temp==0 && key2_temp==3) item_counter[3]<=item_counter[3]-1;
		else if(key1_temp==0 && key2_temp==4) item_counter[4]<=item_counter[4]-1;
		else if(key1_temp==0 && key2_temp==5) item_counter[5]<=item_counter[5]-1;
		else if(key1_temp==0 && key2_temp==6) item_counter[6]<=item_counter[6]-1;
		else if(key1_temp==0 && key2_temp==7) item_counter[7]<=item_counter[7]-1;
		else if(key1_temp==0 && key2_temp==8) item_counter[8]<=item_counter[8]-1;
		else if(key1_temp==0 && key2_temp==9) item_counter[9]<=item_counter[9]-1;
		else if(key1_temp==1 && key2_temp==0) item_counter[10]<=item_counter[10]-1;
		else if(key1_temp==1 && key2_temp==1) item_counter[11]<=item_counter[11]-1;
		else if(key1_temp==1 && key2_temp==2) item_counter[12]<=item_counter[12]-1;
		else if(key1_temp==1 && key2_temp==3) item_counter[13]<=item_counter[13]-1;
		else if(key1_temp==1 && key2_temp==4) item_counter[14]<=item_counter[14]-1;
		else if(key1_temp==1 && key2_temp==5) item_counter[15]<=item_counter[15]-1;
		else if(key1_temp==1 && key2_temp==6) item_counter[16]<=item_counter[16]-1;
		else if(key1_temp==1 && key2_temp==7) item_counter[17]<=item_counter[17]-1;
		else if(key1_temp==1 && key2_temp==8) item_counter[18]<=item_counter[18]-1;
		else if(key1_temp==1 && key2_temp==9) item_counter[19]<=item_counter[19]-1;
		end
	end
	endcase

	end
	end

	endmodule