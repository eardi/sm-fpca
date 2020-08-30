function Gen_Complete_Code(obj,FS,FI,Extra_C_Code)
%Gen_Complete_Code
%
%   This generates a complete standalone FEM interpolation code.

% Copyright (c) 01-29-2013,  Shawn W. Walker

GeomFunc = FS.Get_Unique_Array_Of_GeomFuncs;

obj.Gen_Main_Part_Of_Code(GeomFunc,FS,FI,Extra_C_Code);

obj.Gen_All_Mesh_Geometry_Classes(GeomFunc,true); % classes for computing domain and subdomain geometry

obj.Gen_All_Domain_Classes(GeomFunc); % classes for accessing (topological) subdomain data

obj.Gen_All_Basis_Function_Classes(FS,true); % classes for FEM Space Basis Functions

obj.Gen_All_Coef_Function_Classes(FS,true); % classes for FEM Space Coef Functions

obj.Gen_All_FEM_Interpolation_Classes(FS,FI); % classes for FEM interpolation computations

end