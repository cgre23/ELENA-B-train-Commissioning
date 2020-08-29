close all;
clear all;


%% Load data
 load ('dynamicsdatasetnorm.mat')   %norm
 x =[currentvec; RRvec]';
 z0  =  Bdlvec';

    %% Get size of signals and normalization factor for NMSE
z = z0';
mean1 = mean(z(1,:)); std1 = std(z(1,:));
 z(1,:) = (z(1,:)-mean1)./(std1);  %z(2,:) = (z(2,:)-mean2)./(std2); z(3,:) = (z(3,:)-mean3)./(std3); z(4,:) = (z(4,:)-mean4)./(std4); z(5,:) = (z(5,:)-mean5)./(std5);
  save('normalization_factors_data.mat','mean1','std1');
%% MLP
u =x'; y =z; 
rng('default') 

b=[15 20 25 30 35 40 42 45 48 50];
numNN = 10;
for j = 1:10
    net = feedforwardnet([b(j)]);
    net.trainFcn = 'trainlm';
    net.divideFcn   = 'dividerand';  % No data division 
    net.trainParam.lr=0.1;
    net.divideParam.trainRatio = 0.7;
    net.divideParam.valRatio   = 0.15;
    net.divideParam.testRatio  = 0.15;
    net.performParam.regularization = 0.000001; %5
    net.trainParam.epochs =1000;
    net.layers{1}.transferFcn = 'logsig';
%      net.layers{2}.transferFcn = 'tansig';
    net.trainParam.min_grad = 1e-15;
        for i = 1:numNN
             fprintf('Training %d/%d; hidden nodes: %d\n', i, numNN, b(j) )
            [ nets_, tr ] = train(net,u,y,'useParallel','yes');
            nets{j,i} = nets_;
            msetrn(j,i)= tr.best_perf;
            mseval(j,i) = tr.best_vperf;
            msetst(j,i) = tr.best_tperf;
        end;
end;
% t=y;
%% 
% plot(msetst, 'x-');
average_mean=mean(msetst');
[best_hid best_hid_ind] = min(average_mean);   
[best_perf best_perf_ind] = min(msetst(best_hid_ind,:)); 
neti = nets{best_hid_ind,best_perf_ind};
nrmsetst= sqrt(msetst(best_hid_ind,best_perf_ind))/range(y(1,:));
 save('neural_net_deep.mat','neti');
x = 1:10;
data = (average_mean');
err = std(msetst');
figure;
bar(x,data)                

hold on

er = errorbar(x,data,err);    
er.Color = [0 0 0];                            
er.LineStyle = 'none';  
h1 = ylabel('MSE','interpreter','latex');
h2 = xlabel('$h$','interpreter','latex');
legend('Mean', 'Standard deviation')
newXticklabel = {'15', '20', '25', '30','35','40', '42', '45', '48', '50'};
set(gca,'XtickLabel',newXticklabel);
%set(gca,'FontName','Palatino Linotype');
xlim([0.5 10.5])
hold off


%% Test
data3(:,1) =  currentvec';
data3(:, 2) = RRvec';
data3(:, 3) = Bdlvec';
yt = (neti(data3(:,1:2)')*std1)+mean1;
yhat=data3(:, 3);
figure; plot3(data3(1:10:end,1), data3(1:10:end,2), yt(1:10:end), 'r.', 'LineWidth', 1.5); hold on; plot3(data3(1:10:end,1), data3(1:10:end,2), yhat(1:10:end), 'k.', 'LineWidth', 1.5); title('B_n');  legend( 'Estimated','Target');

err =mean(abs(yt - yhat'))/range(yt)
load('parameter_p');
yt_scaled = yt + (p(1)*data3(:,1)')+p(2);
yhat_scaled = yhat + (p(1)*data3(:,1))+p(2);
NRMSE_scaled = sqrt(mean((yt_scaled - yhat_scaled').^2))/range(yt_scaled)
% figure; plot(data3(1:10:end,1)', yt_scaled(1:10:end)./data3(1:10:end,1)', 'r.', 'LineWidth', 1.5); hold on; plot(data3(1:10:end,1), yhat_scaled(1:10:end)./data3(1:10:end,1),'k.'); title('B_n');  legend( 'Estimated','Target');