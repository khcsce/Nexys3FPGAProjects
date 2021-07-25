`timescale 1ns / 1ps
module parking_meter(
    input clk, //100hz clock
    input rst, 
    input add1,add2,add3,add4,rst1,rst2, //input signals
    output reg a1,a2,a3,a4,   // anode for ssg
    output [6:0] led_seg,     // cathode for ssg
    output [3:0] val1,val2,val3,val4 //BCD values
    );

// Define State Codes
localparam INITIAL     = 3'b000;
localparam ADD_60      = 3'b001;
localparam ADD_120     = 3'b010;
localparam ADD_180     = 3'b011;
localparam ADD_300     = 3'b100;
localparam COUNT_DOWN  = 3'b101;
localparam RST_16      = 3'b110;
localparam RST_150     = 3'b111;


reg [13:0] input_time; // input_time is used to store input coin value (60,120,180,300)
reg [13:0] timer; // time remaining
reg [2:0] state; // store current state
reg initial_state; // 1 when the FSM is INITIAL state. This is to let timer logic to start down counting.
reg return_initial; // This signal will come from timer logic to state that counting is finished (timer is 0)
reg input_time_valid; // valid signal if input_time is valid input. 
reg input_time_captured; // This signal will be 1 after timer logic section of code captures the value from input_time

wire clk_1Hz;   //1Hz
wire clk_2Hz;   //2Hz



//////////////////////// Start of FSM ////////////////////////////////////////////////


// Combinational Logic: Next State Logic
always @ (posedge(clk), posedge(rst), posedge(rst1), posedge(rst2))
begin
    if (rst == 1'b1 && rst1 == 1'b0 && rst2 == 1'b0) begin  // if general reset is HIGH, rst1 and rst2 are LOW 
        input_time <= 0;  // input_time aka the input is set to 0
        state   <= INITIAL; // set state to INTIAL state : 0000 display
        input_time_valid <= 1'b0;
        initial_state <= 1'b0;
    end 
    else if (rst == 1'b0 && rst1 == 1'b1 && rst2 == 1'b0) begin  // if only rst1 is HIGH
        state   <= RST_16; // set current state to RST_16
        input_time <= 14'd16; // set input to 15 seconds
        input_time_valid <= 1'b1; // valid input
        initial_state <= 1'b0; // not at initial state
    end
    else if (rst == 1'b0 && rst1 == 1'b0 && rst2 == 1'b1) begin  // if only rst2 is HIGH
        state   <= RST_150; // set currents tate to RST_150
        input_time <= 14'd150;  // set input to 150 seconds
        input_time_valid <= 1'b1; // valid input
        initial_state <= 1'b0; // not at initial state
    end
    else begin
        case (state)
            INITIAL:begin
                if (add1 == 1'b1 && add2 == 1'b0 && add3 == 1'b0 && add4 == 1'b0) begin // 60 seconds
                    input_time <= input_time + 14'd60; // increment by 60
                    input_time_valid <= 1'b1; // valid input
                    initial_state <= 1'b0; // not initial
                    state   <= ADD_60; // go to add 60 state
                end
                else if (add1 == 1'b0 && add2 == 1'b1 && add3 == 1'b0 && add4 == 1'b0) begin //120
                    input_time <= input_time + 14'd120;
                    input_time_valid <= 1'b1;
                    initial_state <= 1'b0;
                    state   <= ADD_120;
                end
                else if (add1 == 1'b0 && add2 == 1'b0 && add3 == 1'b1 && add4 == 1'b0) begin // 180
                    input_time <= input_time + 14'd180;
                    input_time_valid <= 1'b1;
                    initial_state <= 1'b0;
                    state   <= ADD_180;
                end
                else if (add1 == 1'b0 && add2 == 1'b0 && add3 == 1'b0 && add4 == 1'b1) begin //300
                    input_time <= input_time + 14'd300;
                    input_time_valid <= 1'b1;
                    initial_state <= 1'b0;
                    state   <= ADD_300;
                end
                else begin // otherwise loop back to itrefresh_counterf, INITIAL state
                    state   <= INITIAL;
                    input_time_valid <= 1'b0;
                    initial_state <= 1'b1;
                    input_time <= 0;
                end
            end
            ADD_60:begin  // if add1, 60 seconds not inputted again, just count down the timer
                if (add1 == 1'b0)
                    state <= COUNT_DOWN;
                else
                    state <= ADD_60; // otherwise, loop back to ADD_60 state
            end
            ADD_120:begin
                if (add2 == 1'b0) // if add2, 60 seconds not inputted again, just count down the timer
                    state <= COUNT_DOWN;
                else
                    state <= ADD_120;
            end
            ADD_180:begin 
                if (add3 == 1'b0) // if add3, 180 seconds not inputted again, just count down the timer
                    state <= COUNT_DOWN;
                else
                    state <= ADD_180;
            end   
            ADD_300:begin  // if add4, 300 seconds not inputted again, just count down the timer
                if (add4 == 1'b0)
                    state <= COUNT_DOWN;
                else
                    state <= ADD_300;
            end      
            COUNT_DOWN:begin // count down the timer
                if (add1 == 1'b1 && add2 == 1'b0 && add3 == 1'b0 && add4 == 1'b0) begin // if add1, go back to that ADD_60 state
                    input_time <= input_time + 14'd60; // increment input
                    input_time_valid <= 1'b1;
                    state   <= ADD_60;
                end
                else if (add1 == 1'b0 && add2 == 1'b1 && add3 == 1'b0 && add4 == 1'b0) begin // go back to ADD_120 state
                    input_time <= input_time + 14'd120; // increment input
                    input_time_valid <= 1'b1;
                    state   <= ADD_120;
                end
                else if (add1 == 1'b0 && add2 == 1'b0 && add3 == 1'b1 && add4 == 1'b0) begin // go back to ADD_180 state
                    input_time <= input_time + 14'd180; // increment input
                    input_time_valid <= 1'b1;
                    state   <= ADD_180;
                end
                else if (add1 == 1'b0 && add2 == 1'b0 && add3 == 1'b0 && add4 == 1'b1) begin // go back to ADD_300 state
                    input_time <= input_time + 14'd300; // increment input
                    input_time_valid <= 1'b1;
                    state   <= ADD_300;
                end
					 /*
					 . If input_time_captured = 1, that means input has already captured by the timer logic => reset the input to avoid recapturing
						If return_initial = 1, that means count down is over => go to the initial state.
					 */
					
                else if (input_time_captured == 1'b1) begin
                    input_time <= 0;  // reset to avoid recapturing
                    input_time_valid <= 1'b0;
                    state   <= COUNT_DOWN;
                end
                else if (return_initial == 1'b1)begin //If return_initial = 1, that means count down is over => go to the initial state.
                    input_time <= 0; // input = 0 at INITIAL state
                    input_time_valid <= 1'b0;
                    state <= INITIAL;
                end
                else begin  
                    state   <= COUNT_DOWN;
                end
            end 
            RST_16:begin
                if (input_time_captured == 1'b1) begin // avoid recapturing
                    input_time <= 0;
                    input_time_valid <= 1'b0;
                    state   <= RST_16;
                end
                else if (return_initial == 1'b1)begin // if return_intial = 1, go back to INITIAL state
                    input_time <= 0;
                    input_time_valid <= 1'b0;
                    state <= INITIAL;
                end
                else begin  
                    state   <= RST_16; // otherwise, loop back to same state
                end
            end
            RST_150:begin
                if (input_time_captured == 1'b1) begin // avpod recapturing
                    input_time <= 0;
                    input_time_valid <= 1'b0;
                    state   <= RST_150;
                end
                else if (return_initial == 1'b1)begin  // if return_intial = 1, go back to INITIAL state
                    input_time <= 0;
                    input_time_valid <= 1'b0;
                    state <= INITIAL;
                end
                else begin  
                    state   <= RST_150;
                end
            end
            default:
                state <= INITIAL;
        endcase
    end
end
//End of FSM


/////// Timer Logic ////////////////////////////////////////////////////


// 1hz clock : timer counts down at 1Hz.
 // From spec: " For example, if add4 is then pushed, the display should read 300 seconds and
 //  begin counting down (at 1 Hz)."
 // this is what creates output timer value to the seven-segment display.
 // timer : the value which is going to be showed in the seven segments. 
// always running on 1hz clock, because decrease time each second like IRL

always @ (posedge(clk_1Hz), posedge(rst), posedge(rst1), posedge(rst2))
begin
    if (rst == 1'b1 || rst1 == 1'b1 || rst2 == 1'b1) begin
            timer <= 0;
            input_time_captured <= 1'b0;
            return_initial <= 1'b0;
    end
    else
        if (input_time_valid == 1'b0 && initial_state == 1'b1) begin
            timer <= 0;
            input_time_captured <= 0;
            return_initial <= 1'b0;
        end
        else if (input_time_valid == 1'b1 && initial_state == 1'b0) begin
            if ((timer + input_time) > 14'd9999) begin 
                timer <= 14'd9999;
                input_time_captured <= 1;
                return_initial <= 1'b0;
            end 
            else begin
                timer <= timer + input_time - 1;
                input_time_captured <= 1;
                return_initial <= 1'b0;                
            end
        end   
        else begin
            if (timer == 14'd0) begin 
                return_initial <= 1;
                input_time_captured <= 0;
            end
            else begin
                timer <= timer - 1;
                return_initial <= 0;
                input_time_captured <= 0;
            end
        end
end

//Instantiation of 1Hz clock

clk_divider_1Hz i_clk_divider_1Hz (
    .clk(clk), 
    .rst(rst), 
    .clk_div(clk_1Hz)
    );


//Instantiation of 2Hz clock

clk_divider_2Hz i_clk_divider_2Hz (
    .clk(clk), 
    .rst(rst), 
    .clk_div(clk_2Hz)
    );


///////////////////Blinking Logic /////////////////////////////

wire two_sec_flash; // set to 1 when 0.5 sec on and 0.5 sec off blinking is required
wire one_sec_flash;  // set to 2 when 1 sec on and 1 sec off blinking is required
reg [1:0] flash_counter;  // used to blink the sgements. 2bit value, 
wire [3:0] anode_array;

//assign anode_array = 4'b0000;

assign two_sec_flash = ((timer > 0) && (timer <= 14'd180)) ? 1'b1 : 1'b0; 
assign one_sec_flash = (timer == 0) ? 1'b1 : 1'b0;

always @ (posedge(clk_2Hz), posedge(rst))
begin
     if (rst) 
        flash_counter <= 1; // odd numbers (179,177,175)
     else 
        flash_counter <= flash_counter + 1;
end

/*
a1 - enable signal of the seven segment digit 0 ( 0 - ON, 1 - OFF)
a2 - enable signal of the seven segment digit 1 ( 0 - ON, 1 - OFF)
a3 - enable signal of the seven segment digit 2 ( 0 - ON, 1 - OFF)
a4 - enable signal of the seven segment digit 3 ( 0 - ON, 1 - OFF)

*/


/*
anode_array[0] - enable signal of the seven segment digit 0 coming from the seven segment controller logic
anode_array[1] - enable signal of the seven segment digit 1 coming from the seven segment controller logic
anode_array[2] - enable signal of the seven segment digit 2 coming from the seven segment controller logic
anode_array[3] - enable signal of the seven segment digit 3 coming from the seven segment controller logic

*/

always @ (*)
begin
	/*
	. When one_sec_flash = 1 and flash_counter [0] = 1 it will pass anode_array values from seven segment controller to the board
		That means segment will show the timer value. flash_counter [0] bit will change in each 2Hz clock cycle that means flash_counter[0] bit 
		is changing twice in the 1Hz period. 
		Sflash_counter[0] = 0 condition to blink and then we can use flash_counter [0] = 1 condition off.
	
	*/
    if (one_sec_flash == 1'b1 && flash_counter[0] == 1'b0) begin
        a1 <= anode_array[0];
        a2 <= anode_array[1];
        a3 <= anode_array[2];
        a4 <= anode_array[3];
    end
    else if (one_sec_flash == 1'b1 && flash_counter[0] == 1'b1) begin
        a1 <= 1'b1; //off blink when zero
        a2 <= 1'b1; //off
        a3 <= 1'b1; //off
        a4 <= 1'b1; //off
    end
	 
	  /*
	 When two_sec_flash = 1 and flash_counter[1] = 0 it will pass andoe_arrayvalues from seven segment controller to the hardware. flash_counter [1] bit will change 
	 in every other cycle of 2Hz clock cycle that means flash_counter[1] bit is changing once in the 1Hz period. 
	 So if we use flash_counter[1] = 0 condition to blink and then we can use flash_counter [1] = 1 condition off.
	 */
    else if (two_sec_flash == 1'b1 && flash_counter[1] == 1'b0) begin
        a1 <= anode_array[0];
        a2 <= anode_array[1];
        a3 <= anode_array[2];
        a4 <= anode_array[3];
    end
    else if (two_sec_flash == 1'b1 && flash_counter[1] == 1'b1) begin
        a1 <= 1'b1; //off odd
        a2 <= 1'b1; //off
        a3 <= 1'b1; //off
        a4 <= 1'b1; //off
    end
    else begin 
        a1 <= anode_array[0];
        a2 <= anode_array[1];
        a3 <= anode_array[2];
        a4 <= anode_array[3];  
    end      
end


// SEVEN SEG /////


wire [15:0] bcd_array;

assign val1 = bcd_array[ 3:0];
assign val2 = bcd_array[ 7:4];
assign val3 = bcd_array[11:8];
assign val4 = bcd_array[15:12];

binary2BCD i_binary2BCD ( // for val values
    .decimal(timer), 
    .bcd_array(bcd_array)
    );

four_digit_seven_seg_controller i_four_digit_seven_seg_controller ( // uses mux and decoder module
    .clk     (clk     ),
    .rst     (rst     ),
    .val1      (val1    ),
    .val2      (val2    ),
    .val3      (val3    ),
    .val4      (val4    ),
    .anode_array(anode_array),
    .led_seg (led_seg )
);

endmodule


// Below are the modules used //////////////////////////////////////////



///////////// 1Hz clock module ////////////////////////////////////////////////////

module clk_divider_1Hz(
    input clk, 
    input rst,
    output reg clk_div
    );
    
localparam terminalcount = (50 - 1); //(100hz to 1Hz)
// takes 50 clock cycles for clk_div to change its value

reg [31:0] count;
wire tc;

assign tc = (count == terminalcount); 

always @ (posedge(clk), posedge(rst))
begin
    if (rst) 
        count <= 0;
    else if (tc) 
        count <= 0;     // Reset input_time when terminal count reached
    else 
        count <= count + 1;
end

always @ (posedge(clk), posedge(rst))
begin
    if (rst) 
        clk_div <= 0;
    else if (tc) 
        clk_div <= !clk_div; // flip value when terminal count reached
end
endmodule

///////////////////////////////////1Hz clock module finished//////////////////////////////////////


/////////////////// 2Hz clock module ////////////////////////////////////////////////////


module clk_divider_2Hz (
    input clk, 
    input rst,
    output reg clk_div
    );
    
localparam terminalcount = (25 - 1); 
/* Ratio between 2Hz and 100Hz is 50. So if we count 25 cycle from 100Hz clock
we need to change in 25th cycle so we count until 24. That is terminal count came. 
If terminal count is reached ,we need to reset the input_time to count next period*/

reg [31:0] count;
wire tc;

assign tc = (count == terminalcount);  

always @ (posedge(clk), posedge(rst))
begin
    if (rst) 
        count <= 0;
    else if (tc) 
        count <= 0;     // Reset input_time when terminal count reached
    else 
        count <= count + 1;
end

always @ (posedge(clk), posedge(rst))
begin
    if (rst) 
        clk_div <= 1;
    else if (tc) 
        clk_div <= !clk_div; // flip value when terminal count reached
end
endmodule


/////////////////////// 2Hz clock module finished //////////////////



// Four digit seven seg controller //////////////////////////////////////

// a1,a2,a3,a4  are enable pins of each segment (if 0 - ON, if 1 - OFF)
// Problem is we have four segments and one leg_seg[6:0] ouput. 
// we need four leg_segs to show four digits. But required to only have one leg_seg connected to all four segments. 
// So we need multiplexing. 

// Instantiation from above
/*
binary2BCD i_binary2BCD (
    .decimal(timer), 
    .bcd_array(bcd_array)
    );

four_digit_seven_seg_controller i_four_digit_seven_seg_controller (
    .clk     (clk     ),
    .rst     (rst     ),
    .val1      (val1    ),
    .val2      (val2    ),
    .val3      (val3    ),
    .val4      (val4    ),
    .anode_array(anode_array),
    .led_seg (led_seg )
);

*/
module four_digit_seven_seg_controller (
    input clk,
    input rst,
    input [3:0] val1, // val1
    input [3:0] val2, // val2
    input [3:0] val3, // val3
    input [3:0] val4, // val4
    output [3:0] anode_array,
    output [6:0] led_seg // led_seg
    );
/*
Using a 2 bit counter I am changing mux selected input. Also it will control the decoder output as well. See
diagram in report
*/

reg [1:0] refresh_counter; // flash_counter bit. 2 bits. 1 or 0, 00 , 01 ,10 ,11. 2^2 =4 , 4 displays

// activating led input_time , continuosly update four seven segment displays. 100hz is enough for simulation purposes
always @ (posedge(clk), posedge(rst))
begin
     if (rst) 
        refresh_counter <= 0;
     else 
        refresh_counter <= refresh_counter + 1;
end

wire [3:0] seven_seg;

mux i_mux (.val1(val1), .val2(val2), .val3(val3), .val4(val4), .refresh_counter(refresh_counter), .O(seven_seg));

decoder i_decoder (.in(refresh_counter), .out(anode_array)); // 2 to 4 decoder. refresh_counter is flash_counter bit, anode_array is enable the segments to be on or off
/*
	So in this case all four segments should have the same val value. But we use decoder to turn off other three segments and turn on respective segment only.
	Like that we are supplying each value to the segment ????
	with a 100hz clock human eye may not catch the effect of refreshing. 

*/

seven_seg_controller i_seven_seg_controller ( // set the cathodes
    .bcd_in   (seven_seg),
    .led_seg  (led_seg  )
);

/*
Basically, what is happening is at one moment only one segment will light up. 
In the next clock cycle other one will light up. likewise, it will loop though the four seven segment display. 
Ideally with this refresh rate, we will see all segments will correct digits. 
*/
endmodule

////////// 14-bit binary => BCD output///////////////////////////////////////////////


module binary2BCD(  
  decimal,
  bcd_array
);
  input         [13:0] decimal; //14 bits enough to show 9999
  output    reg [15:0] bcd_array;
  
  //Declare internal variables
  
  reg [29:0] temp_reg;
  integer index;
	// double dabble algorithm: https://en.wikipedia.org/wiki/Double_dabble
  always @ (decimal) begin
    
    // prev number
    temp_reg [29:14] = 0; // 16 spots. 9999 is thousands, hundreds, tens , ones so 16 4 bit strings
    //  new number
    temp_reg [13:0] = decimal; // set first 14 bits to the input which can range up to 9999
    
    for(index=0; index < 14; index = index+1)
      begin
        
        if(temp_reg[29:26] > 4) begin
          temp_reg[29:26] = temp_reg[29:26] + 3; // if greater than 4 add 3
        end
        
        if(temp_reg[25:22] > 4) begin
          temp_reg[25:22] = temp_reg[25:22] + 3;
        end
        
        if(temp_reg[21:18] > 4) begin
          temp_reg[21:18] = temp_reg[21:18] + 3;
        end
        
        if(temp_reg[17:14] > 4) begin
          temp_reg[17:14] = temp_reg[17:14] + 3;
        end
        
        temp_reg = temp_reg << 1; // otherwise shift 
        
      end  
    //  outputs four BCD values in  16-bit register 'bcd_array.' 
    // 0 to 3 are  digit 1
    
    bcd_array = temp_reg[29:14];  
  end
endmodule


////////////// Anode Decoder ///////////////////////////////////////////////////////////////////

// anode => digit enables

/*
 So in this case all four segments should have the same val value. But we use decoder to turn off other three segments and turn on respective segment only.
controller will supply each value to each segment in four clock cycles
with a 100hz clock rate it might fool the human eye

*/
module decoder ( // 4 anodes. so 2 bit flash_counter line. 
    input [1:0] in, 
    output reg [3:0] out
    );

    always @ (*)
    begin
     case(in) 
        2'b00 : begin // based off reasarch, to get anode binary strings, notice in each one , one bit is 0
            out <= 4'b1110;
        end
        2'b01 : begin
            out <= 4'b1101;
        end
        2'b10 : begin
            out <= 4'b1011;
        end
        2'b11 : begin
            out <= 4'b0111;
        end
     endcase 
    end
endmodule


/////////////// MUX /////////////////////////////////////////////////////////////////////////////


module mux (
    input [3:0] val1, // val1
    input [3:0] val2, // val2
    input [3:0] val3, // val3
    input [3:0] val4, // val4
    input [1:0] refresh_counter,
    output reg [3:0] O // which val to be passed into seven seg controller. the decoder will make sure only the right digit
	 // is activated, and refresh rate will hoppefull make it so the human eye can't catch it when going through the 4 vals
    );

    always @ (*)
    begin : MUX
     case(refresh_counter) 
        2'b00 : 
            O <= val1;
        2'b01 : 
            O <= val2;
        2'b10 : 
            O <= val3;
        2'b11 : 
            O <= val4;
        default : 
            O <= val1;
     endcase 
    end
endmodule


//////////////////// SEVEN SEG CONTROLLER /////////////////


module seven_seg_controller ( // 7 seg decoder
    input [3:0] bcd_in,
    output reg [6:0] led_seg
    );

// Cathode patterns of the 7-segment LED display 
always @(*)
    begin
     case(bcd_in)
     4'b0000: led_seg <= 7'b0000001; // "0"  
     4'b0001: led_seg <= 7'b1001111; // "1" 
     4'b0010: led_seg <= 7'b0010010; // "2" 
     4'b0011: led_seg <= 7'b0000110; // "3" 
     4'b0100: led_seg <= 7'b1001100; // "4" 
     4'b0101: led_seg <= 7'b0100100; // "5" 
     4'b0110: led_seg <= 7'b0100000; // "6" 
     4'b0111: led_seg <= 7'b0001111; // "7" 
     4'b1000: led_seg <= 7'b0000000; // "8"  
     4'b1001: led_seg <= 7'b0000100; // "9" 
     default: led_seg <= 7'b0000001; // "0"
     endcase
    end
endmodule

