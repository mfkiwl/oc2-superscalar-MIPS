`ifndef HAZARDDETECTOR_V
`define HAZARDDETECTOR_V

// Issue interface: detects stalls for instructions which read from the ARF
// during the Issue stage (everything except for branches and jr)
//
// Decode interface: detects stalls for instructions which read from the ARF
// during the Decode stage (branches, jr)

module HazardDetector (
    // Issue interface
    input iss_ass_pending_a,
    input [4:0] iss_ass_row_a,
    input iss_check_a,
    input iss_ass_pending_b,
    input [4:0] iss_ass_row_b,
    input iss_check_b,

    output iss_stalled,

    // Decode interface
    input id_ass_pending_a,
    input [4:0] id_ass_row_a,
    input id_check_a, // 1 = check both registers, 0 = check 'a' only
    input id_ass_pending_b,
    input [4:0] id_ass_row_b,
    input id_check_b,

    output id_stalled

);

assign iss_stalled =
    iss_check_a &&
    (iss_ass_pending_a && !(iss_ass_row_a[0]) || iss_ass_row_a[4:1] != 0) ||
    iss_check_b &&
    (iss_ass_pending_b && !(iss_ass_row_b[0]) || iss_ass_row_b[4:1] != 0);

// Note: Decode and Fetch must also be stalled when Issue is stalled.
assign id_stalled = iss_stalled || (
    id_check_a &&
    (id_ass_pending_a && !(id_ass_row_a[0]) || id_ass_row_a[4:1] != 0) ||
    id_check_b &&
    (id_ass_pending_b && !(id_ass_row_b[0]) || id_ass_row_b[4:1] != 0)
);

endmodule

`endif
