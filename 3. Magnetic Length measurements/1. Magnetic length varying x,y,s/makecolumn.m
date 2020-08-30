% enforce column vector (this works also with object arrays)
function y = makecolumn(x)

 if isempty(x), y=[]; return; end   
 [rows cols]=size(x);
 
 if         rows==1 y=x'; 
 elseif     cols==1 y=x;
 else
        error('makecolumn: input is not a  vector');
 end
  

end

