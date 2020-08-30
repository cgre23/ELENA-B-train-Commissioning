% the first ncomb are unique in color and B/W (used in multiplots)
% cycling_mode:     'linecolor' (default)       cycle line colors, using the supplied style and marker
%                   'marker'                    cycle marker type and color, using the supplied style
%                   'all'                       cycle through all possible combinations
%                   'B/W'                       cycle through maximum-contrast combinations, optimized for B/W plots
function linespec = stylespec(color,style,marker,mode)

    colors ={'r' 'g' 'b' 'c' 'm' 'y' 'k'};                         ncolors =length(colors );
    styles ={'-' '--' ':' '-.'};                                   nstyles =length(styles );
    markers={'o' '+' '*' '.' 'x' 's' 'd' '^' 'v' '>' '<' 'p' 'h'}; nmarkers=length(markers);

    persistent  index;  % 1x3 array of indices in style, marker and color array

    if nargin<1 || isempty(color),  color   = 'r';          end
    if nargin<2,                    style   = '-';          end  % style and marker have a meaning when empty
    if nargin<3,                    marker  = '';           end
    if nargin<4,                    mode    = 'continue';   end  % in this case, every call gives a new style

    if isempty(findstrindex(color ,colors ))                     && ~strcmp(color ,'cycle'), error('nLight::stylespec() - undefined color = "%s"' ,color ); end    % this cannot be empty
    if isempty(findstrindex(style ,styles )) && ~isempty(style ) && ~strcmp(style ,'cycle'), error('nLight::stylespec() - undefined style = "%s"' ,style ); end    % these two can 
    if isempty(findstrindex(marker,markers)) && ~isempty(marker) && ~strcmp(marker,'cycle'), error('nLight::stylespec() - undefined marker = "%s"',marker); end

    
    if strcmpi(mode,'restart') || isempty(index),   % initializes all indices ...
        index=[1 1 1]; 
    else                                            % increment all requested indices ...
        if strcmp(color ,'cycle'),   index(1)=modulo(index(1)+1,ncolors );  end
        if strcmp(style ,'cycle'),   index(2)=modulo(index(2)+1,nstyles ); 	end
        if strcmp(marker,'cycle'),   index(3)=modulo(index(3)+1,nmarkers); 	end

        % filter out low-contrast combinations
        if strcmp(mode,'B/W'),  dummy=1; end % TODO
    end

    % ... BUT: use the index only if a specific values is not provided
    if strcmp(color ,'cycle'),  color  = colors {index(1)}; end % else, leave the value supplied as argument
    if strcmp(style ,'cycle'),  style  = styles {index(2)}; end
    if strcmp(marker,'cycle'),  marker = markers{index(3)}; end

    % build the spec string by taking 
    linespec=[style, marker, color];

end

