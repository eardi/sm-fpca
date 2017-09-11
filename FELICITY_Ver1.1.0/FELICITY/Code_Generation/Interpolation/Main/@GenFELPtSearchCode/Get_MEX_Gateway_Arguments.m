function mex_strings = Get_MEX_Gateway_Arguments(obj,FPS)
%Get_MEX_Gateway_Arguments
%
%   This just generates the CPP #defines for passing in input arguments.

% Copyright (c) 06-13-2014,  Shawn W. Walker

% all the geometric functions share the same global domain,
% so we just need one to determine what that is
GF = FPS.GeomFuncs(FPS.keys{1});
Global_Mesh_Domain = GF.Domain.Global;

%%%%%%%
% define text strings
%mex_strings.OLD.FEM         = 'OLD_FEM';
mex_strings.MESH.Node_Value = [Global_Mesh_Domain.Name, '_Mesh_Vertices'];
mex_strings.MESH.DoFmap     = [Global_Mesh_Domain.Name, '_Mesh_DoFmap'];

Need_Orient = FPS.Need_Orientation;

% these strings are for when mesh facet orientation data is needed
if Need_Orient
    mex_strings.MESH.Orient = [Global_Mesh_Domain.Name, '_Mesh_Orient'];
else
    mex_strings.MESH.Orient = ['EMPTY_1'];
end

Need_Subdomain_Embed = FPS.Need_Subdomain_Embedding;

% these strings are for when a co-dimension mesh is used
if Need_Subdomain_Embed
    mex_strings.MESH_SUBDOMAIN = [Global_Mesh_Domain.Name, '_Mesh_Subdomains'];
else
    mex_strings.MESH_SUBDOMAIN = ['EMPTY_2'];
end

end