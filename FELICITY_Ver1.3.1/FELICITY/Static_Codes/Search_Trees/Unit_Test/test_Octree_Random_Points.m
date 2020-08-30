function status = test_Octree_Random_Points()
%test_Octree_Random_Points
%
%   Test code for FELICITY class.

% Copyright (c) 01-14-2014,  Shawn W. Walker

status = 0; % init

% current_file = mfilename('fullpath');
% Current_Dir  = fileparts(current_file);

NUM = 1000000;
points = rand(NUM,3);

disp('create Octree...');
BB = [-0.001, 1.001, -0.001, 1.001, -0.001, 1.001];
Max_Tree_Levels = 32;
Bucket_Size = 20;
tic
OT = mexOctree(points,BB);%,Max_Tree_Levels,Bucket_Size);
toc
clear points;

% generate random points to query nearest neighbors
QP_Num = 100;
query_points = rand(QP_Num,3);

% now find the closest point with the C++ class
disp('Octree nearest neighbor find:');
NN = 1;
tic
[OT_indices, OT_dist] = OT.kNN_Search(query_points,NN);
toc

% compare against brute-force approach
disp('Get nearest neighbors by brute-force:');
tic
[idx, dist] = brute_force(OT,query_points);
toc

ERR_I = abs(idx - double(OT_indices));
ERR_D = abs(dist - OT_dist);
EI = max(ERR_I(:));
ED = max(ERR_D(:));
if or(EI > 0, ED > 1e-15)
    disp(['First nearest neighbor test failed!']);
    status = 1;
    return;
end

% generate new points
new_pts = rand(NUM,3);
disp('Update the tree with brand new points:');
tic
OT = OT.Update_Tree(new_pts);
toc
clear new_pts;

disp('Re-check nearest neighbor find:');
[OT_indices, OT_dist] = OT.kNN_Search(query_points,NN);

% compare against brute-force approach
[idx, dist] = brute_force(OT,query_points);

ERR_I = abs(idx - double(OT_indices));
ERR_D = abs(dist - OT_dist);
EI = max(ERR_I(:));
ED = max(ERR_D(:));
if or(EI > 0, ED > 1e-15)
    disp(['Second nearest neighbor test failed!']);
    status = 1;
    return;
end

% delete the C++ object
delete(OT);

end

function [idx, dist] = brute_force(OT,query_points)

% compare against brute-force approach
QP_Num = size(query_points,1);
idx = zeros(QP_Num,1);
dist = zeros(QP_Num,1);
for ii = 1:QP_Num
    X_Diff = OT.Points(:,1) - query_points(ii,1);
    Y_Diff = OT.Points(:,2) - query_points(ii,2);
    Z_Diff = OT.Points(:,3) - query_points(ii,3);
    Dist = sqrt(X_Diff.^2 + Y_Diff.^2 + Z_Diff.^2);
    [Val, Ind] = min(Dist);
    idx(ii,1) = Ind;
    dist(ii,1) = Val;
end

end