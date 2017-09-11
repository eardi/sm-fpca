function Zero_Func = Get_Zero_Function(obj)
%Get_Zero_Function
%
%   This returns a coefficient array (matrix) of all zeros.  The size of the array is
%   dictated by the number of Degrees-of-Freedom (DoF) and the number of tensor components
%   of the finite element (FE) space.
%
%   Zero_Func = obj.Get_Zero_Function;
%
%   Zero_Func = MxC matrix of all zeros, representing the zero function in the FE space:
%               M = number of DoFs in finite element space.
%               C = number of tensor components of the FE space.

% Copyright (c) 05-05-2014,  Shawn W. Walker

NUM_DoF = obj.num_dof;
Num_Comp = obj.RefElem.Num_Comp;

Zero_Func = zeros(NUM_DoF,Num_Comp);

end