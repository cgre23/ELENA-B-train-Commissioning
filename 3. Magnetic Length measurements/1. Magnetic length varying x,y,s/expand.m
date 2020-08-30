% expand all numbers in the array by the given factor, respect to the center
function xx = expand(x,factor)

    if ~isvector(x) && ~isnumeric(x), error('nLight::expand() - argument x must be a numeric vector'); end

    x0=mean(x);
    
    xx=zeros(size(x));
    for i=1:length(x)
        xx(i)=x0 + factor*(x(i)-x0);
    end    
    
end
% TODO optimize, generalize to arbitrary dimensions

