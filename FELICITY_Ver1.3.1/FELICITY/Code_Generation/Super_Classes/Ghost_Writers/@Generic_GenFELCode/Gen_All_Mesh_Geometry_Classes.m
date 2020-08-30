function Gen_All_Mesh_Geometry_Classes(obj,GeomFunc,For_INTERP)
%Gen_All_Mesh_Geometry_Classes
%
%   This generates the different mesh geometries, such as for integrating on
%   domains of co-dimension 1.

% Copyright (c) 06-13-2014,  Shawn W. Walker

% clone the base class file
FN = 'Abstract_Mesh_Geometry_Class.cc';
OUT_Dir = fullfile(obj.Output_Dir, obj.Sub_Dir.Geometry);
CLONE_File = fullfile(OUT_Dir, FN);
GeomFunc{1}.Copy_File(FN, CLONE_File);

% generate code for each mesh geometry
for ind=1:length(GeomFunc)
    GeomFunc{ind}.INTERPOLATION = For_INTERP; % indicate if this is for interpolation
    GeomFunc{ind}.Gen_Mesh_Geometry_Class_cc(OUT_Dir);
end

end