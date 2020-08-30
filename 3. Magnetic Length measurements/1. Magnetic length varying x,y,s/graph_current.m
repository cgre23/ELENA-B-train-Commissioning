close all;
clear all;

load('graph_current_time.mat');

plot(time1, current_1, 'r', 'LineWidth', 1);
xlabel('Time [s]');
ylabel('Current [A]')
xlim([0 5.3]);