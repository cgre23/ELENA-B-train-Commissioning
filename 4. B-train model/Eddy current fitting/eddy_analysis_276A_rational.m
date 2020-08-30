%% Eddy current analysis
% Christian Grech - 13.03.2019 - TE-MSC-MM

%% Clear Variables, Close Current Figures
clc;
clear all;
close all;
% p(1) = 0.001272614147872;
% p(2) = 2.026356882029685e-04;
load('parameter_p.mat');
%% Load data
% Defining the time samples of the last measured cycle for each of the
% seven measurements
t1=450000:690000;  t2=340000:520000;  t3=300000:450000; t4=250000:424000; 
load('data/Cycle_276A_100As_processed.mat');
I40 = curr(t1);B40 = BdL(t1);
dt40 = tim(2)-tim(1);  g40 = grad_est(t1)';
load('data/Cycle_276A_200As_processed.mat'); 
I50 = curr(t2); B50 = BdL(t2);
dt50 = tim(2)-tim(1); g50 = grad_est(t2)';
g50(19840:20e3) = 200;
load('data/Cycle_276A_500As_processed.mat'); 
I100 = curr(t3); B100 = BdL(t3);
dt100 = tim(2)-tim(1); g100 = grad_est(t3)';
 load('data/Cycle_276A_900As_processed.mat'); 
 I150 = curr(t4);B150 = BdL(t4);
 dt150 = tim(2)-tim(1); g150 = grad_est(t4)';

 % load('data/Cycle_200A_200As_processed.mat');
% I200 = curr(t4);B200 = BdL(t4);
% dt200 = tim(2)-tim(1); g200 = grad_est(t4)';
% g200(25010:25130) = 200;
% load('data/Cycle_250A_200As_processed.mat'); 

% Variable: time; Vc; 
% figure; plot(I40, B40./I40, I50, B50./I50, I100, B100./I100, I150, B150./I150, I200, B200./I200, I250, B250./I250, I276, B276./I276); ylim([1.2e-3 1.4e-3]); grid on;
%% Find the initial point of the eddy current decay
% v refers to the actual value at the initial point, which we are not
% interested in. we are interested in the time sample at which the eddy
% current decay starts for each measurement.

% Ramp up
[v4, t150] = min(diff(g150));
[v5, t100] = min(diff(g100));
[v6, t50] = min(diff(g50));
[v7, t40] = min(diff(g40));

% Ramp down. An offset of 50k samples is added to consider only the ramp
% down decay
[v11, t150d] = max(diff(g150(50001:end)));
[v12, t100d] = max(diff(g100(50001:end)));
[v13, t50d] = max(diff(g50(50001:end)));
[v14, t40d] = max(diff(g40(50001:end)));
 
% Add extra 50k samples following the offset carried out in the last step
t150d = t150d+50000; t100d = t100d+50000; t50d = t50d+50000; t40d = t40d+50000;
      
%% Remove linear component from integral magnetic field measurement
z1 = (B40-(p(1)*I40)-p(2));
z2 = (B50-(p(1)*I50)-p(2));
z3 = (B100-(p(1)*I100)-p(2));
z4 = (B150-(p(1)*I150)-p(2));


% plot the non-linear component of the field against the current
 figure; plot(I40, z1, I50, z2, I100, z3, I150, z4); grid on;
%% Limit the ramp up signal up to plateau (ramp down signals are already limited by the end of the measurement)
a = 1.6; b=39e3; c=39e3; % Parameters chosen explicitly based on plateau length
dI40up = z1(1:end/a);
dI50up = z2(1:end/a);
dI100up = z3(1:end/a);
dI150up =  z4(1:end/a);


 e40up = dI40up(t40:(t40+b)); e50up = dI50up(t50:t50+b); e100up = dI100up(t100:t100+b); e150up = dI150up(t150:t150+b); 
 e40d = z1(t40d:(t40d+c)); e50d = z2(t50d:t50d+c); e100d = z3(t100d:t100d+c); e150d = z4(t150d:t150d+c); 
% 
%% Define time signals for ramp up and ramp down
f = 1/dt40;  % Sample frequency
et = linspace(0, length(e40up)/f, length(e40up));
etd = linspace(0, length(e40d)/f, length(e40d));

e40n = e40up-e40up(1); RR40n = linspace(100,100, length(e40n));
e50n = e50up-e50up(1); RR50n = linspace(200,200, length(e50n));
e100n = e100up-e100up(1); RR100n = linspace(500,500, length(e100n));
e150n = e150up-e150up(1); RR150n = linspace(900,900, length(e150n));

e40dn = e40d-e40d(1); RR40dn = -linspace(100,100, length(e40dn));
e50dn = e50d-e50d(1); RR50dn = -linspace(200,200, length(e50dn));
e100dn = e100d-e100d(1); RR100dn = -linspace(500,500, length(e100dn));
e150dn = e150d-e150d(1); RR150dn = -linspace(900,900, length(e150dn));

% 
%  figure; plot(e276n, e50n, 'k--'); hold on; plot(e276n,e100n, 'b'); hold on; plot(e276n, e150n, 'r--');  hold on; plot(e276n, e200n, 'm--'); hold on; plot(e276n, e250n, 'k'); hold on; plot(e276n, e40n, 'k'); grid on;
figure; plot(et,e40n); hold on; plot(et,e50n); hold on; plot(et,e100n); hold on; plot(et,e150n);  legend('100 A/s', '200 A/s', '500 A/s', '900 A/s');  grid on;
hold on; plot(etd,e40dn); hold on; plot(etd,e50dn); hold on; plot(etd,e100dn); hold on; plot(etd,e150dn);legend('100 A/s', '200 A/s', '500 A/s', '900 A/s', 'Location','eastoutside'); title('B_n signal at different current amplitudes')
xlabel('Time [s]');
ylabel('B_n(t)-B_n(t_0) [Tm]');

%%

f40_ = expFitdouble(et, e40n);
f50_ = expFitdouble(et, e50n);
f100_ = expFitdouble(et, e100n);
f150_ =expFitdouble(et, e150n);
g40_ = expFitdouble(etd, e40dn);
g50_ = expFitdouble(etd, e50dn);
g100_ = expFitdouble(etd, e100dn);
g150_ = expFitdouble(etd, e150dn);


f40= coeffvalues(f40_); f50= coeffvalues(f50_); f100= coeffvalues(f100_); f150= coeffvalues(f150_); 
g40= coeffvalues(g40_); g50= coeffvalues(g50_); g100= coeffvalues(g100_); g150= coeffvalues(g150_);
a = [f40(1); f50(1); f100(1); f150(1)];
b = [f40(2); f50(2); f100(2); f150(2)];
c = [f40(3); f50(3); f100(3); f150(3)];
d = [f40(4); f50(4); f100(4); f150(4)];
e = [f40(5); f50(5); f100(5); f150(5)];

a2 = [g40(1); g50(1); g100(1); g150(1)];
b2 = [g40(2); g50(2); g100(2); g150(2)];
c2 = [g40(3); g50(3); g100(3); g150(3)];
d2 = [g40(4); g50(4); g100(4); g150(4)];
e2 = [g40(5); g50(5); g100(5); g150(5)];
amp = [100; 200; 500; 900];
% UP
t1 = polyFit(amp, a);
t2 = polyFit(amp, b);
t3 = polyFit(amp, c);
t4 = polyFit(amp, d);
t5 = polyFit(amp, e);
% DOWN
t6 = polyFit(amp, a2);
t7 = polyFit(amp, b2);
t8 = polyFit(amp, c2);
t9 = polyFit(amp, d2);
t10= polyFit(amp, e2);

% 
% 
v = 100; 
exp_mod_up = t1(v)*(1-(t2(v)*exp(-t3(v)*et))-(t4(v)*exp(-t5(v)*et)));
exp_mod_down = t6(v)*(1-(t7(v)*exp(-t8(v)*et))-(t9(v)*exp(-t10(v)*et)));
figure; plot(et, exp_mod_up, 'b--','LineWidth',2); hold on; plot(et, e40n, 'r'); grid on; hold on; 
plot(etd, exp_mod_down, 'b--','LineWidth',2); hold on; plot( etd, e40dn, 'r');   hold on;

v = 200; 
exp_mod_up = t1(v)*(1-(t2(v)*exp(-t3(v)*et))-(t4(v)*exp(-t5(v)*et)));
exp_mod_down = t6(v)*(1-(t7(v)*exp(-t8(v)*et))-(t9(v)*exp(-t10(v)*et)));
 plot(et, exp_mod_up, 'b--', 'LineWidth',2); hold on; plot(et, e50n, 'r');  grid on; hold on;
plot(etd, exp_mod_down, 'b--', 'LineWidth',2); hold on; plot(etd, e50dn, 'r');   hold on;

v = 500; 
exp_mod_up = t1(v)*(1-(t2(v)*exp(-t3(v)*et))-(t4(v)*exp(-t5(v)*et)));
exp_mod_down = t6(v)*(1-(t7(v)*exp(-t8(v)*et))-(t9(v)*exp(-t10(v)*et)));
 plot(et, exp_mod_up, 'b--','LineWidth',2); hold on; plot( et, e100n, 'r');  grid on; hold on;
plot(etd, exp_mod_down, 'b--', 'LineWidth',2); hold on; plot(etd, e100dn, 'r');   hold on;

v = 900; 
exp_mod_up = t1(v)*(1-(t2(v)*exp(-t3(v)*et))-(t4(v)*exp(-t5(v)*et)));
exp_mod_down = t6(v)*(1-(t7(v)*exp(-t8(v)*et))-(t9(v)*exp(-t10(v)*et)));
 plot(et, exp_mod_up, 'b--','LineWidth',2); hold on; plot( et, e150n, 'r');  grid on; hold on;
plot(etd, exp_mod_down, 'b--', 'LineWidth',2); hold on; plot(etd, e150dn, 'r');   hold on;



