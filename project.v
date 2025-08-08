`default_nettype none

module tt_um_vga_example(
  input  wire [7:0] ui_in,    // Dedicated inputs
  output wire [7:0] uo_out,   // Dedicated outputs
  input  wire [7:0] uio_in,   // IOs: Input path
  output wire [7:0] uio_out,  // IOs: Output path
  output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
  input  wire       ena,      // always 1 when the design is powered, so you can ignore it
  input  wire       clk,      // 25.175 MHz VGA clock
  input  wire       rst_n     // reset_n - low to reset
);

  //  signals
  wire hsync;
  wire vsync;
  wire [1:0] R;
  wire [1:0] G; 
  wire [1:0] B;
  wire video_active;
  wire [9:0] pix_x;
  wire [9:0] pix_y;

  // Tiny Tapeout VGA PMOD pin mapping
  assign uo_out = {hsync, B[0], G[0], R[0], vsync, B[1], G[1], R[1]};

  // Unused outputs assigned to 0.
  assign uio_out = 8'b0;
  assign uio_oe  = 8'b0;

  // Suppress unused signals warning
  wire _unused_ok = &{ena, ui_in, uio_in};

  // VGA sync generator (must include hvsync_generator.v in your project!)
  hvsync_generator hvsync_gen(
    .clk(clk),
    .reset(~rst_n),
    .hsync(hsync),   
    .vsync(vsync),
    .display_on(video_active),
    .hpos(pix_x),
    .vpos(pix_y) 
  );

  // === Display Logic ===
  // Show a red square in top-left 100x100 region
  wire in_square = (pix_x < 100) && (pix_y < 100) && video_active;

  assign R = in_square ? 2'b11 : 2'b00;
  assign G = 2'b00;
  assign B = 2'b00;

endmodule
