%% ELENA magnet tests - data manipulation and plotting
% Author: Christian Grech (TE-MSC-MM)
% Date: 29/09/2016
% Version: 1.0
close all;
clear all;
n = 101;

for k = 1:n

filename = sprintf('NMRanalysis_%d.txt',k);
filename2 = sprintf('NMRanalysis583_445G_%d.mat',k);

data_block = dlmread(filename,'\t',1,0);
% Separate data
time_original = data_block(:, 1);
trigger_sp = data_block(:, 4);
trigger_op = data_block(:, 6);
DCCT_op = data_block(:, 2);
nmr_sp = data_block(:, 3);
nmr_op = data_block(:, 5);
probe = -data_block(:,7);

% Reset time to zero
time = time_original - time_original(1,1); 
windowWidth = 100;
% Moving average filter in both directions applied to Im
kernel = ones(windowWidth,1) / windowWidth;
DCCT_f = filtfilt(kernel, 1, DCCT_op);

% Convert DCCT voltage to current
current = (DCCT_f *100);
current_nf = DCCT_op *100;

variable = [time(500001:700000) current(500001:700000) nmr_op(500001:700000) nmr_sp(500001:700000) trigger_op(500001:700000) trigger_sp(500001:700000) probe(500001:700000)];
save(filename2, 'variable'); 

end;

