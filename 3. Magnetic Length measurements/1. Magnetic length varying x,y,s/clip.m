% clip(x,bound) - limit x between the given bounds (works also on multidimensional arrays)
function x_clipped = clip(x,bound)

    if isscalar(bound), 
                        xmax=abs(bound); xmin=-xmax; 
    else
                        xmax=bound(2);   xmin=bound(1);
    end

    x_clipped=x;
    x_clipped(find(x<xmin))=NaN; % xmin;
    x_clipped(find(x>xmax))=NaN; % xmax;

end

