% index = findstrindex(target,strarray,mode,tag)
% find the index (or indices) of string 'target' in the given array, or [] if not found
% mode: 'whole' (default)
%       'substr'
% optionally, filter filename by by given tag
% returns empty array on fail
function index = findstrindex(target,strarray,mode,tag)
 
 % assign defaults   
 if nargin<3 mode='whole'; end 
 if nargin<4 tag=''; end
 
 if ischar(strarray), strarray = {strarray}; end   % remain compatible with just one string

 index=[]; % index of the strarray element that matches target
 for i=1:length(strarray)
     
    pos   =strfind(strarray{i},target);
    tagfound=true; 
    if~isempty(tag)>0
       tagpos=strfind(strarray{i},tag); 
       if isempty(tagpos), tagfound=false; end
    end % if 

 
    if ~isempty(pos) % a match has been found
        switch mode
            case 'whole',       if length(target)==length(strarray{i}) && tagfound
                                    index=[index i]; % the whole string element matches target
                                end % if
            case 'substr',      if tagfound,    
                                    index=[index i]; % any substr position counts as a find, in this case
                                end % if
            otherwise,          error('findstrindex: unrecognized mode "%s" (whole or substr expected)',mode);
        end % switch mode
    end % if

 end % for i
 
end % function 

% TODO something like this: checkString = @(s) any(strcmp(s,{'square','rectangle'}));