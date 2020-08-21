% Data prep before training; uncomment save comment to save to mat file

close all;
clear all;
m=1;

%% Load data Major loops
u = 1; v = 1210017; w=100;
p1 = 235700:363726; p2 = 845711:973735;
load('set1/RR2.533/loop1.mat');
t1_1 = loop(u:m:v, 1) - loop(1, 1); H1_1 = loop(u:m:v, 2); B1_1 = loop(u:m:v, 3); d=B1_1(1);
t1_1 = [t1_1(p1); t1_1(p2)]; H1_1 = [H1_1(p1); H1_1(p2)]; B1_1 = [B1_1(p1); B1_1(p2)];
H1_1 = H1_1(1:w:end); B1_1 = B1_1(1:w:end); t1_1 = t1_1(1:w:end);
grad1_1 = diff(H1_1)./diff(t1_1); grad1_1 = [grad1_1; grad1_1(end)];
load('set1/RR2.533/loop2.mat');
t1_2 = loop(u:m:v, 1) - loop(1, 1);  H1_2 = loop(u:m:v, 2);   B1_2 = loop(u:m:v, 3);
delta1 = d-B1_2(1); B1_2 = B1_2+delta1;
t1_2 = [t1_2(p1); t1_2(p2)]; H1_2 = [H1_2(p1); H1_2(p2)]; B1_2 = [B1_2(p1); B1_2(p2)];
H1_2 = H1_2(1:w:end); B1_2 = B1_2(1:w:end); t1_2 = t1_2(1:w:end);
grad1_2 = diff(H1_2)./diff(t1_2); grad1_2 = [grad1_2; grad1_2(end)];
load('set1/RR2.533/loop3.mat');
t1_3 = loop(u:m:v, 1) - loop(1, 1);  H1_3 = loop(u:m:v, 2); B1_3 = loop(u:m:v, 3);
 delta1 = d-B1_3(1); B1_3 = B1_3+delta1;
t1_3 = [t1_3(p1); t1_3(p2)]; H1_3 = [H1_3(p1); H1_3(p2)]; B1_3 = [B1_3(p1); B1_3(p2)];
H1_3 = H1_3(1:w:end); B1_3 = B1_3(1:w:end); t1_3 = t1_3(1:w:end);
grad1_3 = diff(H1_3)./diff(t1_3); grad1_3 = [grad1_3; grad1_3(end)];
load('set1/RR2.533/loop4.mat');
t1_4 = loop(u:m:v, 1) - loop(1, 1); f4 = 1/(t1_4(end)-t1_4(1)); H1_4 = loop(u:m:v, 2); B1_4 = loop(u:m:v, 3);
 delta1 = d-B1_4(1); B1_4 = B1_4+delta1;
t1_4 = [t1_4(p1); t1_4(p2)]; H1_4 = [H1_4(p1); H1_4(p2)]; B1_4 = [B1_4(p1); B1_4(p2)];
H1_4 = H1_4(1:w:end); B1_4 = B1_4(1:w:end); t1_4 = t1_4(1:w:end);
grad1_4 = diff(H1_4)./diff(t1_4); grad1_4 = [grad1_4; grad1_4(end)];
load('set1/RR2.533/loop5.mat');
t1_5 = loop(u:m:v, 1) - loop(1, 1); f5 = 1/(t1_5(end)-t1_5(1)); H1_5 = loop(u:m:v, 2); B1_5 = loop(u:m:v, 3);
delta1 = d-B1_5(1); B1_5 = B1_5+delta1;
t1_5 = [t1_5(p1); t1_5(p2)]; H1_5 = [H1_5(p1); H1_5(p2)]; B1_5 = [B1_5(p1); B1_5(p2)]; 
H1_5 = H1_5(1:w:end); B1_5 = B1_5(1:w:end); t1_5 = t1_5(1:w:end);
grad1_5 = diff(H1_5)./diff(t1_5); grad1_5 = [grad1_5; grad1_5(end)];

u = 1; v = 618001; p1 = 119691:184546; p2 = 433692:498550;
load('set1/RR5/loop1.mat');
t2_1 = loop(u:m:v, 1) - loop(1, 1); H2_1 = loop(u:m:v, 2); B2_1 = loop(u:m:v, 3);
deltaB = d-B2_1(1); B2_1 = B2_1+deltaB;
t2_1 = [t2_1(p1); t2_1(p2)]; H2_1 = [H2_1(p1); H2_1(p2)]; B2_1 = [B2_1(p1); B2_1(p2)];
H2_1 = H2_1(1:w:end); B2_1 = B2_1(1:w:end); t2_1 = t2_1(1:w:end);
grad2_1 = diff(H2_1)./diff(t2_1); grad2_1 = [grad2_1; grad2_1(end)];
load('set1/RR5/loop2.mat');
t2_2 = loop(u:m:v, 1) - loop(1, 1); H2_2 = loop(u:m:v, 2); B2_2 = loop(u:m:v, 3);
 deltaB = d-B2_2(1); B2_2 = B2_2+deltaB;
H2_2 = [H2_2(p1); H2_2(p2)]; B2_2 = [B2_2(p1); B2_2(p2)]; t2_2 = [t2_2(p1); t2_2(p2)]; 
H2_2 = H2_2(1:w:end); B2_2 = B2_2(1:w:end); t2_2 = t2_2(1:w:end); 
grad2_2 = diff(H2_2)./diff(t2_2); grad2_2 = [grad2_2; grad2_2(end)];
load('set1/RR5/loop3.mat');
t2_3 = loop(u:m:v, 1) - loop(1, 1); H2_3 = loop(u:m:v, 2); B2_3 = loop(u:m:v, 3);
 deltaB = d-B2_3(1); B2_3 = B2_3+deltaB;
t2_3 = [t2_3(p1); t2_3(p2)]; H2_3 = [H2_3(p1); H2_3(p2)]; B2_3 = [B2_3(p1); B2_3(p2)];
H2_3 = H2_3(1:w:end); B2_3 = B2_3(1:w:end); t2_3 = t2_3(1:w:end);
grad2_3 = diff(H2_3)./diff(t2_3); grad2_3 = [grad2_3; grad2_3(end)];
load('set1/RR5/loop4.mat');
t2_4 = loop(u:m:v, 1) - loop(1, 1); H2_4 = loop(u:m:v, 2); B2_4 = loop(u:m:v, 3);
 deltaB = d-B2_4(1); B2_4 = B2_4+deltaB;
t2_4 = [t2_4(p1); t2_4(p2)]; H2_4 = [H2_4(p1); H2_4(p2)]; B2_4 = [B2_4(p1); B2_4(p2)];
H2_4 = H2_4(1:w:end); B2_4 = B2_4(1:w:end); t2_4 = t2_4(1:w:end);
grad2_4 = diff(H2_4)./diff(t2_4); grad2_4 = [grad2_4; grad2_4(end)];
load('set1/RR5/loop5.mat');
t2_5 = loop(u:m:v, 1) - loop(1, 1); H2_5 = loop(u:m:v, 2); B2_5 = loop(u:m:v, 3);
 deltaB = d-B2_5(1); B2_5 = B2_5+deltaB;
t2_5 = [t2_5(p1); t2_5(p2)]; H2_5 = [H2_5(p1); H2_5(p2)]; B2_5 = [B2_5(p1); B2_5(p2)];
H2_5 = H2_5(1:w:end); B2_5 = B2_5(1:w:end); t2_5 = t2_5(1:w:end);
grad2_5 = diff(H2_5)./diff(t2_5); grad2_5 = [grad2_5; grad2_5(end)];

u=1; v=314001;  p1 = 59692:92123; p2 = 221689:254125;
load('set1/RR10/loop1.mat');
t3_1 = loop(u:m:v, 1) - loop(1, 1); H3_1 = loop(u:m:v, 2); B3_1 = loop(u:m:v, 3);
deltaB =d-B3_1(1);  B3_1 = B3_1+deltaB;
t3_1 = [t3_1(p1); t3_1(p2)]; H3_1 = [H3_1(p1); H3_1(p2)]; B3_1 = [B3_1(p1); B3_1(p2)];
H3_1 = H3_1(1:w:end); B3_1 = B3_1(1:w:end); t3_1 = t3_1(1:w:end);
grad3_1 = diff(H3_1)./diff(t3_1); grad3_1 = [grad3_1; grad3_1(end)];
load('set1/RR10/loop2.mat');
t3_2 = loop(u:m:v, 1) - loop(1, 1); H3_2 = loop(u:m:v, 2); B3_2 = loop(u:m:v, 3);
 deltaB = d-B3_2(1); B3_2 = B3_2+deltaB;
t3_2 = [t3_2(p1); t3_2(p2)]; H3_2 = [H3_2(p1); H3_2(p2)]; B3_2 = [B3_2(p1); B3_2(p2)]; 
H3_2 = H3_2(1:w:end);B3_2 = B3_2(1:w:end); t3_2 = t3_2(1:w:end);
grad3_2 = diff(H3_2)./diff(t3_2); grad3_2 = [grad3_2; grad3_2(end)];
load('set1/RR10/loop3.mat');
t3_3 = loop(u:m:v, 1) - loop(1, 1); H3_3 = loop(u:m:v, 2); B3_3 = loop(u:m:v, 3);
  deltaB = d-B3_3(1);  B3_3 = B3_3+deltaB;
t3_3 = [t3_3(p1); t3_3(p2)]; H3_3 = [H3_3(p1); H3_3(p2)]; B3_3 = [B3_3(p1); B3_3(p2)];
H3_3 = H3_3(1:w:end); B3_3 = B3_3(1:w:end); t3_3 = t3_3(1:w:end);
grad3_3 = diff(H3_3)./diff(t3_3); grad3_3 = [grad3_3; grad3_3(end)];
load('set1/RR10/loop4.mat');
t3_4 = loop(u:m:v, 1) - loop(1, 1); H3_4 = loop(u:m:v, 2); B3_4 = loop(u:m:v, 3);
  deltaB = d-B3_4(1); B3_4 = B3_4+deltaB;
t3_4 = [t3_4(p1); t3_4(p2)]; H3_4 = [H3_4(p1); H3_4(p2)]; B3_4 = [B3_4(p1); B3_4(p2)];
H3_4 = H3_4(1:w:end); B3_4 = B3_4(1:w:end); t3_4 = t3_4(1:w:end);
grad3_4 = diff(H3_4)./diff(t3_4); grad3_4 = [grad3_4; grad3_4(end)];
load('set1/RR10/loop5.mat');
t3_5 = loop(u:m:v, 1) - loop(1, 1); H3_5 = loop(u:m:v, 2); B3_5 = loop(u:m:v, 3); 
 deltaB = d-B3_5(1);   B3_5 = B3_5+deltaB;
t3_5 = [t3_5(p1); t3_5(p2)]; H3_5 = [H3_5(p1); H3_5(p2)]; B3_5 = [B3_5(p1); B3_5(p2)];
H3_5 = H3_5(1:w:end); B3_5 = B3_5(1:w:end); t3_5 = t3_5(1:w:end);
grad3_5 = diff(H3_5)./diff(t3_5); grad3_5 = [grad3_5; grad3_5(end)];

u=1; v=1830361; p1 = 358157:552341; p2 =1278342:1472522;
load('set1/RR167/loop1.mat');
t4_1 = loop(u:m:v, 1) - loop(1, 1); H4_1 = loop(u:m:v, 2); B4_1 = loop(u:m:v, 3);
deltaB = d-B4_1(1); B4_1 = B4_1+deltaB;
t4_1 = [t4_1(p1); t4_1(p2)]; H4_1 = [H4_1(p1); H4_1(p2)]; B4_1 = [B4_1(p1); B4_1(p2)];
H4_1 = H4_1(1:w:end); B4_1 = B4_1(1:w:end); t4_1 = t4_1(1:w:end);
grad4_1 = diff(H4_1)./diff(t4_1); grad4_1 = [grad4_1; grad4_1(end)];
load('set1/RR167/loop2.mat');
t4_2 = loop(u:m:v, 1) - loop(1, 1); H4_2 = loop(u:m:v, 2); B4_2 = loop(u:m:v, 3);
 deltaB = d-B4_2(1); B4_2 = B4_2+deltaB;
t4_2 = [t4_2(p1); t4_2(p2)]; H4_2 = [H4_2(p1); H4_2(p2)]; B4_2 = [B4_2(p1); B4_2(p2)];
H4_2 = H4_2(1:w:end); B4_2 = B4_2(1:w:end); t4_2 = t4_2(1:w:end);
grad4_2 = diff(H4_2)./diff(t4_2); grad4_2 = [grad4_2; grad4_2(end)];
load('set1/RR167/loop3.mat');
t4_3 = loop(u:m:v, 1) - loop(1, 1); H4_3 = loop(u:m:v, 2); B4_3 = loop(u:m:v, 3);
deltaB = d-B4_3(1); B4_3 = B4_3+deltaB;
t4_3 = [t4_3(p1); t4_3(p2)]; H4_3 = [H4_3(p1); H4_3(p2)]; B4_3 = [B4_3(p1); B4_3(p2)];
H4_3 = H4_3(1:w:end); B4_3 = B4_3(1:w:end); t4_3 = t4_3(1:w:end);
grad4_3 = diff(H4_3)./diff(t4_3); grad4_3 = [grad4_3; grad4_3(end)];
load('set1/RR167/loop4.mat');
t4_4 = loop(u:m:v, 1) - loop(1, 1); H4_4 = loop(u:m:v, 2); B4_4 = loop(u:m:v, 3);
 deltaB = d-B4_4(1); B4_4 = B4_4+deltaB;
t4_4 = [t4_4(p1); t4_4(p2)]; H4_4 = [H4_4(p1); H4_4(p2)]; B4_4 = [B4_4(p1); B4_4(p2)];
H4_4 = H4_4(1:w:end); B4_4 = B4_4(1:w:end); t4_4 = t4_4(1:w:end);
grad4_4 = diff(H4_4)./diff(t4_4); grad4_4 = [grad4_4; grad4_4(end)];
load('set1/RR167/loop5.mat');
t4_5 = loop(u:m:v, 1) - loop(1, 1); H4_5 = loop(u:m:v, 2); B4_5 = loop(u:m:v, 3);
deltaB = d-B4_5(1); B4_5 = B4_5+deltaB;
t4_5 = [t4_5(p1); t4_5(p2)]; H4_5 = [H4_5(p1); H4_5(p2)]; B4_5 = [B4_5(p1); B4_5(p2)];
H4_5 = H4_5(1:w:end); B4_5 = B4_5(1:w:end); t4_5 = t4_5(1:w:end);
grad4_5 = diff(H4_5)./diff(t4_5); grad4_5 = [grad4_5; grad4_5(end)];
% 
%% Minor loops
s=5; m=25;
load('set2/RR2.533/loop1.mat');
t5_1 = loop(1:m:end/s, 1) - loop(1, 1);
H5_1 = loop(1:m:end/s, 2);
B5_1 = loop(1:m:end/s, 3);
grad5_1 = diff(H5_1)./diff(t5_1);
grad5_1 = [grad5_1; grad5_1(end)];
load('set2/RR2.533/loop2.mat');
t5_2 = loop(1:m:end/s, 1) - loop(1, 1);  f2 = 1/(t5_2(end)-t5_2(1));
H5_2 = loop(1:m:end/s, 2);
B5_2 = loop(1:m:end/s, 3);
grad5_2 = diff(H5_2)./diff(t5_2);
grad5_2 = [grad5_2; grad5_2(end)];
load('set2/RR2.533/loop3.mat');
t5_3 = loop(1:m:end/s, 1) - loop(1, 1);  f3 = 1/(t5_3(end)-t5_3(1));
H5_3 = loop(1:m:end/s, 2);
B5_3 = loop(1:m:end/s, 3);
grad5_3 = diff(H5_3)./diff(t5_3);
grad5_3 = [grad5_3; grad5_3(end)];
load('set2/RR2.533/loop4.mat');
t5_4 = loop(1:m:end/s, 1) - loop(1, 1); f4 = 1/(t5_4(end)-t5_4(1));
H5_4 = loop(1:m:end/s, 2);
B5_4 = loop(1:m:end/s, 3);
grad5_4 = diff(H5_4)./diff(t5_4);
grad5_4 = [grad5_4; grad5_4(end)];
load('set2/RR2.533/loop5.mat');
t5_5 = loop(1:m:end/s, 1) - loop(1, 1); f5 = 1/(t5_5(end)-t5_5(1));
H5_5 = loop(1:m:end/s, 2);
B5_5 = loop(1:m:end/s, 3);
grad5_5 = diff(H5_5)./diff(t5_5);
grad5_5 = [grad5_5; grad5_5(end)];

s=4;
load('set2/RR5/loop1.mat');
t6_1 = loop(1:m:end/s, 1) - loop(1, 1);
H6_1 = loop(1:m:end/s, 2);
B6_1 = loop(1:m:end/s, 3);
grad6_1 = diff(H6_1)./diff(t6_1);
grad6_1 = [grad6_1; grad6_1(end)];
load('set2/RR5/loop2.mat');
t6_2 = loop(1:m:end/s, 1) - loop(1, 1);
H6_2 = loop(1:m:end/s, 2);
B6_2 = loop(1:m:end/s, 3);
grad6_2 = diff(H6_2)./diff(t6_2);
grad6_2 = [grad6_2; grad6_2(end)];
load('set2/RR5/loop3.mat');
t6_3 = loop(1:m:end/s, 1) - loop(1, 1);
H6_3 = loop(1:m:end/s, 2);
B6_3 = loop(1:m:end/s, 3);
grad6_3 = diff(H6_3)./diff(t6_3);
grad6_3 = [grad6_3; grad6_3(end)];
load('set2/RR5/loop4.mat');
t6_4 = loop(1:m:end/s, 1) - loop(1, 1);
H6_4 = loop(1:m:end/s, 2);
B6_4 = loop(1:m:end/s, 3);
grad6_4 = diff(H6_4)./diff(t6_4);
grad6_4 = [grad6_4; grad6_4(end)];
load('set2/RR5/loop5.mat');
t6_5 = loop(1:m:end/s, 1) - loop(1, 1);
H6_5 = loop(1:m:end/s, 2);
B6_5 = loop(1:m:end/s, 3);
grad6_5 = diff(H6_5)./diff(t6_5);
grad6_5 = [grad6_5; grad6_5(end)];

s=3.2;
load('set2/RR10/loop1.mat');
t7_1 = loop(1:m:end/s, 1) - loop(1, 1);
H7_1 = loop(1:m:end/s, 2);
B7_1 = loop(1:m:end/s, 3);
grad7_1 = diff(H7_1)./diff(t7_1);
grad7_1 = [grad7_1; grad7_1(end)];
load('set2/RR10/loop2.mat');
t7_2 = loop(1:m:end/s, 1) - loop(1, 1);
H7_2 = loop(1:m:end/s, 2);
B7_2 = loop(1:m:end/s, 3);
grad7_2 = diff(H7_2)./diff(t7_2);
grad7_2 = [grad7_2; grad7_2(end)];
load('set2/RR10/loop3.mat');
t7_3 = loop(1:m:end/s, 1) - loop(1, 1);
H7_3 = loop(1:m:end/s, 2);
B7_3 = loop(1:m:end/s, 3);
grad7_3 = diff(H7_3)./diff(t7_3);
grad7_3 = [grad7_3; grad7_3(end)];
load('set2/RR10/loop4.mat');
t7_4 = loop(1:m:end/s, 1) - loop(1, 1);
H7_4 = loop(1:m:end/s, 2);
B7_4 = loop(1:m:end/s, 3);
grad7_4 = diff(H7_4)./diff(t7_4);
grad7_4 = [grad7_4; grad7_4(end)];
load('set2/RR10/loop5.mat');
t7_5 = loop(1:m:end/s, 1) - loop(1, 1);
H7_5 = loop(1:m:end/s, 2);
B7_5 = loop(1:m:end/s, 3);
grad7_5 = diff(H7_5)./diff(t7_5);
grad7_5 = [grad7_5; grad7_5(end)];

s=6;
load('set2/RR1.67/loop1.mat');
t8_1 = loop(1:m:end/s, 1) - loop(1, 1);
H8_1 = loop(1:m:end/s, 2);
B8_1 = loop(1:m:end/s, 3);
grad8_1 = diff(H8_1)./diff(t8_1);
grad8_1 = [grad8_1; grad8_1(end)];
load('set2/RR1.67/loop2.mat');
t8_2 = loop(1:m:end/s, 1) - loop(1, 1);
H8_2 = loop(1:m:end/s, 2);
B8_2 = loop(1:m:end/s, 3);
grad8_2 = diff(H8_2)./diff(t8_2);
grad8_2 = [grad8_2; grad8_2(end)];
load('set2/RR1.67/loop3.mat');
t8_3 = loop(1:m:end/s, 1) - loop(1, 1);
H8_3 = loop(1:m:end/s, 2);
B8_3 = loop(1:m:end/s, 3);
grad8_3 = diff(H8_3)./diff(t8_3);
grad8_3 = [grad8_3; grad8_3(end)];
load('set2/RR1.67/loop4.mat');
t8_4 = loop(1:m:end/s, 1) - loop(1, 1);
H8_4 = loop(1:m:end/s, 2);
B8_4 = loop(1:m:end/s, 3);
grad8_4 = diff(H8_4)./diff(t8_4);
grad8_4 = [grad8_4; grad8_4(end)];
load('set2/RR1.67/loop5.mat');
t8_5 = loop(1:m:end/s, 1) - loop(1, 1);
H8_5 = loop(1:m:end/s, 2);
B8_5 = loop(1:m:end/s, 3);
grad8_5 = diff(H8_5)./diff(t8_5);
grad8_5 = [diff(H8_5)./diff(t8_5); grad8_5(end)];

load('set2/loopchar.mat');
t9_1 = loop(1:m:end/s, 1) - loop(1, 1);
H9_1 = loop(1:m:end/s, 2);
B9_1 = loop(1:m:end/s, 3);
grad9_1 = diff(H9_1)./diff(t9_1);
grad9_1 = [diff(H9_1)./diff(t9_1); grad9_1(end)];

%% Minor loop signals export
curr_train = [H8_2; H5_1; H7_2];
curr_test =[H9_1];
grad_train = [grad8_2; grad5_1; grad7_2];

grad_test = [grad9_1];
B_train = [B8_2; B5_1; B7_2];
B_test = [B9_1];

train =  [curr_train grad_train B_train];
test =  [curr_test grad_test B_test];
% 
%   save('train.mat', 'train') % Uncomment to save file
%   save('test.mat', 'test')

%%  Major loop signals export
Mcurr_train = [H4_1; H4_2; H4_3; H1_1; H1_2; H1_3; H3_1; H3_2; H3_3];
Mcurr_test =[H2_1; H2_2; H2_3];
Mgrad_train = [grad4_1; grad4_2; grad4_3; grad1_1; grad1_2; grad1_3; grad3_1; grad3_2; grad3_3];

Mgrad_test = [grad2_1; grad2_2; grad2_3];
MB_train = [B4_1; B4_2; B4_3; B1_1; B1_2; B1_3; B3_1; B3_2; B3_3];
MB_test = [B2_1; B2_2; B2_3];

Mtrain =  [Mcurr_train Mgrad_train MB_train];
Mtest =  [Mcurr_test Mgrad_test MB_test];
% 
% save('Mtrain.mat', 'Mtrain')  % Uncomment to save file
% save('Mtest.mat', 'Mtest')

