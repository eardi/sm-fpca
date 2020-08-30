% test bitree (informal test code...)
%
% test_Bitree
clc;
close all force;
clear all;
clear classes;

% disp('test timing:');
% tic
% mex_test();
% toc

NUM = 1000000;
points = rand(NUM,1);

PT = [0.234, 0.6134];
tic
X_Diff = points(:,1) - PT(1);
Dist = abs(X_Diff);
[Y, PI] = min(Dist);
toc

disp('create bi-tree...');
BB = [-0.001, 1.001];
Max_Tree_Levels = 32;
Bucket_Size = 20;
tic
BT = mexBitree(points,BB);%,Max_Tree_Levels);%,Bucket_Size);
toc
clear points;
BT

% now find the closest point with the C++ class
query_points = rand(NUM,1);
%other_points = BT.Points;

disp('Bitree kNN_Search:');
NN = 1;
tic
[BT_indices, BT_dist] = BT.kNN_Search(query_points,NN);
%BT_indices = BT.kNN_Search(other_points,NN);
toc

disp(' ');
disp('MATLAB''s min point index: ');
PI

tic
% KD-tree
kdtreeobj = createns(BT.Points,'NsMethod','kdtree'); % partition the same points!
[idx, dist] = knnsearch(kdtreeobj,query_points,'k',NN);
%[idx, dist] = knnsearch(kdtreeobj,PT,'k',1);
toc
kdtreeobj
%idx

%[BT_indices, idx]

disp('Error is:');
ERR_I = abs(idx - double(BT_indices));
ERR_D = dist - BT_dist;
max(ERR_I(:))
[min(ERR_D(:)), max(ERR_D(:))]

% modify the points
new_pts = rand(NUM,1);
disp('Modify the tree with brand new points:');
tic
BT = BT.Update_Tree(new_pts);
toc
clear new_pts;

disp('Re-check nearest neighbor find:');
[BT_indices, BT_dist] = BT.kNN_Search(query_points,NN);
kdtreeobj = createns(BT.Points,'NsMethod','kdtree'); % partition the same points!
[idx, dist] = knnsearch(kdtreeobj,query_points,'k',NN);

disp('Error is:');
ERR_I = abs(idx - double(BT_indices));
ERR_D = dist - BT_dist;
max(ERR_I(:))
[min(ERR_D(:)), max(ERR_D(:))]

%BT.Print_Tree();

% delete the C++ object
delete(BT);

% END %