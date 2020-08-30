function [New_Vtx, New_Tet] = Refine_Entire_Mesh_3D(Vtx,Tet)
%Refine_Entire_Mesh_3D
%
%   This routine takes a given 3-D mesh structure and refines the entire
%   mesh with uniform refinement.
%
%   [New_Vtx, New_Tet] = Refine_Entire_Mesh_3D(Vtx,Tet);
%
%   OUTPUTS
%   -------
%   New_Vtx, New_Tet:
%       New refined mesh data.
%
%   INPUTS
%   ------
%   Vtx:
%       List of vertices for the old mesh BEFORE refining (Nx3 array).
%
%   Tet:
%       List of tetraderons for the old mesh BEFORE refining (Mx4 array).

% Copyright (c) 08-30-2018,  Shawn W. Walker

% get the individual edges (connected to each tetrahedron)
LE   .Ind = sort(Tet(:,[1 2]),2);
LE(2).Ind = sort(Tet(:,[1 3]),2);
LE(3).Ind = sort(Tet(:,[1 4]),2);
LE(4).Ind = sort(Tet(:,[2 3]),2);
LE(5).Ind = sort(Tet(:,[3 4]),2);
LE(6).Ind = sort(Tet(:,[4 2]),2);

% get a unique list of mesh edges
ALL_EDGE = [LE(1).Ind; LE(2).Ind; LE(3).Ind; LE(4).Ind; LE(5).Ind; LE(6).Ind;];
Edges = unique(ALL_EDGE,'rows');

% get original indices
Num_Vtx = size(Vtx,1);
%V_Ind  = (1:1:Num_Vtx)';
% create new indices (for bisected points on edges)
Edge_New_V_Ind = Num_Vtx + (1:1:size(Edges,1))';

% compute new coordinates (which correspond to ordering of Edges)
New_Vtx_Coord = 0.5 * (Vtx(Edges(:,1),:) + Vtx(Edges(:,2),:));
New_Vtx = [Vtx; New_Vtx_Coord];

% get the new vertex index that corresponds to each edge (midpoint)
Num_LE                  = length(LE);
Local_Edge(Num_LE).Mask = [];
Local_Edge(Num_LE).LOC  = [];
New_V(Num_LE).Ind       = [];
for ii = 1:6
    [Local_Edge(ii).Mask, Local_Edge(ii).LOC] = ismember(LE(ii).Ind,Edges,'rows');
    New_V(ii).Ind = Edge_New_V_Ind(Local_Edge(ii).LOC(Local_Edge(ii).Mask,1),1);
end

% refine corners
Tet_1 = [Tet(:,1), New_V(1).Ind, New_V(2).Ind, New_V(3).Ind];
Tet_2 = [Tet(:,2), New_V(4).Ind, New_V(1).Ind, New_V(6).Ind];
Tet_3 = [Tet(:,3), New_V(2).Ind, New_V(4).Ind, New_V(5).Ind];
Tet_4 = [Tet(:,4), New_V(6).Ind, New_V(3).Ind, New_V(5).Ind];

% 3 cases here:
Case(3).Connectivity = [];
% diagonal is e_1, e_5
Case(1).Connectivity =...
         [New_V(1).Ind, New_V(5).Ind, New_V(2).Ind, New_V(3).Ind;
          New_V(1).Ind, New_V(5).Ind, New_V(3).Ind, New_V(6).Ind;
          New_V(1).Ind, New_V(5).Ind, New_V(6).Ind, New_V(4).Ind;
          New_V(1).Ind, New_V(5).Ind, New_V(4).Ind, New_V(2).Ind];
% diagonal is e_2, e_6
Case(2).Connectivity =...
         [New_V(2).Ind, New_V(6).Ind, New_V(1).Ind, New_V(4).Ind;
          New_V(2).Ind, New_V(6).Ind, New_V(4).Ind, New_V(5).Ind;
          New_V(2).Ind, New_V(6).Ind, New_V(5).Ind, New_V(3).Ind;
          New_V(2).Ind, New_V(6).Ind, New_V(3).Ind, New_V(1).Ind];
% diagonal is e_4, e_3
Case(3).Connectivity =...
         [New_V(4).Ind, New_V(3).Ind, New_V(1).Ind, New_V(6).Ind;
          New_V(4).Ind, New_V(3).Ind, New_V(6).Ind, New_V(5).Ind;
          New_V(4).Ind, New_V(3).Ind, New_V(5).Ind, New_V(2).Ind;
          New_V(4).Ind, New_V(3).Ind, New_V(2).Ind, New_V(1).Ind];
%

% evaluate dihedral angles
Ang_1 = simplex_angles(New_Vtx,Case(1).Connectivity);
Ang_2 = simplex_angles(New_Vtx,Case(2).Connectivity);
Ang_3 = simplex_angles(New_Vtx,Case(3).Connectivity);
Ang_1 = min(Ang_1,[],2);
Ang_2 = min(Ang_2,[],2);
Ang_3 = min(Ang_3,[],2);
% use the case that gives the largest min dihedral angle
[~, Case_Ind] = max([Ang_1, Ang_2, Ang_3],[],2);
% disp('Min Angles Vs. Case:');
% (180/pi) * [Ang_1, Ang_2, Ang_3]

% pick them out
Use_Case_1 = Case_Ind==1;
Use_Case_2 = Case_Ind==2;
Use_Case_3 = Case_Ind==3;

% disp('Test Case Logic:');
% [Use_Case_1, Use_Case_2, Use_Case_3]

% output all of the tets
New_Tet = [Tet_1; Tet_2; Tet_3; Tet_4;
           Case(1).Connectivity(Use_Case_1,:); Case(2).Connectivity(Use_Case_2,:); Case(3).Connectivity(Use_Case_3,:)];
%

end

% function v = tet_vol(p,t)
% % simple tetrahedron volume formula
% 
% d12=p(t(:,2),:)-p(t(:,1),:);
% d13=p(t(:,3),:)-p(t(:,1),:);
% d14=p(t(:,4),:)-p(t(:,1),:);
% v=dot(cross(d12,d13,2),d14,2)/6;
% 
% end

function A = simplex_angles(p,t)
%Compute_Simplex_Angles

% compute normal vector of each face
e_1 = p(t(:,2),:) - p(t(:,1),:);
e_2 = p(t(:,3),:) - p(t(:,1),:);
e_3 = p(t(:,4),:) - p(t(:,1),:);
e_4 = p(t(:,3),:) - p(t(:,2),:);
e_6 = p(t(:,2),:) - p(t(:,4),:);
N_1 = cross(e_4,e_6); % e_4 X e_6
N_1 = normalize(N_1);
N_2 = cross(e_2,e_3); % e_2 X e_3
N_2 = normalize(N_2);
N_3 = cross(e_3,e_1); % e_3 X e_1
N_3 = normalize(N_3);
N_4 = cross(e_1,e_2); % e_1 X e_2
N_4 = normalize(N_4);
theta_1 = acos(-dot(N_3,N_4,2));
theta_2 = acos(-dot(N_2,N_4,2));
theta_3 = acos(-dot(N_2,N_3,2));
theta_4 = acos(-dot(N_1,N_4,2));
theta_5 = acos(-dot(N_1,N_2,2));
theta_6 = acos(-dot(N_1,N_3,2));
A = [theta_1, theta_2, theta_3, theta_4, theta_5, theta_6];

end

function V = normalize(V)

V_norm = sqrt(sum(V.^2,2));

for ind=1:size(V,2)
    V(:,ind) = V(:,ind) ./ V_norm;
end

end