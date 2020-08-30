function yes = isrealvector(x)
    yes = isreal(x) && isvector(x) && ~isRandomVariable(x); % exclude RandomVariables
end