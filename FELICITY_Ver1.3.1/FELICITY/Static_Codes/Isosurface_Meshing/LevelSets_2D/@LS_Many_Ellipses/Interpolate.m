function [Val, Grad] = Interpolate(obj,X)
%Interpolate
%
%    This is the interpolation routine.

% Copyright (c) 04-04-2012,  Shawn W. Walker

P = obj.Param;

Val = 0*X(:,1); % init
Grad = 0*X; % init
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
    rad = [a, b];
    cx  = P.cx(ind);
    cy  = P.cy(ind);
    cen = [cx, cy];
    sn  = P.sign(ind);
    
    NORM = sqrt((  (X(:,1) - cx)/a  ).^2 + (  (X(:,2) - cy)/b  ).^2);
    Val_temp = sn*(1 - NORM);
    
    Grad_temp = 0*X;
    for jj=1:2
        Grad_temp(:,jj) = -sn * ( (X(:,jj) - cen(jj))/rad(jj)^2 ) ./ NORM;
    end
    
    if (ind==1)
        Val = Val_temp;
        Grad = Grad_temp;
    else
        if (sn==1)
            %Val = max(Val,Val_temp);
            [Val, Ind] = max([Val, Val_temp],[],2);
            Use_Grad = (Ind==1);
            Grad(~Use_Grad,:) = Grad_temp(~Use_Grad,:);
        elseif (sn==-1)
            %Val = min(Val,Val_temp);
            [Val, Ind] = min([Val, Val_temp],[],2);
            Use_Grad = (Ind==1);
            Grad(~Use_Grad,:) = Grad_temp(~Use_Grad,:);
        else
            error('Invalid sign value.  Must be +/- 1.');
        end
    end
    
end

end