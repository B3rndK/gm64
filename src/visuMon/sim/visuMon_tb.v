// SPDX-License-Identifier: MIT
// Copyright (C)2024 Bernd Krekeler, Herne, Germany

`timescale 10us / 1us

module visuMon_tb();
  
logic clk;
logic reset;
logic cs;
logic bank;
logic [3:0] red, green, blue;
logic hsync,vsync;
DebugInfo _debugInfo;

visuMon U1 (
  .i_clk25Mhz(clk), 
  .i_reset(reset), 
  .i_cs(cs),
  .i_debugInfo(_debugInfo),
  .o_hsync (hsync), 
  .o_vsync (vsync), 
  .o_red (red), 
  .o_green (green), 
  .o_blue (blue)
); 

initial begin
#1        cs=1;
          reset=1;
          clk = 1'b0;
          forever begin
#1          clk <= ~clk;  
          end
end

initial begin
          //$sdf_annotate("visuMon_tb.sdf", U1);
          // $dumpoff; $dumpon;
          $dumpfile("sim/visuMon_tb.vcd");
          $dumpvars(0, visuMon_tb);
#2        $display("Start (Reset)");          
          reset=0;
#20       reset=1;
          $display ("Reset removed.");
#2        cs=0;
          _debugInfo.ledNo=1;
          _debugInfo.color=red;   
          _debugInfo.status=1;   
#2        assert(U1._debugInfo[0].ledNo==1);
          assert(U1._debugInfo[0].color==red);
          assert(U1._debugInfo[0].status==1);
#2        $display("Finished: time=%3d, clk=%b",$time, clk); 
          $finish(0);
end

endmodule