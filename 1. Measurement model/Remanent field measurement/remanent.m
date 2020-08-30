%% Remanent Field Calculation of ELENA reference magnet before and after degaussing
% Christian Grech

clear all;
close all;

load('after_flux70.mat');
load('after_flux1000.mat');
load('initial_flux70.mat');
load('initial_flux1000.mat');
load('distance.mat');
load('after_hall.mat');
load('initial_probe.mat');

%% Plot raw data
% figure;
% plot(distance,After_Flux_70, 'xb', distance, After_Flux_1000, 'xr', distance, After_Hall, 'xk')

%% Replace NaN values with interpolated data for Initial Data

xi=distance(find(~isnan(Initial_Flux_1000)));yi=Initial_Flux_1000(find(~isnan(Initial_Flux_1000)));
Initial_Flux_1000_interp=interp1(xi,yi,distance,'linear');

xi=distance(find(~isnan(Initial_Flux_70)));yi=Initial_Flux_70(find(~isnan(Initial_Flux_70)));
Initial_Flux_70_interp=interp1(xi,yi,distance,'linear');

%% Plot interpolated data and calculated integrated initial field BEFORE DEGAUSSING
for i = 1:46
Average_after_1b(i) = (Initial_Flux_1000_interp(i)+Initial_probe(i))/2;
blockb(i,1) = Initial_Flux_1000_interp(i);
blockb(i,2) = Initial_probe(i); 
sdb(i) = std(blockb(i,:)); %standard deviation
end;

for i = 146:191
Average_after_2b(i) =  (Initial_Flux_1000_interp(i)+Initial_probe(i))/2;
blockb2(i,1) = Initial_Flux_1000_interp(i);
blockb2(i,2) = Initial_probe(i); 
sdb2(i) = std(blockb2(i,:));  %standard deviation
end;

Initial_flux =  [Average_after_1b'; Initial_probe(47:145); Average_after_2b(146:191)'];  % This is the considered field values before degaussing
Br_before = trapz(distance, Initial_flux)  % integrating the considered field
Initial_flux2 =  [Average_after_1b'; Initial_probe(47:145); Average_after_2b(146:191)'];  % This is the considered field values before degaussing
d5 = linspace(0, 0.46, 46);

f5 = trapz(d5, sdb);
f6 = trapz(d5, sdb2(146:191));

before_sd_Tm = f5+f6                                    % St. deviation in Tm

figure;
plot(distance*1000, Initial_Flux_1000, 'xr', distance*1000, Initial_probe, '-xb', distance*1000, Initial_flux, '-g')
hold on;
plot(distance(94:112)*1000, Initial_flux(94:112),  'xk');
xlabel('Distance from magnet central point [mm]');
ylabel('Magnetic Field [mT]');
legend('Fluxgate Mag-03MS1000','Hall probe THM 7025','Considered values','Extrapolated data');

%% Replace NaN values with interpolated data

xi=distance(find(~isnan(After_Flux_1000)));yi=After_Flux_1000(find(~isnan(After_Flux_1000)));
After_Flux_1000_interp=interp1(xi,yi,distance,'linear');

xi=distance(find(~isnan(After_Hall)));yi=After_Hall(find(~isnan(After_Hall)));
After_Hall_interp=interp1(xi,yi,distance,'linear');

%% Plot interpolated data and calculated integrated final field

for i = 1:72
Average_after_1(i) = (After_Flux_1000_interp(i)+After_Hall_interp(i)+After_Flux_70(i))/3;
block(i,1) = After_Flux_1000_interp(i);
block(i,2) = After_Hall_interp(i); 
block(i,3) = After_Flux_70(i);
sd1(i) = std(block(i,:));   %standard deviation
end;

for i = 122:191
Average_after_2(i) = (After_Flux_1000_interp(i)+After_Hall_interp(i)+After_Flux_70(i))/3;
block2(i,1) = After_Flux_1000_interp(i);
block2(i,2) = After_Hall_interp(i); 
block2(i,3) = After_Flux_70(i);
sd2(i) = std(block2(i,:));  %standard deviation
end;

After_Flux = [Average_after_1'; After_Hall(73:121); Average_after_2(122:191)'];
Br_after = trapz(distance, After_Flux)   % Remanent field after degaussing

d = linspace(0, 0.72, 72);
d2=linspace(0,0.7, 70);
f3 = trapz(d,sd1);
f4 = trapz(d2,sd2(122:191));

before_sd_Tm = f3+f4                       % St. deviation in Tm

figure;
plot(distance*1000, After_Flux_70, '.g', distance*1000, After_Flux_1000, '.k', distance*1000, After_Hall, '.b', distance*1000, After_Flux, '--r', 'LineWidth',1)
legend('Fluxgate Mag-03MS70','Fluxgate Mag-03MS1000','FM 3002','Average','NumColumns',2, 'Location', 'north');
h1 = ylabel('$B$ [mT]','interpreter','latex');
h2 = xlabel('$s$ [mm]','interpreter','latex');
set(gca,'FontName','Palatino Linotype');
ylim([0 0.044]);


figure;
plot(distance*1000, Initial_flux, '-xb', distance*1000, After_Flux, '-xr')
hold on;
plot(distance(94:112)*1000, Initial_flux(94:112),  'xk');
xlabel('Distance from magnet central point [mm]');
ylabel('Magnetic Field [mT]');
legend('Before','After', 'Extrapolated Data');
