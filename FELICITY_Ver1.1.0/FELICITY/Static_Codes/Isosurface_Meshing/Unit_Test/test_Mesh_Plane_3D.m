function status = test_Mesh_Plane_3D()
%test_Mesh_Plane_3D
%
%   Test code for FELICITY class.

% Copyright (c) 03-16-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% create mesher object
tic
Cube_Dim = [0, 1];
Num_BCC_Points = 25;
Use_Newton = true;
TOL = 1e-12; % tolerance to use in computing the cut points
% BCC mesh of the unit cube [0,1] x [0,1] x [0,1]
MG = Mesher3Dmex(Cube_Dim,Num_BCC_Points,Use_Newton,TOL);
toc

% define level set function
%%%%%%%%% PLANE %%%%%%%%%%
LS = LS_Plane();
% define level set function (plane) (positive above)
LS.Param.X0  = [0, 0.1, 0.6];
N_temp = [1, 1, 1];
LS.Param.N0  = N_temp / norm(N_temp); % normalize

tic
MG = MG.Get_Cut_Info(LS);
toc
tic
[TET, VTX] = MG.run_mex(LS);
toc

% create mesh object
MT = MeshTetrahedron(TET, VTX, 'Test');

disp(' ');
disp('==========================================================');
disp('New Mesh Stats');

disp('Max and Min Volume of Cells:');
New_Vol = MT.Volume;
Min_New_Vol = min(New_Vol);
Max_New_Vol = max(New_Vol);
Max_New_Vol
Min_New_Vol

disp('Dihedral Angle Range (degrees):');
MT_Angles = (180/pi) * MT.Angles;
New_Max_Angle = max(MT_Angles(:));
New_Min_Angle = min(MT_Angles(:));
STR_MAX = ['Maximum Angle: ', num2str(New_Max_Angle,'%3.6g')];
disp(STR_MAX);
STR_MIN = ['Minimum Angle: ', num2str(New_Min_Angle,'%3.6g')];
disp(STR_MIN);

% make histogram
A_min = min(MT_Angles,[],2);
A_max = max(MT_Angles,[],2);

% figure;
% subplot(1,2,1);
% hist(A_min,100);
% title('Min Angle (degrees)');
% subplot(1,2,2);
% hist(A_max,100);
% title('Max Angle (degrees)');

% plot surface of mesh
figure;
FF = MT.freeBoundary;
MT = MT.Append_Subdomain('2D','Surface',FF);
SurfMesh = MT.Output_Subdomain_Mesh('Surface');
% MT.Plot_Subdomain('Surface');
ST = SurfMesh.Triangulation;
% Upper_Mask = (SurfMesh.X(ST(:,1),3) > 0.5);
pt = trimesh(ST,SurfMesh.X(:,1),SurfMesh.X(:,2),SurfMesh.X(:,3));
set(pt,'edgecolor',1*[0 0 0]); % make mesh edges black
AZ = -70;
EL = -10;
view(AZ,EL);
% hold on;
% surf(x,y,z);
% %colormap hsv;
% alpha(0.2);
% hold off;
axis equal;
grid on;
title('Surface of Output Mesh');

disp('Surface Mesh (Triangles) Angle Range (degrees):');
Surf_Angles = (180/pi) * SurfMesh.Angles;
Max_Surf_Angle = max(Surf_Angles(:));
Min_Surf_Angle = min(Surf_Angles(:));
STR_MAX = ['Maximum Angle: ', num2str(Max_Surf_Angle,'%3.6g')];
disp(STR_MAX);
STR_MIN = ['Minimum Angle: ', num2str(Min_Surf_Angle,'%3.6g')];
disp(STR_MIN);

status = 0; % init
% verify that angle bounds are satisfied
if or(New_Min_Angle < 8.54, New_Max_Angle > 164.18) % degrees
    disp(['Test Failed!']);
    status = 1;
end

end