function Func_Values = Get_Value(obj,Vector_Comp,alpha)
%Get_Value
%
%   This returns the function evaluations for the given vector component and
%   derivative multi-index.
%   
%   Func_Values = obj.Get_Value(Vector_Comp,alpha);
%
%   Vector_Comp = length 2 vector containing the row,col indices of the function
%                 to return; recall that the function could be vector
%                 or matrix valued.
%   alpha       = 1xN vector that contains the multi-index derivative (of the
%                 function) to return values for.
%                 N = number of independent variables of the function.
%
%   Func_Values = column vector containing function evaluations for a desired
%                 component.

% Copyright (c) 03-01-2013,  Shawn W. Walker

Deriv_Order = error_check_alpha(obj,alpha);

if (Deriv_Order==0)
    Func_Values = obj.Base_Value{Vector_Comp(1),Vector_Comp(2)};
else
    key_str = make_alpha_str(alpha);
    FV_Cell_Array = obj.Deriv_Value(key_str);
    Func_Values = FV_Cell_Array{Vector_Comp(1),Vector_Comp(2)};
end

end