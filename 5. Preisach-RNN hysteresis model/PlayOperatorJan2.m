function [K_1] = PlayOperatorJan2(x,j, n_p, max_x)
%   Detailed explanation goes here
K_1(1) = x(1); 
r_1 = (max_x*(j-1))/n_p;

for i = 2:length(x)
%         K_1(i) = max(x(i)-r_1, min(x(i)+r_1, K_1(i-1))); 
     if x(i) > x(i-1)
             K_1(i) = max(x(i)-r_1, K_1(i-1));  
     elseif x(i)  == x(i-1)
              K_1(i) = K_1(i-1);  
     elseif  x(i)  < x(i-1)
             K_1(i) = min(x(i)+r_1, K_1(i-1));  
     end;
end;


