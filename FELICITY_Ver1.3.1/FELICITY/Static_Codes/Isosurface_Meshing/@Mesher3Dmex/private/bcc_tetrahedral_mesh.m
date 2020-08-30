function mesh = bcc_tetrahedral_mesh(x_range,y_range,z_range,nx,ny,nz)
%bcc_tetrahedral_mesh
%
%   [T,V] = bcc_tetrahedral_mesh(x_range,y_range,z_range,nx,ny,nz)
%
%   Generates a BCC lattice/tetrahedral mesh with dimensions (nx,ny,nz)
%
%   Input:
%     x_range [x_1, x_2] (x-dimensions of box)
%     y_range [y_1, y_2] (y-dimensions of box)
%     z_range [z_1, z_2] (z-dimensions of box)
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
[x,y,z] = meshgrid(linspace(x_range(1),x_range(2),nx),...
                   linspace(y_range(1),y_range(2),ny),...
                   linspace(z_range(1),z_range(2),nz));
%
V = [x(:), y(:), z(:)];
% meshgrid flips x and y ordering
idx = reshape(1:1:prod([ny,nx,nz]),[ny,nx,nz]);
% local vertex numbering (y,x,z)
v1 = idx(1:end-1,1:end-1,1:end-1);v1=v1(:);
v2 = idx(1:end-1,2:end,1:end-1);v2=v2(:);
v3 = idx(2:end,1:end-1,1:end-1);v3=v3(:);
v4 = idx(2:end,2:end,1:end-1);v4=v4(:);
v5 = idx(1:end-1,1:end-1,2:end);v5=v5(:);
v6 = idx(1:end-1,2:end,2:end);v6=v6(:);
v7 = idx(2:end,1:end-1,2:end);v7=v7(:);
v8 = idx(2:end,2:end,2:end);v8=v8(:);

% cell dimensions
Cell_X = ( (x_range(2) - x_range(1)) / (nx-1) );
Cell_Y = ( (y_range(2) - y_range(1)) / (ny-1) );
Cell_Z = ( (z_range(2) - z_range(1)) / (nz-1) );

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
% make final vertex list
mesh.V = [V; New_BCC]; % v12 is linked to v5

% shift indices because we DO NOT use the first vertex!
mesh.V(1,:) = [];
clear v1;
v2 = v2 - 1;
v3 = v3 - 1;
v4 = v4 - 1;
v5 = v5 - 1;
v6 = v6 - 1;
v7 = v7 - 1;
v8 = v8 - 1;
v9 = v9 - 1;
v10 = v10 - 1;
v11 = v11 - 1;
v12 = v12 - 1;

% create the cell connectivity
mesh.T = [ ...
    v9  v6  v2  v10; % in the x-direction
    v9  v8  v6  v10;
    v9  v4  v8  v10;
    v9  v2  v4  v10;
    ...
    v9  v8  v4  v11; % in the y-direction
    v9  v7  v8  v11;
    v9  v3  v7  v11;
    v9  v4  v3  v11;
    ...
    v9  v5  v6  v12; % in the z-direction
    v9  v7  v5  v12;
    v9  v8  v7  v12;
    v9  v6  v8  v12];
%

% get short edges
edge_short_temp = sort(...
               [v2 v9;
                v3 v9;
                v4 v9;
                v5 v9;
                v6 v9;
                v7 v9;
                v8 v9;
                v2 v10;
                v4 v10;
                v6 v10;
                v8 v10;
                v3 v11;
                v4 v11;
                v7 v11;
                v8 v11;
                v5 v12;
                v6 v12;
                v7 v12;
                v8 v12],2);
mesh.edge.short = unique(edge_short_temp,'rows');
% get long edges
edge_long_temp = sort(...
               [v2 v4;
                v4 v8;
                v8 v6;
                v6 v2;
                ...
                v5 v6;
                v8 v7;
                v7 v5;
                ...
                v3 v4;
                v3 v7;
                ...
                v9 v10;
                v9 v11;
                v9 v12],2);
mesh.edge.long = unique(edge_long_temp,'rows');

TR = triangulation(mesh.T,mesh.V);

% get edge attachments
mesh.edge.short_attach = TR.edgeAttachments(mesh.edge.short);
mesh.edge.long_attach  = TR.edgeAttachments(mesh.edge.long);

% get vertex attachments
%mesh.vertex.attach = TR.vertexAttachments;
mesh.vertex.attach = [];

% record edge lengths
short_vec = mesh.V(mesh.edge.short(1,2),:) - mesh.V(mesh.edge.short(1,1),:);
mesh.edge.len.short = norm(short_vec);
long_vec = mesh.V(mesh.edge.long(1,2),:) - mesh.V(mesh.edge.long(1,1),:);
mesh.edge.len.long = norm(long_vec);

% record which vertices and edges are on the boundary
FF = TR.freeBoundary;
BDY_VTX = unique(FF(:));
mesh.vertex.bdy_indicator = false(size(mesh.V,1),1);
mesh.vertex.bdy_indicator(BDY_VTX,1) = true;
mesh.edge.short_bdy_indicator = (sum(ismember(mesh.edge.short, BDY_VTX),2)==2);
mesh.edge.long_bdy_indicator  = (sum(ismember(mesh.edge.long, BDY_VTX),2)==2);

end