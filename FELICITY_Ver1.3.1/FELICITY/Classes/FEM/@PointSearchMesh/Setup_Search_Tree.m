function obj = Setup_Search_Tree(obj,Mesh,BB)
%Setup_Search_Tree
%
%   This sets up the search tree for making point searching more efficient.
%
%   obj = obj.Setup_Search_Tree(Mesh,BB);
%
%   Mesh = (FELICITY mesh) this is the mesh where we will do point searching.
%   BB   = a row vector containing the bounding box coordinates:
%          1-D: BB = [X_min, X_max]
%          2-D: BB = [X_min, X_max, Y_min, Y_max]
%          3-D: BB = [X_min, X_max, Y_min, Y_max, Z_min, Z_max]
%
%   Note: dimension refers to the geometric dimension of the mesh.

% Copyright (c) 08-31-2016,  Shawn W. Walker

% get cell centers
Bary_Centers = Mesh.Get_Cell_Centers();

Max_Tree_Levels = 32;
Bucket_Size = 20;
GD = Mesh.Geo_Dim;
if (GD==1)
    Search_Struct.Tree = mexBitree(Bary_Centers,BB);%,Max_Tree_Levels,Bucket_Size);
elseif (GD==2)
    Search_Struct.Tree = mexQuadtree(Bary_Centers,BB);%,Max_Tree_Levels,Bucket_Size);
elseif (GD==3)
    Search_Struct.Tree = mexOctree(Bary_Centers,BB);%,Max_Tree_Levels,Bucket_Size);
else
    error('Mesh has invalid dimension!');
end
Search_Struct.Neighbors = uint32(Mesh.neighbors);

obj.Trees(Mesh.Name) = Search_Struct;

end