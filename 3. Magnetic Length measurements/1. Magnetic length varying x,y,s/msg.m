% writes a message to the default log (matlab commad window)
% TODO: add log file
function str = msg(msgtxt,var1,var2,var3,var4,var5,var6,var7,var8,var9,var10)

   switch nargin
        case  1,    str=sprintf(msgtxt);
        case  2,    str=sprintf(msgtxt,var1);
        case  3,    str=sprintf(msgtxt,var1,var2);
        case  4,    str=sprintf(msgtxt,var1,var2,var3);
        case  5,    str=sprintf(msgtxt,var1,var2,var3,var4);
        case  6,    str=sprintf(msgtxt,var1,var2,var3,var4,var5);
        case  7,    str=sprintf(msgtxt,var1,var2,var3,var4,var5,var6);
        case  8,    str=sprintf(msgtxt,var1,var2,var3,var4,var5,var6,var7);
        case  9,    str=sprintf(msgtxt,var1,var2,var3,var4,var5,var6,var7,var8);
        case 10,    str=sprintf(msgtxt,var1,var2,var3,var4,var5,var6,var7,var8,var9);
        case 11,    str=sprintf(msgtxt,var1,var2,var3,var4,var5,var6,var7,var8,var9,var10);
        otherwise,  error('msg: too many arguments (no more than 10 output fields)');  
    end % switch
    
    fprintf('--> %s\n',str);
end

