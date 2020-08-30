% like mod(), but the result can be used as an index into an array
% ok for i array inputs    
function m=modulo(i,n)
    m=mod(i-1,n)+1;
end

