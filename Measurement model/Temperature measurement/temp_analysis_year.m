%% Author: Christian Grech
close all;
clear all;

load('data_year.mat');

temperature = data_year(:,1);
time = data_year(:,2);
temperature2 = [temperature(1:22088); temperature(30515:end)];
time2 = [time(1:22088); time(30515:end)];

t=0;
  for i = 1:179992
      if temperature2(i) <= 100 && temperature2(i) >= 15
          t=t+1;
            xval(t) = temperature2(i);
            dat(t) = datetime(time2(i), 'convertfrom','posixtime');
       end;
 end;

  
 %% Results
  temperature3 = nonzeros(xval);
  dat2 = rmmissing(dat);
 figure; plot(dat2,  temperature3, 'k.');
 
RMS = rms(temperature3)
stdev=std(temperature3)
ran = range(temperature3)

h1 = ylabel('Temperature [$^o$C]','interpreter','latex');
h2 = xlabel('Measurement date','interpreter','latex');
set(gca,'FontName','Palatino Linotype');
