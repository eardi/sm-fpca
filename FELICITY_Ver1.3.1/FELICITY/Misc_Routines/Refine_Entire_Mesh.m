function [New_Mesh_Vertex_Coordinates, New_Triangle_Elements, New_Boundary_Elements] =...
          Refine_Entire_Mesh(Vtx_Coord,Triangles,Bdy_Seg,Marked_Triangles)
%Refine_Entire_Mesh
%
%   This routine takes a given mesh structure and refines the mesh wherever there is
%   a "marked" triangle.
%
%   [New_Mesh_Vertex_Coordinates, New_Triangle_Elements, New_Boundary_Elements] =
%             Refine_Entire_Mesh(Vtx_Coord,Triangles,Bdy_Seg,Marked_Triangles)
%
%   OUTPUTS
%   -------
%   New_Mesh_Vertex_Coordinates, New_Triangle_Elements, New_Boundary_Elements:
%       New refined mesh data.
%
%   INPUTS
%   ------
%   Vtx_Coord:
%       List of vertices for the old mesh BEFORE refining (Nx2 array).
%
%   Triangles:
%       List of triangles for the old mesh BEFORE refining (Mx3 array).
%
%   Bdy_Seg:
%       List of boundary segments for the old mesh BEFORE refining (Px2 array).
%
%   Marked_Triangles:
%       List of triangles that have been marked for refining (Qx1 array).
%
%
%   SWW: note this is old code.  You should use the 1to4 refinement method
%        implemented in the MeshTriangle class.

% Copyright (c) 08-16-2006,  Shawn W. Walker



% ALTERNATE: find all triangles that share any of the sides of the marked triangles
FullRefine_Mask = logical(zeros(size(Triangles,1),1));
FullRefine_Mask(Marked_Triangles) = logical(1);

% More_Triangles = logical(1);
% Output_Count = 0;
% while (More_Triangles)

FR_Edge1 = sort(Triangles(FullRefine_Mask,[1,2]),2);
FR_Edge2 = sort(Triangles(FullRefine_Mask,[2,3]),2);
FR_Edge3 = sort(Triangles(FullRefine_Mask,[3,1]),2);
FR_Edges = [FR_Edge1; FR_Edge2; FR_Edge3];
FR_Edges = unique(FR_Edges,'rows');

Neighboring_Mask1 = ismember(sort(Triangles(:,[1 2]),2),FR_Edges,'rows');
Neighboring_Mask2 = ismember(sort(Triangles(:,[2 3]),2),FR_Edges,'rows');
Neighboring_Mask3 = ismember(sort(Triangles(:,[3 1]),2),FR_Edges,'rows');

Num_Sides = Neighboring_Mask1 + Neighboring_Mask2 + Neighboring_Mask3;

% TEMP = (Num_Sides >= 2);
% % FullRefine_Mask
% % TEMP
% More_Triangles = logical(max(abs(FullRefine_Mask - TEMP)));
% FullRefine_Mask = TEMP;

%Output_Count = Output_Count + 1;
%Output_Count
%end

Bisection_Mask = (Num_Sides == 1);
Trisection_Mask = (Num_Sides == 2);
FullRefine_Mask = (Num_Sides == 3);




% Form all edges, non-duplicates are boundary edges
FullRefine_Triangles = Triangles(FullRefine_Mask,:);
Num_FullRefine_Tri = size(FullRefine_Triangles,1);

Edge1 = sort(FullRefine_Triangles(:,[1,2]),2);
Edge2 = sort(FullRefine_Triangles(:,[2,3]),2);
Edge3 = sort(FullRefine_Triangles(:,[3,1]),2);
All_Edges=[Edge1;Edge2;Edge3];
%All_Edges=sort(All_Edges,2);
Unique_Edges=unique(All_Edges,'rows');

Last_Vertex_Num = size(Vtx_Coord,1);
New_Vertex_List = (1:1:size(Unique_Edges,1))' + Last_Vertex_Num;
New_Vertices = 0.5*(Vtx_Coord(Unique_Edges(:,1),:) + Vtx_Coord(Unique_Edges(:,2),:));
New_Mesh_Vertex_Coordinates = [Vtx_Coord; New_Vertices]; % update!


[TF, Edge1_Vertex_Indices] = ismember(Edge1,Unique_Edges,'rows');
[TF, Edge2_Vertex_Indices] = ismember(Edge2,Unique_Edges,'rows');
[TF, Edge3_Vertex_Indices] = ismember(Edge3,Unique_Edges,'rows');
Edge1_Vertex_Indices = New_Vertex_List(Edge1_Vertex_Indices);
Edge2_Vertex_Indices = New_Vertex_List(Edge2_Vertex_Indices);
Edge3_Vertex_Indices = New_Vertex_List(Edge3_Vertex_Indices);

New_Triangle_Elements = Triangles;

% replace old full refined triangles with new interior triangles
New_Triangle_Elements(FullRefine_Mask,:) = [Edge1_Vertex_Indices, Edge2_Vertex_Indices, Edge3_Vertex_Indices];

Other_New_Triangles1 = [FullRefine_Triangles(:,1), Edge1_Vertex_Indices, Edge3_Vertex_Indices];
Other_New_Triangles2 = [FullRefine_Triangles(:,2), Edge2_Vertex_Indices, Edge1_Vertex_Indices];
Other_New_Triangles3 = [FullRefine_Triangles(:,3), Edge3_Vertex_Indices, Edge2_Vertex_Indices];


% bisection triangles
Bisection_Triangles = Triangles(Bisection_Mask,:);
Num_Bisection_Tri = size(Bisection_Triangles,1);

Bi_Edge1 = sort(Bisection_Triangles(:,[1,2]),2);
Bi_Edge2 = sort(Bisection_Triangles(:,[2,3]),2);
Bi_Edge3 = sort(Bisection_Triangles(:,[3,1]),2);

[TF1, Bi_Edge1_Vertex_Indices] = ismember(Bi_Edge1,Unique_Edges,'rows');
[TF2, Bi_Edge2_Vertex_Indices] = ismember(Bi_Edge2,Unique_Edges,'rows');
[TF3, Bi_Edge3_Vertex_Indices] = ismember(Bi_Edge3,Unique_Edges,'rows');

%[Bi_Edge1_Vertex_Indices, Bi_Edge2_Vertex_Indices, Bi_Edge3_Vertex_Indices]

Bisection_Tri_Edge_Index = Bi_Edge1_Vertex_Indices + Bi_Edge2_Vertex_Indices + Bi_Edge3_Vertex_Indices;
Bisection_Tri_New_Vertex_Index = New_Vertex_List(Bisection_Tri_Edge_Index);

Bisection_Opposite_Vertex = zeros(size(Bisection_Tri_New_Vertex_Index,1),1);
Bisection_Opposite_Vertex(TF1) = Bisection_Triangles(TF1,3);
Bisection_Opposite_Vertex(TF2) = Bisection_Triangles(TF2,1);
Bisection_Opposite_Vertex(TF3) = Bisection_Triangles(TF3,2);

% replace old bisection refined triangles with one of the new triangles
New_Triangle_Elements(Bisection_Mask,:) = [Bisection_Tri_New_Vertex_Index, Bisection_Opposite_Vertex, Unique_Edges(Bisection_Tri_Edge_Index,1)];
New_Bisection_Triangles = [Bisection_Tri_New_Vertex_Index, Bisection_Opposite_Vertex, Unique_Edges(Bisection_Tri_Edge_Index,2)];
%New_Bisection_Triangles = [];



% trisection triangles
Trisection_Triangles = Triangles(Trisection_Mask,:);
Num_Trisection_Tri = size(Trisection_Triangles,1);

if (Num_Trisection_Tri > 0)

Trisec_Edge1 = sort(Trisection_Triangles(:,[1,2]),2); % side 1
Trisec_Edge2 = sort(Trisection_Triangles(:,[2,3]),2); % side 2
Trisec_Edge3 = sort(Trisection_Triangles(:,[3,1]),2); % side 3

TF = zeros(Num_Trisection_Tri,3); Trisec_Edge_Vertex_Indices = zeros(Num_Trisection_Tri,3);
[TF(:,1), Trisec_Edge_Vertex_Indices(:,1)] = ismember(Trisec_Edge1,Unique_Edges,'rows');
[TF(:,2), Trisec_Edge_Vertex_Indices(:,2)] = ismember(Trisec_Edge2,Unique_Edges,'rows');
[TF(:,3), Trisec_Edge_Vertex_Indices(:,3)] = ismember(Trisec_Edge3,Unique_Edges,'rows');

TABLE = [0 1 1;1 0 1;1 1 0];
[FOO, No_Touch_Side] = ismember(TF,TABLE,'rows');
Side1_Mask = (No_Touch_Side == 1);
Side2_Mask = (No_Touch_Side == 2);
Side3_Mask = (No_Touch_Side == 3);

Trisection_Tri_Edge_Index = zeros(Num_Trisection_Tri,2);
Trisection_Tri_New_Vertex_Index = zeros(Num_Trisection_Tri,2);
Trisection_Tri_Edge_Index(Side1_Mask,:) = Trisec_Edge_Vertex_Indices(Side1_Mask,[2 3]);
Trisection_Tri_Edge_Index(Side2_Mask,:) = Trisec_Edge_Vertex_Indices(Side2_Mask,[1 3]);
Trisection_Tri_Edge_Index(Side3_Mask,:) = Trisec_Edge_Vertex_Indices(Side3_Mask,[1 2]);

Trisection_Tri_New_Vertex_Index(:,1) = New_Vertex_List(Trisection_Tri_Edge_Index(:,1));
Trisection_Tri_New_Vertex_Index(:,2) = New_Vertex_List(Trisection_Tri_Edge_Index(:,2));

Top_Vertex = zeros(Num_Trisection_Tri,1);
Top_Vertex(Side1_Mask) = Trisection_Triangles(Side1_Mask,3);
Top_Vertex(Side2_Mask) = Trisection_Triangles(Side2_Mask,1);
Top_Vertex(Side3_Mask) = Trisection_Triangles(Side3_Mask,2);

Bottom_Vertex_1 = zeros(Num_Trisection_Tri,1);
Bottom_Vertex_1(Side1_Mask) = Trisection_Triangles(Side1_Mask,2);
Bottom_Vertex_1(Side2_Mask) = Trisection_Triangles(Side2_Mask,2);
Bottom_Vertex_1(Side3_Mask) = Trisection_Triangles(Side3_Mask,1);

Bottom_Vertex_2 = zeros(Num_Trisection_Tri,1);
Bottom_Vertex_2(Side1_Mask) = Trisection_Triangles(Side1_Mask,1);
Bottom_Vertex_2(Side2_Mask) = Trisection_Triangles(Side2_Mask,3);
Bottom_Vertex_2(Side3_Mask) = Trisection_Triangles(Side3_Mask,3);

% replace old trisection refined triangles with one of the new triangles (the uniform
% one).
New_Triangle_Elements(Trisection_Mask,:) = [Top_Vertex, Trisection_Tri_New_Vertex_Index];
% setup the other two...
New_Trisection_Triangles_Choice1_A = [Bottom_Vertex_1, Trisection_Tri_New_Vertex_Index];
New_Trisection_Triangles_Choice1_B = [Bottom_Vertex_1, Trisection_Tri_New_Vertex_Index(:,2), Bottom_Vertex_2];
New_Trisection_Triangles_Choice2_A = [Bottom_Vertex_2, Trisection_Tri_New_Vertex_Index(:,[2 1])];
New_Trisection_Triangles_Choice2_B = [Bottom_Vertex_2, Trisection_Tri_New_Vertex_Index(:,1), Bottom_Vertex_1];

% need to pick between the two choices...

% compute objective functions for the trisected triangles
for index = 1:Num_Trisection_Tri

    Choice1_A_OBJ(index,1) =...
    Triangle_Objective_Function(New_Mesh_Vertex_Coordinates(New_Trisection_Triangles_Choice1_A(index,:),:),...
                                New_Mesh_Vertex_Coordinates(New_Trisection_Triangles_Choice1_A(index,:),:) );
    Choice1_B_OBJ(index,1) =...
    Triangle_Objective_Function(New_Mesh_Vertex_Coordinates(New_Trisection_Triangles_Choice1_B(index,:),:),...
                                New_Mesh_Vertex_Coordinates(New_Trisection_Triangles_Choice1_B(index,:),:) );

    Choice2_A_OBJ(index,1) =...
    Triangle_Objective_Function(New_Mesh_Vertex_Coordinates(New_Trisection_Triangles_Choice2_A(index,:),:),...
                                New_Mesh_Vertex_Coordinates(New_Trisection_Triangles_Choice2_A(index,:),:) );
    Choice2_B_OBJ(index,1) =...
    Triangle_Objective_Function(New_Mesh_Vertex_Coordinates(New_Trisection_Triangles_Choice2_B(index,:),:),...
                                New_Mesh_Vertex_Coordinates(New_Trisection_Triangles_Choice2_B(index,:),:) );
end
Choice1_OBJ = Choice1_A_OBJ.^2 + Choice1_B_OBJ.^2;
Choice2_OBJ = Choice2_A_OBJ.^2 + Choice2_B_OBJ.^2;

% minimize between these ...
[Val, min_OBJ_index] = min([Choice1_OBJ, Choice2_OBJ],[],2);
Mask_OBJ_2 = (min_OBJ_index == 2);

% ... and choose the one with least COST
New_Trisection_Triangles_A = New_Trisection_Triangles_Choice1_A;
New_Trisection_Triangles_B = New_Trisection_Triangles_Choice1_B;
New_Trisection_Triangles_A(Mask_OBJ_2,:) = New_Trisection_Triangles_Choice2_A(Mask_OBJ_2,:);
New_Trisection_Triangles_B(Mask_OBJ_2,:) = New_Trisection_Triangles_Choice2_B(Mask_OBJ_2,:);

% set them up
New_Trisection_Triangles = [New_Trisection_Triangles_A; New_Trisection_Triangles_B];

else
%
New_Trisection_Triangles = [];
end

% put them all together
New_Triangle_Elements = [New_Triangle_Elements; Other_New_Triangles1; Other_New_Triangles2; Other_New_Triangles3;...
                                                New_Bisection_Triangles; New_Trisection_Triangles];

% if necessary, fix the inverted triangle
if (size(New_Mesh_Vertex_Coordinates,2)==2)
    flip=simple_tri_area(New_Mesh_Vertex_Coordinates,New_Triangle_Elements)<0;
    New_Triangle_Elements(flip,[1,2])=New_Triangle_Elements(flip,[2,1]);
end

% get the new boundary
New_Boundary_Elements=tri_mesh_free_boundary(New_Mesh_Vertex_Coordinates,New_Triangle_Elements);

end

function v = simple_tri_area(p,t)
% simple triangle area formula

Geo_Dim = size(p,2);

d12=p(t(:,2),:)-p(t(:,1),:);
d13=p(t(:,3),:)-p(t(:,1),:);
if (Geo_Dim > 2)
    v = sqrt(sum(cross(d12,d13,2).^2,2));
else
    v = (d12(:,1).*d13(:,2)-d12(:,2).*d13(:,1))/2;
end

end

function e=tri_mesh_free_boundary(p,t)
% find free boundary edges of triangular mesh

% form all edges
edges=[t(:,[1,2]);
       t(:,[1,3]);
       t(:,[2,3])];
node3=[t(:,3);t(:,2);t(:,1)];
edges=sort(edges,2);
% non-duplicates are boundary edges
[BLAH,ix,jx]=unique(edges,'rows');
vec=histc(jx,1:max(jx));
qx=find(vec==1);
e=edges(ix(qx),:);
node3=node3(ix(qx));

% get the correct orientation
v1=p(e(:,2),:)-p(e(:,1),:);
v2=p(node3,:)-p(e(:,1),:);
ix=find(v1(:,1).*v2(:,2)-v1(:,2).*v2(:,1) <= 0);
e(ix,[1,2])=e(ix,[2,1]);

end