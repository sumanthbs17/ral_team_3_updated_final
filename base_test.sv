
`include "package.sv"


class base_test extends uvm_test;
   `uvm_component_utils (base_test)

   reg_env         m_env;
  
//    reset_seq      m_reset_seq;
   uvm_status_e   status;

   function new (string name = "base_test", uvm_component parent);
      super.new (name, parent);
   endfunction

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
      m_env = reg_env::type_id::create ("m_env", this);
     
//       m_reset_seq = reset_seq::type_id::create ("m_reset_seq", this);
   endfunction

//    virtual task  reset_phase (uvm_phase phase);
//       super.reset_phase (phase);
//       phase.raise_objection (this);
//       m_reset_seq.start (m_env.m_agent.m_seqr);
//       phase.drop_objection (this);
//    endtask

   virtual task run_phase (uvm_phase phase);
      base_sequence m_seq = base_sequence::type_id::create ("m_seq");
      phase.raise_objection (this);
      m_seq.start (m_env.m_agent.m_seqr);
      phase.drop_objection (this);
   endtask
endclass

class reg_test extends base_test;
  `uvm_component_utils(reg_test)
  
  function new(string name = "reg_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
  
  task test_imp();
   reg_seq rseq = reg_seq::type_id::create("rseq");
    rseq.start(m_env.m_agent.m_seqr);
  endtask
endclass