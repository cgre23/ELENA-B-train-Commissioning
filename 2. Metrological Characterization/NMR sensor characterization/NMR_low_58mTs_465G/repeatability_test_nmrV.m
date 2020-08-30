%% ELENA magnet tests - data manipulation and plotting
% Author: Christian Grech (TE-MSC-MM)
% Date: 29/09/2016
% Version: 1.0
close all;
clear all;
n = 100;
trigger_opV = zeros(n,1);
trigger_spV = zeros(n,1);
width_op = zeros(n,1);
width_sp = zeros(n,1);

for k = 1:n

filename = sprintf('NMRanalysis_465G_581_%d.mat',k);
load(filename, 'variable');

% Separate data
time = variable(:, 1);
trigger_sp = variable(:, 5);
trigger_op = variable(:, 4);
DCCT_op = variable(:, 2);
nmr_sp = variable(:, 6);
nmr_op = variable(:, 3);

% Reset time to zero
% time = time_original - time_original(1,1); 

% Plot  voltage
plot(time, nmr_op);
xlim([0.813 0.816]);
hold on;
% Convert DCCT voltage to current
current = (DCCT_op *100);

[minop, minopt] = min(nmr_op);
[minsp, minspt] = min(nmr_sp);

[maxop, maxopt] = max(nmr_op);
[maxsp, maxspt] = max(nmr_sp);

width_op(k) = maxopt - minopt;
width_sp(k) = maxspt - minspt;

mean_op = mean(nmr_op(1:700000));
mean_sp = mean(nmr_sp(1:700000));

trigger_opV(k) = maxop - minop;
trigger_spV(k) = maxsp - minsp;

% fprintf('k=%d, Operational V = %f,  Spare V = %f\n',k,trigger_opV(k),trigger_spV(k));
nmr_op_store(:,k) = nmr_op;
end;

for k = 1:1000000
mean_nmr(k) = mean(nmr_op_store(k,:));
end;
hold on;
plot(time, mean_nmr, '-k','LineWidth', 2);
h2 = xlabel('Time [s]','interpreter','latex');
h1 = ylabel('NMR Voltage [V]','interpreter','latex');
set(gca,'FontName','Palatino Linotype');
xlim([0.813 0.816]);
meanop = mean(trigger_opV);
meansp = mean(trigger_spV);

meanoptime = mean(width_op)/1000000;
meansptime = mean(width_sp)/1000000;

stdev_op = std(trigger_opV);
stdev_sp = std(trigger_spV);
