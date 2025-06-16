clc;
clear;

% Input hex file
inputFile = 'ency_image.txt';  % Change as needed

% Output files
rFile = 'R_values.txt';
gFile = 'G_values.txt';
bFile = 'B_values.txt';

% Read the hex data
fid = fopen(inputFile, 'r');
hexData = textscan(fid, '%s');
fclose(fid);

hexData = hexData{1};

% Initialize arrays
numPixels = length(hexData);
R_dec = zeros(numPixels, 1);
G_dec = zeros(numPixels, 1);
B_dec = zeros(numPixels, 1);

% Extract R, G, B components and convert to decimal
for k = 1:numPixels
    hexStr = upper(strtrim(hexData{k}));  % Convert to uppercase and trim spaces
    
    % Keep only valid hex characters (0-9 and A-F)
    hexStr = regexprep(hexStr, '[^0-9A-F]', '');
    
    if length(hexStr) ~= 6
        error('Invalid hex string at line %d: %s', k, hexStr);
    end
    
    R_dec(k) = hex2dec(hexStr(1:2));
    G_dec(k) = hex2dec(hexStr(3:4));
    B_dec(k) = hex2dec(hexStr(5:6));
end

% Write to files in decimal
writematrix(R_dec, rFile);
writematrix(G_dec, gFile);
writematrix(B_dec, bFile);

disp('R, G, and B files (in decimal) have been created.');



con_fid = fopen('para.h', 'wt');
fprintf(con_fid, '%s \t %s \t %s', '`define', 'MAX_LEN');
fprintf(con_fid, '\n');
fclose(con_fid);

% Simulation commands
hdldaemon('socket', 4999);
cmd = {'vlib work', ['vlog decy.v tb_decy.v' ...
    '' ...
    ''], ...
    'vsim test', ...
    'view wave', ...
    'add wave -r /*', 'run -all', 'exit'};
vsim('tclstart', cmd);

pause;

% Set input file name (hex values in text)
filename = 'ency_image.txt';  % Change this to your file name

% Read file
fid = fopen(filename, 'r');
hexData = textscan(fid, '%s');
fclose(fid);

hexData = hexData{1};

% Check number of pixels
numPixels = 1024 * 1024;
if length(hexData) ~= numPixels
    error('File does not contain exactly 1024 x 1024 pixels (%d found)', length(hexData));
end

% Initialize image array
img = zeros(1024, 1024, 3, 'uint8');

% Convert each 24-bit hex to RGB
for k = 1:numPixels
    hexStr = hexData{k};
    
    % Extract R, G, B components
    R = uint8(hex2dec(hexStr(1:2)));
    G = uint8(hex2dec(hexStr(3:4)));
    B = uint8(hex2dec(hexStr(5:6)));
    
    % Compute row and column
    row = floor((k-1) / 1024) + 1;
    col = mod((k-1), 1024) + 1;
    
    % Assign to image
    img(row, col, :) = [R, G, B];
end

% Display image
imshow(img);

% Save image
imwrite(img, 'output_decy.png');