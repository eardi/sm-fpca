function mesh = bcc_tetrahedral_cube(side_range,N)
%bcc_tetrahedral_cube
%
%   [T,V] = bcc_tetrahedral_mesh(side_range,N)
%
%   Generates a BCC lattice/tetrahedral mesh with dimensions (nx,ny,nz)
%
%   Input:
%     side_range [d_1, d_2] (x,y,z-dimensions of box)
%     N  number of points in x,y,z directions on grid
%   Output:
%     T  tetrahedra list of indices into V
%     V  list of vertex coordinates in 3D
%
%   Example
%     [T,V] = bcc_tetrahedral_mesh(3,3,3);
%     tetramesh(T,V); %also try tetramesh(T,V,'FaceAlpha',0);
%
% See also delaunayn, tetramesh

% generate the points (of the [0,1]^3)
V0 = bcc_tetrahedral_mesh_points_only(N,N,N);

% modify the points, so that an exact cube can be created

% find all vertices above the x=1, y=1, and z=1 planes
x1_mask = V0(:,1) > 1 + 1e-10;
y1_mask = V0(:,2) > 1 + 1e-10;
z1_mask = V0(:,3) > 1 + 1e-10;
V_ind = (1:1:size(V0,1))';
V0_x1_ind = V_ind(x1_mask,1);
V0_y1_ind = V_ind(y1_mask,1);
V0_z1_ind = V_ind(z1_mask,1);

% move those vertices to exactly the x=1, y=1, and z=1 planes
V0(V0_x1_ind,1) = 1;
V0(V0_y1_ind,2) = 1;
V0(V0_z1_ind,3) = 1;

% copy those vertices, and move to exactly the x=0, y=0, and z=0 planes
V1_x0 = V0(V0_x1_ind,:);
V1_x0(:,1) = 0;
V1_y0 = V0(V0_y1_ind,:);
V1_y0(:,2) = 0;
V1_z0 = V0(V0_z1_ind,:);
V1_z0(:,3) = 0;

% add the vertex at the origin
V1_O = [0,0,0];

% collect the vertices
mesh.V = [V0; V1_x0; V1_y0; V1_z0; V1_O];

% now, mesh it
mesh.T = delaunay(mesh.V);

% now, we need more info...
TR = triangulation(mesh.T,mesh.V);
All_Edges = sort(TR.edges(),2);
Edge_Vec = mesh.V(All_Edges(:,2),:) - mesh.V(All_Edges(:,1),:);
Edge_Len = sqrt(sum(Edge_Vec.^2,2));

% compute short and long edge lengths
long_edge_len = 1 / (N-1);
short_edge_len = (sqrt(3)/2) * long_edge_len;

% get short/long edges
long_mask  = (Edge_Len < 1.01*long_edge_len) & (Edge_Len > 0.99*long_edge_len);
short_mask = (Edge_Len < 1.01*short_edge_len) & (Edge_Len > 0.99*short_edge_len);

mesh.edge.long  = All_Edges(~short_mask,:); % the not short ones
mesh.edge.short = All_Edges(short_mask,:);

% get edge attachments
mesh.edge.short_attach = TR.edgeAttachments(mesh.edge.short);
mesh.edge.long_attach  = TR.edgeAttachments(mesh.edge.long);

% get vertex attachments
%mesh.vertex.attach = TR.vertexAttachments;
mesh.vertex.attach = [];

% record which vertices and edges are on the boundary
FF = TR.freeBoundary;
BDY_VTX = unique(FF(:));
mesh.vertex.bdy_indicator = false(size(mesh.V,1),1);
mesh.vertex.bdy_indicator(BDY_VTX,1) = true;
mesh.edge.short_bdy_indicator = (sum(ismember(mesh.edge.short, BDY_VTX),2)==2);
mesh.edge.long_bdy_indicator  = (sum(ismember(mesh.edge.long, BDY_VTX),2)==2);

% now do the scaling
side_len = side_range(2) - side_range(1);
if side_len <= 0
    error('Side length must be positive!');
end
mesh.V = side_len * mesh.V;
mesh.V(:,1) = mesh.V(:,1) + side_range(1);
mesh.V(:,2) = mesh.V(:,2) + side_range(1);
mesh.V(:,3) = mesh.V(:,3) + side_range(1);

% record edge lengths
%short_vec = mesh.V(mesh.edge.short(1,2),:) - mesh.V(mesh.edge.short(1,1),:);
mesh.edge.len.short = side_len * short_edge_len;
%long_vec = mesh.V(mesh.edge.long(1,2),:) - mesh.V(mesh.edge.long(1,1),:);
mesh.edge.len.long = side_len * long_edge_len;

end