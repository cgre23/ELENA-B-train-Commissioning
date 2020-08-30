% find the arguments in a string having the form label(arg1,arg2,....,argn)
% complex numeric arguments must have the format 1+3i
function arguments = parseFuncArgs(str,label,mode)

    if nargin < 2, label     ='';         end
    if nargin < 3, mode      ='numeric';  end
    if nargin < 4, delimiter = ',';       end

    % first, isolate the text between brackets,accortding to the selected mode
    switch mode
        case       'numeric',   accepted_chars=',.+-0-9Ee';
        otherwise,              accepted_chars='^)';
    end
    expression=['(?<=' label '\s*\(\s*)[' accepted_chars ']*(?=\s*\))'];
    
    [start, stop] = regexp(str,expression);
    if isempty(start), 
        arguments={};  
        warning('nLight::parseFuncArgs() - no arguments found in "%s"',str);
        return;
    end 

    arguments = parseString(str(start:stop),mode,delimiter);

end

