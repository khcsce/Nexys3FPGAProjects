`timescale 1ns / 1ps

module testbench_105123806;

	// Inputs
	reg CARD_IN;
	reg VALID_TRAN;
	reg [3:0] ITEM_CODE;
	reg KEY_PRESS;
	reg DOOR_OPEN;
	reg RELOAD;
	reg CLK;
	reg RESET;

	// Outputs
	wire VEND;
	wire INVALID_SEL;
	wire FAILED_TRAN;
	wire [2:0] COST;

	// Instantiate the Unit Under Test (UUT)
	vending_machine uut (
		.CARD_IN(CARD_IN), 
		.VALID_TRAN(VALID_TRAN), 
		.ITEM_CODE(ITEM_CODE), 
		.KEY_PRESS(KEY_PRESS), 
		.DOOR_OPEN(DOOR_OPEN), 
		.RELOAD(RELOAD), 
		.CLK(CLK), 
		.RESET(RESET), 
		.VEND(VEND), 
		.INVALID_SEL(INVALID_SEL), 
		.FAILED_TRAN(FAILED_TRAN), 
		.COST(COST)
	);

always #5 CLK=~CLK;
	
	initial begin
		// Initialize Inputs
		CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		CLK = 0;
		//RESET system
		RESET = 1;
		
		//start system by RESET=0
		#20 RESET=0;
		//RELOADing first time
		#15 RELOAD=1;
		#10 RELOAD=0;
		
		//normal case ITEM_CODE=11
		//CARD_IN
		#10 CARD_IN=1;
		//1st key pressed
		#10 KEY_PRESS=1;
		// key '1' presserd	
		#10 ITEM_CODE=1;
		//key unpressed
		#10 KEY_PRESS=0;
		// 2nd KEY_PRESSed and ITEM_CODE=1
		#10 ITEM_CODE=1;
		   KEY_PRESS=1;
		//key unpressed
		#20 KEY_PRESS=0;
		//transaction is valid
		#10 VALID_TRAN=1;
		//DOOR_OPENed
		#10 DOOR_OPEN=1;
		//door closed
		#20 DOOR_OPEN=0;
		
		//see if transaction happens while RELOADing or not
		#10 RELOAD=1; CARD_IN=1; //RELOAD and CARD_IN goes high same time
		#10 RELOAD=0;
		//ITEM_CODE=09
		#10 KEY_PRESS=1;
		// key '0' pressed	
		#10 ITEM_CODE=1;
		//key unpressed
		#10 KEY_PRESS=0;
		// 2nd KEY_PRESSed and ITEM_CODE=1
		#10 ITEM_CODE=9;
		   KEY_PRESS=1;
		//key unpressed
		#20 KEY_PRESS=0;
		//transaction is valid
		#10 VALID_TRAN=1;
		//DOOR_OPENed
		#10 DOOR_OPEN=1;
		//door closed
		#20 DOOR_OPEN=0;
		//Special cases

		// Special case 1: VALID_TRAN signal does not go high within 5 clock cycles
	   CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		//CARD_IN
		#10 CARD_IN=1;
		//1st key pressed
		#10 KEY_PRESS=1;
		// key '1' presserd	
		#10 ITEM_CODE=1;
		//key unpressed
		#10 KEY_PRESS=0;
		// 2nd KEY_PRESSed and ITEM_CODE=1
		#10 ITEM_CODE=1;
		   KEY_PRESS=1;
		//key unpressed
		#20 KEY_PRESS=0;
		//transaction is valid after 6 cycles
		#70 VALID_TRAN=1;
		//DOOR_OPENed
		#10 DOOR_OPEN=1;
		//door closed
		#20 DOOR_OPEN=0;
		#10 CARD_IN=0; //card out
		
		// Special case 2: key1 not pressed within 5 cycles
   	#20 CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		RESET=1;
		#20 RESET=0; RELOAD=1; //RELOADing
		#10 RELOAD=0;
		#10 CARD_IN=1;
		// key pressed after 60 cycles
		#70 KEY_PRESS=1;
		#10 KEY_PRESS=0;
		
		// Special case 3: key2 not pressed within 5 cycles
		//CARD_IN
		CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		#10 RESET=1;
		#20 RESET=0; RELOAD=1;
		#10 RELOAD=0;
		#10 CARD_IN=1;
		//1st key pressed
		#10 KEY_PRESS=1;
		// key '1' presserd	
		#10 ITEM_CODE=1;
		//key unpressed
		#10 KEY_PRESS=0;
		//key2 pressed after 5 cycles
		#70 KEY_PRESS=1;
		
		// Special case 4: Door not open within 5 cycles
		//CARD_IN
			CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		#10 CARD_IN=1;
		//1st key pressed
		#10 KEY_PRESS=1;
		// key '1' presserd	
		#10 ITEM_CODE=1;
		//key unpressed
		#10 KEY_PRESS=0;
		// 2nd KEY_PRESSed and ITEM_CODE=1
		#10 ITEM_CODE=1;
		   KEY_PRESS=1;
		//key unpressed
		#20 KEY_PRESS=0;
		//transaction is valid
		#10 VALID_TRAN=1;
		//DOOR_OPENed after 5 cycles
		#60 DOOR_OPEN=1;
		//door closed
		#20 DOOR_OPEN=0;
		
		//special_case 5: item code invalid (ITEM_CODE=21)
		//CARD_IN
		CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		#10 CARD_IN=1;
		//1st key pressed
		#10 KEY_PRESS=1;
		// key '1' presserd	
		#10 ITEM_CODE=2;
		//key unpressed
		#10 KEY_PRESS=0;
		// 2nd KEY_PRESSed and ITEM_CODE=1
		#20 ITEM_CODE=1;
		   KEY_PRESS=1;
		//key unpressed
		#20 KEY_PRESS=0;
		//transaction is valid
		#10 VALID_TRAN=1;
		//DOOR_OPENed
		#10 DOOR_OPEN=1;
		//door closed
		#20 DOOR_OPEN=0;
		
		//special_case 5: not enough items left as RESETs the item_counter to zero
		#10 RESET=1; VALID_TRAN=0;
		#20 RESET=0;
		//CARD_IN
		#10 CARD_IN=1;
		//1st key pressed
		#10 KEY_PRESS=1;
		// key '1' presserd	
		#10 ITEM_CODE=1;
		//key unpressed
		#10 KEY_PRESS=0;
		// 2nd KEY_PRESSed and ITEM_CODE=1
		#10 ITEM_CODE=1;
		 KEY_PRESS=1;
		//key unpressed
		#20 KEY_PRESS=0;
		//transaction is valid
		#10 VALID_TRAN=1;
		//DOOR_OPENed
		#10 DOOR_OPEN=1;
		//door closed
		#20 DOOR_OPEN=0;
		
		// Last Special Case
		//FAQ1: door never goes low
		#10 RESET=1; VALID_TRAN=0; CARD_IN=0;
		#20 RESET=0;RELOAD=1;
		#10 RELOAD=0;
		//CARD_IN
		#10 CARD_IN=1;
		//1st key pressed
		#10 KEY_PRESS=1;
		// key '1' presserd	
		#10 ITEM_CODE=0;
		//key unpressed
		#10 KEY_PRESS=0;
		// 2nd KEY_PRESSed and ITEM_CODE=1
		#10 ITEM_CODE=0;
		   KEY_PRESS=1;
		//key unpressed
		#20 KEY_PRESS=0;
		//transaction is valid
		#10 VALID_TRAN=1;
		//DOOR_OPENed
		#10 DOOR_OPEN=1;
	   
		#200 //door not closes for 20 cycles
		
		#10 RESET=1; CARD_IN=0;//reset // could have changed with DOOR_OPEN = 0 or left it in the state forever...
		
		// Wait 100 ns for global RESET to finish
		#100 $finish;
        
		// Add stimulus here

        

	end
      
endmodule


// FALLING EDGE
/*
`timescale 1ns / 1ps

module testbench_105123806;

	// Inputs
	reg CARD_IN;
	reg VALID_TRAN;
	reg [3:0] ITEM_CODE;
	reg KEY_PRESS;
	reg DOOR_OPEN;
	reg RELOAD;
	reg CLK;
	reg RESET;

	// Outputs
	wire VEND;
	wire INVALID_SEL;
	wire FAILED_TRAN;
	wire [2:0] COST;

	// Instantiate the Unit Under Test (UUT)
	vending_machine uut (
		.CARD_IN(CARD_IN), 
		.VALID_TRAN(VALID_TRAN), 
		.ITEM_CODE(ITEM_CODE), 
		.KEY_PRESS(KEY_PRESS), 
		.DOOR_OPEN(DOOR_OPEN), 
		.RELOAD(RELOAD), 
		.CLK(CLK), 
		.RESET(RESET), 
		.VEND(VEND), 
		.INVALID_SEL(INVALID_SEL), 
		.FAILED_TRAN(FAILED_TRAN), 
		.COST(COST)
	);

always #5 CLK=~CLK;
	
	initial begin
		// Initialize inputs
		CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		CLK = 0;
		//RESET system
		RESET = 1;
		
		//start system => reset = 0
		#25 RESET=0;
		// reloading items
		#20 RELOAD=1;
		#15 RELOAD=0;
		
		///////////////////////////////NORMAl CASE///////////////////////////
		//ITEM_CODE=11
		
		//CARD_IN
		#15 CARD_IN=1;
		//1st key pressed
		#15 KEY_PRESS=1;
		// key one pressed
		#15 ITEM_CODE=1;
		//key 1 unpressed
		#15 KEY_PRESS=0;
		// 2nd key pressed, ITEM_CODE=1
		#15 ITEM_CODE=1;
		KEY_PRESS=1;
		//key unpressed
		#25 KEY_PRESS=0;
		//transaction is valid
		#15 VALID_TRAN=1;
		// door open
		#15 DOOR_OPEN=1;
		//door closed
		#25 DOOR_OPEN=0;
		// get the item :) successful
		
		//sanity check if transaction happens while reloading or it does not
		#15 RELOAD=1; CARD_IN=1; //RELOAD and CARD_IN goes high same time
		#15 RELOAD=0;
		//ITEM_CODE=09
		#15 KEY_PRESS=1;
		// key '0' pressed	
		#15 ITEM_CODE=1;
		//key unpressed
		#15 KEY_PRESS=0;
		// 2nd key pressed,ITEM_CODE=1
		#15 ITEM_CODE=9;
		 KEY_PRESS=1;
		//key unpressed
		#25 KEY_PRESS=0;
		//transaction is valid
		#15 VALID_TRAN=1;
		//DOOR_OPENed
		#15 DOOR_OPEN=1;
		//door closed
		#25 DOOR_OPEN=0;

		/////////// Special cases////////////////////////////////////////

		// Special case 1: VALID_TRAN signal not high within 5 clock cycles
	   CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		//CARD_IN
		#15 CARD_IN=1;
		//1st key pressed
		#15 KEY_PRESS=1;
		// key 1 pressd
		#15 ITEM_CODE=1;
		//key 1 unpressed
		#15 KEY_PRESS=0;
		// 2nd key pressed, ITEM_CODE=1
		#15 ITEM_CODE=1;
		KEY_PRESS=1;
		//key unpressed
		#25 KEY_PRESS=0;
		// nothigh within 5 clock cycles
		#75 VALID_TRAN=1;
		// door open
		#15 DOOR_OPEN=1;
		// door close
		#25 DOOR_OPEN=0;
		#15 CARD_IN=0; //card out
		
		// Special case 2: key 1 not pressed within 5 cycles
   	#25 CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		RESET=1;
		#25 RESET=0; RELOAD=1; // RELOADING
		#15 RELOAD=0;
		#15 CARD_IN=1;
		// key pressed after 60 cycles
		#75 KEY_PRESS=1;
		#15 KEY_PRESS=0;
		
	// Special case 3: key2 not pressed within 5 cycles
		//CARD_IN
		CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		#15 RESET=1;
		#25 RESET=0; RELOAD=1;
		#15 RELOAD=0;
		#15 CARD_IN=1;
		//1st key pressed
		#15 KEY_PRESS=1;
		// key '1' presserd	
		#15 ITEM_CODE=1;
		//key unpressed
		#15 KEY_PRESS=0;
		//key2 pressed after 5 cycles
		#75 KEY_PRESS=1;
		
		// Special case 4: Door not open within 5 cycles
		//CARD_IN
		CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		#15 CARD_IN=1;
		//1st key pressed
		#15 KEY_PRESS=1;
		// key '1' presserd	
		#15 ITEM_CODE=1;
		//key unpressed
		#15 KEY_PRESS=0;
		// 2nd key pressed, ITEM_CODE=1
		#15 ITEM_CODE=1;
		  KEY_PRESS=1;
		//key unpressed
		#25 KEY_PRESS=0;
		//transaction is valid
		#15 VALID_TRAN=1;
		//door open after 5 cycles
		#65 DOOR_OPEN=1;
		//door closed
		#25 DOOR_OPEN=0;
		
		//special_case 5: item code invalid (ITEM_CODE=21)
		//CARD_IN
		CARD_IN = 0;
		VALID_TRAN = 0;
		ITEM_CODE = 0;
		KEY_PRESS = 0;
		DOOR_OPEN = 0;
		RELOAD = 0;
		#15 CARD_IN=1;
		//1st key pressed
		#15 KEY_PRESS=1;
		// key '1' presserd	
		#15 ITEM_CODE=2;
		//key unpressed
		#15 KEY_PRESS=0;
		// 2nd key pressed, ITEM_CODE=1
		#25 ITEM_CODE=1;
		   KEY_PRESS=1;
		//key unpressed
		#25 KEY_PRESS=0;
		//transaction is valid
		#15 VALID_TRAN=1;
		//DOOR_OPENed
		#15 DOOR_OPEN=1;
		//door closed
		#25 DOOR_OPEN=0;
		
		//special_case 5: not enough items left as RESETs the item_counter to zero
		#15 RESET=1; VALID_TRAN=0;	
		#25 RESET=0;
		//CARD_IN
		#15 CARD_IN=1;
		//1st key pressed
		#15 KEY_PRESS=1;
		// key '1' presserd	
		#15 ITEM_CODE=1;
		//key unpressed
		#15 KEY_PRESS=0;
		// 2nd key_pressed, ITEM_CODE=1
		#15 ITEM_CODE=1;
		   KEY_PRESS=1;
		//key unpressed
		#25 KEY_PRESS=0;
		//transaction is valid
		#15 VALID_TRAN=1;
		// door opened
		#15 DOOR_OPEN=1;
		//door closed
		#25 DOOR_OPEN=0;
		
		// Last Special Case
		//FAQ1: door never goes low
		#15 RESET=1; VALID_TRAN=0; CARD_IN=0;
		#25 RESET=0;RELOAD=1;
		#15 RELOAD=0;
		//CARD_IN
		#15 CARD_IN=1;
		//1st key pressed
		#15 KEY_PRESS=1;
		// key '1' presserd	
		#15 ITEM_CODE=0;
		//key unpressed
		#15 KEY_PRESS=0;
		// 2nd key pressed, ITEM_CODE=1
		#15 ITEM_CODE=0;
		 KEY_PRESS=1;
		//key unpressed
		#25 KEY_PRESS=0;
		//transaction is valid
		#15 VALID_TRAN=1;
		// door opened
		#15 DOOR_OPEN=1;
		#205 //door not closed for 20 cycles
		#15 RESET=1; CARD_IN=0;//reset // could have changed with DOOR_OPEN = 0 or left it in that state forever...
		// Wait 100 ns for global RESET to finish
		#100 $finish;
        

	end
      
endmodule

*/


