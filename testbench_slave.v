`include "ahb_slave.v"
`include "ahb_slave_mem.v"
`include "ahb_slave_ram.v"

module test_ahb_slave;


   reg                      clk;
   reg                      reset;
   reg			    HSEL;
   
   reg  [23:0]               HADDR;
   reg  [2:0]                HBURST;
   reg  [1:0]                HSIZE;
   reg  [1:0]                HTRANS;
   reg                       HWRITE;
   reg  [31:0]               HWDATA;
   reg [2:0]			RANDSPLIT;		//First bit indicates whether or not split will be used, and the rest 3 bits the master number.//CHANGES//
   reg [3:0]			HMASTER;		//CHANGES//
   reg				HMASTLOCK;		//CHANGES//
   reg     		     STALL_pre;

   wire [31:0]              HRDATA;
   wire 		    HREADY;
   wire [1:0]		    HRESP;
   wire [15:0]			HSPLIT;

   wire                     WR;
   wire                     RD;
   wire [8:0]              ADDR_WR;
   wire [8:0]              ADDR_RD;
   wire [31:0]              DIN;
   wire [31:0]              DOUT;
  

   initial
   begin
   
	  $dumpfile("Testsplit.vcd");
	  $dumpvars(0,test_ahb_slave);
	  
	  clk = 1'b0;
	  reset = 1'b1;
	  HSEL = 1'b0;
	  HADDR = 24'h0;
	  HBURST = 3'b000;
	  HSIZE = 2'b00;
	  HTRANS = 2'b00;
	  HWRITE = 1'b0;
	  HWDATA = 32'h0;
	  STALL_pre = 1'b0;
	  RANDSPLIT = $random;
	  HMASTER = 4'b0001;
	  HMASTLOCK = 1'b0;
	  
	  /* eisagwgh ths timhs 1 sth thesh 20*/
	  #5  reset = 1'b0;
	      HSEL = 1'b1;
	      HADDR = 24'h20;
	      RANDSPLIT = $random;
	      HBURST = 3'b101;
	      HSIZE = 2'b10;
	      HTRANS = 2'b10;	/*NONSEQ = 2'b10*/
	      HWRITE = 1'b1;
	      HWDATA = 32'h1;
	      STALL_pre = 1'b1;

	  #10 HWRITE = 1'b1;
	  
	  /* anagnwsh ths timhs apo th thesh 20*/
	  #10 HWRITE = 1'b0;
	      HMASTER = 4'b0010;
	      RANDSPLIT = $random;

	  /* eisagwgh ths timhs 2 sth thesh 24*/    
	  #10 HADDR = 24'h24;
	      HTRANS = 2'b11;	/*SEQ = 2'b11*/
	      HWRITE = 1'b1;
	      HWDATA = 32'h2;
	      RANDSPLIT = $random;
	      	  
	  #10 HWRITE = 1'b1; 


	  /* anagnwsh ths timhs apo th thesh 24*/
	  #10 HWRITE = 1'b0;   
	      RANDSPLIT = $random;
	  /* eisagwgh ths timhs 2 sth thesh 28*/
	  #10 HADDR = 24'h28;
	      HTRANS = 2'b10;	/*NONSEQ = 2'b11*/
	      HWRITE = 1'b1;
	      HWDATA = 32'h3;
	      RANDSPLIT = $random;
	      
	  #10 HWRITE = 1'b1; 


	  /* anagnwsh ths timhs apo th thesh 28*/
	  #10 HWRITE = 1'b0; 
	      RANDSPLIT = $random;

	  /* eisagwgh ths timhs 4 sth thesh 2c*/
	  #10 HADDR = 24'h2c;
	      HTRANS = 2'b11;	/*SEQ = 2'b11*/
	      HWRITE = 1'b1;
	      HWDATA = 32'h4;
	      RANDSPLIT = $random;
 
	      
	  #10 HWRITE = 1'b1; 

	  
	  /* anagnwsh ths timhs apo th thesh 2c*/
	  #10 HWRITE = 1'b0;
	      RANDSPLIT = $random;

	  /* eisagwgh ths timhs 5 sth thesh 30*/	
	  #10 HADDR = 24'h30;
	      HBURST = 3'b101;
	      HSIZE = 2'b10;
	      HTRANS = 2'b01;	/*STALL   = 2'b01*/
	      HWRITE = 1'b1;
	      HWDATA = 32'h5;
	      RANDSPLIT = $random;
	      
	  #100 $finish;
   end
    
   always 
   begin
	  #5 clk = ~clk;
   end

   ahb_slave slave_test(clk,reset,HSEL,HADDR,HBURST,HSIZE,HTRANS,HWRITE,HWDATA,RANDSPLIT,HMASTER,HMASTLOCK,HRDATA,HREADY,HRESP,HSPLIT,STALL_pre);

endmodule
