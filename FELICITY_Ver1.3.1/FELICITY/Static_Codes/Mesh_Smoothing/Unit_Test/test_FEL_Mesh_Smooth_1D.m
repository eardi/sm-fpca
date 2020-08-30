function status = test_FEL_Mesh_Smooth_1D()
%test_FEL_Mesh_Smooth_1D
%
%   Test code for FELICITY class.

% Copyright (c) 04-23-2013,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

N_pts = 100+1;
Vtx = linspace(0,1,N_pts)';
Vtx_Indices = (1:1:length(Vtx))';
Elem = [Vtx_Indices(1:end-1,1), Vtx_Indices(2:end,1)];
MI = MeshInterval(Elem,Vtx,'Uniform');
fB = MI.freeBoundary;
Vtx_Attach = MI.vertexAttachments;
Vol = MI.Volume;
Bin_X = linspace(0.1*mean(Vol),2*mean(Vol),11);
clear MI;
Bdy_Vtx_Indices = unique(fB(:));

disp('Number of Vertices and Elements:');
[size(Vtx,1), size(Elem,1)]

% perturb = 1.2 * (1/N_pts) * (rand(size(Vtx,1),1) - 0.5);
% perturb(Bdy_Vtx_Indices,1) = 0;
% Vtx_perturb = Vtx + perturb;
RefDataFileName = fullfile(Current_Dir,'FEL_Mesh_Smooth_1D_REF_Data.mat');
load(RefDataFileName);

figure;
subplot(1,2,1);
MI_perturb = MeshInterval(Elem,Vtx_perturb,'Perturbed');
Vol = MI_perturb.Volume;
hist(Vol,Bin_X);
title('Element Volumes (Perturbed Mesh)');

Num_Sweeps = 2;
Vtx_Indices_To_Update = setdiff((1:1:size(Vtx_perturb,1))',Bdy_Vtx_Indices);
New_Vtx = FEL_Mesh_Smooth(Vtx_perturb,Elem,Vtx_Attach,Vtx_Indices_To_Update,Num_Sweeps);

subplot(1,2,2);
MI_smooth = MeshInterval(Elem,New_Vtx,'Smoothed');
Vol = MI_smooth.Volume;
hist(Vol,Bin_X);
title('Element Volumes (Smoothed Mesh)');

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