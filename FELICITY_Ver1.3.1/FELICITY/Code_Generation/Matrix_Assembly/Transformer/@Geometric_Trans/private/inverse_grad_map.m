function obj = inverse_grad_map(obj)
%inverse_grad_map
%
%   Get the inverse of the (square) matrix PHI.Grad.

% Copyright (c) 05-19-2016,  Shawn W. Walker

num_row = size(obj.PHI.Grad,1);
num_col = size(obj.PHI.Grad,2);

if (num_row==num_col)
    if (num_row==1)
        obj.PHI.Inv_Grad = sym('PHI_Inv_Grad_11');
    elseif (num_row==2)
        %obj.PHI.Inv_Grad = sym('[PHI_Inv_Grad_11, PHI_Inv_Grad_12; PHI_Inv_Grad_21, PHI_Inv_Grad_22]');
        obj.PHI.Inv_Grad = sym('PHI_Inv_Grad_%d%d',[2 2]);
    elseif (num_row==3)
        %obj.PHI.Inv_Grad = sym('[PHI_Inv_Grad_11, PHI_Inv_Grad_12, PHI_Inv_Grad_13; PHI_Inv_Grad_21, PHI_Inv_Grad_22, PHI_Inv_Grad_23; PHI_Inv_Grad_31, PHI_Inv_Grad_32, PHI_Inv_Grad_33]');
        obj.PHI.Inv_Grad = sym('PHI_Inv_Grad_%d%d',[3 3]);
    else
        error('Not implemented!');
    end
else
    obj.PHI.Inv_Grad = [];
end

end