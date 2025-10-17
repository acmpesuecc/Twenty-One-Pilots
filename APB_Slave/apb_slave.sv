// APB Slave Interface
// Interfaces with Simple Memory Interface using APB protocol

module APB_Slave (
  input         wire        clk,
  input         wire        reset,

  // APB Interface
  input         wire        psel_i,
  input         wire        penable_i,
  input         wire[9:0]   paddr_i,
  input         wire        pwrite_i,
  input         wire[31:0]  pwdata_i,
  output        reg[31:0]   prdata_o,
  output        reg         pready_o,
  
  // Memory Interface
  output        reg         mem_req_o,
  output        reg         mem_req_rnw_o,
  output        reg[3:0]    mem_req_addr_o,
  output        reg[31:0]   mem_req_wdata_o,
  input         wire        mem_req_ready_i,
  input         wire[31:0]  mem_req_rdata_i
);

  // APB State Machine
  typedef enum logic [1:0] {
    IDLE   = 2'b00,
    SETUP  = 2'b01,
    ACCESS = 2'b10
  } apb_state_t;
  
  apb_state_t current_state, next_state;
  
  // State register
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      current_state <= IDLE;
    end else begin
      current_state <= next_state;
    end
  end
  
  // Next state logic
  always @(*) begin
    next_state = current_state;
    
    case (current_state)
      IDLE: begin
        if (psel_i && !penable_i) begin
          next_state = SETUP;
        end
      end
      
      SETUP: begin
        if (penable_i) begin
          next_state = ACCESS;
        end
      end
      
      ACCESS: begin
        if (mem_req_ready_i) begin
          next_state = IDLE;
        end
      end
      
      default: next_state = IDLE;
    endcase
  end
  
  // Output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      mem_req_o <= 1'b0;
      mem_req_rnw_o <= 1'b0;
      mem_req_addr_o <= 4'd0;
      mem_req_wdata_o <= 32'd0;
      prdata_o <= 32'd0;
      pready_o <= 1'b0;
    end else begin
      case (current_state)
        IDLE: begin
          mem_req_o <= 1'b0;
          pready_o <= 1'b0;
        end
        
        SETUP: begin
          // Prepare memory request
          mem_req_o <= 1'b1;
          mem_req_rnw_o <= !pwrite_i;  // Convert write to rnw (read-not-write)
          mem_req_addr_o <= paddr_i[3:0];  // Use lower 4 bits for memory address
          mem_req_wdata_o <= pwdata_i;
          pready_o <= 1'b0;
        end
        
        ACCESS: begin
          mem_req_o <= 1'b1;
          if (mem_req_ready_i) begin
            pready_o <= 1'b1;
            if (!pwrite_i) begin
              prdata_o <= mem_req_rdata_i;
            end
          end else begin
            pready_o <= 1'b0;
          end
        end
        
        default: begin
          mem_req_o <= 1'b0;
          pready_o <= 1'b0;
        end
      endcase
    end
  end

endmodule
