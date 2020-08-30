% generalized linear/logarithmic plotting of multiple scatter lines
% for readability, should be called by specialized wrappers xyplot, logplot ....
% NB: NaN in x and y are ignored, this can be used to plot traces of unequal lengths

% TODO add error bars
% linespec = stylespec(color,style,marker,mode)
function fighan = multimodeScatterPlot(h,x,y,graph_title,x_label,y_label,xmode,ymode,legend_labels,styles)

    
    
    if nargin< 4 || isempty(graph_title)  , graph_title   = '<untitled>';                end
    if nargin< 5 || isempty(x_label)      , x_label       = 'x';                         end
    if nargin< 6 || isempty(y_label)      , y_label       = 'y';                         end
    if nargin< 7                          , xmode         = 'lin';                       end
    if nargin< 8                          , ymode         = 'lin';                       end
    if nargin< 9 || isempty(legend_labels), legend_labels = {};                          end
    if nargin<10 || isempty(styles)       , styles        = 'stylespec(cycle,-,)';   end

    % ---------- in this case, vectors of unequal length can be padded with plot-transparent NaNs and packed in matrices ------

    if iscell(x) && iscell(y),  
        x = flush2mat(x,NaN);
        y = flush2mat(y,NaN);
    end

    % ---------------- check and adjust the size of the data vectors -----------------------------------------
    
    if isempty(y) || ndims(y)>2, error('nLight::multimodeScatterPlot() - y must be a non-empty vector or 2D matrix'); end

    [nx, mx]=size(x);
    [ny, my]=size(y);

    if isempty(x) % create a default x with integer indices so that size(x)=size(y)
        
        if        isrow(y),     x=[1:my]';  y=y'; % force data to be in columns 
        elseif iscolumn(y),     x=[1:ny]';  
        else   x=repmat([1:ny]',[1, my]);              % in this case, we have a 2D matrix
        end
    % NB; otherwise, no info is created for x: just repeat the given vector to fill all columns
    else
        
        if nx~=ny, error('nLight::xyplot() - inconsistent number of rows in x (=%d) and y (=%d)',nx,ny); end
        
        if mx==1,  % in this case, copy the columns over
            x=repmat(x,[1, my]);
        elseif mx~=my
            error('nLight::xyplot() - x must have either 1 or the same number of columns as y =%d',my);
        end

    end 

   [n m]=size(y); % x and y have now the same size

    % ---------------- define the arguments that specify data and style for all the plot traces -----------------------------------------------------------

    % NB: series are in columns !!
    plotargs=cell(3*m,1);
    for i=1:m % trace index
                                    plotargs{1+3*(i-1)}=x(:,i);  % this works even if x is a vector
                                    plotargs{2+3*(i-1)}=y(:,i);

        % -------- check style specification (may depend on index i!) ---------
        if     ischar   (styles),   
                                if ~isempty(strfind(styles,'stylespec'))  % use automatic style cycling facility
                                	ss=parseFuncArgs(styles,'stylespec','string');
                                    if length(ss) ~=3,  error('nLight::multimodeScatterPlot() - 3 arguments expected in the style specification string "%s"',styles); end 
                                    if i==1, mode='restart'; else mode='continue'; end
                                    plotargs{3+3*(i-1)}=stylespec(ss{:},mode);
                                else
                                    plotargs{3+3*(i-1)}=styles; % standard matlab style specification expected here, use as is
                                end
        elseif iscellstr(styles),   plotargs{3+3*(i-1)}=styles{modulo(i,m)};
        else                        error('nLight::multimodeScatterPlot() - Invalid styles parameter');
        end

    end % for i (row in the input matrices)

    % -> TODO check negative data ranges for log plots
    
    %----------------------- get an existing or a new figure---------------------------------------
    fighan = newFigureHandle(h);
    hold on;
    %----------------------- plot proper ---------------------------------------

    switch xmode

        case        'lin',  switch ymode    
                                case 'lin',         plot(plotargs{:}); % this syntax creates a comma-separated list
                                case 'log',     semilogy(plotargs{:});
                                otherwise,  error('nLight::multimodeScatterPlot() - unknown y axis mode');     
                            end

        case        'log',  switch ymode    
                                case 'lin',     semilogx(plotargs{:}); % this syntax creates a comma-separated list
                                case 'log',       loglog(plotargs{:});
                                otherwise,  error('nLight::multimodeScatterPlot() - unknown y axis mode');         
                            end

        otherwise,  error('nLight::multimodeScatterPlotx() - unknown x axis mode'); 

    end % switch xmode

    %----------------------- labels & decorations -----------------------------------------------

    title(graph_title);
    xlabel(x_label);
    ylabel(y_label);

    % zoom slightly in, in order to correctly show markers at the plot's boundaries
    bounds=axis();

    xbounds = expand(bounds(1:2),1.1);  if strcmpi(xmode,'log'), if xbounds(1)<=0, xbounds(1)=bounds(1); end; end % simply revert expand()
    ybounds = expand(bounds(3:4),1.1);  if strcmpi(ymode,'log'), if ybounds(1)<=0, ybounds(1)=bounds(3); end; end
    axis([ xbounds, ybounds  ]);


    if ~isempty(legend_labels),
        if ischar(legend_labels), legend_labels={legend_labels}; end
        if ~iscellstr(legend_labels)
            error('nLight::multimodeScatterPlotx() - argument "legend_labels" must be either empty or a cell array of strings');
        end
        legend(legend_labels{:}); % TODO gives warning, believes there are 2 more legend entries
    end    

    %-----------------------------------------------------------------------------------------------
    hold off;

end

% fig = figure;
%  errorbar(x,y,l,u);
%  ax = get(fig,'CurrentAxes');
%  set(ax,'XScale','log','YScale','log') 
