% error reporting modes, used e.g. by err()
classdef MODE
    
    properties (Constant)

        SILENT   =   0;     % do nothing and go on
        NORMAL   =   1;     % report a little and go on
        VERBOSE  =   2;     % report all and go on
        FATAL    =   3;     % report all and stop
    
    end
        
end

