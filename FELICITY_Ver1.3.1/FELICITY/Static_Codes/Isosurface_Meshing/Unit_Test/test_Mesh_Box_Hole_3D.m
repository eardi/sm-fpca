function status = test_Mesh_Box_Hole_3D()
%test_Mesh_Box_Hole_3D
%
%   Test code for FELICITY class.

% Copyright (c) 03-10-2020,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% create mesher object
tic
Cube_Dim = [0, 1];
Num_BCC_Points = 25;
Use_Newton = true;
TOL = 1e-12; % tolerance to use in computing the cut points
Exact_Cube = true; % indicate if background grid is an exact cube
% BCC mesh of the unit cube [0,1] x [0,1] x [0,1]
MG = Mesher3Dmex(Cube_Dim,Num_BCC_Points,Use_Newton,TOL,Exact_Cube);
toc

% define level set function
%%%%%%%%% SPHERE %%%%%%%%%%
LS = LS_Sphere();
% define level set function (sphere) (positive inside)
LS.Param.cx  = 0.5;
LS.Param.cy  = 0.5;
LS.Param.cz  = 0.5;
LS.Param.rad = 0.1;
LS.Param.sign = -1; % positive outside

% setup up handle to interpolation routine
Interp_Handle = @(pt) LS.Interpolate(pt);

tic
MG = MG.Get_Cut_Info(Interp_Handle);
toc
tic
[TET, VTX] = MG.run_mex(Interp_Handle);
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

% get separate boundaries
FF = MT.freeBoundary;
BC = (1/3) * (MT.Points(FF(:,1),:) + MT.Points(FF(:,2),:) + MT.Points(FF(:,3),:));
TEMP = [BC(:,1) - LS.Param.cx, BC(:,2) - LS.Param.cy, BC(:,3) - LS.Param.cz];
BC_Dist = sqrt(sum(TEMP.^2,2));
Outer_Mask = BC_Dist > 1.2 * LS.Param.rad;
Inner_Mask = ~Outer_Mask;
MT = MT.Append_Subdomain('2D','Outer_Surface',FF(Outer_Mask,:));
MT = MT.Append_Subdomain('2D','Inner_Surface',FF(Inner_Mask,:));

Outer_SurfMesh = MT.Output_Subdomain_Mesh('Outer_Surface');
Inner_SurfMesh = MT.Output_Subdomain_Mesh('Inner_Surface');

% plot outer/inner surfaces of mesh
figure;

% MT.Plot_Subdomain('Outer_Surface');
% Upper_Mask = (SurfMesh.Points(ST(:,1),3) > 0.5);
subplot(1,2,1);
pt = trimesh(Outer_SurfMesh.ConnectivityList,Outer_SurfMesh.Points(:,1),Outer_SurfMesh.Points(:,2),Outer_SurfMesh.Points(:,3));
set(pt,'edgecolor',1*[0 0 0]); % make mesh edges black
AZ = -30;
EL = 25;
view(AZ,EL);
% hold on;
% surf(x,y,z);
% %colormap hsv;
% alpha(0.2);
% hold off;
axis equal;
grid on;
title('Outer Surface of Output Mesh');

subplot(1,2,2);
pt = trimesh(Inner_SurfMesh.ConnectivityList,Inner_SurfMesh.Points(:,1),Inner_SurfMesh.Points(:,2),Inner_SurfMesh.Points(:,3));
set(pt,'edgecolor',1*[0 0 0]); % make mesh edges black
AZ = -40;
EL = 30;
view(AZ,EL);
% hold on;
% surf(x,y,z);
% %colormap hsv;
% alpha(0.2);
% hold off;
axis equal;
grid on;
title('Inner Surface of Output Mesh');


disp('Surface Mesh (Triangles) Angle Range (degrees):');
Surf_Angles = (180/pi) * Outer_SurfMesh.Angles;
Max_Surf_Angle = max(Surf_Angles(:));
Min_Surf_Angle = min(Surf_Angles(:));
STR_MAX = ['Maximum Angle: ', num2str(Max_Surf_Angle,'%3.6g')];
disp(STR_MAX);
STR_MIN = ['Minimum Angle: ', num2str(Min_Surf_Angle,'%3.6g')];
disp(STR_MIN);


% make a nice plot of surface
figure;
subplot(1,2,1);
p2 = patch('Vertices', MT.Points, 'Faces', FF(Outer_Mask,:));
LSU_PURPLE = 2.5*[36 0 84]/255; % brighten it
set(p2,'FaceColor',LSU_PURPLE,'EdgeColor','none');
%set(p2,'FaceColor','magenta','EdgeColor','none');
daspect([1,1,1])
view(3); axis tight
AZ1 = -30;
EL1 = 25;
view(AZ1,EL1);
AZ2 = -80;
EL2 = 10;
camlight(AZ2,EL2);
lighting gouraud;
title('Outer Surface of Output Mesh');

subplot(1,2,2);
p2 = patch('Vertices', MT.Points, 'Faces', FF(Inner_Mask,:));
set(p2,'FaceColor',LSU_PURPLE,'EdgeColor','none');
%set(p2,'FaceColor','magenta','EdgeColor','none');
daspect([1,1,1])
view(3); axis tight
AZ1 = -40;
EL1 = 25;
view(AZ1,EL1);
AZ2 = -80;
EL2 = 10;
camlight(AZ2,EL2);
lighting gouraud;
title('Inner Surface of Output Mesh');
grid on;

status = 0; % init
% verify that angle bounds are satisfied
if or(New_Min_Angle < 8.54, New_Max_Angle > 164.18) % degrees
    disp(['Test Failed!']);
    status = 1;
end

end