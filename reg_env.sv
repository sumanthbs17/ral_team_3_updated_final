// Register environment class puts together the model, adapter and the predictor

//`include "ral_sys_reg.sv"
//`include "pkt_reg_adapter.sv"

class reg_env extends uvm_env;
   `uvm_component_utils (reg_env)
   function new (string name="reg_env", uvm_component parent);
      super.new (name, parent);
   endfunction

   ral_sys_reg               m_ral_model;         // Register Model
   ral_adapter                m_reg2apb;           // Convert Reg Tx <-> Bus-type packets
  uvm_reg_predictor #(seq_item)   m_apb2reg_predictor; // Map APB tx to register in model
   my_agent                       m_agent;             // Agent to drive/monitor transactions

   virtual function void build_phase (uvm_phase phase);
      super.build_phase (phase);
     m_agent         = my_agent ::type_id::create ("m_agent", this);
      m_ral_model          = ral_sys_reg ::type_id::create ("m_ral_model", this);
      m_reg2apb            = ral_adapter :: type_id :: create ("m_reg2apb");
     m_apb2reg_predictor  = uvm_reg_predictor #(seq_item) :: type_id :: create ("m_apb2reg_predictor", this);

      m_ral_model.build ();
     m_ral_model.reset ();
      m_ral_model.lock_model ();
     m_ral_model.print ();
     uvm_config_db #(ral_sys_reg)::set (null, "uvm_test_top", "m_ral_model", m_ral_model);
   endfunction

   virtual function void connect_phase (uvm_phase phase);
      super.connect_phase (phase);
      m_apb2reg_predictor.map       = m_ral_model.default_map;
      m_apb2reg_predictor.adapter   = m_reg2apb;
     m_ral_model.default_map.set_sequencer( .sequencer( m_agent.m_seqr), .adapter(m_reg2apb) );
     m_ral_model.default_map.set_base_addr('h0);
   endfunction
endclass
