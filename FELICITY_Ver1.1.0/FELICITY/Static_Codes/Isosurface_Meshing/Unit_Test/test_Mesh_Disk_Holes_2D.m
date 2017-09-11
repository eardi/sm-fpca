function status = test_Mesh_Disk_Holes_2D()
%test_Mesh_Disk_Holes_2D
%
%   Test code for FELICITY class.

% Copyright (c) 03-16-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% create mesher object
tic
Box_Dim = [0, 1];
Num_BCC_Points = 31;
Use_Newton = false;
TOL = 1e-2; % tolerance to use in computing the cut points
% BCC mesh of the unit square [0,1] x [0,1]
MG = Mesher2Dmex(Box_Dim,Num_BCC_Points,Use_Newton,TOL);
toc

% define level set function
%%%%%%%%% Disk with Holes %%%%%%%%%%
LS = LS_Many_Ellipses();
LS.Param.rad_x = [0.45, 0.1, 0.2];
LS.Param.rad_y = [0.45, 0.2, 0.1];
LS.Param.cx    = [0.5, 0.35, 0.65];
LS.Param.cy    = [0.5, 0.35, 0.65];
LS.Param.sign  = [1, -1, -1];

tic
MG = MG.Get_Cut_Info(LS);
toc
tic
[TRI, VTX] = MG.run_mex(LS);
toc

% create mesh object
MT = MeshTriangle(TRI, VTX, 'Test');

disp(' ');
disp('==========================================================');
disp('New Mesh Stats');

disp('Max and Min Volume of Cells:');
New_Vol = MT.Volume;
Min_New_Vol = min(New_Vol);
Max_New_Vol = max(New_Vol);
Max_New_Vol
Min_New_Vol

disp('Angle Range (degrees):');
MT_Angles = (180/pi) * MT.Angles;
New_Max_Angle = max(MT_Angles(:));
New_Min_Angle = min(MT_Angles(:));
STR_MAX = ['Maximum Angle: ', num2str(New_Max_Angle,'%3.6g')];
disp(STR_MAX);
STR_MIN = ['Minimum Angle: ', num2str(New_Min_Angle,'%3.6g')];
disp(STR_MIN);

% plot surface of mesh
figure;
MT.Plot;
axis equal;
grid on;
title('Output Mesh');

status = 0; % init
% verify that angle bounds are satisfied
if or(New_Min_Angle < 10.0, New_Max_Angle > 160.0) % degrees
    disp(['Test Failed!']);
    status = 1;
end

end