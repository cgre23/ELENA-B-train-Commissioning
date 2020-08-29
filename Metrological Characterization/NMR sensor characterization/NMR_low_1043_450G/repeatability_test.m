%% ELENA magnet tests - data manipulation and plotting
% Author: Christian Grech (TE-MSC-MM)
% Date: 29/09/2016
% Version: 1.0
close all;
clear all;
n = 10;

trigger_times_sp = zeros(n,1);
trigger_currents_sp = zeros(n,1);
trigger_diff_sp = zeros(n,1);
minimumpeak_op = zeros(n,1);
minimumpeak_sp = zeros(n,1);

for k = 10:n

filename = sprintf('NMRanalysis1043_450G_%d.mat',k);
load(filename, 'variable');

% Separate data
time = variable(:, 1);
trigger_sp = variable(:, 6);
trigger_op = variable(:, 5);
current = variable(:, 2);
nmr_sp = variable(:, 4);
nmr_op = variable(:, 3);
probe = variable(:,7);
windowWidth = 150;
% Moving average filter in both directions applied to Im
kernel = ones(windowWidth,1) / windowWidth;
OPfilt = filtfilt(kernel, 1, nmr_op);
x = 0.032
 plot(1000*(time-time(1)-0.093),OPfilt-x,'-b','LineWidth',1);
 hold on; plot( 1000*(time-time(1)-0.093), (trigger_op*0.028)+0.13, '-r', 'LineWidth',1);
h2 = xlabel('Time [ms]','interpreter','latex');
h1 = ylabel('Voltage [V]','interpreter','latex');
set(gca,'FontName','Palatino Linotype');
 xlim([0 7]);
ylim([-0.15 0.3]);
legend('NMR signal', 'Trigger signal');
hold on;
time_index_op = find(trigger_op < 1, 1);
time_index_sp = find(trigger_sp < 1, 1);
% [minop minopt] = min(nmr_op);
% [minsp minspt] = min(nmr_sp); 

% minimumpeak_op(k) = time(minopt);
% minimumpeak_sp(k) = time(minspt);

time_index_NMRop = find(nmr_op < -0.026,900);
time_index_NMRsp = find(nmr_sp < 0.04, 900);

xOP = time(time_index_NMRop);
yOP = nmr_op(time_index_NMRop);
pOP = polyfit(xOP,yOP,3);
y1OP = polyval(pOP,xOP);

xSP = time(time_index_NMRsp);
ySP = nmr_sp(time_index_NMRsp);
pSP = polyfit(xSP,ySP,3);
y1SP = polyval(pSP,xSP);

[minop minopt] = min(y1OP);
[minsp minspt] = min(y1SP); 

minimumpeak_op(k) = time(minopt+time_index_NMRop(1));
minimumpeak_sp(k) = time(minspt+time_index_NMRsp(1));
% 
% figure;
% plot(xOP,yOP,'-b', xOP, y1OP, '-r');
% xlabel('Time (s)');
% ylabel('Voltage (V)');
% legend('Actual OP','Fit OP');
% 
% figure;
% plot(xSP,ySP,'-b', xSP, y1SP, '-r');
% xlabel('Time (s)');
% ylabel('Voltage (V)');
% legend('Actual SP','Fit SP');

trigger_times_op(k) = time(time_index_op);
trigger_diff_op(k) = time(time_index_op) - time(minopt+time_index_NMRop(1));
%trigger_currents_op(k) = current(time_index_op);

trigger_times_sp(k) = time(time_index_sp);
trigger_diff_sp(k) = time(time_index_sp) - time(minspt+time_index_NMRsp(1));
%trigger_currents_sp(k) = current(time_index_sp);
% 
fprintf('k=%d, OP time = %f, SP time = %f\n', k,trigger_times_op(k), trigger_times_sp(k));

end;
% figure;
% histogram(trigger_times_op);
% xlabel('Operational B-train Trigger time');
% ylabel('Number of occurences');
% figure;
% histogram(trigger_currents_op);
% xlabel('Operational B-train Trigger current');
% ylabel('Number of occurences');
% figure;
% histogram(trigger_times_sp);
% xlabel('Spare B-train Trigger time');
% ylabel('Number of occurences');
% figure;
% histogram(trigger_currents_sp);
% xlabel('Spare B-train Trigger current');
% ylabel('Number of occurences');
% 
% stdev_opA = std(trigger_currents_op);
% stdev_spA = std(trigger_currents_sp);
stdev_opT = std(trigger_times_op);
stdev_spT = std(trigger_times_sp);

stdev_peak_op = std(minimumpeak_op)
stdev_peak_sp = std(minimumpeak_sp)
avgop = mean(trigger_times_op);
avgsp = mean(trigger_times_sp);
avgdiff_op_sp = avgop - avgsp;

avgdiffop = mean(trigger_diff_op)
avgdiffsp = mean(trigger_diff_sp)