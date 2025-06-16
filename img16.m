clc;
clear;

% Load the 1024x1024 combined image (non-shuffled)
combined_image = imread('output_decy.png');

% Extract R, G, B channels
combined_red = combined_image(:,:,1);
combined_green = combined_image(:,:,2);
combined_blue = combined_image(:,:,3);

% Parameters
num_images = 16;  % 4x4 grid
grid_size = 4;
block_size = 256;  % size of each image block
output_folder = 'D:\Analog\Images\DecryptedImages';  % Folder to save decrypted images
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Preallocate cell arrays for reconstructed R, G, B channels
reconstructed_red = cell(1, num_images);
reconstructed_green = cell(1, num_images);
reconstructed_blue = cell(1, num_images);

% Extract 256x256 blocks based on grid (No shuffle, normal order)
for row = 1:grid_size
    for col = 1:grid_size
        idx = (row - 1) * grid_size + col;  % Sequential 1 to 16
        
        r_start = (row - 1) * block_size + 1;
        r_end = r_start + block_size - 1;
        c_start = (col - 1) * block_size + 1;
        c_end = c_start + block_size - 1;
        
        % Extract each 256x256 block directly
        reconstructed_red{idx} = combined_red(r_start:r_end, c_start:c_end);
        reconstructed_green{idx} = combined_green(r_start:r_end, c_start:c_end);
        reconstructed_blue{idx} = combined_blue(r_start:r_end, c_start:c_end);
    end
end

% Combine R, G, B channels to reconstruct original images
reconstructed_images = cell(1, num_images);  % Preallocate
for i = 1:num_images
    reconstructed_images{i} = cat(3, reconstructed_red{i}, reconstructed_green{i}, reconstructed_blue{i});
    
    % Save reconstructed images
    filename = fullfile(output_folder, sprintf('reconstructed_image%d.png', i));
    imwrite(reconstructed_images{i}, filename);
end

disp('Original images successfully reconstructed!');

% Create para.h file
con_fid = fopen('para.h', 'wt');
fprintf(con_fid, '%s \t %s \t %s', '`define', 'MAX_LEN', '');
fprintf(con_fid, '\n');
fclose(con_fid);

% Simulation commands
hdldaemon('socket', 4999);
cmd = {'vlib work', 'vlog ency.v test.v', 'vsim test', 'view wave', 'add wave -r /*', 'run -all', 'exit'};
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

% Save image to DecryptedImages folder
imwrite(img,'output_image.png');

