%----------------------------------------------------------------------------------------------------
% one-liner call for a simple logarithmic plot, one curve, no markers
% optionally, one or both axes can be on a logarithmic scale
%----------------------------------------------------------------------------------------------------
function fighan = logyplot(h,x,y,graph_title,x_label,y_label,legend_labels)

    if nargin<4,    graph_title   = [];     end
    if nargin<5,    x_label       = [];     end
    if nargin<6,    y_label       = [];     end
    if nargin<7,    legend_labels = {};     end
    if nargin< 8 || isempty(styles)       , styles        = 'stylespec(cycle,-,)';   end

    fighan = multimodeScatterPlot(h,x,y,graph_title,x_label,y_label,'lin','log',legend_labels);

end

