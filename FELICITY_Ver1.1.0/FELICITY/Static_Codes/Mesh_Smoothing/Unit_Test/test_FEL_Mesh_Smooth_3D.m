function status = test_FEL_Mesh_Smooth_3D()
%test_FEL_Mesh_Smooth_3D
%
%   Test code for FELICITY class.

% Copyright (c) 04-23-2013,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

N_pts = 20+1;
[Elem,Vtx] = bcc_tetrahedral_mesh(N_pts,N_pts,N_pts);
TR = TriRep(Elem,Vtx);
fB = TR.freeBoundary;
Vtx_Attach = TR.vertexAttachments;
clear TR;
Bdy_Vtx_Indices = unique(fB(:));

disp('Number of Vertices and Elements:');
[size(Vtx,1), size(Elem,1)]

% perturb = 0.55 * (1/N_pts) * (rand(size(Vtx,1),3) - 0.5);
% perturb(Bdy_Vtx_Indices,1) = 0;
% perturb(Bdy_Vtx_Indices,2) = 0;
% perturb(Bdy_Vtx_Indices,3) = 0;
% Vtx_perturb = Vtx + perturb;
RefDataFileName = fullfile(Current_Dir,'FEL_Mesh_Smooth_3D_REF_Data.mat');
load(RefDataFileName);

MT_perturb = MeshTetrahedron(Elem,Vtx_perturb,'Perturbed');
Ang = MT_perturb.Angles * 180/pi;
disp('Min and Max Dihedral Angles of perturbed mesh (degrees):');
[min(Ang(:)), max(Ang(:))]
disp(' ');
disp(' ');

disp('Smooth Mesh with 2 Gauss-Seidel Iterations...');
Num_Sweeps = 2;
Vtx_Indices_To_Update = setdiff((1:1:size(Vtx_perturb,1))',Bdy_Vtx_Indices);
New_Vtx = FEL_Mesh_Smooth(Vtx_perturb,Elem,Vtx_Attach,Vtx_Indices_To_Update,Num_Sweeps);

disp(' ');
disp(' ');

MT_new = MeshTetrahedron(Elem,New_Vtx,'Smoothed');
Ang = MT_new.Angles * 180/pi;
disp('Min and Max Dihedral Angles of *smoothed* mesh (degrees):');
[min(Ang(:)), max(Ang(:))]

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