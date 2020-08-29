%% Eddy current analysis
% Christian Grech - 13.03.2019 - TE-MSC-MM

%% Clear Variables, Close Current Figures
clc;
clear all;
close all;
p(1) = 0.001272614147872;
p(2) = 2.026356882029685e-04;

%% Load data
r3=24000:36600;  r4=24000:39000;  r6=24000:42000;  r9=24000:40000;  r12=26000:44000;  r15=26000:40000;  r18=30000:45000; 
load('data/Cycle_40A_500As.mat');
I40 = curr(r3);
B40 = BdL(r3);
t40 = tim(r3); grad_est = grad_est';
g40 = grad_est(r3);
load('data/Cycle_50A_500As.mat'); 
I50 = curr(r4);
B50 = BdL(r4);
t50 = tim(r4); grad_est = grad_est';
g50 = grad_est(r4);
load('data/Cycle_100A_500As.mat'); 
I100 = curr(r6);
B100 = BdL(r6);
t100 = tim(r6); grad_est = grad_est';
g100 = grad_est(r6);
load('data/Cycle_150A_500As.mat'); 
I150 = curr(r9);
B150 = BdL(r9);
t150 = tim(r9); grad_est = grad_est';
g150 = grad_est(r9);
load('data/Cycle_200A_500As.mat');
I200 = curr(r12);
B200 = BdL(r12);
t200 = tim(r12); grad_est = grad_est';
g200 = grad_est(r12);
load('data/Cycle_250A_500As.mat'); 
I250 = curr(r15);
B250 = BdL(r15);
t250 = tim(r15); grad_est = grad_est';
g250 = grad_est(r15);
load('data/Cycle_276A_500As.mat'); 
I276 = curr(r18);
B276 = BdL(r18);
t276 = tim(r18); grad_est = grad_est';
g276 = grad_est(r18);
% Variable: time; Vc; 
% figure; plot(I40, B40./I40, I50, B50./I50, I100, B100./I100, I150, B150./I150, I200, B200./I200, I250, B250./I250, I276, B276./I276); ylim([1.2e-3 1.4e-3]); grid on;
%% Read Data
[v i276] = min(diff(g276));
[v i250] = min(diff(g250));
[v i200] = min(diff(g200));
[v i150] = min(diff(g150));
[v i100] = min(diff(g100));
[v i50] = min(diff(g50));
[v i40] = min(diff(g40));

[v i276d] = max(diff(g276(5001:end)));
[v i250d] = max(diff(g250(5001:end)));
[v i200d] = max(diff(g200(5001:end)));
[v i150d] = max(diff(g150(5001:end)));
[v i100d] = max(diff(g100(5001:end)));
[v i50d] = max(diff(g50(5001:end)));
[v i40d] = max(diff(g40(5001:end)));
   
i276d = i276d+5000; i250d = i250d+5000; i200d = i200d+5000; i150d = i150d+5000; i100d = i100d+5000; i50d = i50d+5000; i40d = i40d+5000;
      
%%
z1 = (B40-(p(1)*I40)-p(2));
z2 = (B50-(p(1)*I50)-p(2));
z3 = (B100-(p(1)*I100)-p(2));
z4 = (B150-(p(1)*I150)-p(2));
z5 = (B200-(p(1)*I200)-p(2));
z6 = (B250-(p(1)*I250)-p(2));
z7 = (B276-(p(1)*I276)-p(2));

 figure; plot(I40, z1, I50, z2, I100, z3, I150, z4, I200, z5, I250, z6, I276, z7); grid on;
% 
a = 1.6;
dI40up = z1(1:end/a);
dI50up = z2(1:end/a);
dI100up = z3(1:end/a);
dI150up =  z4(1:end/a);
dI200up = z5(1:end/a);
dI250up = z6(1:end/a);
 dI276up = z7(1:end/a);

b=4000; c=4000;

 e40up = dI40up(i40:(i40+b)); e50up = dI50up(i50:i50+b); e100up = dI100up(i100:i100+b); e150up = dI150up(i150:i150+b); e200up = dI200up(i200:i200+b); e250up = dI250up(i250:i250+b); e276up = dI276up(i276:i276+b); 
 e40d = z1(i40d:(i40d+c)); e50d = z2(i50d:i50d+c); e100d = z3(i100d:i100d+c); e150d = z4(i150d:i150d+c); e200d = z5(i200d:i200d+c); e250d = z6(i250d:i250d+c); e276d = z7(i276d:i276d+c); 
% 

et = linspace(0, length(e40up)/2000, length(e40up));
etd = linspace(0, length(e40d)/2000, length(e40d));

e40n = e40up-e40up(1);
e50n = e50up-e50up(1);
e100n = e100up-e100up(1);
e150n = e150up-e150up(1);
e200n = e200up-e200up(1);
e250n = e250up-e250up(1);
e276n = e276up-e276up(1);

e40dn = e40d-e40d(1);
e50dn = e50d-e50d(1);
e100dn = e100d-e100d(1);
e150dn = e150d-e150d(1);
e200dn = e200d-e200d(1);
e250dn = e250d-e250d(1);
e276dn = e276d-e276d(1);
% 
%  figure; plot(e276n, e50n, 'k--'); hold on; plot(e276n,e100n, 'b'); hold on; plot(e276n, e150n, 'r--');  hold on; plot(e276n, e200n, 'm--'); hold on; plot(e276n, e250n, 'k'); hold on; plot(e276n, e40n, 'k'); grid on;
figure; plot(et,e40n); hold on; plot(et,e50n); hold on; plot(et,e100n); hold on; plot(et,e150n); hold on; plot(et,e200n);hold on; plot(et,e250n); hold on; plot(et,e276n); legend('40A', '50A', '100A', '150A', '200A', '250A', '276A');  grid on;
hold on; plot(etd,e40dn); hold on; plot(etd,e50dn); hold on; plot(etd,e100dn); hold on; plot(etd,e150dn); hold on; plot(etd,e200dn);hold on; plot(etd,e250dn); hold on; plot(etd,e276dn); legend('40A', '50A', '100A', '150A', '200A', '250A', '276A', 'Location','eastoutside'); title('B_n signal at different current amplitudes')
xlabel('Time [s]');
ylabel('B_n(t)-B_n(t_0) [Tm]');

amp = [40; 50; 100; 150; 200; 250; 276];

%% Means of BdL and B
f40_ = expFitdouble(et, e40n);
f50_ = expFitdouble(et, e50n);
f100_ = expFitdouble(et, e100n);
f150_ =expFitdouble(et, e150n);
f200_ = expFitdouble(et, e200n);
f250_ = expFitdouble(et, e250n);
f276_ = expFitdouble(et, e276n);
g40_ = expFitdouble(etd, e40dn);
g50_ = expFitdouble(etd, e50dn);
g100_ = expFitdouble(etd, e100dn);
g150_ = expFitdouble(etd, e150dn);
g200_ = expFitdouble(etd, e200dn);
g250_ = expFitdouble(etd, e250dn);
g276_ = expFitdouble(etd, e276dn);

f40= coeffvalues(f40_); f50= coeffvalues(f50_); f100= coeffvalues(f100_); f150= coeffvalues(f150_); f200= coeffvalues(f200_); f250= coeffvalues(f250_); f276= coeffvalues(f276_);
g40= coeffvalues(g40_); g50= coeffvalues(g50_); g100= coeffvalues(g100_); g150= coeffvalues(g150_); g200= coeffvalues(g200_); g250= coeffvalues(g250_); g276= coeffvalues(g276_);
a = [f40(1); f50(1); f100(1); f150(1); f200(1); f250(1); f276(1)];
b = [f40(2); f50(2); f100(2); f150(2); f200(2); f250(2); f276(2)];
c = [f40(3); f50(3); f100(3); f150(3); f200(3); f250(3); f276(3)];
d = [f40(4); f50(4); f100(4); f150(4); f200(4); f250(4); f276(4)];
e = [f40(5); f50(5); f100(5); f150(5); f200(5); f250(5); f276(5)];

a2 = [g40(1); g50(1); g100(1); g150(1); g200(1); g250(1); g276(1)];
b2 = [g40(2); g50(2); g100(2); g150(2); g200(2); g250(2); g276(2)];
c2 = [g40(3); g50(3); g100(3); g150(3); g200(3); g250(3); g276(3)];
d2 = [g40(4); g50(4); g100(4); g150(4); g200(4); g250(4); g276(4)];
e2 = [g40(5); g50(5); g100(5); g150(5); g200(5); g250(5); g276(5)];

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
v = 40; 
exp_mod_up = t1(v)*(1-(t2(v)*exp(-t3(v)*et))-(t4(v)*exp(-t5(v)*et)));
exp_mod_down = t6(v)*(1-(t7(v)*exp(-t8(v)*et))-(t9(v)*exp(-t10(v)*et)));
figure; plot(et, exp_mod_up, 'b--','LineWidth',2); hold on; plot(et, e40n, 'r-', 'LineWidth',1); grid on; hold on; 
plot(etd, exp_mod_down, 'b--','LineWidth',2); hold on; plot( etd, e40dn, 'r-', 'LineWidth',1);   hold on;

v = 50; 
exp_mod_up = t1(v)*(1-(t2(v)*exp(-t3(v)*et))-(t4(v)*exp(-t5(v)*et)));
exp_mod_down = t6(v)*(1-(t7(v)*exp(-t8(v)*et))-(t9(v)*exp(-t10(v)*et)));
 plot(et, exp_mod_up, 'b--', 'LineWidth',2); hold on; plot(et, e50n, 'r-', 'LineWidth',1);  grid on; hold on;
plot(etd, exp_mod_down, 'b--', 'LineWidth',2); hold on; plot(etd, e50dn, 'r-', 'LineWidth',1);   hold on;

v = 100; 
exp_mod_up = t1(v)*(1-(t2(v)*exp(-t3(v)*et))-(t4(v)*exp(-t5(v)*et)));
exp_mod_down = t6(v)*(1-(t7(v)*exp(-t8(v)*et))-(t9(v)*exp(-t10(v)*et)));
 plot(et, exp_mod_up, 'b--','LineWidth',2); hold on; plot( et, e100n, 'r-', 'LineWidth',1);  grid on; hold on;
plot(etd, exp_mod_down, 'b--', 'LineWidth',2); hold on; plot(etd, e100dn, 'r-', 'LineWidth',1);   hold on;

v = 150; 
exp_mod_up = t1(v)*(1-(t2(v)*exp(-t3(v)*et))-(t4(v)*exp(-t5(v)*et)));
exp_mod_down = t6(v)*(1-(t7(v)*exp(-t8(v)*et))-(t9(v)*exp(-t10(v)*et)));
 plot(et, exp_mod_up, 'b--','LineWidth',2); hold on; plot( et, e150n, 'r-', 'LineWidth',1);  grid on; hold on;
plot(etd, exp_mod_down, 'b--', 'LineWidth',2); hold on; plot(etd, e150dn, 'r-', 'LineWidth',1);   hold on;

v = 200; 
exp_mod_up = t1(v)*(1-(t2(v)*exp(-t3(v)*et))-(t4(v)*exp(-t5(v)*et)));
exp_mod_down = t6(v)*(1-(t7(v)*exp(-t8(v)*et))-(t9(v)*exp(-t10(v)*et)));
 plot(et, exp_mod_up, 'b--', 'LineWidth',2); hold on; plot(et, e200n, 'r-', 'LineWidth',1);  grid on; hold on;
plot(etd, exp_mod_down, 'b--', 'LineWidth',2); hold on; plot(etd, e200dn, 'r-', 'LineWidth',1);   hold on;

v = 250; 
exp_mod_up = t1(v)*(1-(t2(v)*exp(-t3(v)*et))-(t4(v)*exp(-t5(v)*et)));
exp_mod_down = t6(v)*(1-(t7(v)*exp(-t8(v)*et))-(t9(v)*exp(-t10(v)*et)));
 plot(et, exp_mod_up, 'b--', 'LineWidth',2); hold on; plot(et, e250n, 'r-', 'LineWidth',1);  grid on; hold on;
plot(etd, exp_mod_down, 'b--', 'LineWidth',2); hold on; plot(etd, e250dn, 'r-', 'LineWidth',1);   hold on;

v = 276; 
exp_mod_up = t1(v)*(1-(t2(v)*exp(-t3(v)*et))-(t4(v)*exp(-t5(v)*et)));
exp_mod_down = t6(v)*(1-(t7(v)*exp(-t8(v)*et))-(t9(v)*exp(-t10(v)*et)));
 plot(et, exp_mod_up, 'b--', 'LineWidth',2); hold on; plot(et, e276n, 'r-', 'LineWidth',1);  grid on; hold on;
plot(etd, exp_mod_down, 'b--', 'LineWidth',2); hold on; plot(etd, e276dn, 'r-', 'LineWidth',1);   hold on;
legend('Modelled', 'Actual'); 
 xlabel('Time [s]'); xlim([0 2]);

%% Test function


