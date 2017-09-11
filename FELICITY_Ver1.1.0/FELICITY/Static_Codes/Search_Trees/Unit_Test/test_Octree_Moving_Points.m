function status = test_Octree_Moving_Points()
%test_Octree_Moving_Points
%
%   Test code for FELICITY class.

% Copyright (c) 01-15-2014,  Shawn W. Walker

status = 0; % init
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% create a structured set of points
NUM = 500;
z_points = linspace(0.2,0.8,NUM)';
x_points = 0.25*(cos(4*pi*z_points) + 1) + 0.25;
y_points = 0.25*(sin(4*pi*z_points) + 1) + 0.25;
points = [x_points, y_points, z_points];

disp('create Octree...');
BB = [-0.001, 1.001, -0.001, 1.001, -0.001, 1.001];
Max_Tree_Levels = 32;
Bucket_Size = 20;
tic
OT = mexOctree(points,BB);%,Max_Tree_Levels,Bucket_Size);
toc
clear points x_points y_points z_points;

% extract data describing octree
Tree_Data_1 = OT.Get_Tree_Data;
% store this as reference data
RefDataFileName_1 = fullfile(Current_Dir,'FEL_Octree_1_REF_Data.mat');
% Tree_Data_1_REF = Tree_Data_1;
% save(RefDataFileName_1,'Tree_Data_1_REF');
load(RefDataFileName_1);

disp('plot the Octree...');
tic
FH = OT.Plot_Tree;
toc
hold on;
plot3(OT.Points(:,1),OT.Points(:,2),OT.Points(:,3),'k-','LineWidth',2.0);
hold off;
AX = [0 1 0 1 0 1];
axis(AX);
axis equal;
title('Octree: Initial Points');

% move the points
rot_pts = [OT.Points(:,1) - 0.5, OT.Points(:,2) - 0.5, OT.Points(:,3) - 0.5];

% rotate!
ANG = 75 * pi/180;
R = rotationmat3D(ANG,[1 1 1]);
rot_pts = rot_pts * R';
rot_pts = rot_pts + 0.5; % shift back
disp('update the Octree with the rotated points:');
tic
OT = OT.Update_Tree(rot_pts);
toc
clear rot_pts;

disp('plot the Octree...');
tic
FH = OT.Plot_Tree;
toc
hold on;
plot3(OT.Points(:,1),OT.Points(:,2),OT.Points(:,3),'k-','LineWidth',2.0);
hold off;
AX = [0 1 0 1 0 1];
axis(AX);
axis equal;
title('Octree: Rotated Points');

% delete the C++ object
delete(OT);

% compare to reference data
if ~isequal(Tree_Data_1_REF,Tree_Data_1)
    disp(['Test Failed for Tree_Data_1...']);
    status = 1;
end

end

function R = rotationmat3D(r,Axis)
%function R = rotationmat3D(radians,Axis)
%
% creates a rotation matrix such that R * x 
% operates on x by rotating x around the origin r radians around line
% connecting the origin to the point "Axis"
%
% example:
% rotate around a random direction a random amount and then back
% the result should be an Identity matrix
%
%r = rand(4,1);
%rotationmat3D(r(1),[r(2),r(3),r(4)]) * rotationmat3D(-r(1),[r(2),r(3),r(4)])
%
% example2: 
% rotate around z axis 45 degrees
% Rtest = rotationmat3D(pi/4,[0 0 1])
%
%Bileschi 2009
% if nargin == 1
%    if(length(rotX) == 3)
%       rotY = rotX(2);
%       rotZ = rotZ(3);
%       rotX = rotX(1);
%    end
% end

% useful intermediates
L = norm(Axis);
if (L < eps)
   error('axis direction must be non-zero vector');
end
Axis = Axis / L;
L = 1;
u = Axis(1);
v = Axis(2);
w = Axis(3);
u2 = u^2;
v2 = v^2;
w2 = w^2;
c = cos(r);
s = sin(r);
%storage
R = nan(3);
%fill
R(1,1) =  u2 + (v2 + w2)*c;
R(1,2) = u*v*(1-c) - w*s;
R(1,3) = u*w*(1-c) + v*s;
R(2,1) = u*v*(1-c) + w*s;
R(2,2) = v2 + (u2+w2)*c;
R(2,3) = v*w*(1-c) - u*s;
R(3,1) = u*w*(1-c) - v*s;
R(3,2) = v*w*(1-c)+u*s;
R(3,3) = w2 + (u2+v2)*c;

end