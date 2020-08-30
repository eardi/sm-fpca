function [obj, Embedding_Data] = Define_Mesh(obj,MISC)
%Define_Mesh
%
%   Define the global mesh (and any sub-domains) for the simulation.

% Copyright (c) 01-27-2017,  Shawn W. Walker

obj.Mesh = []; % fill this in!
% note: obj.Mesh is a FELICITY mesh class object.

% define and append any sub-domains here (if there are any)...
% ...
% fill this in!

% EXAMPLE: (change this!)
[Tri, Vtx] = bcc_triangle_mesh(101,101);
obj.Mesh = MeshTriangle(Tri,Vtx,'Omega');

FB = obj.Mesh.freeBoundary();
obj.Mesh = obj.Mesh.Append_Subdomain('1D','Gamma',FB);

% create embedding data (if needed)
DoI_Names = {'fill_in'; 'fill_in'}; % domains of integration
Embedding_Data = obj.Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);

end