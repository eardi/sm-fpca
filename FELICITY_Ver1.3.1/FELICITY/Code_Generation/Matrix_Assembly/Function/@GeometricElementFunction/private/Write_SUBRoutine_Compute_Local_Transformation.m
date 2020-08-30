function status = Write_SUBRoutine_Compute_Local_Transformation(obj,fid,Compute_Local_Transformation)
%Write_SUBRoutine_Compute_Local_Transformation
%
%   This generates a sub-routine of the Mesh_Geometry_Class for computing
%   transformations of the local element map.

% Copyright (c) 06-20-2012,  Shawn W. Walker

ENDL = '\n';
TAB = '    ';
% TAB2 = [TAB, TAB];
% insert code snippet
fprintf(fid, ['', ENDL]);
fprintf(fid, [obj.BEGIN_Auto_Gen, ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, ['/* compute the local transformation based on the given mesh entity */', ENDL]);
fprintf(fid, ['void MGC::Compute_Local_Transformation()', ENDL]);
fprintf(fid, ['{', ENDL]);

Embed = obj.Domain.Get_Sub_DoI_Embedding_Data;
fprintf(fid, [TAB, '// read in the embedding info', ENDL]);
fprintf(fid, [TAB, 'const int Global_Cell_Index = Domain->Global_Cell_Index;', ENDL]);
% if Embed.Subdomain_Entity_Index
%     fprintf(fid, [TAB, 'const int Sub_Cell_Index    = Domain->Sub_Cell_Index;', ENDL]);
% end
if Embed.Subdomain_Entity_Index
    fprintf(fid, [TAB, 'const int Sub_Entity_Index  = Domain->Sub_Entity_Index;', ENDL]);
end
if Embed.DoI_Entity_Index
    fprintf(fid, [TAB, 'const int DoI_Entity_Index  = Domain->DoI_Entity_Index;', ENDL]);
end
fprintf(fid, ['', ENDL]);

fprintf(fid, [TAB, '// compute "facet" orientation directions of current simplex', ENDL]);
fprintf(fid, [TAB, 'if (ORIENT)  Get_Local_Orientation(Global_Cell_Index);', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [TAB, '/* compute local map */', ENDL]);
fprintf(fid, ['', ENDL]);
fprintf(fid, [Compute_Local_Transformation.Main_Subroutine, ENDL]);
fprintf(fid, ['}', ENDL]);
fprintf(fid, ['/***************************************************************************************/', ENDL]);
fprintf(fid, [obj.END_Auto_Gen, ENDL]);
status = fprintf(fid, ['', ENDL]);

end