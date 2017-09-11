% test octree (informal test code...)
%
% test_Octree
clc;
close all force;
clear all;
clear classes;

% disp('test timing:');
% tic
% mex_test();
% toc

NUM = 1000000;
points = rand(NUM,3);
% points = 0.3*rand(NUM,2);
% points = points + 0.2*points;
% points = [points; points + 0.5];
%points = [0.0, 0.0; points; 1.0, 1.0];
%points

PT = [0.234, 0.6134, 0.154];
tic
X_Diff = points(:,1) - PT(1);
Y_Diff = points(:,2) - PT(2);
Z_Diff = points(:,3) - PT(3);
Dist = sqrt(X_Diff.^2 + Y_Diff.^2 + Z_Diff.^2);
[Y, PI] = min(Dist);
toc
disp(' ');
% PT
% disp('MATLAB''s min point index: ');
% PI

disp('create oc-tree...');
BB = [-0.001, 1.001, -0.001, 1.001 -0.001, 1.001];
Max_Tree_Levels = 32;
Bucket_Size = 20;
tic
%CH = mexOctree_CPP('new',points,BB);%,Max_Tree_Levels);%,Bucket_Size);
OT = mexOctree(points,BB,Max_Tree_Levels);%,Bucket_Size);
toc
clear points;
OT

% OT.Print_Tree;
% delete(OT);
% asfsfd

% now find the closest point with the C++ class
query_points = rand(NUM,3);

disp('Octree kNN_Search:');
NN = 1;
tic
[OT_indices, OT_dist] = OT.kNN_Search(query_points,NN);
%OT_indices = OT.kNN_Search(other_points,NN);
toc

disp('KD-Tree Search:');
tic
% KD-tree
kdtreeobj = createns(OT.Points,'NsMethod','kdtree'); % partition the same points!
[idx, dist] = knnsearch(kdtreeobj,query_points,'k',NN);
%[idx, dist] = knnsearch(kdtreeobj,PT,'k',1);
toc
kdtreeobj
%idx

%[OT_indices, idx]

disp('Error is:');
ERR_I = abs(idx - double(OT_indices));
ERR_D = dist - OT_dist;
max(ERR_I(:))
[min(ERR_D(:)), max(ERR_D(:))]

% Valid = OT.Check_Tree();
% if (~Valid)
%     disp('--------------------------------------------------');
%     disp('The points are not partitioned properly!!!!');
%     disp('--------------------------------------------------');
% end

% modify the points
new_pts = rand(NUM,3);
disp('Update the tree with brand new points:');
tic
%delete(OT);
%OT = mexOctree(new_pts,BB);%,Max_Tree_Levels,Bucket_Size);
OT = OT.Update_Tree(new_pts);
toc
clear new_pts;

disp('Re-check nearest neighbor find:');
[OT_indices, OT_dist] = OT.kNN_Search(query_points,NN);
kdtreeobj = createns(OT.Points,'NsMethod','kdtree'); % partition the same points!
[idx, dist] = knnsearch(kdtreeobj,query_points,'k',NN);

disp('Error is:');
ERR_I = abs(idx - double(OT_indices));
ERR_D = dist - OT_dist;
max(ERR_I(:))
[min(ERR_D(:)), max(ERR_D(:))]

%OT.Print_Tree();

% delete the C++ object
delete(OT);

% END %