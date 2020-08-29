%% ELENA magnet tests - data manipulation and plotting
% Author: Christian Grech (TE-MSC-MM)
% Date: 29/09/2016
% Version: 1.0
close all;
clear all;
n = 100;

trigger_times_sp = zeros(n,1);
trigger_currents_sp = zeros(n,1);
trigger_diff_sp = zeros(n,1);
minimumpeak_op = zeros(n,1);
minimumpeak_sp = zeros(n,1);

for k = 1:n

filename = sprintf('NMRanalysis_%d.txt',k);

data_block = dlmread(filename,'\t',1,0);
% Separate data
time_original = data_block(:, 1);
trigger_sp = data_block(:, 3);
DCCT_op = data_block(:, 4);
nmr_sp = data_block(:, 6);
nmr_op = data_block(:, 5);
probe = -data_block(:,2);

% Reset time to zero
time = time_original - time_original(1,1); 
windowWidth = 100;
% Moving average filter in both directions applied to Im
kernel = ones(windowWidth,1) / windowWidth;
DCCT_f = filtfilt(kernel, 1, DCCT_op);

% Convert DCCT voltage to current
current = (DCCT_f *100);
current_nf = DCCT_op *100;

% figure; plot(time,nmr_op, time, trigger_sp);
%  xlabel('Time (s)');
%  ylabel('Voltage (V)');
%  xlim([1.9535 1.9555]);
 
time_index_sp = find(trigger_sp < 0.05, 1);
[minop minopt] = min(nmr_op);
[minsp minspt] = min(nmr_sp); 

minimumpeak_op(k) = time(minopt);
minimumpeak_sp(k) = time(minspt);

trigger_times_sp(k) = time(time_index_sp);
trigger_diff_sp(k) = time(time_index_sp) - time(minopt);
trigger_currents_sp(k) = current(time_index_sp);
% hold on;
% plot(time(time_index_sp), trigger_sp(time_index_sp), 'rx');

% 
fprintf('k=%d, SP time = %f, SP current = %f\n', k, trigger_times_sp(k),trigger_currents_sp(k));

end;

% figure;
% histogram(trigger_times_sp);
% xlabel('Spare B-train Trigger time');
% ylabel('Number of occurences');
% figure;
% histogram(trigger_currents_sp);
% xlabel('Spare B-train Trigger current');
% ylabel('Number of occurences');

stdev_spA = std(trigger_currents_sp);
stdev_spT = std(trigger_times_sp);
stdev_peak_op = std(minimumpeak_op);
stdev_peak_sp = std(minimumpeak_sp);
avgsp = mean(trigger_times_sp);
avgdiffsp = mean(trigger_diff_sp);