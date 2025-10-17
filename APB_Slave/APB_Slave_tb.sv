module APB_Slave_tb;
  logic        clk;
  logic        reset;
  logic        psel_i;
  logic        penable_i;
  logic [9:0]  paddr_i;
  logic        pwrite_i;
  logic [31:0] pwdata_i;
  wire  [31:0] prdata_o;
  wire         pready_o;


  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end


  APB_Slave u_dut (
    .clk        (clk),
    .reset      (reset),
    .psel_i     (psel_i),
    .penable_i  (penable_i),
    .paddr_i    (paddr_i),
    .pwrite_i   (pwrite_i),
    .pwdata_i   (pwdata_i),
    .prdata_o   (prdata_o),
    .pready_o   (pready_o)
  );


  initial begin
    // Initialize signals
    reset = 1;
    psel_i = 0;
    penable_i = 0;
    paddr_i = '0;
    pwrite_i = 0;
    pwdata_i = '0;


    repeat(5) @(posedge clk);
    reset = 0;
    @(posedge clk);


    $display("Test Case 1: Write to memory address 4'h3");
    write_transaction(10'h3, 32'hDEADBEEF);
    repeat(2) @(posedge clk);


    $display("Test Case 2: Read from memory address 4'h3");
    read_transaction(10'h3);
    

    $display("Test Case 3: Write to memory address 4'h7");
    write_transaction(10'h7, 32'h12345678);
    repeat(2) @(posedge clk);


    $display("Test Case 4: Read from memory address 4'h7");
    read_transaction(10'h7);


    repeat(5) @(posedge clk);
    $finish;
  end

  task write_transaction(input logic [9:0] addr, input logic [31:0] data);
    // Setup phase
    @(posedge clk);
    psel_i = 1;
    paddr_i = addr;
    pwdata_i = data;
    pwrite_i = 1;
    

    @(posedge clk);
    penable_i = 1;
    

    while (!pready_o) @(posedge clk);
    

    @(posedge clk);
    psel_i = 0;
    penable_i = 0;
  endtask


  task read_transaction(input logic [9:0] addr);

    @(posedge clk);
    psel_i = 1;
    paddr_i = addr;
    pwrite_i = 0;
    

    @(posedge clk);
    penable_i = 1;
    

    while (!pready_o) @(posedge clk);
    

    $display("Read Data: 0x%h", prdata_o);
    

    @(posedge clk);
    psel_i = 0;
    penable_i = 0;
  endtask


  property apb_setup_phase;
    @(posedge clk) psel_i && !penable_i |=> penable_i;
  endproperty
  
  property apb_valid_ready;
    @(posedge clk) psel_i && penable_i && !pready_o |=> psel_i && penable_i;
  endproperty

  assert_apb_setup:    assert property(apb_setup_phase);
  assert_apb_ready:    assert property(apb_valid_ready);

endmodule