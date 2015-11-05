`ifndef SCOREBOARD_V
`define SCOREBOARD_V

module Scoreboard(
    input            clock,
    input            reset,

    // inputs from issue stage, this is asynchronous
    // 1st register
    input      [4:0] ass_addr_a,      // requested register
    output           ass_pending_a,   // register status
    output     [1:0] ass_unit_a,      // register functional unit
    output     [4:0] ass_row_a,       // register execution stage
    // 2nd register
    input      [4:0] ass_addr_b,      // requested register
    output           ass_pending_b,   // register status
    output     [1:0] ass_unit_b,      // register functional unit
    output     [4:0] ass_row_b,       // register execution stage

    // inputs from issue stage
    input      [1:0] registerunit,    // which functional unit it is going to
    // 1st register
    input      [4:0] writeaddr_a,     // register to become pending
    input            enablewrite_a,    // prevent incorrect write (e.g. during stalls)
    // 2nd register
    input      [4:0] writeaddr_b,     // register to become pending
    input            enablewrite_b    // prevent incorrect write (e.g. during stalls)
);

    reg [7:0] rows[31:0];
    reg [5:0] i;

    // outputs requested register data
    assign ass_pending_a = rows[ass_addr_a][7];
    assign ass_unit_a    = rows[ass_addr_a][6:5];
    assign ass_row_a     = rows[ass_addr_a][4:0];

    assign ass_pending_b = rows[ass_addr_b][7];
    assign ass_unit_b    = rows[ass_addr_b][6:5];
    assign ass_row_b     = rows[ass_addr_b][4:0];

    always @(posedge clock or negedge reset) begin
        if(~reset) begin

            for (i=0; i<32; i=i+1) begin
                rows[i] <= 8'b0ZZ00000;
            end

        end else begin

            for (i=0; i<32; i=i+1) begin
                // updates the positions of the data
                rows[i][4:0] = rows[i][4:0] >> 1;
                if(rows[i][4:0] == 5'b00000) begin
                    // register is not pending anymore
                    rows[i][7:5]  = 3'b0ZZ;
                end
            end

            // writes registers claimed on issue stage
            if(enablewrite_a) begin
                // the corresponding registers becomes pending
                // and we write its functional unity
                rows[writeaddr_a][7] = 1'b1;
                rows[writeaddr_a][6:5] = registerunit;
                rows[writeaddr_a][4] = 1'b1;
            end

            if(enablewrite_b) begin
                // the corresponding registers becomes pending
                // and we write its functional unity
                rows[writeaddr_b][7] = 1'b1;
                rows[writeaddr_b][6:5] = registerunit;
                rows[writeaddr_b][4] = 1'b1;
            end

        end
    end

endmodule

`endif
