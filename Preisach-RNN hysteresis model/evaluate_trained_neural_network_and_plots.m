% Neural net evaluation software based on the files generated during
% training
% 22.09.2019
close all;
clear all;

%% Input signals plotting
m=1;
 windowWidth = 1;

 kernel = ones(windowWidth,1) / windowWidth;

load('train4.mat'); load('Mtrain3.mat')
scale_current = range(train(1:1:end,1))/2;
scale_B = range(train(1:1:end,3))/2;
scale_grad = range(train(1:1:end,2))/2;
curr_train = [ train(1:m:end,1); Mtrain(1:m:end,1)]/scale_current;

grad_train_nf = [train(1:1:end,2); Mtrain(1:1:end,2)]/scale_grad;
grad_train = filtfilt(kernel, 1, grad_train_nf);  
grad_train = grad_train(1:m:end);  
B_train= [train(1:m:end,3); Mtrain(1:m:end,3)]/scale_B;

load('Mtest3.mat')
curr_Mtest = Mtest(1:m:end,1)/scale_current;
grad_Mtest_nf = Mtest(1:1:end,2)/scale_grad;
grad_Mtest = filtfilt(kernel, 1, grad_Mtest_nf); 
grad_Mtest = grad_Mtest(1:m:end);  
B_Mtest= Mtest(1:m:end,3)/scale_B;
load('test4.mat')
curr_test =[test(1:m:end,1)]/scale_current;
grad_test_nf = [test(1:1:end,2)]/scale_grad;
grad_test = filtfilt(kernel, 1, grad_test_nf); 
grad_test = grad_test(1:m:end);  
B_test= [test(1:m:end,3)]/scale_B;
clear train
%% Preisach operators
n_oper = 6;
max_x = max(curr_train);
max_x_test = max(curr_test);
max_x_Mtest = max(curr_Mtest);
% 
for i = 1:n_oper
    [S] =PlayOperatorJan2(curr_train', i, n_oper,max_x);
    [S_test] = PlayOperatorJan2(curr_test',i, n_oper,max_x_test);
    [S_Mtest] = PlayOperatorJan2(curr_Mtest',i, n_oper,max_x_Mtest);
    K(i,:) = S;
    K_test(i,:)=S_test;
    K_Mtest(i,:)=S_Mtest;
end;
 train_minor_range = 1:3.41719e4;
 train_major_range = 3.4172e4:length(curr_train);
% %% Train/test data setup
 x = [curr_train grad_train K']';
t=B_train';
x_test = [curr_test grad_test K_test']';
t_test = B_test';
x_Mtest = [curr_Mtest grad_Mtest K_Mtest']';
t_Mtest = B_Mtest';
x_eval = [x_test x_Mtest];
 f = 200; ds = 0.005;
 time_train = linspace(0, length(curr_train)*ds, length(curr_train));
 figure; plot(time_train, x(1,:)', 'LineWidth',1); hold on;
 plot(time_train, x(2,:)','LineWidth',1); hold on;
% plot(time_train, x(3,:)',  'LineWidth',1); hold on;
% plot(time_train, x(4,:)', 'LineWidth',1); hold on;
% plot(time_train, x(5,:)', 'LineWidth',1); hold on;
% plot(time_train, x(6,:)',  'LineWidth',1); hold on;
% plot(time_train, x(7,:)',  'LineWidth',1); hold on;
% plot(time_train, x(8,:)',  'LineWidth',1); hold on;
 ylabel('Normalised inputs'); xlabel('Time [s]'); ylim([-1.5 1.5]); xlim([0 280])
 leg1=legend('$H$', '$\dot{H}$', '$P_1$', '$P_2$', '$P_3$', '$P_4$', '$P_5$', '$P_6$', 'Location','southwest', 'Orientation', 'vertical');
 set(leg1,'Interpreter','latex');
 set(leg1,'FontSize',10);
 ax=gca;
ax.YAxis.TickLabelFormat = '%.1f';

time_test = linspace(0, length(x_eval)*ds, length(x_eval));
figure; plot(time_test, x_eval(1,:)', 'LineWidth',1); hold on;
plot(time_test, x_eval(2,:)','LineWidth',1); hold on;
% plot(time_test, x_eval(3,:)',  'LineWidth',1); hold on;
% plot(time_test, x_eval(4,:)', 'LineWidth',1); hold on;
% plot(time_test, x_eval(5,:)', 'LineWidth',1); hold on;
% plot(time_test, x_eval(6,:)',  'LineWidth',1); hold on;
% plot(time_test, x_eval(7,:)',  'LineWidth',1); hold on;
% plot(time_test, x_eval(8,:)',  'LineWidth',1); hold on;
ylabel('Normalised inputs'); xlabel('Time [s]'); 
leg1=legend('$H$', '$\dot{H}$', '$P_1$', '$P_2$', '$P_3$', '$P_4$', '$P_5$', '$P_6$', 'Location','southwest', 'Orientation', 'vertical');
set(leg1,'Interpreter','latex');
set(leg1,'FontSize',10);
 ax=gca;
ax.YAxis.TickLabelFormat = '%.1f';
%% Analysis of trained neural network

load('final_data_3_compressed.mat')
neti = nets{9,4};
pred_ = neti(x_test_);
perf_test = sqrt(perform(neti,pred_,t_test_))*100/range(t_test);
predM_ = neti(x_Mtest_);
perf_Mtest = sqrt(perform(neti,predM_,t_Mtest_))*100/range(t_Mtest);
pred = cell2mat(pred_);
 predM = cell2mat(predM_);
%  view(neti)
wb = getwb(neti);
tM = linspace(0, length(t_Mtest(1,560:1:end))*ds, length(t_Mtest(1,560:1:end)));
tm = linspace(0, length(t_test(1,500:1:end))*ds, length(t_test(1,500:1:end)));

figure;            
% plot( x(1,train_minor_range)*scale_current, t(1,train_minor_range)*scale_B, 'b-',  'LineWidth', 1 ) ; hold on;
plot(x_test(1,500:20:end)*scale_current, t_test(1,500:20:end)*scale_B, 'k-', 'LineWidth', 1 ) ; hold on;
plot(x_test(1,500:20:end)*scale_current, pred(1,500:20:end)*scale_B, 'rx',  'LineWidth', 1 ) ; hold on;
xlabel('H [Am^{-1}]');
ylabel('B [T]');
legend('Evaluation data', 'Predicted data');
 ax=gca;
ax.YAxis.TickLabelFormat = '%.1f';

figure;       
plot( x(1,train_major_range)*scale_current, t(1,train_major_range)*scale_B, 'g-',  'LineWidth', 1 ) ;  hold on;
plot( x_Mtest(1,560:10:end)*scale_current, t_Mtest(1,560:10:end)*scale_B, 'k-', 'LineWidth', 1 ) ; hold on;
plot( x_Mtest(1,560:15:end)*scale_current, predM(1,560:15:end)*scale_B, 'rx',  'LineWidth', 1 ) ; hold on;
xlabel('H [Am^{-1}]');
ylabel('B [T]');
legend('Training data', 'Evaluation data', 'Predicted data', 'Location', 'northwest');
 ax=gca;
ax.YAxis.TickLabelFormat = '%.1f';

figure; plot(tm, t_test(1,500:end)*scale_B, 'k-', 'LineWidth', 1.5 ); hold on; plot(tm(1:50:end),pred(1,500:50:end)*scale_B,'g--', 'LineWidth', 1.5); 
legend('Actual', 'Estimated');
ylabel('B [T]');
xlabel('Time [s]');
 ax=gca;
ax.YAxis.TickLabelFormat = '%.1f';

figure; plot(tM, t_Mtest(1,560:1:end)*scale_B, 'k'); hold on; plot(tM, predM(1,560:end)*scale_B,'r--'); 
legend('Actual', 'Estimated');
ylabel('B [T]');
xlabel('Time [s]');
 ax=gca;
ax.YAxis.TickLabelFormat = '%.1f';

% NRMSE_minor = rmse(t_test(1,500:end), pred(1,500:end))*100/range(t_test)
% NRMSE_major = rmse(t_Mtest(1,560:end), predM(1,560:end))*100/range(t_Mtest)

%% Univariate sensitivity analysis

x_sens=ones(8,1100)*0;
y_sens=zeros(8,1100);
s = rng;
r = (rand(1,1100)*2)-1;
for j = 1:8
    x_sens(j,:) = r;
    x_sens_=con2seq(x_sens);
    pred_sens_(j,:) = neti(x_sens_);
end;
figure;
    pred_sens =cell2mat(pred_sens_);
    y_sens=pred_sens*scale_B;
    stdev = std(y_sens');
%     plot(y_sens');
     bar(stdev)
 leg1={'$H$', '$\dot{H}$', '$P_1$', '$P_2$', '$P_3$', '$P_4$', '$P_5$', '$P_6$'};
 set(gca,'xticklabel',leg1)
 set(gca,'TickLabelInterpreter','latex')
xl= xlabel('Input, $j$'); 
set(xl,'Interpreter','latex')
 yl=ylabel('Standard Deviation ($\sigma_j(z_s)$) [T]');
  set(yl,'Interpreter','latex')
   ax=gca;
ax.XAxis.TickLabelFormat = '%.1f';
ax.YAxis.TickLabelFormat = '%.1f';
%    set(leg1,'Interpreter','latex');