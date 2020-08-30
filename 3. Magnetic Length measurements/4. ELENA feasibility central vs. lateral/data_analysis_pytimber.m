close all; 
clear all;

filename = 'BatCtime.csv';
filename3 = 'Marker2Ctime.csv';
filename4 = 'Marker1Ctime.csv';

M = csvread(filename,1);
timestamp = M(1:end,1);
B_C1 = M(1:end,2);
B_C2 = M(1:end,3);
time1 = datetime(timestamp, 'convertfrom','epochtime');

M3 = csvread(filename3,1);
timestamp3 = M3(:,1);
CtimeM2_C1 = M3(:,2);
CtimeM2_C2 = M3(:,3);
time3 = datetime(timestamp3, 'convertfrom','epochtime');

M4 = csvread(filename4,1);
timestamp4 = M4(:,1);
CtimeM1_C1 = M4(:,2);
CtimeM1_C2 = M4(:,3);
time4 = datetime(timestamp4, 'convertfrom','epochtime');


 
 %% Marker repeatability
 s=0;
  for l=1:length(timestamp4)
     if (CtimeM1_C1(l) < 0.5355 && CtimeM1_C1(l) >0.5331) && (CtimeM1_C2(l)< 0.6 && CtimeM1_C2(l) > 0.5331)
            s=s+1;
            CtimeM1_C1f(s)=CtimeM1_C1(l);
            CtimeM1_C2f(s)=CtimeM1_C2(l);
            time4f(s)=time4(l);
     end;
 end;
 s=0;
   for l=1:length(timestamp3)
     if (CtimeM2_C1(l) < 2.4 && CtimeM2_C1(l) > 2.3) && (CtimeM2_C2(l)< 2.4 && CtimeM2_C2(l) > 2.3)
            s=s+1;
            CtimeM2_C1f(s)=CtimeM2_C1(l);
            CtimeM2_C2f(s)=CtimeM2_C2(l);
            time3f(s)=time3(l);
     end;
 end;

%  

s1 = sprintf('Number of M2 points: %d', length(time3f)); 
 figure; plot(time3f, CtimeM2_C1f, 'kx', time3f, CtimeM2_C2f, 'rx'); legend('$s=0$~mm', '$s=340$~mm','interpreter','latex');  ylabel('$t_k$ [s]','interpreter','latex');
  
 %%
Bdot_PBMDEC = 0.153517590000000;
Bdot_HMMD1_1 = 9.525790000000001e+02;
Bdot_HMMD1_2 = 6.186424000000002e+03;

  dt_M1C1=std(CtimeM1_C1f)*Bdot_HMMD1_1;
  dt_M1C2=std(CtimeM1_C2f)*Bdot_HMMD1_1;
  
 dt_M2C1=range(CtimeM2_C1f);
 dt_M2C2=range(CtimeM2_C2f);
  s2 = sprintf('Central sensor setup high field marker: %f s', dt_M2C1);
s3 = sprintf('Lateral sensor setup high field marker: %f s', dt_M2C2);
s4 = sprintf('Central sensor setup low field marker: %f G', dt_M1C1);
s5 = sprintf('Lateral sensor setup low field marker: %f G', dt_M1C2);


%% Display
disp('___________________REPORT__________________________________');
disp(s1); disp(s2); disp(s3); disp(s4); disp(s5); 
disp('_______________________________________________________________');
