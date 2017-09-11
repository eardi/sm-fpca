function obj = grad_map(obj)
%grad_map
%
%   Get the gradient of PHI.

% Copyright (c) 02-20-2012,  Shawn W. Walker

% represent gradient symbolically
if (obj.GeoDim==1)
    obj.PHI.Grad = sym('[PHI_Grad_11]');
elseif (obj.GeoDim==2)
    if (obj.TopDim==1)
        obj.PHI.Grad = sym('[PHI_Grad_11; PHI_Grad_21]');
    elseif (obj.TopDim==2)
        obj.PHI.Grad = sym('[PHI_Grad_11, PHI_Grad_12; PHI_Grad_21, PHI_Grad_22]');
    end
elseif (obj.GeoDim==3)
    if (obj.TopDim==1)
        obj.PHI.Grad = sym('[PHI_Grad_11; PHI_Grad_21; PHI_Grad_31]');
    elseif (obj.TopDim==2)
        obj.PHI.Grad = sym('[PHI_Grad_11, PHI_Grad_12; PHI_Grad_21, PHI_Grad_22; PHI_Grad_31, PHI_Grad_32]');
    elseif (obj.TopDim==3)
        obj.PHI.Grad = sym('[PHI_Grad_11, PHI_Grad_12, PHI_Grad_13; PHI_Grad_21, PHI_Grad_22, PHI_Grad_23; PHI_Grad_31, PHI_Grad_32, PHI_Grad_33]');
    end
end

end