function status = Execute_Point_Search_Planar_Domain()
%Execute_Point_Search_Planar_Domain
%
%   Demo code for finding mesh cells and local reference domain coordinates for a given
%   set of global points.

% Copyright (c) 08-01-2014,  Shawn W. Walker

% get test mesh
[Omega_Vtx, Omega_Tri] = Standard_Triangle_Mesh_Test_Data();
% domain is a square [0, 2] x [0, 2]
MT = MeshTriangle(Omega_Tri, Omega_Vtx, 'Omega'); % make a triangulation so we can get neighbors
Omega_Neighbors = uint32(MT.neighbors);

% define the global points
NP = 20;
GX = 2*rand(NP,2);

% create random initial guesses as to which mesh triangle contains each global point
Num_Cells = MT.Num_Cell();
Cell_Indices = uint32(randi(Num_Cells,NP,1));

% collect all the data needed to search the domain Omega
Omega_Given_Points = {Cell_Indices, GX, Omega_Neighbors};

% search!
tic
SEARCH = DEMO_mex_Point_Search_Planar_Domain(MT.Points,uint32(MT.ConnectivityList),[],[],Omega_Given_Points);
toc

status = 0; % init
if ~strcmp(SEARCH.Name,'Omega')
    disp('Domain name does not match!');
    status = 1;
end

% extract closest cell indices
CI = double(SEARCH.DATA{1});
% if any of the indices is 0, then the corresponding global point was not found
if (min(CI) <= 0)
    disp('At least one point was not found in the mesh!');
    status = 1;
end

% extract corresponding local reference triangle coordinates
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

% map local coordinates (of the found points) to the corresponding global coordinates
XC = MT.referenceToCartesian(CI, Local_Ref_Coord);

% the difference between the original "given" points and the "found" points
%     should be zero (or machine precision)
DIFF1 = GX - XC;
ERROR = max(abs(DIFF1(:)));
if (ERROR > 1e-14)
    ERROR
    disp(['Test Failed for Point Searching...']);
    status = 1;
end

% plot the given points and found points
figure;
F1 = trimesh(MT.ConnectivityList,MT.Points(:,1),MT.Points(:,2),0*MT.Points(:,1));
set(F1,'edgecolor','k');
hold on;
HG = plot(GX(:,1),GX(:,2),'kp','MarkerSize',15);
HF = plot(XC(:,1),XC(:,2),'r.','MarkerSize',15);
hold off;
legend([HG, HF],'Given Points','Found Points');
axis([0 2 0 2]);
axis square;
title('Point Search On A Planar Triangulation');
view(2);

end