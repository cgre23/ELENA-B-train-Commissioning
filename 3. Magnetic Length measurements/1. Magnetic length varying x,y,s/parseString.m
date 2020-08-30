function arguments = parseString(str,mode,delimiter)

    if nargin < 2, mode      = 'numeric';   end
    if nargin < 3, delimiter = ',';         end
   
    n=length(str);

    limits=strfind(str,delimiter);
    narg=length(limits)+1;

    switch mode
        case    'numeric',  arguments=zeros([narg, 1]);
        otherwise,          arguments=cell ([narg, 1]);
    end

    for i=1:narg

        if i==1,     start=1; else start=limits(i-1)+1; end 
        if i==narg,  stop =n; else stop =limits(i  )-1; end 

        if start<=stop, substr=str(start:stop);
        else            substr='';
        end

        switch mode
            case    'numeric',  if isempty(substr),   arguments(i)=0;
                                else                  arguments(i)=str2double(substr);
                                end
            otherwise,                                field = strtrim(substr);
                                                      val   = str2num(field); 
                                                      if isempty(val) || isdate(field),
                                                            arguments{i}=field;
                                                      else  
                                                            arguments{i}=val;  % enforce double type for numeric values
                                                      end
        end

    end % for i


end

