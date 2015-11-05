`ifndef ISSUE_V
`define ISSUE_V

`include "./src/Scoreboard.v"
`include "./src/HazardDetector.v"

module Issue(
    input        clock,
    input        reset,

    // Inputs to repeat to execution stage
    input        id_iss_selalushift,
    input        id_iss_selimregb,
    input [2:0]  id_iss_aluop,
    input        id_iss_unsig,
    input [1:0]  id_iss_shiftop,
    input [4:0]  id_iss_shiftamt,
    input [31:0] id_iss_rega,
    input        id_iss_readmem,
    input        id_iss_writemem,
    input [31:0] id_iss_regb,
    input [31:0] id_iss_imedext,
    input        id_iss_selwsource,
    input [4:0]  id_iss_regdest,
    input        id_iss_writereg,
    input        id_iss_writeov,

    // These are register values from the register file
    input [31:0] reg_id_ass_dataa,
    input [31:0] reg_id_ass_datab,

    // These are the register addresses, we use them to access the register file
    input [4:0]  id_reg_addra,
    input [4:0]  id_reg_addrb,

    // Represents number of register operands (1 => 3 registers, 0 => 2 registers)
    input        id_iss_selregdest,

    // Repeated to execution stage
    output        iss_ex_selalushift,
    output        iss_ex_selimregb,
    output [2:0]  iss_ex_aluop,
    output        iss_ex_unsig,
    output [1:0]  iss_ex_shiftop,
    output [4:0]  iss_ex_shiftamt,
    output [31:0] iss_ex_rega,
    output        iss_ex_readmem,
    output        iss_ex_writemem,
    output [31:0] iss_ex_regb,
    output [31:0] iss_ex_imedext,
    output        iss_ex_selwsource,
    output [4:0]  iss_ex_regdest,
    output        iss_ex_writereg,
    output        iss_ex_writeov,

    // These connect to the register file
    // Output from register file is connected to inputs above
    output [31:0] iss_reg_addra,
    output [31:0] iss_reg_addrb,

    // Functional unit to send instruction
    output reg [1:0] iss_ex_func_unit,

    // Issue-related stall
    output       iss_stall

);

    assign iss_ex_selalushift = id_iss_selalushift;
    assign iss_ex_selimregb = id_iss_selimregb;
    assign iss_ex_aluop = id_iss_aluop;
    assign iss_ex_unsig = id_iss_unsig;
    assign iss_ex_shiftop = id_iss_shiftop;
    assign iss_ex_shiftamt = id_iss_shiftamt;
    assign iss_ex_rega = id_iss_rega;
    assign iss_ex_readmem = id_iss_readmem;
    assign iss_ex_writemem = id_iss_writemem;
    assign iss_ex_regb = id_iss_regb;
    assign iss_ex_imedext = id_iss_imedext;
    assign iss_ex_selwsource = id_iss_selwsource;
    assign iss_ex_regdest = id_iss_regdest;
    assign iss_ex_writereg = id_iss_writereg;
    assign iss_ex_writeov = id_iss_writeov;
    assign iss_reg_addra = id_reg_addra;
    assign iss_reg_addrb = id_reg_addrb;
    assign reg_iss_dataa = reg_id_dataa;
    assign reg_iss_datab = reg_id_datab;

    // Register to read from file
    assign iss_reg_addra = id_reg_addra;
    assign iss_reg_addrb = id_reg_addrb;

    wire       a_pending;
    wire       b_pending;

    wire [4:0] ass_row_a;
    wire [4:0] ass_row_b;

    wire [1:0] ass_unit_a;
    wire [1:0] ass_unit_b;

    wire [1:0] registerunit;

    wire [4:0] writeaddr_a;
    wire       enablewrite_a;
    
    wire [4:0] writeaddr_b;
    wire       enablewrite_b;

    Scoreboard SB (.clock(clock),
                   .reset(reset),

                   .ass_addr_a(id_reg_addra),
                   .ass_pending_a(a_pending),
                   .ass_unit_a(ass_unit_a),
                   .ass_row_a(ass_row_a),

                   .ass_addr_b(id_reg_addrb),
                   .ass_pending_b(b_pending),
                   .ass_unit_b(ass_unit_b),
                   .ass_row_b(ass_row_b),

                   .registerunit(registerunit),

                   .writeaddr_a(writeaddr_a),
                   .enablewrite_a(enablewrite_a),
                   
                   .writeaddr_b(writeaddr_b),
                   .enablewrite_b(enablewrite_b)
        );

    HazardDetector HDETECTOR(.ass_pending_a(a_pending),
                             .ass_row_a(ass_row_a),
                             .ass_pending_b(b_pending),
                             .ass_row_b(ass_row_b),
                             .selregdest(id_iss_selregdest),
                             .stalled(iss_stall)
    );

    always @(posedge clock or negedge reset) begin
        if (reset) begin
            if(~iss_stall) begin
                // TODO send to corresponding functional unit
            end else begin
                iss_ex_func_unit <= 2'bZZ;
            end
        end
    end

endmodule

`endif
