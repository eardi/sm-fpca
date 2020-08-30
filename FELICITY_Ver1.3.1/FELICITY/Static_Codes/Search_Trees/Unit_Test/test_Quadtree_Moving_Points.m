function status = test_Quadtree_Moving_Points()
%test_Quadtree_Moving_Points
%
%   Test code for FELICITY class.

% Copyright (c) 01-14-2014,  Shawn W. Walker

status = 0; % init
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% create a structured set of points
NUM = 2000;
x_points = linspace(0.25,0.75,NUM)';
y_points = 0.25*(sin(4*pi*(x_points - 0.5)) + 1) + 0.25;
points = [x_points, y_points];

disp('create Quadtree...');
BB = [-0.001, 1.001, -0.001, 1.001];
Max_Tree_Levels = 32;
Bucket_Size = 20;
tic
QT = mexQuadtree(points,BB);%,Max_Tree_Levels,Bucket_Size);
toc
clear points x_points y_points;

% extract data describing quadtree
Tree_Data_1 = QT.Get_Tree_Data;
% store this as reference data
RefDataFileName_1 = fullfile(Current_Dir,'FEL_Quadtree_1_REF_Data.mat');
% Tree_Data_1_REF = Tree_Data_1;
% save(RefDataFileName_1,'Tree_Data_1_REF');
load(RefDataFileName_1);

disp('plot the Quadtree...');
tic
FH = QT.Plot_Tree;
toc
hold on;
plot(QT.Points(:,1),QT.Points(:,2),'k-','LineWidth',2.0);
hold off;
AX = [0 1 0 1];
axis(AX);
axis square;
title('Quadtree: Initial Points');

% move the points
rot_pts = [QT.Points(:,1) - 0.5, QT.Points(:,2) - 0.5];
% rotate!
ANG = 65 * pi/180;
R = [cos(ANG), -sin(ANG);
     sin(ANG), cos(ANG)];
rot_pts = rot_pts * R';
rot_pts = rot_pts + 0.5; % shift back
disp('update the Quadtree with the rotated points:');
tic
QT = QT.Update_Tree(rot_pts);
toc
clear rot_pts;

disp('plot the Quadtree...');
tic
FH = QT.Plot_Tree;
toc
hold on;
plot(QT.Points(:,1),QT.Points(:,2),'k-','LineWidth',2.0);
hold off;
AX = [0 1 0 1];
axis(AX);
axis square;
title('Quadtree: Rotated Points');

% delete the C++ object
delete(QT);

% compare to reference data
if ~isequal(Tree_Data_1_REF,Tree_Data_1)
    disp(['Test Failed for Tree_Data_1...']);
    status = 1;
end

end