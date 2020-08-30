function [Tet_Face, Tet_Face_Orient] = Get_Facet_Info(obj,Faces)
%Get_Facet_Info
%
%   Given a global "facet" list (just faces in a TetrahedronMesh), this outputs a
%   data structure that indicates which global facets (faces) are attached to
%   each tetrahedron in the mesh, as well as the orientation of the local facets
%   (faces) with respect to the global list.
%
%   [Tet_Face, Tet_Face_Orient] = obj.Get_Facet_Info(Faces);
%
%   Faces = Rx3 matrix of oriented mesh faces.
%
%   Tet_Face = Mx4 matrix that connects obj.ConnectivityList with Faces. The (i,j)
%              entry, where 1 <= i <= M, 1 <= j <= 4, stores an index that
%              points into the rows of Faces, i.e. Faces(Tet_Face(i,j),:) is the
%              *global* face representation of local face j of tetrahedron i:
%              obj.ConnectivityList(i,:).
%              Note: M = obj.Num_Cell (number of tet's in obj.ConnectivityList).
%              Note: the orientation of Faces is ignored here.
%              Note: if Tet_Face(i,j)==0, then local face j of tetrahedron i is
%                    NOT in Faces (in either orientation).
%   Tet_Face_Orient = (boolean) Mx4 matrix indicates whether the orientation of
%                     local face j of tetrahedron i is opposite to the orientation
%                     of Faces(Tet_Face(i,j),:).
%                     true means:
%                     local face j of tetrahedron i = (positive permutation)
%                                     Faces(Tet_Face(i,j),[1 2 3]), or
%                                     Faces(Tet_Face(i,j),[3 1 2]), or
%                                     Faces(Tet_Face(i,j),[2 3 1]).
%                     false means:
%                     local face j of tetrahedron i = (negative permutation)
%                                     Faces(Tet_Face(i,j),[3 2 1]), or
%                                     Faces(Tet_Face(i,j),[2 1 3]), or
%                                     Faces(Tet_Face(i,j),[1 3 2]).
%
%   Example:
%     % coordinates
%     Vtx = [0 0 0;
%            1 0 0;
%            1 1 0;
%            0 1 0;
%            0.5 0.5 0;
%            0.5 0.5 1];
%     % tetrahedral connectivity
%     Tet = [1     2     5     6;
%            2     3     5     6;
%            3     4     5     6;
%            4     1     5     6];
%     obj = MeshTetrahedron(Tet,Vtx,'Pyramid');
%     Faces = obj.faces;
%     [Tet_Face, Tet_Face_Orient] = obj.Get_Facet_Info(Faces);

% Copyright (c) 10-17-2016,  Shawn W. Walker

if (size(Faces,2)~=3)
    error('Input facet list for a tetrahedral mesh must have 3 columns (because they are triangular faces).');
end

% init
Tet_Face = zeros(obj.Num_Cell,4);

% find local faces with positive global orientation #1
[TF1_1, LOC1] = ismember(obj.ConnectivityList(:,[2 3 4]),Faces,'rows'); % local facet (face) 1
[TF2_1, LOC2] = ismember(obj.ConnectivityList(:,[1 4 3]),Faces,'rows'); % local facet (face) 2
[TF3_1, LOC3] = ismember(obj.ConnectivityList(:,[1 2 4]),Faces,'rows'); % local facet (face) 3
[TF4_1, LOC4] = ismember(obj.ConnectivityList(:,[1 3 2]),Faces,'rows'); % local facet (face) 4

Tet_Face(TF1_1,1) = LOC1(TF1_1);
Tet_Face(TF2_1,2) = LOC2(TF2_1);
Tet_Face(TF3_1,3) = LOC3(TF3_1);
Tet_Face(TF4_1,4) = LOC4(TF4_1);

% find local faces with positive global orientation #2
[TF1_2, LOC1] = ismember(obj.ConnectivityList(:,[4 2 3]),Faces,'rows'); % local facet (face) 1
[TF2_2, LOC2] = ismember(obj.ConnectivityList(:,[3 1 4]),Faces,'rows'); % local facet (face) 2
[TF3_2, LOC3] = ismember(obj.ConnectivityList(:,[4 1 2]),Faces,'rows'); % local facet (face) 3
[TF4_2, LOC4] = ismember(obj.ConnectivityList(:,[2 1 3]),Faces,'rows'); % local facet (face) 4

Tet_Face(TF1_2,1) = LOC1(TF1_2);
Tet_Face(TF2_2,2) = LOC2(TF2_2);
Tet_Face(TF3_2,3) = LOC3(TF3_2);
Tet_Face(TF4_2,4) = LOC4(TF4_2);

% find local faces with positive global orientation #3
[TF1_3, LOC1] = ismember(obj.ConnectivityList(:,[3 4 2]),Faces,'rows'); % local facet (face) 1
[TF2_3, LOC2] = ismember(obj.ConnectivityList(:,[4 3 1]),Faces,'rows'); % local facet (face) 2
[TF3_3, LOC3] = ismember(obj.ConnectivityList(:,[2 4 1]),Faces,'rows'); % local facet (face) 3
[TF4_3, LOC4] = ismember(obj.ConnectivityList(:,[3 2 1]),Faces,'rows'); % local facet (face) 4

Tet_Face(TF1_3,1) = LOC1(TF1_3);
Tet_Face(TF2_3,2) = LOC2(TF2_3);
Tet_Face(TF3_3,3) = LOC3(TF3_3);
Tet_Face(TF4_3,4) = LOC4(TF4_3);

% find local faces with **negative** global orientation #1
[TF1_1, LOC1] = ismember(obj.ConnectivityList(:,[4 3 2]),Faces,'rows'); % local facet (face) 1
[TF2_1, LOC2] = ismember(obj.ConnectivityList(:,[3 4 1]),Faces,'rows'); % local facet (face) 2
[TF3_1, LOC3] = ismember(obj.ConnectivityList(:,[4 2 1]),Faces,'rows'); % local facet (face) 3
[TF4_1, LOC4] = ismember(obj.ConnectivityList(:,[2 3 1]),Faces,'rows'); % local facet (face) 4

Tet_Face(TF1_1,1) = LOC1(TF1_1);
Tet_Face(TF2_1,2) = LOC2(TF2_1);
Tet_Face(TF3_1,3) = LOC3(TF3_1);
Tet_Face(TF4_1,4) = LOC4(TF4_1);

% find local faces with **negative** global orientation #2
[TF1_2, LOC1] = ismember(obj.ConnectivityList(:,[2 4 3]),Faces,'rows'); % local facet (face) 1
[TF2_2, LOC2] = ismember(obj.ConnectivityList(:,[1 3 4]),Faces,'rows'); % local facet (face) 2
[TF3_2, LOC3] = ismember(obj.ConnectivityList(:,[1 4 2]),Faces,'rows'); % local facet (face) 3
[TF4_2, LOC4] = ismember(obj.ConnectivityList(:,[1 2 3]),Faces,'rows'); % local facet (face) 4

Tet_Face(TF1_2,1) = LOC1(TF1_2);
Tet_Face(TF2_2,2) = LOC2(TF2_2);
Tet_Face(TF3_2,3) = LOC3(TF3_2);
Tet_Face(TF4_2,4) = LOC4(TF4_2);

% find local faces with **negative** global orientation #3
[TF1_3, LOC1] = ismember(obj.ConnectivityList(:,[3 2 4]),Faces,'rows'); % local facet (face) 1
[TF2_3, LOC2] = ismember(obj.ConnectivityList(:,[4 1 3]),Faces,'rows'); % local facet (face) 2
[TF3_3, LOC3] = ismember(obj.ConnectivityList(:,[2 1 4]),Faces,'rows'); % local facet (face) 3
[TF4_3, LOC4] = ismember(obj.ConnectivityList(:,[3 1 2]),Faces,'rows'); % local facet (face) 4

Tet_Face(TF1_3,1) = LOC1(TF1_3);
Tet_Face(TF2_3,2) = LOC2(TF2_3);
Tet_Face(TF3_3,3) = LOC3(TF3_3);
Tet_Face(TF4_3,4) = LOC4(TF4_3);

% combine all negative orientations
TF1 = TF1_1 | TF1_2 | TF1_3;
TF2 = TF2_1 | TF2_2 | TF2_3;
TF3 = TF3_1 | TF3_2 | TF3_3;
TF4 = TF4_1 | TF4_2 | TF4_3;

% record which faces have orientation opposite to the given global list
Tet_Face_Orient = true(obj.Num_Cell,4);
Tet_Face_Orient(TF1,1) = false;
Tet_Face_Orient(TF2,2) = false;
Tet_Face_Orient(TF3,3) = false;
Tet_Face_Orient(TF4,4) = false;

end