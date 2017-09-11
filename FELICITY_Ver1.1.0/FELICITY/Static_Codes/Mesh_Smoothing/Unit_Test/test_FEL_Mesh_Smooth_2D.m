function status = test_FEL_Mesh_Smooth_2D()
%test_FEL_Mesh_Smooth_2D
%
%   Test code for FELICITY class.

% Copyright (c) 04-23-2013,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

N_pts = 40+1;
[Elem, Vtx] = bcc_triangle_mesh(N_pts,N_pts);
TR = TriRep(Elem,Vtx);
fB = TR.freeBoundary;
Vtx_Attach = TR.vertexAttachments;
clear TR;
Bdy_Vtx_Indices = unique(fB(:));

disp('Number of Vertices and Elements:');
[size(Vtx,1), size(Elem,1)]

% perturb = 0.7 * (1/N_pts) * (rand(size(Vtx,1),2) - 0.5);
% perturb(Bdy_Vtx_Indices,1) = 0;
% perturb(Bdy_Vtx_Indices,2) = 0;
% Vtx_perturb = Vtx + perturb;
RefDataFileName = fullfile(Current_Dir,'FEL_Mesh_Smooth_2D_REF_Data.mat');
load(RefDataFileName);

figure;
subplot(1,2,1);
trimesh(Elem,Vtx_perturb(:,1),Vtx_perturb(:,2),0*Vtx_perturb(:,2));
view(2);
axis([0 1 0 1]);
axis equal;
axis([0 1 0 1]);
title('Perturbed Mesh');

Num_Sweeps = 2;
Vtx_Indices_To_Update = setdiff((1:1:size(Vtx_perturb,1))',Bdy_Vtx_Indices);
New_Vtx = FEL_Mesh_Smooth(Vtx_perturb,Elem,Vtx_Attach,Vtx_Indices_To_Update,Num_Sweeps);

subplot(1,2,2);
trimesh(Elem,New_Vtx(:,1),New_Vtx(:,2),0*New_Vtx(:,2));
view(2);
axis([0 1 0 1]);
axis equal;
axis([0 1 0 1]);
title('Smoothed Mesh (2 Gauss-Seidel Iterations)');

% New_Vtx_REF = New_Vtx;
% save(RefDataFileName,'Vtx_perturb','New_Vtx_REF');

status = 0; % init
% compare to reference data
ERROR = max(abs(New_Vtx(:) - New_Vtx_REF(:)));
if (ERROR > 4e-15)
    disp(['Test Failed...']);
    status = 1;
end

end