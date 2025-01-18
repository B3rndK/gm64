// SPDX-License-Identifier: MIT
// Copyright (C)2024 Bernd Krekeler, Herne, Germany

`ifndef CLOCKGEN_H
`define CLOCKGEN_H

/* Main clock generation... */

module clockGen(input  clk10Mhz,
								output logic clkSys);
								
parameter sysclk="49.26"; //49.26 We need at least 48 Mhz for the 'PSRAM race'...sysclk/50 will provide us 0.9582 (PAL) phi
parameter referenceClk="10.0"; 	 // Reference clock is 10Mhz coming from FPGA

wire clkSysPLL;

CC_PLL #(
	.REF_CLK(referenceClk), // reference input in MHz
	.OUT_CLK(sysclk),   		// pll output frequency in MHz
	.PERF_MD("SPEED"), 	  // LOWPOWER, ECONOMY, SPEED
	.LOW_JITTER(1),    			// 0: disable, 1: enable low jitter mode
	.CI_FILTER_CONST(2), 		// default 
  .CP_FILTER_CONST(4)  		// default 
	) pll_inst_clkdot (
	.CLK_REF(clk10Mhz), .CLK0(clkSysPLL)
);

// Connect the sysclk to the global routing resources of the FPGA to ensure that all
// modules get the signal (nearly...) at the same time
CC_BUFG pll_sysclk (.I(clkSysPLL), .O(clkSys));

endmodule

`endif


