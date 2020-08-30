function V = bcc_tetrahedral_mesh_points_only(nx,ny,nz)
%bcc_tetrahedral_mesh_points_only
%
%   V = bcc_tetrahedral_mesh_points_only(nx,ny,nz)
%
%   Generates a BCC lattice/tetrahedral mesh with dimensions (nx,ny,nz)
%
%   Input:
%     nx  number of points in x direction on grid
%     ny  number of points in y direction on grid
%     nz  number of points in z direction on grid
%   Output:
%     T  tetrahedra list of indices into V
%     V  list of vertex coordinates in 3D
%
%   Example
%     [T,V] = bcc_tetrahedral_mesh(3,3,3);
%     tetramesh(T,V); %also try tetramesh(T,V,'FaceAlpha',0);
%
% See also delaunayn, tetramesh

if or( nx < 2 , or( ny < 2 , nz < 2 ) )
    error('Must be at least 2 points in all three directions!');
end

% Create a grid
[x,y,z] = meshgrid(linspace(0,1,nx),linspace(0,1,ny),linspace(0,1,nz));
V = [x(:) y(:) z(:)];
% meshgrid flips x and y ordering
idx = reshape(1:prod([ny,nx,nz]),[ny,nx,nz]);
% local vertex numbering
v1 = idx(1:end-1,1:end-1,1:end-1);v1=v1(:);
v2 = idx(1:end-1,2:end,1:end-1);v2=v2(:);
v3 = idx(2:end,1:end-1,1:end-1);v3=v3(:);
v4 = idx(2:end,2:end,1:end-1);v4=v4(:);
v5 = idx(1:end-1,1:end-1,2:end);v5=v5(:);
v6 = idx(1:end-1,2:end,2:end);v6=v6(:);
v7 = idx(2:end,1:end-1,2:end);v7=v7(:);
v8 = idx(2:end,2:end,2:end);v8=v8(:);

% cell dimensions
Cell_X = (1/(nx-1));
Cell_Y = (1/(ny-1));
Cell_Z = (1/(nz-1));

% create BCC coordinates
New_BCC = V(v1,:);
New_BCC(:,1) = New_BCC(:,1) + Cell_X/2;
New_BCC(:,2) = New_BCC(:,2) + Cell_Y/2;
New_BCC(:,3) = New_BCC(:,3) + Cell_Z/2;

Num_Cells = (nx-1) * (ny-1) * (nz-1);
if (size(New_BCC,1)~=Num_Cells)
    error('Number of cells does not match number of center vertices.');
end

v9 = (1:1:Num_Cells)' + size(V,1);
V = [V; New_BCC]; % v9 is linked to v1~v8

% get v10
v10 = zeros(Num_Cells,1); % init
[TF, LOC] = ismember(v2,v1); % find the v2's that are also v1's
% note: v2(TF) == v1(LOC(TF))
v10(TF,1) = v9(LOC(TF),1); % v10 corresponds to v9 at those
% create X-shifted BCC coordinates
New_BCC = V(v2(~TF),:);
New_BCC(:,1) = New_BCC(:,1) + Cell_X/2;
New_BCC(:,2) = New_BCC(:,2) + Cell_Y/2;
New_BCC(:,3) = New_BCC(:,3) + Cell_Z/2;
v10(~TF,1) = (1:1:size(New_BCC,1))' + size(V,1);
V = [V; New_BCC]; % v10 is linked to v2

% get v11
v11 = zeros(Num_Cells,1); % init
[TF, LOC] = ismember(v3,v1); % find the v3's that are also v1's
% note: v3(TF) == v1(LOC(TF))
v11(TF,1) = v9(LOC(TF),1); % v11 corresponds to v9 at those
% create Y-shifted BCC coordinates
New_BCC = V(v3(~TF),:);
New_BCC(:,1) = New_BCC(:,1) + Cell_X/2;
New_BCC(:,2) = New_BCC(:,2) + Cell_Y/2;
New_BCC(:,3) = New_BCC(:,3) + Cell_Z/2;
v11(~TF,1) = (1:1:size(New_BCC,1))' + size(V,1);
V = [V; New_BCC]; % v11 is linked to v3

% get v12
v12 = zeros(Num_Cells,1); % init
[TF, LOC] = ismember(v5,v1); % find the v5's that are also v1's
% note: v5(TF) == v1(LOC(TF))
v12(TF,1) = v9(LOC(TF),1); % v12 corresponds to v9 at those
% create Z-shifted BCC coordinates
New_BCC = V(v5(~TF),:);
New_BCC(:,1) = New_BCC(:,1) + Cell_X/2;
New_BCC(:,2) = New_BCC(:,2) + Cell_Y/2;
New_BCC(:,3) = New_BCC(:,3) + Cell_Z/2;
v12(~TF,1) = (1:1:size(New_BCC,1))' + size(V,1);
V = [V; New_BCC]; % v12 is linked to v5

% we DO NOT use the first vertex! (that is the origin)
V(1,:) = [];

end