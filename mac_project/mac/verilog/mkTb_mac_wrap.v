//
// Generated by Bluespec Compiler, version 2021.12.1 (build fd501401)
//
// On Mon Oct 28 21:39:44 IST 2024
//
//
// Ports:
// Name                         I/O  size props
// CLK                            I     1 clock
// RST_N                          I     1 reset
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkTb_mac_wrap(CLK,
		     RST_N);
  input  CLK;
  input  RST_N;

  // ports of submodule ifc_mac
  wire [32 : 0] ifc_mac_getResult;
  wire [31 : 0] ifc_mac_getResult_c;
  wire [7 : 0] ifc_mac_getResult_a, ifc_mac_getResult_b;

  // rule scheduling signals
  wire CAN_FIRE_RL_answer, WILL_FIRE_RL_answer;

  // submodule ifc_mac
  mac_wrap ifc_mac(.CLK(CLK),
		   .RST_N(RST_N),
		   .getResult_a(ifc_mac_getResult_a),
		   .getResult_b(ifc_mac_getResult_b),
		   .getResult_c(ifc_mac_getResult_c),
		   .getResult(ifc_mac_getResult),
		   .RDY_getResult());

  // rule RL_answer
  assign CAN_FIRE_RL_answer = 1'd1 ;
  assign WILL_FIRE_RL_answer = 1'd1 ;

  // submodule ifc_mac
  assign ifc_mac_getResult_a = 8'd215 ;
  assign ifc_mac_getResult_b = 8'd87 ;
  assign ifc_mac_getResult_c = 32'd15000 ;

  // handling of system tasks

  // synopsys translate_off
  always@(negedge CLK)
  begin
    #0;
    $display("The answer is: %0d", ifc_mac_getResult);
    $finish(32'd0);
  end
  // synopsys translate_on
endmodule  // mkTb_mac_wrap

