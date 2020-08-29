%% ELENA magnet tests - data manipulation and plotting
% Author: Christian Grech (TE-MSC-MM)
% Date: 29/09/2016
% Version: 1.0
close all;
clear all;
n = 1;
trigger_opV = zeros(n,1);
trigger_spV = zeros(n,1);
width_op = zeros(n,1);
width_sp = zeros(n,1);

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

% Plot  voltage
plot(time, trigger);
xlabel('Time (s)');
ylabel(' NMR signal (V)');
% legend('Operational','Spare');
xlim([1.952 1.959]);
hold on;
% Convert DCCT voltage to current
current = (DCCT_op *100);

[minop, minopt] = min(nmr_op);
[minsp, minspt] = min(nmr_sp);

[maxop, maxopt] = max(nmr_op);
[maxsp, maxspt] = max(nmr_sp);

%width_op(k) = maxopt - minopt;
%width_sp(k) = maxspt - minspt;

mean_op = mean(nmr_op(1:700000));
mean_sp = mean(nmr_sp(1:700000));

trigger_opV(k) = mean_op - minop;
trigger_spV(k) = mean_sp - minsp;

fprintf('k=%d, Operational V = %f,  Spare V = %f\n',k,trigger_opV(k),trigger_spV(k));

end;

% histogram(trigger_opV);
% xlabel('Operational NMR voltage amplitude');
% ylabel('Number of occurences');
% figure;
% histogram(trigger_spV);
% xlabel('Spare NMR voltage amplitude');
% ylabel('Number of occurences');

meanop = mean(trigger_opV);
meansp = mean(trigger_spV);

%meanoptime = mean(width_op/1000000);
%meansptime = mean(width_sp/1000000);

stdev_op = std(trigger_opV);
stdev_sp = std(trigger_spV);

