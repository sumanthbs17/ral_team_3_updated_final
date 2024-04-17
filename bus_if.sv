interface bus_if (input clk,input rst);
  // This interface holds signals related to APB bus protocol
   logic [31:0]   paddr;
   logic [31:0]   pwdata;
   logic [31:0]   prdata;
   logic          pwrite;
   logic          psel;
   logic          penable;
   logic          presetn;
   logic data_in;
  logic valid_in;
  logic out_port1;
  logic out_port2;
  logic out_port3;
  logic out_port4;
  logic valid_out;
endinterface