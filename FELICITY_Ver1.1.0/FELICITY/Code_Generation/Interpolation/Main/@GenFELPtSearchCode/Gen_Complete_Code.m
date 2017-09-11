function Gen_Complete_Code(obj,FPS,BLANK,Extra_C_Code)
%Gen_Complete_Code
%
%   This generates a complete standalone mesh point search code, i.e. for finding a
%   surrounding element and local coordinates for a given point.

% Copyright (c) 06-13-2014,  Shawn W. Walker

obj.Gen_Main_Part_Of_Code(FPS,Extra_C_Code);

GeomFunc = FPS.GeomFuncs.values;

obj.Gen_All_Mesh_Geometry_Classes(GeomFunc,true); % classes for computing domain and subdomain geometry

obj.Gen_All_Domain_Classes(GeomFunc); % classes for accessing (topological) subdomain data

obj.Gen_All_Point_Search_Classes(FPS); % classes for domain point searches

end