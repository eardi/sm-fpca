% test quadtree (informal test code...)
%
% test_Quadtree
clc;
close all force;
clear all;
clear classes;

% disp('test timing:');
% tic
% mex_test();
% toc

NUM = 1000000;
points = rand(NUM,2);
% points = 0.3*rand(NUM,2);
% points = points + 0.2*points;
% points = [points; points + 0.5];
%points = [0.0, 0.0; points; 1.0, 1.0];
%points

PT = [0.234, 0.6134];
tic
X_Diff = points(:,1) - PT(1);
Y_Diff = points(:,2) - PT(2);
Dist = sqrt(X_Diff.^2 + Y_Diff.^2);
[Y, PI] = min(Dist);
toc

disp('create quad-tree...');
BB = [-0.001, 1.001, -0.001, 1.001];
Max_Tree_Levels = 32;
Bucket_Size = 20;
tic
QT = mexQuadtree(points,BB);%,Max_Tree_Levels);%,Bucket_Size);
toc
clear points;
QT

% now find the closest point with the C++ class
other_points = rand(NUM,2);
%other_points = QT.Points;

disp('Quadtree kNN_Search:');
NN = 1;
tic
[QT_indices, QT_dist] = QT.kNN_Search(other_points,NN);
%QT_indices = QT.kNN_Search(other_points,NN);
toc

disp(' ');
disp('MATLAB''s min point index: ');
PI

tic
% KD-tree
kdtreeobj = createns(QT.Points,'NsMethod','kdtree'); % partition the same points!
[idx, dist] = knnsearch(kdtreeobj,other_points,'k',NN);
%[idx, dist] = knnsearch(kdtreeobj,PT,'k',1);
toc
kdtreeobj
%idx

%[QT_indices, idx]

disp('Error is:');
ERR_I = abs(idx - double(QT_indices));
ERR_D = dist - QT_dist;
max(ERR_I(:))
[min(ERR_D(:)), max(ERR_D(:))]

% modify the points
new_pts = rand(NUM,2);
disp('Modify the tree with brand new points:');
tic
%delete(QT);
%QT = mexQuadtree(new_pts,BB);%,Max_Tree_Levels,Bucket_Size);
QT = QT.Update_Tree(new_pts);
toc
clear new_pts;

disp('Re-check nearest neighbor find:');
[QT_indices, QT_dist] = QT.kNN_Search(other_points,NN);
kdtreeobj = createns(QT.Points,'NsMethod','kdtree'); % partition the same points!
[idx, dist] = knnsearch(kdtreeobj,other_points,'k',NN);

disp('Error is:');
ERR_I = abs(idx - double(QT_indices));
ERR_D = dist - QT_dist;
max(ERR_I(:))
[min(ERR_D(:)), max(ERR_D(:))]

%QT.Print_Tree();

% delete the C++ object
delete(QT);

% END %