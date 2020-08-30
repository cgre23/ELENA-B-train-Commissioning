% wrapper for regexp(~,~,'match') able to thread along cell array of strings
% returns a cell array of strings, unless a specific index is demanded
function [match, index] = RX(string,pattern)

    if ~ischar(pattern), error('nLight::RX(): invalid pattern argument (char expected)'); end;
    
    % separate neatly the two use cases, lest confusion ensues
    if ischar(string)
        
    	match = regexp(string,pattern,'match');
        if ~isempty(match)
            index = 1; % not very useful, but let's be consistent
        end

    elseif iscellstr(string)
            
        match   =  cell(size(string));
        i_match = zeros(size(string));
        for i=1:numel(string)  
        
            m = regexp(string{i},pattern,'match');
            if ~isempty(match{i})
                i_match(i) = 1; % save the index
            end    
        
            switch length(m)
                case 0,         match{i} = NaN; % not to crach subsequent cell2mat calls
                case 1,         match{i} = m{1}; 
                otherwise       warning('additional matches of %s in %s were found but will be ignored',pattern,string{i});
            end

        end % for i
        index = find(i_match~=0);
        
    else
        error('nLight::RX(): invalid string argument (char or cell array of char expected)');
    end    


end % function block()


