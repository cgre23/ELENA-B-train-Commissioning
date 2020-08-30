% TOD update so points do not have noly one coordinate
% size(bdl) = [I,1]; size(blocal) = [I,s]
function [s_star, lm_star, dlm_rel_star, dlm_star, dlm_rel_0, improvement, dlm_rel,h] = findOptimalSingleSensorPosition_new(lm,s, tag, col)
% 
%     if length(I) ~= size(bdl   ,1), error(   'bdl must have as many rows as current values'); end
%     if length(I) ~= size(blocal,1), error('blocal must have as many rows as current values'); end
%     if length(s) ~= size(blocal,2), error('blocal must have as many columns as position values'); end
% 
%     % get rid of possible NaNs
%     nanlines = find(isnan(bdl)); if ~isempty(nanlines), bdl(nanlines)=[]; blocal(nanlines,:)=[]; I(nanlines)=[]; end
%     if ~isempty(find(isnan(blocal))), error('NaN still found in blocal'); end
%     
%     % optionally refine linearly the field measurement - the rest follows
%     if nargin > 4
%         if ~isempty(s_refined)
%             blocal_refined = nan(length(I),length(s_refined));
%             for i=1:length(I)
%                 SPR = Sprint(s,blocal(i,:)); 
%                 blocal_refined(i,:) = SPR.Interpolate(s_refined);
%             end
% 
%                  s = s_refined;   
%             blocal = blocal_refined;
%         end
%     end
lm = lm';
    
%     lm      = bdl./blocal; %[I,s]
    lm_avg  = mean(lm,1);
    lm_rel  = lm./lm_avg;

%     ITF     = bdl./I;
    
    [dlm_rel_star,  jmin, dlm] = spanmin(lm_rel,1);      
    
    dlm_rel   = dlm./lm_avg;
    s_star    = s(jmin);
    lm_star   = lm_avg(jmin);
     dlm_star  = spanmin(lm(:,jmin),1);
%     dlm_star = 0;
    i0          = find(s==0); if isempty(i0), warning('central position s=0 not found - using s(1) instead'); i0=1; end
    dlm_rel_0   = dlm_rel(i0);
    improvement = dlm_rel_0/dlm_rel_star;
    
        h(1) = logyplot([],makecolumn(s), lm_avg',' Average Magnetic Length','s [m]','$\bar{\ell}_m$ (m)');  
        h(2) = logyplot([],makecolumn(s), dlm'  ,[tag,         ' Delta Magnetic Length'],'s [m]','\Delta l_m (m)');  grid on;
        h(3) = logyplot([],makecolumn(s),dlm_rel',[ tag, ' Relative Delta Magnetic Length'],'s [m]','\Delta l_m/\bar{l}_m (-)');  grid on;
%        figure;
%        h(2) = plot(s, dlm', 'bx-'); title([tag,         ' Delta Magnetic Length']); xlabel('s [m]'); ylabel('\Delta l_m (m)');  grid on;
%        figure;
%        h(1) = semilogy(s,dlm_rel', col); title([ tag, ' Relative Delta Magnetic Length']); xlabel('s [m]'); ylabel('\Delta l_m/\bar{l}_m (-)');  grid on; hold on;
%     
    % additional diagnostics
    % xyplot([],ITF,lm);
    
end