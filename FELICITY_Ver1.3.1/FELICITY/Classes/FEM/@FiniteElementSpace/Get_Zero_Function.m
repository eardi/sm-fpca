function Zero_Func = Get_Zero_Function(obj)
%Get_Zero_Function
%
%   This returns a coefficient array (matrix) of all zeros.  The size of
%   the array is dictated by the number of Degrees-of-Freedom (DoF) and the
%   *total* number of tuple components of the finite element (FE) space.
%
%   Zero_Func = obj.Get_Zero_Function;
%
%   Zero_Func = RxC matrix of all zeros, representing the zero function in the FE space:
%               R = number of DoFs in *base* finite element (FE) space.
%               C = total number of tuple components of the FE space, i.e.
%                   C = M*N, where the FE space tuple-size is M x N.

% Copyright (c) 03-26-2018,  Shawn W. Walker

NUM_DoF = obj.num_dof;
Num_Comp = prod(obj.Num_Comp);

Zero_Func = zeros(NUM_DoF,Num_Comp);

end