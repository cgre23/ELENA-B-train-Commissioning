%% Software to train neural  network; trains 100 neural networks and takes around 2 days
% The output files are saved as final_data_3_compressed.mat and
% final_data_4_compressed (this one with no Preisach inputs)
close all;
clear all;

%% Load data
m=1;
 windowWidth = 1;
% % Moving average filter in both directions applied to Im
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

for i = 1:n_oper
    [S] =PlayOperatorJan2(curr_train', i, n_oper,max_x);
    [S_test] = PlayOperatorJan2(curr_test',i, n_oper,max_x_test);
    [S_Mtest] = PlayOperatorJan2(curr_Mtest',i, n_oper,max_x_Mtest);
    K(i,:) = S;
    K_test(i,:)=S_test;
    K_Mtest(i,:)=S_Mtest;
end;

%% Train/test data setup
x = [curr_train grad_train K']';
t=B_train';
x_test = [curr_test grad_test K_test']';
t_test = B_test';
x_Mtest = [curr_Mtest grad_Mtest K_Mtest']';
t_Mtest = B_Mtest';

Hmin =4;
Hmax =13;                             
dH = 1; 

layers= (Hmin:dH:Hmax)'; 
num_layers = length(layers);
rng('default')
j=0 ;
 numNN =10;

nets = cell(num_layers, numNN); tr = cell(num_layers, numNN); 
x_ = con2seq(x);
x_test_ = con2seq(x_test);
x_Mtest_ = con2seq(x_Mtest);
t_ = con2seq(t);
t_test_ = con2seq(t_test);
t_Mtest_ = con2seq(t_Mtest);
%% Training
for h = Hmin:dH:Hmax 
    j=j+1; 
    H=h;
     net =layrecnet(1:2,H);  
%         Nw = (I+1)*h+(h+1)*O ;
        net.divideFcn = 'divideint'; 
%     [trnind valind tstind] = divideint(N,trnratio,valratio,tstratio) ; 
    net.divideParam.trainRatio = 0.7; % Ratio of targets for training. Default = 0.7.
    net.divideParam.valRatio = 0.15; % Ratio of targets for validation. Default = 0.15.
    net.divideParam.testRatio = 0.15; % Ratio of targets for testing. Default = 0.15.
    net.divideMode = 'time';  % Divide up every sample
    net.trainFcn = 'trainlm';
    net.trainParam.goal=1e-8;
    net.layers{1}.transferFcn = 'tansig'; % hidden layer
        [Xs,Xi,Ai,Ts] = preparets(net,x_,t_);
        for i = 1:numNN
            fprintf('Training %d/%d; hidden nodes: %d\n', i, numNN, H)
            [ nets_ tr_] = train(net,Xs,Ts,Xi,Ai, 'useParallel', 'yes'); 
            nets{j,i} = nets_;
            tr{j,i} = tr_;
            stopcrit{j,i}        = tr{j,i}.stop; 
            numepochs(j,i) = tr{j,i}.num_epochs; 
            bestepoch(j,i)   = tr{j,i}.best_epoch; 
            MSEtst(j,i)        = tr{j,i}.tperf(tr{j,i}.best_epoch+1); 
            hidden_nodes(j,i) = H;
        end
end 

%% Analysis
H= (Hmin:dH:Hmax)'; 
NRMSEtst     = sqrt(MSEtst)*100/range(t)
format short g 

f=0;
for j = 1:(length(H))
        for k= 1:numNN
            f=f+1;
        summary(f,:) = [ hidden_nodes(j,k); bestepoch(j,k);  NRMSEtst(j,k)]';
        end;
end;
summary
average_mean=mean(NRMSEtst');
[best_hid best_hid_ind] = min(average_mean);   
[best_perf best_perf_ind] = min(NRMSEtst(best_hid_ind,:)); 
% best_net = nets{}
predTotal=0;
neti = nets{best_hid_ind,best_perf_ind};
pred_ = neti(x_test_);
perf_test = sqrt(perform(neti,pred_,t_test_))*100/range(t_test);
predM_ = neti(x_Mtest_);
perf_Mtest = sqrt(perform(neti,predM_,t_Mtest_))*100/range(t_Mtest);
pred = cell2mat(pred_);
predM = cell2mat(predM_);
view(neti)

figure;            
plot( x_test(1,500:end)*scale_current, t_test(1,500:end)*scale_B, 'k-', 'LineWidth', 1 ) ; hold on;
plot( x_test(1,500:end)*scale_current, pred(1,500:end)*scale_B, 'rx',  'LineWidth', 1 ) ; hold on;
xlabel('H / Am^{-1}');
ylabel('B / T');
figure;            
plot( x_Mtest(1,500:end)*scale_current, t_Mtest(1,500:end)*scale_B, 'k-', 'LineWidth', 1 ) ; hold on;
plot( x_Mtest(1,500:end)*scale_current, predM(1,500:end)*scale_B, 'rx',  'LineWidth', 1 ) ; hold on;
xlabel('H / Am^{-1}');
ylabel('B / T');
legend('Test data', 'Estimated test data', 'Training data');
fprintf('Test NRMSE %f  \n', perf_test)

figure; plot(t_test(1,500:end)*scale_B, 'b'); hold on; plot(pred(1,500:end)*scale_B,'r--'); 
legend('Actual', 'Estimated');
ylabel('B / T');
xlabel('Sample');

figure; plot(t_Mtest(1,500:end)*scale_B, 'b'); hold on; plot(predM(1,500:end)*scale_B,'r--'); 
legend('Actual', 'Estimated');
ylabel('B / T');
xlabel('Sample');

NRMSE_minor = rmse(t_test(1,5:end), pred(1,5:end))*100/range(t_test)
NRMSE_major = rmse(t_Mtest(1,500:end), predM(1,500:end))*100/range(t_Mtest)