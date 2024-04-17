class base_sequence extends uvm_sequence#(seq_item);
  seq_item req;
  `uvm_object_utils(base_sequence)
  
  function new (string name = "base_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Base seq: Inside Body", UVM_LOW);
    `uvm_do(req);
  endtask
endclass

class reg_seq extends uvm_sequence#(seq_item);
  seq_item req;
  ral_sys_reg m_ral_model;
  uvm_status_e   status;
  uvm_reg_data_t read_data;
  `uvm_object_utils(reg_seq)
  
  function new (string name = "reg_seq");
    super.new(name);
  endfunction

  task body();
    `uvm_info(get_type_name(), "Reg seq: Inside Body", UVM_LOW);
    if(!uvm_config_db#(ral_sys_reg) :: get(uvm_root::get(), "", "m_ral_model", m_ral_model))
      `uvm_fatal(get_type_name(), "m_ral_model is not set at top level");
       
       m_ral_model.md_reg.chip_en_reg_h.write(status, 1'b1);
    m_ral_model.md_reg.chip_en_reg_h.read(status, read_data);
    
  //     m_ral_model.md_reg.chip_id.write(status, 8'b01010101);
   // m_ral_model.md_reg.chip_id.read(status, read_data);
    
  //     m_ral_model.md_reg.output_port_en.write(status, 4'b0100);
   // m_ral_model.md_reg.output_port_en.read(status, read_data);
  endtask
endclass