function NEW_u_x = Hopf_Lax_Update(obj,Vtx_Ind,u)
%Hopf_Lax_Update
%
%   Simple routine to get min on a star of triangles at a given node.

% Copyright (c) 07-01-2009,  Shawn W. Walker

% get list of triangles in the current star
Star_Vtx_Mask     = obj.TM.TriStarData(:,Vtx_Ind) ~= 0;
Tri_Indices       = full(obj.TM.TriStarData(Star_Vtx_Mask,Vtx_Ind));
Num_Star_Tri      = length(Tri_Indices);
Tri_Star          = obj.TM.DoFmap(Tri_Indices,:);

% need to re-order so that the vertex at the center of the star is listed first
% Note that we maintain the positive orientation of the triangles!
M1 = (Tri_Star - Vtx_Ind) == 0;
In_2nd_Col = M1(:,2);
In_3rd_Col = M1(:,3);

Tri_Star(In_2nd_Col,:) = Tri_Star(In_2nd_Col,[2 3 1]);
Tri_Star(In_3rd_Col,:) = Tri_Star(In_3rd_Col,[3 1 2]);

Trial_u = zeros(Num_Star_Tri,1);
for j=1:Num_Star_Tri
    Trial_u(j) = Find_Min_On_Tri(obj.TM.Vtx(Tri_Star(j,1),:),obj.TM.Vtx(Tri_Star(j,2),:),obj.TM.Vtx(Tri_Star(j,3),:),...
                                 u(Tri_Star(j,2),1),u(Tri_Star(j,3),1));
end

% get the minimum on the star
NEW_u_x = min(Trial_u);

% END %