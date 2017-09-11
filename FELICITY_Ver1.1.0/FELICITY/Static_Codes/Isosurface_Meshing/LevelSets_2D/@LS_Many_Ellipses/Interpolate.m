function [Val, Grad] = Interpolate(obj,X)
%Interpolate
%
%    This is the interpolation routine.

% Copyright (c) 04-04-2012,  Shawn W. Walker

P = obj.Param;

Val = 0*X(:,1);
if (P.sign(1) > 0)
    Val(:) = -Inf;
elseif (P.sign(1) < 0)
    Val(:) = Inf;
else
    error('Invalid sign value.  Must be +/- 1.');
end

for ind = 1:length(P.sign)
    
    a   = P.rad_x(ind);
    b   = P.rad_y(ind);
    cx  = P.cx(ind);
    cy  = P.cy(ind);
    sn  = P.sign(ind);
    
    NORM = sqrt((  (X(:,1) - cx)/a  ).^2 + (  (X(:,2) - cy)/b  ).^2);
    
    Val_temp = sn*(1 - NORM);
    
    if (ind==1)
        Val = Val_temp;
    else
        if (sn==1)
            Val = max(Val,Val_temp);
        elseif (sn==-1)
            Val = min(Val,Val_temp);
        else
            error('Invalid sign value.  Must be +/- 1.');
        end
    end
    
end

Grad = []; % not used

end