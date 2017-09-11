function Elem_DoF = Get_Edge_to_Tri_Data(Tri)
%Get_Edge_to_Tri_Data
%
%   This function is a TEST! to get edge to triangle connectivity.
%
%   TAG ID:
%
%   ?????

% Copyright (c) 12-01-2010,  Shawn W. Walker

error('do NOT use!');

Num_Tri = size(Tri,1);

% % get the number of mesh vertices (i.e. just look at the largest vertex number in the
% % mesh triangle data structure)
% Num_Vtx = double(max(Tri(:)));

% generate the edge lists that correspond to the new nodes
Edge1 = zeros(Num_Tri,2);
Edge2 = zeros(Num_Tri,2);
Edge3 = zeros(Num_Tri,2);
Edge1_Flip = false(Num_Tri,1);
Edge2_Flip = false(Num_Tri,1);
Edge3_Flip = false(Num_Tri,1);
E1_to_T = zeros(Num_Tri,1);
E2_to_T = zeros(Num_Tri,1);
E3_to_T = zeros(Num_Tri,1);

for ind=1:Num_Tri
    % edge1
    if Tri(ind,2) > Tri(ind,3)
        Edge1(ind,:) = Tri(ind,[3 2]);
        Edge1_Flip(ind,1) = true;
    else
        Edge1(ind,:) = Tri(ind,[2 3]);
    end
    E1_to_T(ind,1) = ind;
    % edge2
    if Tri(ind,3) > Tri(ind,1)
        Edge2(ind,:) = Tri(ind,[1 3]);
        Edge2_Flip(ind,1) = true;
    else
        Edge2(ind,:) = Tri(ind,[3 1]);
    end
    E2_to_T(ind,1) = ind;
    % edge3
    if Tri(ind,1) > Tri(ind,2)
        Edge3(ind,:) = Tri(ind,[2 1]);
        Edge3_Flip(ind,1) = true;
    else
        Edge3(ind,:) = Tri(ind,[1 2]);
    end
    E3_to_T(ind,1) = ind;
end

% Edge1 = sort(Tri(:,[2 3]),2);
% Edge2 = sort(Tri(:,[3 1]),2);
% Edge3 = sort(Tri(:,[1 2]),2);

% all triangle edge list
ALL_EDGE = [Edge1;Edge2;Edge3];
ALL_FLIP = [Edge1_Flip;Edge2_Flip;Edge3_Flip];
ALL_E_to_T = [E1_to_T;E2_to_T;E3_to_T];

[SORT_EDGE, rearrange] = sortrows(ALL_EDGE);
SORT_FLIP   = ALL_FLIP(rearrange,:);
SORT_E_to_T = ALL_E_to_T(rearrange,:);






ALL_EDGE = unique(ALL_EDGE,'rows');



end