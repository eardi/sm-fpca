function Perm_Tet = get_tetrahedral_entity_permutations(Perm_Signature)
%get_tetrahedral_entity_permutations
%
%   Given a permutation of the unit "reference" tetrahedron to itself, this
%   returns a structure that records which topological entities get mapped
%   to one another.
%
%   Perm_Signature = 4x1 col vector.
%                    Vtx #i ---> Vtx #Perm_Signature(i).
%                    Note: this maps from {1,2,3,4} to itself.
%
%   Note: this permutation maps from \hat{T} to \tilde{T}.
%
%   Perm_Tet.Vtx  = Perm_Signature;
%   Perm_Tet.Edge = 6x1 col vector.
%                   Edge #i ---> Edge #Perm_Tet.Edge(i).
%                   Note: this maps from {1,2,3,4,5,6} to itself.
%   Perm_Tet.Face = 4x1 col vector.
%                   Face #i ---> Face #Perm_Tet.Face(i).
%                   Note: this maps from {1,2,3,4} to itself.
%   Perm_Tet.Tet  = 1x1 col vector = 1.

% Copyright (c) 10-31-2016,  Shawn W. Walker

if (size(Perm_Signature,2)~=1)
    error('Must be column vector!');
end

% define reference vertices, edges, faces, and tet
% NOTE: we do NOT care about orientation changes here.
Vtx_Defn  = [1;
             2;
             3;
             4];
%
Edge_Defn = sort([1 2;
                  1 3;
                  1 4;
                  2 3;
                  3 4;
                  4 2],2);
%
Face_Defn = sort([2 3 4;
                  1 4 3;
                  1 2 4;
                  1 3 2],2);
%
%Tet_Defn = [1 2 3 4];

% get permutation

% vertices (easy)
Perm_Tet.Vtx = 0*Vtx_Defn;
Perm_Tet.Vtx(:) = Perm_Signature(Vtx_Defn(:));

% edges
New_Edge = 0*Edge_Defn;
New_Edge(:) = Perm_Signature(Edge_Defn(:));
New_Edge = sort(New_Edge,2);

[TF,LOC] = ismember(New_Edge,Edge_Defn,'rows');
Perm_Tet.Edge = LOC;
% check it
if ~isempty(setdiff(Perm_Tet.Edge,(1:1:6)'))
    error('The Perm_Signature is not correct!');
end

% faces
New_Face = 0*Face_Defn;
New_Face(:) = Perm_Signature(Face_Defn(:));
New_Face = sort(New_Face,2);

[TF,LOC] = ismember(New_Face,Face_Defn,'rows');
Perm_Tet.Face = LOC;
% check it
if ~isempty(setdiff(Perm_Tet.Face,(1:1:4)'))
    error('The Perm_Signature is not correct!');
end

% tet (easy)
Perm_Tet.Tet = 1;

end