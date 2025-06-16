module test;
  parameter n = 1048576;

  // Inputs
  reg clk;
  reg rst;
  reg [23:0] i;
  reg [7:0] data [0:n];   // 8-bit decimal
  reg [7:0] data1 [0:n];
  reg [7:0] data2 [0:n];
  integer m, f1;
  integer f_red, f_green, f_blue;

  // Output
  wire [23:0] o;

  // Instantiate the Unit Under Test (UUT)
  ency_master uut (.o(o), .i(i), .clk(clk), .rst(rst));

  // Clock generation
  always #10 clk = ~clk;

  initial begin
    // Initialize
    clk = 0;
    rst = 1;
    #20;
    rst = 0;

    // Open input files (decimal data)
    f_red = $fopen("red_8bit.txt", "r");
    f_green = $fopen("green_8bit.txt", "r");
    f_blue = $fopen("blue_8bit.txt", "r");

    // Read decimal numbers into arrays
    for (m = 0; m <= n; m = m + 1) begin
      $fscanf(f_red, "%d\n", data[m]);
      $fscanf(f_green, "%d\n", data1[m]);
      $fscanf(f_blue, "%d\n", data2[m]);
    end

    $fclose(f_red);
    $fclose(f_green);
    $fclose(f_blue);

    // Open output file
    f1 = $fopen("ency_image.txt", "w");

    // Apply input data
    for (m = 0; m <= n; m = m + 1) begin
      i = {data[m], data1[m], data2[m]};  // 24-bit RGB input
      #20;
      $fwrite(f1, "%x\n", o);
    end

    $fclose(f1);
    $finish;
  end

endmodule
