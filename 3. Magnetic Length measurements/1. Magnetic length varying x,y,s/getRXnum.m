% get number(s) by regular expression
% thread over cell array
% ex: getRXnum(filename,'(?<=_freq_)[\+\-0-9.]+(?=Hz_)')
function val= getRXnum(str,rxpattern,default,warn_if_multimatch)

    if nargin < 2, val=0; return; end
    if nargin < 3, default=[]; end
    if nargin < 4, warn_if_multimatch = false; end
    
    match = RX(str,rxpattern);

    if length(match)>1 && warn_if_multimatch,
        msg('nLight::getRXnum() - %d matches found for pattern "%s"',length(match),rxpattern);
    end % ignore any subsequent matches
    
    if ~isempty(match), val = cell2num(match);   
    else
        if isempty(default)
            error('nLight::getRXnum(): no match found and no default defined');
        else
            val = default*eye(size(match));
        end    
        
    end

end

