function mex_strings = Get_MEX_Gateway_Arguments(obj,FS)
%Get_MEX_Gateway_Arguments
%
%   This just generates the CPP #defines for passing in input arguments.

% Copyright (c) 06-13-2014,  Shawn W. Walker

Global_Mesh_Domain = FS.Integration(1).DoI_Geom.Domain.Global;

%%%%%%%
% define text strings
mex_strings.OLD.FEM         = 'OLD_FEM';
mex_strings.MESH.Node_Value = [Global_Mesh_Domain.Name, '_Mesh_Vertices'];
mex_strings.MESH.DoFmap     = [Global_Mesh_Domain.Name, '_Mesh_DoFmap'];

if obj.Need_Orientation(FS)
    mex_strings.MESH.Orient = [Global_Mesh_Domain.Name, '_Mesh_Orient'];
else
    mex_strings.MESH.Orient = ['EMPTY_1'];
end

% these strings are for when a co-dimension mesh is used
if obj.Need_Subdomain_Embedding(FS)
    mex_strings.MESH_SUBDOMAIN = [Global_Mesh_Domain.Name, '_Mesh_Subdomains'];
else
    mex_strings.MESH_SUBDOMAIN = ['EMPTY_2'];
end

end