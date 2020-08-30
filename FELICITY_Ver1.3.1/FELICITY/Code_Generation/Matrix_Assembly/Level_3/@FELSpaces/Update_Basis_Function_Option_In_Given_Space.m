function obj = Update_Basis_Function_Option_In_Given_Space(obj,Integration_Index,phi)
%Update_Basis_Function_Option_In_Given_Space
%
%   This updates what needs to be computed in the C++ code for the basis
%   function corresponding to the given FE Space index.

% Copyright (c) 03-15-2012,  Shawn W. Walker

TEMP_BasisFunc = obj.Integration(Integration_Index).BasisFunc(phi.Space_Name);
TEMP_BasisFunc = TEMP_BasisFunc.OR_Option_Struct(phi.Opt);
obj.Integration(Integration_Index).BasisFunc(phi.Space_Name) = TEMP_BasisFunc;

end