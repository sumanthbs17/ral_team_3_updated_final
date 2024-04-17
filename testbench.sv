// Code your testbench here
// or browse Examples
//`timescale 1ns/1ps
import uvm_pkg::*;
 `include "uvm_macros.svh"


//`include "axi4_globals_pkg.sv"
//`include "design.sv"
`include "bus_if.sv"
`include "base_test.sv"





module testbench;

bit clk;
bit rst;
always #5 clk = ~clk;
initial begin
//  clk = 1;
  rst = 1;
  #6;
  rst = 0;
//  `uvm_info("CLOCK", $sformatf("clk = %0d",clk), 
end

bus_if vif (clk, rst);

  designs  pB0 (  .clk    (vif.clk),
                .rst (vif.rst),
                .paddr   (vif.paddr),
                .p_wdata  (vif.pwdata),
                .prdata  (vif.prdata),
                .psel    (vif.psel),
                .p_write  (vif.pwrite),
                .pen (vif.penable),
                .data_in (vif.data_in),
                .valid_in (vif.valid_in),
                .valid_out (vif.valid_out),
                .out_port1 (vif.out_port1),
                .out_port2 (vif.out_port2),
                .out_port3 (vif.out_port3),
                .out_port4 (vif.out_port4)
                
               );
 

  initial begin
  `uvm_info("TOP",$sformatf("in top"),UVM_NONE);
    uvm_config_db#(virtual bus_if)::set(null, "", "vif", vif);
    run_test("reg_test");
    #500 $finish;
  end
endmodule