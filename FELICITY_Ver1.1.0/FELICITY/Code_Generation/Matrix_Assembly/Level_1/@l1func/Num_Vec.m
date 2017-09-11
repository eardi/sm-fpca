function NV = Num_Vec(obj)
%Num_Vec
%
%   This returns the number of vector components.
%
%   NV = obj.Num_Vec;

% Copyright (c) 08-01-2011,  Shawn W. Walker

Dim_of_Basis_Func = size(obj.Element.Elem.Basis.Func{1});
if (Dim_of_Basis_Func(2)~=1)
    error('Basis functions can only be column vectors (will improve later).');
end
NV = Dim_of_Basis_Func(1);

end