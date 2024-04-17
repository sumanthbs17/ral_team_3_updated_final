// Declare a sequence_item for the APB transaction


// Drives a given apb transaction packet to the APB interface
class my_driver extends uvm_driver #(seq_item);
   `uvm_component_utils (my_driver)

   seq_item  pkt;

   virtual bus_if vif;

   function new (string name = "my_driver", uvm_component parent);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
     if (! uvm_config_db#(virtual bus_if)::get (this, "*", "vif", vif))
         `uvm_error ("DRVR", "Did not get bus if handle")
   endfunction

   virtual task run_phase (uvm_phase phase);
      bit [31:0] data;

      vif.psel <= 0;
      vif.penable <= 0;
      vif.pwrite <= 0;
      vif.paddr <= 0;
      vif.pwdata <= 0;
      forever begin
         seq_item_port.get_next_item (pkt);
         if (pkt.write)
            write (pkt.addr, pkt.data);
         else begin
            read (pkt.addr, data);
            pkt.data = data;
         end
         seq_item_port.item_done ();
      end
   endtask

   virtual task read (  input bit    [31:0] addr,
                        output logic [31:0] data);
      vif.paddr <= addr;
      vif.pwrite <= 0;
      vif.psel <= 1;
      @(posedge vif.clk);
      vif.penable <= 1;
     @(posedge vif.clk);
      data = vif.prdata;
      vif.psel <= 0;
      vif.penable <= 0;
   endtask

   virtual task write ( input bit [31:0] addr,
                        input bit [31:0] data);
      vif.paddr <= addr;
      vif.pwdata <= data;
      vif.pwrite <= 1;
      vif.psel <= 1;
      @(posedge vif.clk);
      vif.penable <= 1;
      @(posedge vif.clk);
      vif.psel <= 0;
      vif.penable <= 0;
   endtask
endclass

// Monitors the APB interface for any activity and reports out
// through an analysis port
class my_monitor extends uvm_monitor;
   `uvm_component_utils (my_monitor)
   function new (string name="my_monitor", uvm_component parent);
      super.new (name, parent);
   endfunction

  uvm_analysis_port #(seq_item)  mon_ap;
   virtual bus_if  vif;

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      mon_ap = new ("mon_ap", this);
     uvm_config_db #(virtual bus_if)::get (null, "*", "vif", vif);
   endfunction

   virtual task run_phase (uvm_phase phase);
      
         forever begin
            @(posedge vif.clk)
            if (vif.psel & vif.penable & vif.presetn) begin
               seq_item pkt = seq_item::type_id::create ("pkt");
               pkt.addr = vif.paddr;
               if (vif.pwrite)
                  pkt.data = vif.pwdata;
               else
                  pkt.data = vif.prdata;
               pkt.write = vif.pwrite;
               mon_ap.write (pkt);
            end
         end
     
   endtask
endclass

// The agent puts together the driver, sequencer and monitor
class my_agent extends uvm_agent;
  `include "my_sequencer.sv"
   `uvm_component_utils (my_agent)
   function new (string name="my_agent", uvm_component parent);
      super.new (name, parent);
   endfunction

   my_driver                  m_drvr;
   my_monitor                 m_mon;
   my_sequencer               m_seqr;

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_drvr = my_driver::type_id::create ("m_drvr", this);
     m_seqr = my_sequencer::type_id::create ("m_seqr", this);
      m_mon = my_monitor::type_id::create ("m_mon", this);
   endfunction

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase (phase);
      m_drvr.seq_item_port.connect (m_seqr.seq_item_export);
   endfunction
endclass