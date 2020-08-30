%% ELENA magnet tests - Calculating Residual offset calibration value using NMR value
% Author: Christian Grech (TE-MSC-MM)
% Date: 29/09/2016
% Version: 1.0
close all;
clear all;
%%
count = 0;
for y = 1:3
      if y == 1
       x = 0;     elseif y ==2
       x = 500;     elseif y ==3
       x = 800;     end;
%     figure;
    for s = 1:9
        if s == 1
            v = 0;     elseif s ==2
            v = 100;     elseif s ==3
            v = 200;     elseif s ==4
            v = 220;     elseif s ==5
            v = 270;     elseif s ==6
            v = 330;     elseif s ==7
            v = 360;     elseif s ==8
            v = 400;     elseif s ==9
            v = 470;    end;
        
        for k = 1:3
            filename1 = sprintf('Voff_%d_%d_%d.mat',x,v, k);
            load(filename1);
            n = 1;
            % Separate data
             time1 = var(1:n:end, 1);
            Vc1nf = -var(1:n:end,3);
            Probe_1 = var(1:n:end, 4)/5;
            Probe_2 = var(1:n:end, 5)/5;
            Probe_3 = var(1:n:end, 6)/5;
            current_1 = var(1:n:end, 2)*100;
               count = count+1;
            f = round(1/(time1(2)-time1(1)));
            %% Data filtering
             windowWidth = 400;
             windowWidth2 = 400;
            windowWidth3 = 400;
             kernel = ones(windowWidth,1) / windowWidth;
             kernel2 = ones(windowWidth2,1) / windowWidth2;
            kernel3 = ones(windowWidth3,1) / windowWidth3;
             curr = filtfilt(kernel, 1, current_1);
             Probe1f= filtfilt(kernel2, 1, Probe_1);
             Probe2f= filtfilt(kernel2, 1, Probe_2);
             Probe3f= filtfilt(kernel2, 1, Probe_3);
            Vc1= filtfilt(kernel3, 1, Vc1nf);
            %% Drift correction mechnism
                for i = 1: length(Vc1(1,:))
                    flux1(:,i) = cumtrapz(time1(:,i), Vc1(:,i));
                end

            %        figure; plot(flux1);
              drift_index = 8e4:10e4;
              pol = polyfit(time1(drift_index), flux1(drift_index),1);
              V01 = pol(1);

            l = 0.9714;
            wc = 2.8579;
            r1= 0.65e4:4.724e4;
            r2 = 1.075e5:1.486e5;
            %% Calculating BdL
                Flux0 = 0.0019126;
                Phi1 = Flux0+cumtrapz(time1, Vc1-V01);
                BdL_sep = Phi1/(wc);
%                 off2 = 6.43e-4;   % in Tm
                   off2 = 0;
                BdL_sep1 = BdL_sep+off2;
                I_int = 60:1:274;   d=2; 
                %I_int = 60:1:274;
                I_lp = [ I_int; I_int(end:-1:1)  ];
                BdL_int_up(:, count) =  interp1(curr(r1), BdL_sep1(r1), I_int);
                BdL_int_down(:, count) =  interp1(curr(r2), BdL_sep1(r2), I_int);
                B_int_up_1(:, count) =  interp1(curr(r1), Probe1f(r1), I_int);
                B_int_up_2(:, count) =  interp1(curr(r1), Probe2f(r1), I_int);
                B_int_up_3(:, count) =  interp1(curr(r1), Probe3f(r1), I_int);
                B_int_down_1(:, count) =  interp1(curr(r2), Probe1f(r2), I_int);
                B_int_down_2(:, count) =  interp1(curr(r2), Probe2f(r2), I_int);
                B_int_down_3(:, count) =  interp1(curr(r2), Probe3f(r2), I_int);
                B_int_lp_1(:, count) = [B_int_up_1(:, count); B_int_down_1(end:-1:1, count)];   
                B_int_lp_2(:, count) = [B_int_up_2(:, count); B_int_down_2(end:-1:1, count)]; 
                B_int_lp_3(:, count) = [B_int_up_3(:, count); B_int_down_3(end:-1:1, count)]; 
                BdL_lp(:, count) = [BdL_int_up(:, count); BdL_int_down(end:-1:1, count)];
                lm_up_5mm_all(:, count) = BdL_int_up(:, count)./B_int_up_3(:, count);
                lm_up_16mm_all(:, count) = BdL_int_up(:, count)./B_int_up_2(:, count);
                lm_up_25mm_all(:, count) = BdL_int_up(:, count)./B_int_up_1(:, count);
                lm_down_5mm_all(:, count) = BdL_int_down(:, count)./B_int_down_3(:, count);
                lm_down_16mm_all(:, count) = BdL_int_down(:, count)./B_int_down_2(:, count);
                lm_down_25mm_all(:, count) = BdL_int_down(:, count)./B_int_down_1(:, count);
                lm_lp_5mm_all(:, count) = BdL_lp(:, count)./B_int_lp_3(:, count);
                lm_lp_16mm_all(:, count) = BdL_lp(:, count)./B_int_lp_2(:, count);
                lm_lp_25mm_all(:, count) = BdL_lp(:, count)./B_int_lp_1(:, count);              
  
                if k == 3
                       downsamp = count/3;        
                    lm_up_5mm(:, downsamp) = mean(lm_up_5mm_all(:,(count-2):count)');                                                        sd_lm_up_5mm(:, downsamp) = std(lm_up_5mm_all(:,(count-2):count)');
                    lm_up_16mm(:, downsamp) = mean(lm_up_16mm_all(:,(count-2):count)');                                                    sd_lm_up_16mm(:, downsamp) = std(lm_up_16mm_all(:,(count-2):count)');
                    lm_up_25mm(:, downsamp) = mean(lm_up_25mm_all(:,(count-2):count)');                                                    sd_lm_up_25mm(:, downsamp) = std(lm_up_25mm_all(:,(count-2):count)');
                    lm_down_5mm(:, downsamp) = mean(lm_down_5mm_all(:,(count-2):count)');                                               sd_lm_down_5mm(:, downsamp) = std(lm_down_5mm_all(:,(count-2):count)');
                    lm_down_16mm(:, downsamp) = mean(lm_down_16mm_all(:,(count-2):count)');                                            sd_lm_down_16mm(:, downsamp) = std(lm_down_16mm_all(:,(count-2):count)');
                    lm_down_25mm(:, downsamp) = mean(lm_down_25mm_all(:,(count-2):count)');                                            sd_lm_down_25mm(:, downsamp) = std(lm_down_25mm_all(:,(count-2):count)');
                    lm_lp_5mm(:, downsamp) = mean(lm_lp_5mm_all(:,(count-2):count)');                                                             sd_lm_lp_5mm(:, downsamp) = std(lm_lp_5mm_all(:,(count-2):count)');
                    lm_lp_16mm(:, downsamp) = mean(lm_lp_16mm_all(:,(count-2):count)');                                                         sd_lm_lp_16mm(:, downsamp) = std(lm_lp_16mm_all(:,(count-2):count)');
                    lm_lp_25mm(:, downsamp) = mean(lm_lp_25mm_all(:,(count-2):count)');                                                         sd_lm_lp_25mm(:, downsamp) = std(lm_lp_25mm_all(:,(count-2):count)');                    
                     column_track(:, downsamp) = [x; v; k];
%                   subplot(3,3,s); 
%                   errorbar(I_int(1:d:end), lm_up_5mm(1:d:end, downsamp), sd_lm_up_5mm(1:d:end, downsamp), 'b');                        hold on;
%                   errorbar(I_int(1:d:end), lm_down_5mm(1:d:end, downsamp), sd_lm_down_5mm(1:d:end, downsamp), 'b');                hold on;
%                   errorbar(I_int(1:d:end), lm_up_16mm(1:d:end, downsamp), sd_lm_up_16mm(1:d:end, downsamp), 'r');                    hold on;
%                   errorbar(I_int(1:d:end), lm_down_16mm(1:d:end, downsamp), sd_lm_down_16mm(1:d:end, downsamp), 'r');             hold on;                
%                   errorbar(I_int(1:d:end), lm_up_25mm(1:d:end, downsamp), sd_lm_up_25mm(1:d:end, downsamp), 'g');                     hold on;
%                   errorbar(I_int(1:d:end), lm_down_25mm(1:d:end, downsamp), sd_lm_down_25mm(1:d:end, downsamp), 'g'); ylabel('Mag. length [m]'); xlabel('Current [A]'); 
%                   tit = sprintf('Mag. length at x = %d and s = %d', x,v); 
%                   title(tit);
                end;
        end;
    end;
        %% Interpolate wrt s
         s_int = 0:0.05:470;    m=9;
         s_actual = column_track(2, 1:m); % 9 unique distances on the s-axis
       
        if y==1
             lm_int_up_5mm_x0 = interp1(s_actual, lm_up_5mm(:,1:m)', s_int); 
             lm_int_down_5mm_x0 = interp1(s_actual, lm_down_5mm(:,1:m)', s_int);
             lm_int_lp_5mm_x0 = interp1(s_actual, lm_lp_5mm(:,1:m)', s_int); 
             lm_int_up_16mm_x0 = interp1(s_actual, lm_up_16mm(:,1:m)', s_int); 
             lm_int_down_16mm_x0 = interp1(s_actual, lm_down_16mm(:,1:m)', s_int);
             lm_int_lp_16mm_x0 = interp1(s_actual, lm_lp_16mm(:,1:m)', s_int); 
             lm_int_up_25mm_x0 = interp1(s_actual, lm_up_25mm(:,1:m)', s_int); 
             lm_int_down_25mm_x0 = interp1(s_actual, lm_down_25mm(:,1:m)', s_int);
             lm_int_lp_25mm_x0 = interp1(s_actual, lm_lp_25mm(:,1:m)', s_int); 
%                 [s_star_up, lm_star_up, dlm_rel_star_up, dlm_star_up, dlm_rel_0_up, improvement_up, dlm_up_5mm_0] = findOptimalSingleSensorPosition_new( lm_int_up_5mm_x0,s_int, 'UP, 5mm, central', 'rx-'); 
%               fprintf('UP @ 5 mm; central:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_up, lm_star_up, dlm_star_up, dlm_rel_star_up, dlm_rel_0_up, improvement_up);
%                [s_star_down, lm_star_down, dlm_rel_star_down, dlm_star_down, dlm_rel_0_down, improvement_down, dlm_dw_5mm_0] = findOptimalSingleSensorPosition_new( lm_int_down_5mm_x0,s_int, 'DOWN, 5mm, central', 'rx-'); 
%               fprintf('DOWN @ 5 mm, central:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_down, lm_star_down, dlm_star_down, dlm_rel_star_down, dlm_rel_0_down, improvement_down);
             [s_star_lp, lm_star_lp, dlm_rel_star_lp, dlm_star_lp, dlm_rel_0_lp, improvement_lp, dlm_lp_5mm_0, h(1,:)] = findOptimalSingleSensorPosition_new( lm_int_lp_5mm_x0,s_int, 'LOOP, 5mm, central', 'rx-'); 
             fprintf('LOOP @ 5 mm; central:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_lp, lm_star_lp, dlm_star_lp, dlm_rel_star_lp, dlm_rel_0_lp, improvement_lp);
%                [s_star_up16, lm_star_up16, dlm_rel_star_up16, dlm_star_up16, dlm_rel_0_up16, improvement_up16, dlm_up_16mm_0] = findOptimalSingleSensorPosition_new( lm_int_up_16mm_x0,s_int, 'UP, 16mm, central', 'rx-'); 
%               fprintf('UP @ 16 mm, central:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_up16, lm_star_up16, dlm_star_up16, dlm_rel_star_up16, dlm_rel_0_up16, improvement_up16);
%                [s_star_down16, lm_star_down16, dlm_rel_star_down16, dlm_star_down16, dlm_rel_0_down16, improvement_down16, dlm_dw_16mm_0] = findOptimalSingleSensorPosition_new( lm_int_down_16mm_x0,s_int, 'DOWN, 16mm, central', 'rx-'); 
%               fprintf('DOWN @ 16 mm, central:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_down16, lm_star_down16, dlm_star_down16, dlm_rel_star_down16, dlm_rel_0_down16, improvement_down16);
               [s_star_lp16, lm_star_lp16, dlm_rel_star_lp16, dlm_star_lp16, dlm_rel_0_lp16, improvement_lp16, dlm_lp_16mm_0, h(2,:)] = findOptimalSingleSensorPosition_new( lm_int_lp_16mm_x0,s_int, 'LOOP, 16mm, central', 'gx-'); 
             fprintf('LOOP @ 16 mm, central:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_lp16, lm_star_lp16, dlm_star_lp16, dlm_rel_star_lp16, dlm_rel_0_lp16, improvement_lp16);
%               [s_star_up25, lm_star_up25, dlm_rel_star_up25, dlm_star_up25, dlm_rel_0_up25, improvement_up25, dlm_up_25mm_0] = findOptimalSingleSensorPosition_new( lm_int_up_25mm_x0,s_int, 'UP, 25mm, central', 'rx-'); 
%               fprintf('UP @ 25 mm, central:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_up25, lm_star_up25, dlm_star_up25, dlm_rel_star_up25, dlm_rel_0_up25, improvement_up25);
%                [s_star_down25, lm_star_down25, dlm_rel_star_down25, dlm_star_down25, dlm_rel_0_down25, improvement_down25, dlm_dw_25mm_0] = findOptimalSingleSensorPosition_new( lm_int_down_25mm_x0,s_int, 'DOWN, 25mm, central', 'rx-'); 
%               fprintf('DOWN @ 25 mm, central:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_down25, lm_star_down25, dlm_star_down25, dlm_rel_star_down25, dlm_rel_0_down25, improvement_down25);
             [s_star_lp25, lm_star_lp25, dlm_rel_star_lp25, dlm_star_lp25, dlm_rel_0_lp25, improvement_lp25, dlm_lp_25mm_0, h(3,:)] = findOptimalSingleSensorPosition_new( lm_int_lp_25mm_x0,s_int, 'LOOP, 25mm, central', 'bx-'); 
             fprintf('LOOP @ 25 mm, central:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_lp25, lm_star_lp25, dlm_star_lp25, dlm_rel_star_lp25, dlm_rel_0_lp25, improvement_lp25);
             legtext = {'y = 5 mm',...
           'y = 16 mm',...
           'y = 25 mm'};
            styles  = {'r-','g-','b-',};
            % combinePlots([h(1,1),h(2,1),h(3,1),h(1,3),h(2,3),h(3,3)],'lin','log',legtext,styles);  hold on; xlabel('s (m)'); ylabel('(m) or (-)'); hold off;
            combinePlots([h(1,3),h(2,3),h(3,3)],'lin','log',legtext,styles);  hold on; xlabel('s [mm]'); ylabel('$\Delta\ell_m/\bar{\ell}_m$ '); hold on; 
            xl = xline(430, '.-k',{'Magnet pole'}); 
            xl.LabelVerticalAlignment = 'middle';
            xl.LabelHorizontalAlignment = 'center';hold off;
        elseif y==2
             lm_int_up_5mm_x500 = interp1(s_actual, lm_up_5mm(:,(m+1):(2*m))', s_int);          lm_int_lp_5mm_x500 = interp1(s_actual, lm_lp_5mm(:,(m+1):(2*m))', s_int); 
             lm_int_down_5mm_x500 = interp1(s_actual, lm_down_5mm(:,(m+1):(2*m))', s_int);
             lm_int_up_16mm_x500 = interp1(s_actual, lm_up_16mm(:,(m+1):(2*m))', s_int);      lm_int_lp_16mm_x500 = interp1(s_actual, lm_lp_16mm(:,(m+1):(2*m))', s_int); 
             lm_int_down_16mm_x500 = interp1(s_actual, lm_down_16mm(:,(m+1):(2*m))', s_int);
             lm_int_up_25mm_x500 = interp1(s_actual, lm_up_25mm(:,(m+1):(2*m))', s_int);      lm_int_lp_25mm_x500 = interp1(s_actual, lm_lp_25mm(:,(m+1):(2*m))', s_int);
             lm_int_down_25mm_x500 = interp1(s_actual, lm_down_25mm(:,(m+1):(2*m))', s_int);
%              [s_star_up, lm_star_up, dlm_rel_star_up, dlm_star_up, dlm_rel_0_up, improvement_up, dlm_up_5mm_5] = findOptimalSingleSensorPosition_new( lm_int_up_5mm_x500,s_int, 'UP, 5mm,  x=500mm', 'rx-'); 
%              fprintf('UP @ 5 mm; x=500:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_up, lm_star_up, dlm_star_up, dlm_rel_star_up, dlm_rel_0_up, improvement_up);
%               [s_star_down, lm_star_down, dlm_rel_star_down, dlm_star_down, dlm_rel_0_down, improvement_down, dlm_dw_5mm_5, dlm_dw_5mm_5] = findOptimalSingleSensorPosition_new( lm_int_down_5mm_x500,s_int, 'DOWN, 5mm, x=500mm', 'rx-'); 
%              fprintf('DOWN @ 5 mm, x=500:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_down, lm_star_down, dlm_star_down, dlm_rel_star_down, dlm_rel_0_down, improvement_down);
             [s_star_lp, lm_star_lp, dlm_rel_star_lp, dlm_star_lp, dlm_rel_0_lp, improvement_lp, dlm_lp_5mm_5,  p(1,:)] = findOptimalSingleSensorPosition_new( lm_int_lp_5mm_x500,s_int, 'LOOP, 5mm, x=500mm', 'kx-'); 
             fprintf('LOOP @ 5 mm; x=500:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_lp, lm_star_lp, dlm_star_lp, dlm_rel_star_lp, dlm_rel_0_lp, improvement_lp);
%               [s_star_up16, lm_star_up16, dlm_rel_star_up16, dlm_star_up16, dlm_rel_0_up16, improvement_up16, dlm_up_16mm_5] = findOptimalSingleSensorPosition_new( lm_int_up_16mm_x500,s_int, 'UP, 16mm, x=500mm', 'rx-'); 
%              fprintf('UP @ 16 mm, x=500:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_up16, lm_star_up16, dlm_star_up16, dlm_rel_star_up16, dlm_rel_0_up16, improvement_up16);
%               [s_star_down16, lm_star_down16, dlm_rel_star_down16, dlm_star_down16, dlm_rel_0_down16, improvement_down16, dlm_dw_16mm_5] = findOptimalSingleSensorPosition_new( lm_int_down_16mm_x500,s_int, 'DOWN, 16mm, x=500mm', 'rx-'); 
%              fprintf('DOWN @ 16 mm, x=500:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_down16, lm_star_down16, dlm_star_down16, dlm_rel_star_down16, dlm_rel_0_down16, improvement_down16);
             [s_star_lp16, lm_star_lp16, dlm_rel_star_lp16, dlm_star_lp16, dlm_rel_0_lp16, improvement_lp16, dlm_lp_16mm_5,  p(2,:)] = findOptimalSingleSensorPosition_new( lm_int_lp_16mm_x500,s_int, 'LOOP, 16mm, x=500', 'mx-'); 
             fprintf('LOOP @ 16 mm, x=500:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_lp16, lm_star_lp16, dlm_star_lp16, dlm_rel_star_lp16, dlm_rel_0_lp16, improvement_lp16);
%              [s_star_up25, lm_star_up25, dlm_rel_star_up25, dlm_star_up25, dlm_rel_0_up25, improvement_up25, dlm_up_25mm_5] = findOptimalSingleSensorPosition_new( lm_int_up_25mm_x500,s_int, 'UP, 25mm, x=500mm', 'rx-'); 
%              fprintf('UP @ 25 mm, x=500:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_up25, lm_star_up25, dlm_star_up25, dlm_rel_star_up25, dlm_rel_0_up25, improvement_up25);
%               [s_star_down25, lm_star_down25, dlm_rel_star_down25, dlm_star_down25, dlm_rel_0_down25, improvement_down25, dlm_dw_25mm_5] = findOptimalSingleSensorPosition_new( lm_int_down_25mm_x500,s_int, 'DOWN, 25mm, x=500mm', 'rx-'); 
%              fprintf('DOWN @ 25 mm, x=500:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_down25, lm_star_down25, dlm_star_down25, dlm_rel_star_down25, dlm_rel_0_down25, improvement_down25);
             [s_star_lp25, lm_star_lp25, dlm_rel_star_lp25, dlm_star_lp25, dlm_rel_0_lp25, improvement_lp25, dlm_lp_25mm_5,  p(3,:)] = findOptimalSingleSensorPosition_new( lm_int_lp_25mm_x500,s_int, 'LOOP, 25mm, x=500', 'cx-'); 
             fprintf('LOOP @ 25 mm, x=500:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_lp25, lm_star_lp25, dlm_star_lp25, dlm_rel_star_lp25, dlm_rel_0_lp25, improvement_lp25);
            legtext = {'y = 5 mm',...
           'y = 16 mm',...
           'y = 25 mm'};
            styles  = {'r-','g-','b-',};
            % combinePlots([h(1,1),h(2,1),h(3,1),h(1,3),h(2,3),h(3,3)],'lin','log',legtext,styles);  hold on; xlabel('s (m)'); ylabel('(m) or (-)'); hold off;
            combinePlots([p(1,3),p(2,3),p(3,3)],'lin','log',legtext,styles);  hold on; xlabel('s [mm]'); ylabel('$\Delta\ell_m/\bar{\ell}_m$'); hold on; 
            xl = xline(430, '.-k',{'Magnet pole'}); 
            xl.LabelVerticalAlignment = 'middle';
            xl.LabelHorizontalAlignment = 'center';hold off;
        else
             lm_int_up_5mm_x800 = interp1(s_actual, lm_up_5mm(:,(2*m+1):(3*m))', s_int);                                 lm_int_lp_5mm_x800 = interp1(s_actual, lm_lp_5mm(:,(2*m+1):(3*m))', s_int); 
             lm_int_down_5mm_x800 = interp1(s_actual, lm_down_5mm(:,(2*m+1):(3*m))', s_int);
             lm_int_up_16mm_x800 = interp1(s_actual, lm_up_16mm(:,(2*m+1):(3*m))', s_int);                              lm_int_lp_16mm_x800 = interp1(s_actual, lm_lp_16mm(:,(2*m+1):(3*m))', s_int);
             lm_int_down_16mm_x800 = interp1(s_actual, lm_down_16mm(:,(2*m+1):(3*m))', s_int);
             lm_int_up_25mm_x800 = interp1(s_actual, lm_up_25mm(:,(2*m+1):(3*m))', s_int);                              lm_int_lp_25mm_x800 = interp1(s_actual, lm_lp_25mm(:,(2*m+1):(3*m))', s_int);
             lm_int_down_25mm_x800 = interp1(s_actual, lm_down_25mm(:,(2*m+1):(3*m))', s_int);
%              [s_star_up, lm_star_up, dlm_rel_star_up, dlm_star_up, dlm_rel_0_up, improvement_up, dlm_up_5mm_8] = findOptimalSingleSensorPosition_new( lm_int_up_5mm_x800,s_int, 'UP, 5mm,  x=800mm', 'rx-'); 
%              fprintf('UP @ 5 mm; x=800:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_up, lm_star_up, dlm_star_up, dlm_rel_star_up, dlm_rel_0_up, improvement_up);
%               [s_star_down, lm_star_down, dlm_rel_star_down, dlm_star_down, dlm_rel_0_down, improvement_down, dlm_dw_5mm_8] = findOptimalSingleSensorPosition_new( lm_int_down_5mm_x800,s_int, 'DOWN, 5mm, x=800mm', 'rx-'); 
%              fprintf('DOWN @ 5 mm, x=800:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_down, lm_star_down, dlm_star_down, dlm_rel_star_down, dlm_rel_0_down, improvement_down);
               [s_star_lp, lm_star_lp, dlm_rel_star_lp, dlm_star_lp, dlm_rel_0_lp, improvement_lp, dlm_lp_5mm_8, q(1,:)] = findOptimalSingleSensorPosition_new( lm_int_lp_5mm_x800,s_int, 'LOOP, 5mm, x=800mm', 'rx--'); 
             fprintf('LOOP @ 5 mm; x=800:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_lp, lm_star_lp, dlm_star_lp, dlm_rel_star_lp, dlm_rel_0_lp, improvement_lp);
%               [s_star_up16, lm_star_up16, dlm_rel_star_up16, dlm_star_up16, dlm_rel_0_up16, improvement_up16, dlm_up_16mm_8] = findOptimalSingleSensorPosition_new( lm_int_up_16mm_x800,s_int, 'UP, 16mm, x=800mm', 'rx-'); 
%              fprintf('UP @ 16 mm, x=800:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_up16, lm_star_up16, dlm_star_up16, dlm_rel_star_up16, dlm_rel_0_up16, improvement_up16);
%               [s_star_down16, lm_star_down16, dlm_rel_star_down16, dlm_star_down16, dlm_rel_0_down16, improvement_down16, dlm_dw_16mm_8] = findOptimalSingleSensorPosition_new( lm_int_down_16mm_x800,s_int, 'DOWN, 16mm, x=800mm', 'rx-'); 
%              fprintf('DOWN @ 16 mm, x=800:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_down16, lm_star_down16, dlm_star_down16, dlm_rel_star_down16, dlm_rel_0_down16, improvement_down16);
             [s_star_lp16, lm_star_lp16, dlm_rel_star_lp16, dlm_star_lp16, dlm_rel_0_lp16, improvement_lp16, dlm_lp_16mm_8, q(2,:)] = findOptimalSingleSensorPosition_new( lm_int_lp_16mm_x800,s_int, 'LOOP, 16mm, x=800mm', 'gx--'); 
             fprintf('LOOP @ 16 mm, x=800:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_lp16, lm_star_lp16, dlm_star_lp16, dlm_rel_star_lp16, dlm_rel_0_lp16, improvement_lp16);
%              [s_star_up25, lm_star_up25, dlm_rel_star_up25, dlm_star_up25, dlm_rel_0_up25, improvement_up25, dlm_up_25mm_8] = findOptimalSingleSensorPosition_new( lm_int_up_25mm_x800,s_int, 'UP, 25mm, x=800mm', 'rx-'); 
%              fprintf('UP @ 25 mm, x=800:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_up25, lm_star_up25, dlm_star_up25, dlm_rel_star_up25, dlm_rel_0_up25, improvement_up25);
%               [s_star_down25, lm_star_down25, dlm_rel_star_down25, dlm_star_down25, dlm_rel_0_down25, improvement_down25, dlm_dw_25mm_8] = findOptimalSingleSensorPosition_new( lm_int_down_25mm_x800,s_int, 'DOWN, 25mm, x=800mm', 'rx-'); 
%              fprintf('DOWN @ 25 mm, x=800:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_down25, lm_star_down25, dlm_star_down25, dlm_rel_star_down25, dlm_rel_0_down25, improvement_down25);
              [s_star_lp25, lm_star_lp25, dlm_rel_star_lp25, dlm_star_lp25, dlm_rel_0_lp25, improvement_lp25, dlm_lp_25mm_8, q(3,:)] = findOptimalSingleSensorPosition_new( lm_int_lp_25mm_x800,s_int, 'LOOP, 25mm, x=800mm', 'bx--'); 
             fprintf('LOOP @ 25 mm, x=800:   s* = %f,\t Lm*=%f,\t DeltaLm*=%f,\t  DeltaLm_rel*=%f,\t DeltaLm_rel0=%f,\t improvement =%f \n',s_star_lp25, lm_star_lp25, dlm_star_lp25, dlm_rel_star_lp25, dlm_rel_0_lp25, improvement_lp25);
%             legtext = {'y = 5 mm',...
%            'y = 16 mm',...
%            'y = 25 mm'};
%             styles  = {'r-','g-','b-',};
%             % combinePlots([h(1,1),h(2,1),h(3,1),h(1,3),h(2,3),h(3,3)],'lin','log',legtext,styles);  hold on; xlabel('s (m)'); ylabel('(m) or (-)'); hold off;
%             combinePlots([q(1,3),q(2,3),q(3,3)],'lin','log',legtext,styles);  hold on; xlabel('s (m)'); ylabel('(m) or (-)'); title('x=80mm'); hold off;
            legtext = {'x = 0 mm',...
           'x = 50 mm',...
           'x = 80 mm'};
            styles  = {'r-','g-','b-',};
            combinePlots([h(1,3),p(1,3),q(1,3)],'lin','log',legtext,styles);  hold on; xlabel('s [mm]'); ylabel('$\Delta\ell_m/\bar{\ell}_m$'); hold on; 
            xl = xline(430, '.-k',{'Magnet pole'}); 
            xl.LabelVerticalAlignment = 'middle';
            xl.LabelHorizontalAlignment = 'center';hold off;
        end;

        
        
end;
%% 3D
% Z = [dlm_lp_5mm_0 dlm_lp_5mm_5  dlm_lp_5mm_8]';
% Y = [s_int s_int s_int]';
% X = [ones(1, length(s_int))*0 ones(1, length(s_int))*500 ones(1, length(s_int))*800]';
% o = 50;
% figure;
% F.Method = 'linear';
%  F.ExtrapolationMethod = 'nearest';
% F = scatteredInterpolant(X,Y,Z);
% tj =  0:0.2:470;
% ti = 0:50:800;
% [qx,qy] = meshgrid(ti,tj);
% qz = F(qx,qy);
% % qz = griddata(X,Y,Z,qx,qy,'cubic');
% mesh(qx,qy,qz);
% hold on;
%  plot3(X(1:o:end),Y(1:o:end),Z(1:o:end),'k*'); hold on;
% %plot3([X,X]',[Y,Y]', [-err0, err0]'+Z' ,'.-r');
% xlabel('x [mm]'); ylabel('s [mm]');  zlabel('\Delta l_m/\bar{l}_m (-)')
% grid on; title('Loop \Delta l_m')
% % set(gca,'zscale','log')