module tb_test;
  parameter n = 1048576;

  // Inputs
  reg clk;
  reg rst;
  reg [23:0] i;
  reg [8:0] data [0:n-1];   // 8-bit decimal for R values
  reg [8:0] data1 [0:n-1];  // 8-bit decimal for G values
  reg [8:0] data2 [0:n-1];  // 8-bit decimal for B values
  integer m, f1, fR, fG, fB;
  integer r, g, b;

  // Output
  wire [23:0] o;

  // Instantiate the Unit Under Test (UUT)
  decy_master uut (.o(o), .i(i), .clk(clk), .rst(rst));

  // Clock generation
  always #10 clk = ~clk;

  initial begin
    // Initialize
    clk = 0;
    rst = 1;
    #20;
    rst = 0;

    // Open input files for R, G, and B values
    fR = $fopen("R_values.txt", "r");
    fG = $fopen("G_values.txt", "r");
    fB = $fopen("B_values.txt", "r");

    if (fR == 0 || fG == 0 || fB == 0) begin
      $display("Error opening input files.");
      $finish;
    end

    // Open output file for decy_image
    f1 = $fopen("decy_image.txt", "w");
    if (f1 == 0) begin
      $display("Error opening decy_image.txt");
      $finish;
    end

    // Apply input data
    for (m = 0; m < n; m = m + 1) begin
      // Read decimal values for R, G, B
      $fscanf(fR, "%d\n", r);
      $fscanf(fG, "%d\n", g);
      $fscanf(fB, "%d\n", b);

      // Pack R, G, B values into 24-bit RGB input
      i = {r[7:0], g[7:0], b[7:0]};  // 24-bit RGB input
      #20;  // Wait for 20 time units for processing

      // Write output to file in 24-bit hexadecimal format
      $fwrite(f1, "%06x\n", o);  // 6-digit hex

      // Optional progress display
      if (m % 100000 == 0)
        $display("Processed %d pixels", m);
    end

    $fclose(f1);
    $fclose(fR);
    $fclose(fG);
    $fclose(fB);
    $display("Simulation done. Output written to decy_image.txt");
    $finish;
  end

endmodule
												 
