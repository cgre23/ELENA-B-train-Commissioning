close all;
clear all;
load('maglength_plot');


% plot(s_int, lm_int_up_5mm_x0);
% ylabel('\ell_m [m]');
% xlabel('s [mm]');
% ylim([0.968 0.98]);
% xlim([0 400]);
% legend('60 A', '110 A', '160 A', '210 A', '260 A');
figure; m=1;
plot(s_int(1:m:end), lm_int_lp_5mm_x0(1:m:end,1),'-'); hold on;
plot(s_int(1:m:end), lm_int_lp_5mm_x0(1:m:end,2),'-'); hold on;
plot(s_int(1:m:end), lm_int_lp_5mm_x0(1:m:end,3),'-'); hold on;
plot(s_int(1:m:end), lm_int_lp_5mm_x0(1:m:end,4),'-'); hold on;
plot(s_int(1:m:end), lm_int_lp_5mm_x0(1:m:end,5),'-'); hold on;
plot(s_int(1:m:end), lm_int_lp_5mm_x0(1:m:end,6),'-'); hold on;
plot(s_int(1:m:end), lm_int_lp_5mm_x0(1:m:end,7),'-'); hold on;
plot(s_int(1:m:end), lm_int_lp_5mm_x0(1:m:end,8),'k-'); hold on;
ylabel('$\ell_m$ [m]','interpreter','latex');
xlabel('s [mm]','interpreter','latex');
ylim([0.962 1.01]);
xlim([0 470]);
xl = xline(430, '.-r',{'Magnet pole'}); 
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
% set(gca, 'FontName', 'Palatino Linotype')
% xline(0, '--r',{'Magnet centre'});
legend('60 A, 200 A/s', '120 A, 200 A/s', '180 A, 200 A/s', '240 A, 200 A/s', '240 A, -200 A/s', '180 A, -200 A/s', '120 A, -200 A/s', '60 A, -200 A/s','Location','northwest');

figure;
plot(s_int, lm_int_lp_16mm_x0(:,1)); hold on;
plot(s_int, lm_int_lp_16mm_x0(:,2)); hold on;
plot(s_int, lm_int_lp_16mm_x0(:,3)); hold on;
plot(s_int, lm_int_lp_16mm_x0(:,4)); hold on;
plot(s_int, lm_int_lp_16mm_x0(:,5)); hold on;
plot(s_int, lm_int_lp_16mm_x0(:,6)); hold on;
plot(s_int, lm_int_lp_16mm_x0(:,7)); hold on;
plot(s_int, lm_int_lp_16mm_x0(:,8),'k-'); hold on;
ylabel('$\ell_m$ [m]','interpreter','latex');
xlabel('s [mm]','interpreter','latex');
ylim([0.962 1.01]);
xlim([0 470]);
xl = xline(430, '.-r',{'Magnet pole'}); 
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
% set(gca, 'FontName', 'Palatino Linotype')
% xline(0, '--r',{'Magnet centre'});
legend('60 A, 200 A/s', '120 A, 200 A/s', '180 A, 200 A/s', '240 A, 200 A/s', '240 A, -200 A/s', '180 A, -200 A/s', '120 A, -200 A/s', '60 A, -200 A/s','Location','northwest');

figure;
plot(s_int, lm_int_lp_25mm_x0(:,1)); hold on;
plot(s_int, lm_int_lp_25mm_x0(:,2)); hold on;
plot(s_int, lm_int_lp_25mm_x0(:,3)); hold on;
plot(s_int, lm_int_lp_25mm_x0(:,4)); hold on;
plot(s_int, lm_int_lp_25mm_x0(:,5)); hold on;
plot(s_int, lm_int_lp_25mm_x0(:,6)); hold on;
plot(s_int, lm_int_lp_25mm_x0(:,7)); hold on;
plot(s_int, lm_int_lp_25mm_x0(:,8),'k-'); hold on;
ylabel('$\ell_m$ [m]','interpreter','latex');
xlabel('s [mm]','interpreter','latex');
ylim([0.962 1.01]);
xlim([0 470]);
xl = xline(430, '.-r',{'Magnet pole'}); 
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
% set(gca, 'FontName', 'Palatino Linotype')
legend('60 A, 200 A/s', '120 A, 200 A/s', '180 A, 200 A/s', '240 A, 200 A/s', '240 A, -200 A/s', '180 A, -200 A/s', '120 A, -200 A/s', '60 A, -200 A/s','Location','northwest');

figure;
plot(s_int, lm_int_lp_5mm_x500(:,1)); hold on;
plot(s_int, lm_int_lp_5mm_x500(:,2)); hold on;
plot(s_int, lm_int_lp_5mm_x500(:,3)); hold on;
plot(s_int, lm_int_lp_5mm_x500(:,4)); hold on;
plot(s_int, lm_int_lp_5mm_x500(:,5)); hold on;
plot(s_int, lm_int_lp_5mm_x500(:,6)); hold on;
plot(s_int, lm_int_lp_5mm_x500(:,7)); hold on;
plot(s_int, lm_int_lp_5mm_x500(:,8),'k-'); hold on;
ylabel('$\ell_m$ [m]','interpreter','latex');
xlabel('s [mm]','interpreter','latex');
ylim([0.962 1.01]);
xlim([0 470]);
xl=xline(430, '.-r',{'Magnet pole'});
xl.LabelVerticalAlignment = 'middle';
xl.LabelHorizontalAlignment = 'center';
% set(gca, 'FontName', 'Palatino')
% xline(0, '--r',{'Magnet centre'});
legend('60 A, 200 A/s', '120 A, 200 A/s', '180 A, 200 A/s', '240 A, 200 A/s', '240 A, -200 A/s', '180 A, -200 A/s', '120 A, -200 A/s', '60 A, -200 A/s','Location','northwest');
% 
% figure;
% plot(s_int, lm_int_lp_5mm_x800(:,1)); hold on;
% plot(s_int, lm_int_lp_5mm_x800(:,2)); hold on;
% plot(s_int, lm_int_lp_5mm_x800(:,3)); hold on;
% plot(s_int, lm_int_lp_5mm_x800(:,4)); hold on;
% plot(s_int, lm_int_lp_5mm_x800(:,5), '--'); hold on;
% plot(s_int, lm_int_lp_5mm_x800(:,6), '--'); hold on;
% plot(s_int, lm_int_lp_5mm_x800(:,7), '--'); hold on;
% plot(s_int, lm_int_lp_5mm_x800(:,8), '--'); hold on;
% ylabel('$\ell_m$ [m]','interpreter','latex');
% xlabel('s [mm]','interpreter','latex');
% ylim([0.962 1.01]);
% xlim([0 470]);
% xline(430, '.-r',{'Magnet pole'});
% % xline(0, '--r',{'Magnet centre'});
% legend('60 A, 200 A/s', '120 A, 200 A/s', '180 A, 200 A/s', '240 A, 200 A/s', '240 A, -200 A/s', '180 A, -200 A/s', '120 A, -200 A/s', '60 A, -200 A/s','Location','northwest');