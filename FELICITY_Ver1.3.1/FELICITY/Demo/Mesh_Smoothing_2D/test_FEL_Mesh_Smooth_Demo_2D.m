function status = test_FEL_Mesh_Smooth_Demo_2D()
%test_FEL_Mesh_Smooth_Demo_2D
%
%   Test code for FELICITY class.

% Copyright (c) 04-24-2013,  Shawn W. Walker

% create mesh of unit square
N_pts = 30+1;
[Elem, Vtx] = bcc_triangle_mesh(N_pts,N_pts);
TR = TriRep(Elem,Vtx);
fB = TR.freeBoundary;
Bdy_Vtx_Indices = unique(fB(:));
Vtx_Attach = TR.vertexAttachments;
clear TR;

disp('Number of Vertices and Elements:');
[size(Vtx,1), size(Elem,1)]

% deform mesh
STD = 0.1;
%Gauss = @(x,y) exp(-(x.^2 + y.^2)/STD);
Gauss_x = @(xx) -(2/STD) * (xx(:,1) - 0.5) .* exp(-((xx(:,1) - 0.5).^2 + (xx(:,2) - 0.5).^2)/STD);
Gauss_y = @(xx) -(2/STD) * (xx(:,2) - 0.5) .* exp(-((xx(:,1) - 0.5).^2 + (xx(:,2) - 0.5).^2)/STD);
displace = (0.5*STD) * [Gauss_x(Vtx), Gauss_y(Vtx)];
% set the displacement to zero on the boundary
displace(Bdy_Vtx_Indices,1) = 0;
displace(Bdy_Vtx_Indices,2) = 0;
Vtx_displace = Vtx + displace;

figure;
subplot(1,2,1);
trimesh(Elem,Vtx_displace(:,1),Vtx_displace(:,2),0*Vtx_displace(:,2));
view(2);
AX = [0 1 0 1];
axis(AX);
axis equal;
axis(AX);
title('Deformed Mesh');

% optimize mesh vertices
Num_Sweeps = 30;
Vtx_Indices_To_Update = setdiff((1:1:size(Vtx_displace,1))',Bdy_Vtx_Indices);
Vtx_Smooth_1 = FEL_Mesh_Smooth(Vtx_displace,Elem,Vtx_Attach,Vtx_Indices_To_Update,Num_Sweeps);

subplot(1,2,2);
trimesh(Elem,Vtx_Smooth_1(:,1),Vtx_Smooth_1(:,2),0*Vtx_Smooth_1(:,2));
view(2);
axis(AX);
axis equal;
axis(AX);
title('Smoothed Mesh After 30 Gauss-Seidel Iterations');

% perturb mesh
displace = 0.5 * (1/N_pts) * (rand(size(Vtx,1),2) - 0.5);
% set the displacement to zero on the boundary
displace(Bdy_Vtx_Indices,1) = 0;
displace(Bdy_Vtx_Indices,2) = 0;
Vtx_perturb = Vtx + displace;

figure;
subplot(1,2,1);
trimesh(Elem,Vtx_perturb(:,1),Vtx_perturb(:,2),0*Vtx_perturb(:,2));
view(2);
AX = [0 1 0 1];
axis(AX);
axis equal;
axis(AX);
title('Perturbed Mesh');

% optimize mesh vertices
Num_Sweeps = 2;
Vtx_Smooth_2 = FEL_Mesh_Smooth(Vtx_perturb,Elem,Vtx_Attach,Vtx_Indices_To_Update,Num_Sweeps);

subplot(1,2,2);
trimesh(Elem,Vtx_Smooth_2(:,1),Vtx_Smooth_2(:,2),0*Vtx_Smooth_2(:,2));
view(2);
axis(AX);
axis equal;
axis(AX);
title('Smoothed Mesh After 2 Gauss-Seidel Iterations');

status = 0; % just say it passed

end