function [obj, Embedding_Data] = Define_Mesh(obj,MISC)
%Define_Mesh
%
%   Define the global mesh (and any sub-domains) for the simulation.

% Copyright (c) 05-05-2014,  Shawn W. Walker

obj.Mesh = []; % fill this in!
% note: obj.Mesh is a FELICITY mesh class object.

% define and append any sub-domains here (if there are any)...
% ...
% 

% fill this in!

% create embedding data (if needed)
DoI_Names = {'fill_in'; 'fill_in'}; % domains of integration
Embedding_Data = obj.Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);

end