%% ELENA magnet tests - data manipulation and plotting
% Author: Christian Grech (TE-MSC-MM)
% Date: 29/09/2016
% Version: 1.0
close all;
clear all;
n =104;

trigger_times_fmr = zeros(n,1);
trigger_currents_sp = zeros(n,1);
trigger_diff_fmr = zeros(n,1);
minimumpeak_nmr = zeros(n,1);
minimumpeak_fmr = zeros(n,1);

for k =1:n

filename = sprintf('1000G/NMRanalysis1_1000G_%d.mat',k);
load(filename, 'variable');

% Separate data
time = variable(:, 1);
trigger_fmr = variable(:, 6);
trigger_nmr = variable(:, 5);
nmr = variable(:, 3);
fmr = variable(:, 4);
current = variable(:, 2);

%  plot(time,trigger_nmr,'-b');
% xlabel('Time (s)');
% ylabel('Voltage (V)');
% %xlim([2.98 3]);
% hold on;

time_index_op = find(trigger_nmr < 1, 1);
time_index_sp = find(trigger_fmr < 1, 1);
[minop minopt] = min(nmr);
[minsp minspt] = min(fmr); 

minimumpeak_nmr(k) = time(minopt);
minimumpeak_fmr(k) = time(minspt);
trigger_times_nmr(k) = time(time_index_op);
trigger_diff_nmr(k) = time(time_index_op) - time(minopt);
%trigger_currents_op(k) = current(time_index_op);

trigger_times_fmr(k) = time(time_index_sp);
trigger_diff_fmr(k) = time(time_index_sp) - time(minspt);
%trigger_currents_sp(k) = current(time_index_sp);

% 
fprintf('k=%d, NMR time = %f, FMR time = %f\n', k,trigger_times_nmr(k), trigger_times_fmr(k));

nmr_fmr(k) = time(time_index_op) - time(time_index_sp);
end;
avg_nmr_fmr = mean(nmr_fmr(k))
figure;
histogram(trigger_times_nmr);
xlabel('NMR Trigger time');
ylabel('Number of occurences');

figure;
histogram(trigger_times_fmr);
xlabel('FMR Trigger time');
ylabel('Number of occurences');


stdev_NMR_T = std(trigger_times_nmr)
stdev_FMR_T = std(trigger_times_fmr)

stdev_peak_NMR = std(minimumpeak_nmr);
stdev_peak_FMR = std(minimumpeak_fmr);
avgNMR = mean(trigger_times_nmr);
avgFMR = mean(trigger_times_fmr);
avgdiff_NMR_FMR = avgNMR - avgFMR

avgdiffNMR = mean(trigger_diff_nmr)
avgdiffFMR = mean(trigger_diff_fmr)