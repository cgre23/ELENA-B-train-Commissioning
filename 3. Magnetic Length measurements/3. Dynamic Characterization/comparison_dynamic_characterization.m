%% Magnetic length - Dynamic Characterization
% Author: Christian Grech (TE-MSC-MM)
% Date: 29/09/2016
% Version: 1.0
% close all;
clear all;
count = 0;
for w=1
        p=0; q=0;
        for k =1:24
            clear flux1
            filename1 = sprintf('Cal_2_%d.mat', k);
            load(filename1);
            n = 1;
            % Separate data
             time1 = var(1:n:end, 1);
            Vc1nf = -var(1:n:end,3);
            NMR_high_1 = var(1:n:end, 4);
            NMR_high_2 = var(1:n:end, 5);
            FMR_low_1 = var(1:n:end, 6);
            FMR_low_2 = var(1:n:end, 7);
            FMR_high_1 = var(1:n:end, 8);
            FMR_high_2 = var(1:n:end, 9);
            current_1 = var(1:n:end, 2)*100;
                    
            count = count+1;
            f = round(1/(time1(2)-time1(1)));
            %% Data filtering
             windowWidth = 400;
             windowWidth2 = 4;
            windowWidth3 = 4;
            kernel = ones(windowWidth,1) / windowWidth;
            kernel2 = ones(windowWidth2,1) / windowWidth2;
            kernel3 = ones(windowWidth3,1) / windowWidth3;
             curr = filtfilt(kernel, 1, current_1);
            Vc1= filtfilt(kernel3, 1, Vc1nf);
            
            if k < 4
            elseif k >= 4 && k <7      
            elseif k >= 7 && k <10  
                       NMR_high_1(2:2.6e4) = NMR_high_1(1) ;
                       NMR_high_2(2:2.6e4) = NMR_high_2(1) ;
                       NMR_high_1(3.4e5:3.6e5) = NMR_high_1(1) ;
                       NMR_high_2(3.4e5:3.6e5) = NMR_high_2(1) ;
            elseif k >= 10 && k <13
            elseif k >= 13 && k <16
                       NMR_high_1(1:19e3) = NMR_high_1(1) ;
                       NMR_high_2(1:19e3) = NMR_high_2(1) ;
                       NMR_high_1(2.35e5:2.55e5) = NMR_high_1(1) ;
                       NMR_high_2(2.35e5:2.55e5) = NMR_high_2(1) ;
            elseif k >= 16 && k <19
                       NMR_high_1(1:19e3) = NMR_high_1(1) ;
                       NMR_high_2(1:19e3) = NMR_high_2(1) ;
                       NMR_high_1(2e5:2.2e5) = NMR_high_1(1) ;
                       NMR_high_2(2e5:2.2e5) = NMR_high_2(1) ;
            elseif k >= 19 && k <22
                       NMR_high_1(1:29e3) = NMR_high_1(1) ;
                       NMR_high_2(1:29e3) = NMR_high_2(1) ;
                       NMR_high_1(1.75e5:1.95e5) = NMR_high_1(1) ;
                       NMR_high_2(1.75e5:1.95e5) = NMR_high_2(1) ;                
            elseif k >= 22 && k <25
                       NMR_high_1(1:29e3) = NMR_high_1(1) ;
                       NMR_high_2(1:29e3) = NMR_high_2(1) ;
                       NMR_high_1(1.58e5:1.7e5) = NMR_high_1(1) ;
                       NMR_high_2(1.58e5:1.7e5) = NMR_high_2(1) ;    
            elseif k >= 25 && k <28
                       NMR_high_1(1:29e3) = NMR_high_1(1) ;
                       NMR_high_2(1:29e3) = NMR_high_2(1) ;
                       NMR_high_1(1.2e5:1.3e5) = NMR_high_1(1) ;
                       NMR_high_2(1.2e5:1.3e5) = NMR_high_2(1) ;             
            end;  
            
            %% Drift correction mechnism
                for i = 1: length(Vc1(1,:))
                    flux1(:,i) = cumtrapz(time1(:,i), Vc1(:,i));
                end

            %        figure; plot(flux1);
           drift_index = (length(flux1)-25e3):length(flux1);
           pol = polyfit(time1(drift_index), flux1(drift_index),1);
           V01 = pol(1);

            l = 0.9714;
            wc = 2.8579;
              r1= 1:(length(flux1));

            %% Calculating BdL
                Flux0 = 0.0019126;
                Phi1 = Flux0+cumtrapz(time1, Vc1-V01);
                BdL_sep = Phi1/(wc);
                off2 = 0;
                BdL_sep1 = BdL_sep+off2;

        [v_low in_NMR_high_up_1(k)] = min(NMR_high_1);
        [v_high in_NMR_high_up_2(k)] = min(NMR_high_2);
        [v_low in_FMR_low_up_1(k)] = min(FMR_low_1(r1));
        [v_high in_FMR_low_up_2(k)] = min(FMR_low_2(r1));
        [v_low in_FMR_high_up_1(k)] = min(FMR_high_1(r1));
        [v_high in_FMR_high_up_2(k)] = min(FMR_high_2(r1));
        
                  Bdot(k) = (BdL_sep1(in_NMR_high_up_2(k))-BdL_sep1((in_NMR_high_up_2(k)-(f/10))))*10;
    
        BdL_optimal_NMR_high(k) = BdL_sep1(in_NMR_high_up_1(k))/340e-3;
        BdL_central_NMR_high(k) = BdL_sep1(in_NMR_high_up_2(k))/340e-3;
        BdL_central_FMR_high(k) = BdL_sep1(in_FMR_high_up_1(k))/190.1e-3;
        BdL_optimal_FMR_high(k) = BdL_sep1(in_FMR_high_up_2(k))/208.6e-3;
        BdL_central_FMR_low(k) = BdL_sep1(in_FMR_low_up_1(k))/38.216e-3;
        BdL_optimal_FMR_low(k) = BdL_sep1(in_FMR_low_up_2(k))/41.548e-3;
        
                    if rem(k,3) == 0
             p=p+1;
            psigma_central(p) = mean(BdL_central_NMR_high(k-2:k));
            psigma_optimal(p) = mean(BdL_optimal_NMR_high(k-2:k));
            psigmaFMRh_central(p) = mean(BdL_central_FMR_high(k-2:k));
            psigmaFMRh_optimal(p) = mean(BdL_optimal_FMR_high(k-2:k));
            psigmaFMRl_central(p) = mean(BdL_central_FMR_low(k-2:k));
            psigmaFMRl_optimal(p) = mean(BdL_optimal_FMR_low(k-2:k));
             prange_t(p) = mean(Bdot(k-2:k));
            end;
        
            if rem(k,3) == 0
                q=q+1;
                range_t(q) = std(prange_t(1:q),1);
                sigma_central(q) = range(psigma_central(1:q));
                sigma_optimal(q) = range(psigma_optimal(1:q));
                sigmaFMRh_central(q) = range(psigmaFMRh_central(1:q));
                sigmaFMRh_optimal(q) = range(psigmaFMRh_optimal(1:q));
                sigmaFMRl_central(q) = range(psigmaFMRl_central(1:q));
                sigmaFMRl_optimal(q) = range(psigmaFMRl_optimal(1:q));
                imp(q) = sigma_central(q)./sigma_optimal(q);
                imp1(q) = sigmaFMRh_central(q)./sigmaFMRh_optimal(q);
                imp2(q) = sigmaFMRl_central(q)./sigmaFMRl_optimal(q);
            end;

       end;
       
end;
%%
figure;plot(range_t, imp2, 'rx-', 'LineWidth',1.5); hold on;
plot(range_t, imp1, 'gx-',  'LineWidth',1.5); hold on;
plot(range_t, imp, 'bx-', 'LineWidth',1.5); hold on;
yline(1,'-.k'); xline(0.087,'-.k'); xline(0.09,'-.k'); xline(0.2063,'-.k');
ylabel('\Gamma');
xlabel('$\upsilon $ [Tm/s]','interpreter','latex')
legend('45 mT', '200 mT', '340 mT')
