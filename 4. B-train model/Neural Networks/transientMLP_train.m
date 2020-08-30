%% Training MLP for eddy current decay modeling
% Christian Grech 21.12.2019

close all;
clear all;

%% Load data
 load ('data_scat_new.mat')
 x = data_scat(:, 1:2);
 z  =  data_scat(:, 3:7)';

    %% Normalization
mean1 = mean(z(1,:)); mean2 = mean(z(2,:)); mean3 = mean(z(3,:)); mean4 = mean(z(4,:)); mean5 = mean(z(5,:));
std1 = std(z(1,:)); std2 = std(z(2,:)); std3 = std(z(3,:)); std4 = std(z(4,:)); std5 = std(z(5,:));
z(1,:) = (z(1,:)-mean1)./(std1);
z(2,:) = (z(2,:)-mean2)./(std2);
z(3,:) = (z(3,:)-mean3)./(std3);
z(4,:) = (z(4,:)-mean4)./(std4);
z(5,:) = (z(5,:)-mean5)./(std5);
save('normalization_factors_eddy_new.mat','mean1','mean2','mean3', 'mean4', 'mean5','std1','std2','std3', 'std4', 'std5');
%% MLP
u =x'; y =z; 

rng('default') 
a=[20 24 28 32 36 40 44 48 52 56];
b=[10 12 14 16 18 20 22 24 26 28];
l=10;
numNN = 10;
for j = 1:l
    net = feedforwardnet([a(j) b(j)]);
    net.trainFcn = 'trainlm';
    net.divideFcn   = 'dividerand';  % No data division 
    net.trainParam.lr=0.1;
    net.divideParam.trainRatio = 0.7;
    net.divideParam.valRatio   = 0.15;
    net.divideParam.testRatio  = 0.15;
    net.performParam.regularization = 0.000001;
    net.trainParam.epochs =1000;
    net.layers{1}.transferFcn = 'tansig';
    net.trainParam.min_grad = 1e-19;
    for i = 1:numNN
         fprintf('Training %d/%d; hidden nodes: %d %d\n', i, numNN, a(j), b(j))
        [ nets_, tr ] = train(net,u,y,'useParallel','yes');
        nets{j,i} = nets_;
        msetrn(j,i)= tr.best_perf;
        mseval(j,i) = tr.best_vperf;
        msetst(j,i) = tr.best_tperf;
    end;
       
end;
%%
average_mean=mean(msetst');
[best_hid best_hid_ind] = min(average_mean);   
[best_perf best_perf_ind] = min(msetst(best_hid_ind,:)); 
%  best_hid_ind=10;
%  best_perf_ind=1;
neti = nets{best_hid_ind,best_perf_ind};
nrmsetst= sqrt(msetst(best_hid_ind,best_perf_ind))/range(y(1,:));
save('neural_net_eddy_exp2.mat','neti');
%%
x = 1:l;
data = average_mean';
err = std(msetst');
figure;
b = bar(x,data)                
b.FaceColor = 'r';
hold on

er = errorbar(x,data,err);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
h1 = ylabel('MSE','interpreter','latex');
h2 = xlabel('$h$','interpreter','latex');
legend('Mean', 'Standard deviation')
newXticklabel = {'[20 10]','[24 12]','[28 14]','[32 16]','[36 18]','[40 20]','[44 22]', '[48 24]','[52 26]', '[56 28]'};
set(gca,'XtickLabel',newXticklabel);
hold off


%% Test
et = linspace(0, 2, 4000); % define time parameter

amp=0;
load('parametersd_200As');
exp_mod_up_200 = t1(amp)*(1-(t2(amp)*exp(-t3(amp)*et))-(t4(amp)*exp(-t5(amp)*et)));
exp_mod_down_200 = t6(amp)*(1-(t7(amp)*exp(-t8(amp)*et))-(t9(amp)*exp(-t10(amp)*et)));


inp = [amp; 0];
inp_down = [amp; 0];
yp_test = neti(inp); yp1_test = neti(inp_down);
p1 = (yp_test(1,:)*std1)+mean1; 
p2 = (yp_test(2,:)*std2)+mean2; 
p3 = (yp_test(3,:)*std3)+mean3; 
p4 = (yp_test(4,:)*std4)+mean4; 
p5 = (yp_test(5,:)*std5)+mean5; 

p1d = (yp1_test(1,:)*std1)+mean1; 
p2d = (yp1_test(2,:)*std2)+mean2; 
p3d = (yp1_test(3,:)*std3)+mean3; 
p4d = (yp1_test(4,:)*std4)+mean4; 
p5d = (yp1_test(5,:)*std5)+mean5; 

exp_mod_up = p1*(1-(p2*exp(-p3*et))-(p4*exp(-p5*et)));
exp_mod_down =p1d*(1-(p2d*exp(-p3d*et))-(p4d*exp(-p5d*et)));
m=10; figure;
plot(et(1:m:end), exp_mod_up(1:m:end), 'rx'); hold on; plot(et(1:m:end), exp_mod_up_200(1:m:end), 'b--'); hold on;
plot(et(1:m:end), exp_mod_down(1:m:end), 'rx'); hold on; plot(et(1:m:end), exp_mod_down_200(1:m:end), 'b--');
legend('Estimated', 'Target');

y=exp_mod_up_200;
yhat=exp_mod_up;
y1=exp_mod_down_200;
yhat1=exp_mod_down;

% 
NRMSE_up = sqrt(mean((y - yhat).^2))/range(y);  % Root Mean Squared Error
NRMSE_down = sqrt(mean((y1 - yhat1).^2))/range(y1);  % Root Mean Squared Error
