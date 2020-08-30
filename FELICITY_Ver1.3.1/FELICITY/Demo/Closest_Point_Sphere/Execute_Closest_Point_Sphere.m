function status = Execute_Closest_Point_Sphere()
%Execute_Closest_Point_Sphere
%
%   Demo code for computing closest points on a surface triangulation mesh.

% Copyright (c) 07-24-2014,  Shawn W. Walker

% note: this method of computing the closest point is only first order accurate.
% this is because the accuracy is essentially limited by how accurate the normal vector is
% approximated by the surface mesh.  In this case, the surface mesh is piecewise linear,
% so the normal vector is only first order accurate.

% get unit sphere mesh
Refine_Level = 4;
Center = [0, 0, 0];
Radius = 1;
[TRI, VTX] = triangle_mesh_of_sphere(Center,Radius,Refine_Level);
Mesh = MeshTriangle(TRI, VTX, 'Sphere');

% define the global points
NP = 10;
% set some random global points
% GX = 3*(rand(NP,3) - 0.5);
s_vec = (-1:0.6:1)'; % make sure no point is *exactly* at the origin
[XX,YY,ZZ] = meshgrid(s_vec,s_vec,s_vec);
GX = [XX(:), YY(:), ZZ(:)];
% GX = [1, 0.4, 0.9;
%       -0.8, -0.7, -1];
% note: if one of the points is at the origin, then the MAX_ERROR (below) will be large.
%       This is because all of the points on the sphere are equidistant to the origin
%       so there is no unique closest point.  The point searching code will find one of
%       the surface mesh points (i.e. it will converge), but it does not make sense to
%       compare it to the "true" value because there is no unique true value.
Cell_Indices = uint32(ones(size(GX,1),1));
%Cell_Indices = uint32(randi(Mesh.Num_Cell,size(GX,1),1));
Sphere_Neighbors = uint32(Mesh.neighbors);
Sphere_Given_Points = {Cell_Indices, GX, Sphere_Neighbors};

% search!
tic
SEARCH = DEMO_mex_Point_Search_Sphere(Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Sphere_Given_Points);
toc
% RefSEARCHDataFileName = fullfile(Current_Dir,'FEL_Execute_Pt_Search_Surface_In_3D_REF_Data.mat');
% % SEARCH_REF = SEARCH;
% % save(RefSEARCHDataFileName,'SEARCH_REF');
% load(RefSEARCHDataFileName);

status = 0; % init
% get closest cell indices
CI = double(SEARCH.DATA{1});
if (min(CI) <= 0)
    disp('At least one point was not found in the mesh!');
    status = 1;
end

% get corresponding local reference triangle coordinates
Local_Ref_Coord = SEARCH.DATA{2};
N1 = 1 - sum(Local_Ref_Coord,2);
CHK = [N1, Local_Ref_Coord];
MIN_VAL = min(CHK(:));
MAX_VAL = max(CHK(:));
% make sure the coordinates are inside the ref triangle
if ~and(MIN_VAL >= -1e-15, MAX_VAL <= 1 + 1e-15)
    disp('Some local points are outside reference triangle!');
    status = 1;
end

% next, compute the closest points "analytically"
LEN0 = sqrt(sum(GX.^2,2)) + 1e-15;
Closest_Points = GX;
Closest_Points(:,1) = GX(:,1) ./ LEN0;
Closest_Points(:,2) = GX(:,2) ./ LEN0;
Closest_Points(:,3) = GX(:,3) ./ LEN0;
% recall: radius = 1

% get global coordinates of the "found" closest points on sphere
XC = Mesh.referenceToCartesian(CI, Local_Ref_Coord);

% the difference between the analytic and computed closest points should be small
ERROR = Closest_Points - XC;
MAX_ERROR = max(abs(ERROR(:)));

if (MAX_ERROR > 2.86e-2)
    MAX_ERROR
    disp(['Found points are not accurate...']);
    status = 1;
end

% plot closest points and sphere
figure;
FH = Mesh.Plot;
set(FH,'facealpha',0.4);
hold on;
plot3(GX(:,1),GX(:,2),GX(:,3),'k*','MarkerSize',10);
plot3(XC(:,1),XC(:,2),XC(:,3),'r.','MarkerSize',20);
plot3([XC(:,1), GX(:,1)]',[XC(:,2), GX(:,2)]',[XC(:,3), GX(:,3)]',...
      'b-','LineWidth',1.6);
hold off;
axis([-1.5 1.5 -1.5 1.5 -1.5 1.5]);
axis equal;
title('Closest Points On Triangulation Of Sphere');

end