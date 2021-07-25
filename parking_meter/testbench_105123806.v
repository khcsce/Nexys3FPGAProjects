`timescale 1ms / 1us

module testbench_105123806;
    // Inputs 
    reg clk;
    reg rst;
    reg add1;
    reg add2;
    reg add3;
    reg add4;
    reg rst1;
    reg rst2;
    // Output
    wire a1;
    wire a2;
    wire a3;
    wire a4;
    wire [6:0] led_seg;
    wire [3:0] val1;
    wire [3:0] val2;
    wire [3:0] val3;
    wire [3:0] val4;  

// Instantiate the Unit Under Test (UUT)
parking_meter uut (
    .clk (clk ),
    .rst (rst ),
    .add1(add1),
    .add2(add2),
    .add3(add3),
    .add4(add4),
    .rst1(rst1),
    .rst2(rst2),
    .a1(a1),
    .a2(a2),
    .a3(a3),
    .a4(a4),
    .led_seg(led_seg),   
    .val1(val1),
    .val2(val2),
    .val3(val3),
    .val4(val4)
);

    //always
    //    #5 clk = ~clk; //clk //100MHz
    always
        #5 clk = ~clk; //clk //100Hz (10ms)

    initial begin
        // Initialize Inputs
        clk  = 0;
        rst  = 1;
        add1 = 0;
        add2 = 0;
        add3 = 0;
        add4 = 0;
        rst1 = 0;
        rst2 = 0;

        #100 ; //100ms
        rst = 0;
        // Wait 100 ns for global reset to finish
        #100;  //100ms

        //CASE 1//
       //60 coin //
          
        add1 = 1; 
        #100;   //100ms 
        add1 = 0;  
        #70000; //70s

        //CASE 2//
        // 60 and 120 coin within 1 sec//
      

        add1 = 1; 
        #100;   //100ms
        add1 = 0;
        #100;  //100ms
        add2 = 1; 
        #100;   //100ms 
        add2 = 0;
        #190000;  //190s

        //CASE 3//
        //I180, and 60 coin after 10S //
        
        
        add3 = 1; 
        #100; //100ms
        add3 = 0;  
        #10000; //10S
        add1 = 1; 
        #100;  //100ms
        add1 = 0;
        #250000; //25S

        //CASE 4//
        //300 coin and rst1 in the middle///
        

        add4 = 1; 
        #100;  //100ms
        add4 = 0;  
        #10000; //10S
        rst1 = 1; 
        #100;   //100ms
        rst1 = 0;
        #20000; //20s

        //CASE 5//
        //180 coin and rst2 in the middle//
     
        #1000; //1S
        add3 = 1; 
        #100;  //100ms
        add3 = 0;  
        #5600; //5S
        rst2 = 1; 
        #100;  //100ms
        rst2 = 0;
        #160000; //100S

       
        //Input of coins greater than 9999  
      
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        //////////3000////////
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S  
        //////////6000////////
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S 
        //////////9000////////
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        add4 = 1; 
        #1000;  //1S
        add4 = 0; 
        #1000;  //1S
        /////////10500/////////
        #5000;               
    end
endmodule