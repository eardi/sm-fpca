function Data = Get_Subdomain_2D(obj,Oriented_Faces,STRICT)
%Get_Subdomain_2D
%
%   This sets up a data structure for representing a sub-domain in a tetra
%   mesh.  Dimension of the subdomain is 2-D (i.e. oriented faces in the mesh).
%   Note: this code only works if the mesh is positively oriented!
%   Note: the order of the elements will change.
%
%   Data = obj.Get_Subdomain_2D(Oriented_Faces,STRICT);
%
%   Oriented_Faces = Mx3 matrix of oriented triangle data (indexes into obj.Points).
%   STRICT = (boolean) true means to only accept the Subdomain if *ALL*
%            Oriented_Faces are found (otherwise it outputs an empty matrix).
%            false means to tolerate any unfound faces, i.e. output the
%            subdomain data for the found faces only.
%
%   Data = Mx2 matrix. First column are tetra indices that refer to tetrahedra
%          in the global mesh that contain the Oriented_Faces; the rows of Data
%          corresponds to rows of Oriented_Faces.  Second column are local face
%          indices (either +/- 1, ..., 4) within a tetrahedron that represent
%          the global faces in Oriented_Faces.

% Copyright (c) 06-27-2012,  Shawn W. Walker

if (nargin < 3)
    STRICT = false; % default
end

% simple error checks
if (size(Oriented_Faces,2)~=3)
    error('The given subdomain must be an Mx3 matrix of vertex indices, where each row represents an oriented triangle (face)!');
end

% define local faces (and struct); see the PDF manual!
G.Local    = [2 3 4]; % face1
G(2).Local = [1 4 3]; % face2
G(3).Local = [1 2 4]; % face3
G(4).Local = [1 3 2]; % face4
G(4).Tets_plus  = [];
G(4).Tets_minus = [];
G(4).Or_plus    = [];
G(4).Or_minus   = [];
MEM_plus(4).TF      = [];
%MEM_plus(4).OF_LOC  = [];
MEM_minus(4).TF     = [];
%MEM_minus(4).OF_LOC = [];

% get reference (don't worry, MATLAB will NOT actually copy it)
Tet_Data = obj.ConnectivityList;

Current_Oriented_Faces = [Oriented_Faces, (1:1:size(Oriented_Faces,1))']; % init with location info
for ind = 1:4
    Sub_DATA = Tet_Data(:,G(ind).Local);
    % find the tets whos Face #(ind) corresponds to the given face (positive orientation)
    [TF1, LOC1] = ismember(Sub_DATA,Current_Oriented_Faces(:,[1 2 3]),'rows');
    [TF2, LOC2] = ismember(Sub_DATA,Current_Oriented_Faces(:,[3 1 2]),'rows');
    [TF3, LOC3] = ismember(Sub_DATA,Current_Oriented_Faces(:,[2 3 1]),'rows');
    MEM_plus(ind).TF  = TF1 | TF2 | TF3;
    LOC = 0*LOC1;
    LOC(TF1) = LOC1(TF1);
    LOC(TF2) = LOC2(TF2);
    LOC(TF3) = LOC3(TF3);
    
    %MEM_plus(ind).OF_LOC = Current_Oriented_Faces(LOC(MEM_plus(ind).TF),4);
    left_over_face_indices = setdiff((1:1:size(Current_Oriented_Faces,1))',LOC);
    Current_Oriented_Faces = Current_Oriented_Faces(left_over_face_indices,:);
end

Current_Oriented_Faces = Current_Oriented_Faces(:,[1 3 2 4]); % flip the face
for ind = 1:4
    Sub_DATA = Tet_Data(:,G(ind).Local);
    % find the tets whos Face #(ind) corresponds to the given face (negative orientation)
    [TF1, LOC1] = ismember(Sub_DATA,Current_Oriented_Faces(:,[1 2 3]),'rows');
    [TF2, LOC2] = ismember(Sub_DATA,Current_Oriented_Faces(:,[3 1 2]),'rows');
    [TF3, LOC3] = ismember(Sub_DATA,Current_Oriented_Faces(:,[2 3 1]),'rows');
    MEM_minus(ind).TF  = TF1 | TF2 | TF3;
    LOC = 0*LOC1;
    LOC(TF1) = LOC1(TF1);
    LOC(TF2) = LOC2(TF2);
    LOC(TF3) = LOC3(TF3);
    
    %MEM_minus(ind).OF_LOC = Current_Oriented_Faces(LOC(MEM_minus(ind).TF),4);
    left_over_face_indices = setdiff((1:1:size(Current_Oriented_Faces,1))',LOC);
    Current_Oriented_Faces = Current_Oriented_Faces(left_over_face_indices,:);
end

if ~isempty(Current_Oriented_Faces)
    if STRICT
        Data = [];
        return;
    else
        % output a message!
        disp(['Subdomain entities (Oriented_Faces) were not found in ', obj.Name, ' mesh...']);
        disp('          ... they will be ignored.');
    end
end

% collect the tets into 4 groups (where each group has the Tet indices which
% directly corresponds to a subset of the given faces)
Num_Tet = size(Tet_Data,1);
All_Tet_Indices = (1:1:Num_Tet)';
for ind = 1:4
    G(ind).Tets_plus  = All_Tet_Indices(MEM_plus(ind).TF,1);
    G(ind).Tets_minus = All_Tet_Indices(MEM_minus(ind).TF,1);
    G(ind).Or_plus    =  ind * ones(size(G(ind).Tets_plus,1),1);
    G(ind).Or_minus   = -ind * ones(size(G(ind).Tets_minus,1),1);
end

% concatenate!
Data = [G(1).Tets_plus,  G(1).Or_plus;
        G(1).Tets_minus, G(1).Or_minus;
        G(2).Tets_plus,  G(2).Or_plus;
        G(2).Tets_minus, G(2).Or_minus;
        G(3).Tets_plus,  G(3).Or_plus;
        G(3).Tets_minus, G(3).Or_minus;
        G(4).Tets_plus,  G(4).Or_plus;
        G(4).Tets_minus, G(4).Or_minus];
%

end