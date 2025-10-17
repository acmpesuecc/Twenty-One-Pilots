// APB Master Interface
// Generates APB transactions based on command input

module APB_Master (
  input       wire        clk,
  input       wire        reset,

  input       wire[1:0]   cmd_i,        // 00: NOP, 01: Read, 10: Write

  // APB Interface
  output      reg         psel_o,
  output      reg         penable_o,
  output      reg[31:0]   paddr_o,
  output      reg         pwrite_o,
  output      reg[31:0]   pwdata_o,
  input       wire        pready_i,
  input       wire[31:0]  prdata_i,
  
  // Additional outputs for system integration
  output      reg         rd_valid_o,
  output      reg[31:0]   rd_data_o
);

  // Fixed address for operations
  localparam ADDR = 32'hDEAD_CAFE;
  
  // State machine
  typedef enum logic [2:0] {
    IDLE   = 3'b000,
    SETUP  = 3'b001,
    ACCESS = 3'b010,
    WAIT   = 3'b011
  } apb_state_t;
  
  apb_state_t current_state, next_state;
  
  // Registered data for increment operation
  reg [31:0] last_read_data;
  
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
        if (cmd_i == 2'b01 || cmd_i == 2'b10) begin
          next_state = SETUP;
        end
      end
      
      SETUP: begin
        next_state = ACCESS;
      end
      
      ACCESS: begin
        if (pready_i) begin
          next_state = WAIT;
        end
      end
      
      WAIT: begin
        if (cmd_i == 2'b00) begin
          next_state = IDLE;
        end
      end
      
      default: next_state = IDLE;
    endcase
  end
  
  // Output logic
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      psel_o <= 1'b0;
      penable_o <= 1'b0;
      paddr_o <= 32'd0;
      pwrite_o <= 1'b0;
      pwdata_o <= 32'd0;
      rd_valid_o <= 1'b0;
      rd_data_o <= 32'd0;
      last_read_data <= 32'd0;
    end else begin
      case (current_state)
        IDLE: begin
          psel_o <= 1'b0;
          penable_o <= 1'b0;
          rd_valid_o <= 1'b0;
        end
        
        SETUP: begin
          psel_o <= 1'b1;
          penable_o <= 1'b0;
          paddr_o <= ADDR;
          rd_valid_o <= 1'b0;
          
          case (cmd_i)
            2'b01: begin  // Read
              pwrite_o <= 1'b0;
            end
            2'b10: begin  // Write (increment and write)
              pwrite_o <= 1'b1;
              pwdata_o <= last_read_data + 1;
            end
            default: begin
              pwrite_o <= 1'b0;
            end
          endcase
        end
        
        ACCESS: begin
          psel_o <= 1'b1;
          penable_o <= 1'b1;
          
          if (pready_i) begin
            if (!pwrite_o) begin  // Read operation completed
              last_read_data <= prdata_i;
              rd_data_o <= prdata_i;
              rd_valid_o <= 1'b1;
            end else begin
              rd_valid_o <= 1'b0;
            end
          end
        end
        
        WAIT: begin
          psel_o <= 1'b0;
          penable_o <= 1'b0;
          if (rd_valid_o) begin
            rd_valid_o <= 1'b0;  // Clear valid after one cycle
          end
        end
        
        default: begin
          psel_o <= 1'b0;
          penable_o <= 1'b0;
          rd_valid_o <= 1'b0;
        end
      endcase
    end
  end

endmodule
