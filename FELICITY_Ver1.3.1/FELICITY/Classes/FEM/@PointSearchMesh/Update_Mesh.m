function obj = Update_Mesh(obj,Mesh,BB)
%Update_Mesh
%
%   This updates the mesh (and associated tree structure) for searching.
%
%   obj = obj.Update_Mesh(Mesh,BB);
%
%   Mesh = (FELICITY mesh) this is the mesh where we will do point searching.
%   BB   = a row vector containing the bounding box coordinates:
%          1-D: BB = [X_min, X_max]
%          2-D: BB = [X_min, X_max, Y_min, Y_max]
%          3-D: BB = [X_min, X_max, Y_min, Y_max, Z_min, Z_max]
%
%   Note: dimension refers to geometric dimension of the mesh.

% Copyright (c) 08-31-2016,  Shawn W. Walker

% reset
obj.Trees = containers.Map();

% get info about mesh
obj.Mesh_Info = Mesh_Info_Struct; % init
obj = obj.Get_Mesh_Info(Mesh);

% recreate the tree
obj = obj.Setup_Search_Tree(Mesh,BB);

end