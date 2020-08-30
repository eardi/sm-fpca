function status = Execute_Example_DoF_Gen_2D(mexName)
%Execute_Example_DoF_Gen_2D
%
%   Demo code for FELICITY Auto-Generated DoF Allocation Code (in 2-D).

% Copyright (c) 01-01-2011,  Shawn W. Walker

% load up the 'standard' triangulation
[Vtx, Tri] = Standard_Triangle_Mesh_Test_Data();

% plot the mesh
figure;
p1 = trimesh(Tri,Vtx(:,1),Vtx(:,2),0*Vtx(:,2));
view(2);
axis equal;
shading interp;
set(p1,'edgecolor','k'); % make mesh black
title('Sample Mesh for Automatic DoF Allocation Test');

% allocate DoFs
tic
[P1_DoFmap, P2_DoFmap] = feval(str2func(mexName),uint32(Tri));
toc

disp('-----------------------');
disp('P1 DoFmap:');
disp(P1_DoFmap);
disp('-----------------------');
disp('P2 DoFmap:');
disp(P2_DoFmap);
disp('-----------------------');

% BEGIN: load reference data
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefFEMDataFileName = fullfile(Current_Dir,'Example_DoF_Gen_2D_REF_Data.mat');
% P1_DoFmap_REF = P1_DoFmap;
% P2_DoFmap_REF = P2_DoFmap;
% save(RefFEMDataFileName,'P1_DoFmap_REF','P2_DoFmap_REF');
load(RefFEMDataFileName);
% END: load reference data

status = 0; % init
% compare to reference data
P1_DoF_ERROR = max(abs(P1_DoFmap(:) - P1_DoFmap_REF(:)));
P2_DoF_ERROR = max(abs(P2_DoFmap(:) - P2_DoFmap_REF(:)));
if ~(P1_DoF_ERROR==0)
    disp('Test Failed for P1_DoFmap.');
    status = 1;
elseif ~(P2_DoF_ERROR==0)
    disp('Test Failed for P2_DoFmap.');
    status = 1;
else
    disp('Test passed!');
end

end