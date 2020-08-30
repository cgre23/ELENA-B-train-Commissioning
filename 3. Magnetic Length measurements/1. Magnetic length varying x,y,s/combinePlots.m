% h = combinePlots(fighandles,xmode,ymode,legtext,styles)
function h = combinePlots(fighandles,xmode,ymode,legtext,styles)

    if nargin < 2, xmode='lin'; end
    if nargin < 3, ymode='lin'; end
    if nargin < 4, legtext={}; end
    if nargin < 5, styles={}; end

    h = figure; hold on;

    l = 1;
    for fig=1:length(fighandles)
        
        linehandle = findobj(fighandles(fig),'Type','line'); % also: lines are Children of Axes objects
        
        for fl=1:length(linehandle)
            if isempty(styles)  % ugly, but I'm in a hurry
                plot(linehandle(fl).XData,linehandle(fl).YData);
            else
                plot(linehandle(fl).XData,linehandle(fl).YData,styles{l});
            end
            l = l + 1;
        end
        
        source_axes = findobj(fighandles(fig),'Type','Axes');
           new_axes = gca();                    new_axes.XAxis.Label.Interpreter = 'latex';
                                                new_axes.YAxis.Label.Interpreter = 'latex';
        if ~isempty(source_axes.XLabel.String), new_axes.XLabel.String = source_axes.XLabel.String; end 
        if ~isempty(source_axes.YLabel.String), new_axes.YLabel.String = source_axes.YLabel.String; end
        
    end

    if strcmpi(xmode(1:3),'log'), set(gca,'Xscale','log'); end
    if strcmpi(ymode(1:3),'log'), set(gca,'Yscale','log'); end

    if ~isempty(legtext), legend(legtext,'interpreter','latex'); end
    grid on;

    hold off;

end

% define handle arrays with: h = gobjects(length(files),3);
% example:
% legtext = {'<Lm> DC (m)','<Lm> 115 A/s (m)','<Lm> 200 A/s (m)','\Delta Lm/<Lm> DC (m)','\Delta Lm/<Lm> 115 A/s (m)','\Delta Lm/<Lm> 200 A/s (m)'};
% styles  = {'r:','g:','b:','r-','g-','b-',};
% combinePlots([h(1,1),h(2,1),h(3,1),h(1,3),h(2,3),h(3,3)],'lin','log',legtext,styles);  hold on; xlabel('s (m)'); ylabel('(m) or (-)'); hold off;
