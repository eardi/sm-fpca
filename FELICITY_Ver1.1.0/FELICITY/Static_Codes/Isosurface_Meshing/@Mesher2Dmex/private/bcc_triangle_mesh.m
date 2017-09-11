function mesh = bcc_triangle_mesh(x_range,y_range,nx,ny)
%bcc_triangle_mesh
%
%   [T,V] =  bcc_triangle_mesh(x_range,y_range,nx,ny)
%
%   Generates a "BCC" 2-D lattice/triangle mesh with dimensions (nx,ny)
%   Note: this is the standard 2-D criss-cross grid.
%
%   Input:
%     x_range [x_1, x_2] (x-dimensions of box)
%     y_range [y_1, y_2] (y-dimensions of box)
%     nx      number of points in x direction on grid
%     ny      number of points in y direction on grid
%   Output:
%     T  triangle list of indices into V
%     V  list of vertex coordinates in 3D
%
%   Example
%     [T,V] = bcc_triangle_mesh(3,3);
%     trimesh(T,V(:,1),V(:,2));
%
% See also delaunay, trimesh

if or( nx < 2 , ny < 2 )
    error('Must be at least 2 points in all two directions!');
end

% Create a grid
[x,y] = meshgrid(linspace(x_range(1),x_range(2),nx),linspace(y_range(1),y_range(2),ny));
V = [x(:) y(:)];
% meshgrid flips x and y ordering
idx = reshape(1:prod([ny,nx]),[ny,nx]);
% local vertex numbering
v1 = idx(1:end-1,1:end-1);v1=v1(:);
v2 = idx(2:end,1:end-1);v2=v2(:);
v3 = idx(1:end-1,2:end);v3=v3(:);
v4 = idx(2:end,2:end);v4=v4(:);

% cell dimensions
Cell_X = ( (x_range(2) - x_range(1)) / (nx-1) );
Cell_Y = ( (y_range(2) - y_range(1)) / (ny-1) );

% create BCC coordinates
New_BCC = V(v1,:);
New_BCC(:,1) = New_BCC(:,1) + Cell_X/2;
New_BCC(:,2) = New_BCC(:,2) + Cell_Y/2;

Num_Cells = (nx-1) * (ny-1);
if (size(New_BCC,1)~=Num_Cells)
    error('Number of cells does not match number of center vertices.');
end

v5 = (1:1:Num_Cells)' + size(V,1);
mesh.V = [V; New_BCC]; % v5 is linked to v1~v4

% create the cell connectivity
mesh.T = [ ...
    v1  v3  v5;
    v3  v4  v5;
    v4  v2  v5;
    v2  v1  v5];
%

% get short edges
edge_short_temp = sort(...
               [v1 v5;
                v2 v5;
                v3 v5;
                v4 v5],2);
mesh.edge.short = unique(edge_short_temp,'rows');
% get long edges
edge_long_temp = sort(...
               [v1 v2;
                v1 v3;
                v2 v4;
                v3 v4],2);
mesh.edge.long = unique(edge_long_temp,'rows');

TR = TriRep(mesh.T,mesh.V);

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