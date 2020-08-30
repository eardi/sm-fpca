function CPP_Name = Get_Basis_Eval_CPP_Name(obj,VAR_NAME,Deriv_Multiindex)
%Get_Basis_Eval_CPP_Name
%
%   This returns the C++ name to use for storing evaluations of the basis
%   functions (in the generated code).  Evaluations are at the quadrature
%   points.
%
%   Note: Deriv_Multiindex is 1x3 vector, where Deriv_Multiindex(j)
%   indicates the number of derivatives to take with respect to x_j
%   (i.e. the jth coordinate).

% Copyright (c) 09-13-2016,  Shawn W. Walker

Deriv_str = obj.Append_Multiindex_Derivative_String(Deriv_Multiindex);
CPP_Name = [VAR_NAME, '_Basis_Val_', Deriv_str];

end