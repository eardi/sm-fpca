function Gen_Misc_Geometry_Classes(obj,fid,GeomFunc)
%Gen_Misc_Geometry_Classes
%
%   This generates a section of Misc_Stuff.h:  the mesh geometry class files.
%   fid = an (open) file ID to "Misc_Stuff.h".

% Copyright (c) 06-13-2014,  Shawn W. Walker

% copy some standard files over
FC = FELCodeHdr();

% mesh geometry
obj.Make_SubDir(obj.Sub_Dir.Geometry);
Geometry_Dir = fullfile(obj.Output_Dir, obj.Sub_Dir.Geometry);

ENDL = '\n';
fprintf(fid, ['// mesh geometry class files', ENDL]);
fprintf(fid, ['#include "./', obj.Sub_Dir.Geometry, '/ALL_Mesh_Geometry.h"', ENDL]);
status = write_geometry_files(Geometry_Dir,'ALL_Mesh_Geometry.h',GeomFunc);
fprintf(fid, ['', ENDL]);

end

function status = write_geometry_files(Dir,hdr_h,GeomFunc)

ENDL = '\n';

WRITE_File = fullfile(Dir, hdr_h);

% open file for writing
fid = fopen(WRITE_File, 'a');
fprintf(fid, ['/*', ENDL]);
fprintf(fid, ['============================================================================================', ENDL]);
fprintf(fid, ['    Mesh geometry class files.', ENDL]);
fprintf(fid, ['============================================================================================', ENDL]);
fprintf(fid, ['*/', ENDL]);
fprintf(fid, ['', ENDL]);

fprintf(fid, ['#include "Abstract_Mesh_Geometry_Class.cc"', ENDL]);
Num_GeomFunc = length(GeomFunc);
for ind = 1:Num_GeomFunc
    FN = GeomFunc{ind}.CPP.Data_Type_Name_cc;
    fprintf(fid, ['#include "', FN, '"', ENDL]);
end
fprintf(fid, ['', ENDL]);

fprintf(fid, ['/***/', ENDL]);
status = fclose(fid);

end