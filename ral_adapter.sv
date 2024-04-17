class ral_adapter extends uvm_reg_adapter;
  `uvm_object_utils (ral_adapter)
//   uvm_sequencer #(bus_pkt)     tmp_seqr;

  function new (string name = "ral_adapter");
      super.new (name);
   endfunction

   virtual function uvm_sequence_item reg2bus (const ref uvm_reg_bus_op rw);
      seq_item pkt = seq_item::type_id::create ("pkt");
//      pkt.set_sequencer (this.tmp_seqr);
      pkt.write = (rw.kind == UVM_WRITE) ? 1: 0;
      pkt.addr  = rw.addr;
      pkt.data  = rw.data;
     $info("nkzdfnbhcb ");
      `uvm_info ("adapter", $sformatf ("reg2bus addr=0x%0h data=0x%0h kind=%s", pkt.addr, pkt.data, rw.kind.name), UVM_DEBUG) 
      return pkt; 
   endfunction

   virtual function void bus2reg (uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
      seq_item pkt;
      if (! $cast (pkt, bus_item)) begin
         `uvm_fatal ("reg2apb_adapter", "Failed to cast bus_item to pkt")
      end
   
      rw.kind = pkt.write ? UVM_WRITE : UVM_READ;
      rw.addr = pkt.addr;
      rw.data = pkt.data;
      `uvm_info ("adapter", $sformatf("bus2reg : addr=0x%0h data=0x%0h kind=%s status=%s", rw.addr, rw.data, rw.kind.name(), rw.status.name()), UVM_DEBUG)
   endfunction
endclass