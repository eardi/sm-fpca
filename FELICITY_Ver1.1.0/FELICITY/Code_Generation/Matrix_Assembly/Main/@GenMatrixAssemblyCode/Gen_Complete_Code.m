function Gen_Complete_Code(obj,FS,FM,Extra_C_Code)
%Gen_Complete_Code
%
%   This generates a complete standalone matrix assembly code.

% Copyright (c) 06-18-2012,  Shawn W. Walker

GeomFunc = FS.Get_Unique_Array_Of_GeomFuncs;

obj.Gen_Main_Part_Of_Code(GeomFunc,FS,FM,Extra_C_Code);

obj.Gen_All_Mesh_Geometry_Classes(GeomFunc,false); % classes for computing domain and subdomain geometry

obj.Gen_All_Domain_Classes(GeomFunc); % classes for accessing (topological) subdomain data

obj.Gen_All_Basis_Function_Classes(FS,false); % classes for FEM Space Basis Functions

obj.Gen_All_Coef_Function_Classes(FS,false); % classes for FEM Space Coef Functions

obj.Gen_All_FEM_Matrix_Classes(FS,FM); % classes for FEM matrix computations

end