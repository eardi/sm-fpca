function [status, Mesh] = test_FEL_Mesh_Skeleton_2D()
%test_FEL_Mesh_Skeleton_2D
%
%   Test code for FELICITY class, on creating mesh "skeleton" data.

% Copyright (c) 05-07-2019,  Shawn W. Walker

% create a mesh object
np = 11;
[Tri, Vtx] = regular_triangle_mesh(np,np);
Mesh = MeshTriangle(Tri,Vtx,'Square');

% add the boundary
BDY  = Mesh.freeBoundary();
Mesh = Mesh.Append_Subdomain('1D','Gamma',BDY);

% add the skeleton
Mesh = Mesh.Append_Skeleton('Skeleton_Plus','Skeleton_Minus');
Sk_Plus = Mesh.Get_Global_Subdomain('Skeleton_Plus');
Sk_Minus = Mesh.Get_Global_Subdomain('Skeleton_Minus');

% they should be distinct because of orientation
ERR_intersect = ~isempty(intersect(Sk_Plus,Sk_Minus,'rows'));

% check it!
All_Edges = sort(Mesh.edges(),2);

% the mesh edges *are* the plus skeleton
ERR_Plus = ~isempty(setdiff(sort(Sk_Plus,2),All_Edges,'rows'));
ERR_Plus = or(ERR_Plus,size(Sk_Plus,1)~=size(All_Edges,1));

% the difference should be the boundary
Plus_remove_Minus = setdiff(sort(Sk_Plus,2),sort(Sk_Minus,2),'rows');
ERR_BDY = ~isempty(setdiff(sort(Plus_remove_Minus,2),sort(BDY,2),'rows'));
ERR_BDY = or(ERR_BDY,size(Plus_remove_Minus,1)~=size(BDY,1));

ERR = [ERR_intersect, ERR_Plus, ERR_BDY]';
ERR_CHK = max(ERR);
status = 0; % init
if (ERR_CHK)
    disp('Triangle skeleton is not correct in 2-D!');
    ERR
    status = 1;
end

end