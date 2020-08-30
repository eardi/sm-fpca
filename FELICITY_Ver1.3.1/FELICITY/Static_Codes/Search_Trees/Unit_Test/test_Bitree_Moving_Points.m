function status = test_Bitree_Moving_Points()
%test_Bitree_Moving_Points
%
%   Test code for FELICITY class.

% Copyright (c) 01-14-2014,  Shawn W. Walker

status = 0; % init
current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% create a structured set of points
NUM = 200;
pt1 = linspace(0.25,0.75,NUM)';
points = pt1.^3; % non-uniform map

disp('create Bitree...');
BB = [-0.001, 1.001];
Max_Tree_Levels = 32;
Bucket_Size = 20;
tic
BT = mexBitree(points,BB);%,Max_Tree_Levels,Bucket_Size);
toc
clear points;

% extract data describing bitree
Tree_Data_1 = BT.Get_Tree_Data;
% store this as reference data
RefDataFileName_1 = fullfile(Current_Dir,'FEL_Bitree_1_REF_Data.mat');
% Tree_Data_1_REF = Tree_Data_1;
% save(RefDataFileName_1,'Tree_Data_1_REF');
load(RefDataFileName_1);

disp('plot the Bitree...');
tic
FH = BT.Plot_Tree;
toc
hold on;
plot(BT.Points(:,1),0*BT.Points(:,1),'k.');
hold off;
AX = [0 1 -0.5 0.5];
axis(AX);
axis square;
title('Bitree: Initial Points');

% move the points
mov_pts = BT.Points + 0.7*cos(1.5*pi*BT.Points);
disp('update the Bitree with the moved points:');
tic
BT = BT.Update_Tree(mov_pts);
toc
clear mov_pts;

disp('plot the Bitree...');
tic
FH = BT.Plot_Tree;
toc
hold on;
plot(BT.Points(:,1),0*BT.Points(:,1),'k.');
hold off;
AX = [0 1 -0.5 0.5];
axis(AX);
axis square;
title('Bitree: Moved Points');

% delete the C++ object
delete(BT);

% compare to reference data
if ~isequal(Tree_Data_1_REF,Tree_Data_1)
    disp(['Test Failed for Tree_Data_1...']);
    status = 1;
end

end