function status = FEL_Execute_Pt_Search_2D(mexName)
%FEL_Execute_Pt_Search_2D
%
%   test FELICITY Auto-Generated Point Search Code.

% Copyright (c) 07-24-2014,  Shawn W. Walker

% current_file = mfilename('fullpath');
% Current_Dir  = fileparts(current_file);

% get test mesh
[Omega_P1_Vtx, Omega_Tri] = Standard_Triangle_Mesh_Test_Data();
% domain is a square [0, 2] X [0, 2]
Mesh = MeshTriangle(Omega_Tri, Omega_P1_Vtx, 'Omega');
% refine
for ind = 1:2
    Mesh = Mesh.Refine;
end

% define the global points
NP = 1000; % 1000
Cell_Indices = uint32(randi(Mesh.Num_Cell,NP,1));
% set some random global points
Omega_Neighbors = uint32(Mesh.neighbors);
Omega_Given_Points = {[], 2*rand(NP,2), Omega_Neighbors};

% search!
tic
SEARCH = feval(str2func(mexName),Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Omega_Given_Points);
toc
% RefSEARCHDataFileName = fullfile(Current_Dir,'FEL_Execute_XXXXX_REF_Data.mat');
% % SEARCH_REF = SEARCH;
% % save(RefSEARCHDataFileName,'SEARCH_REF');
% load(RefSEARCHDataFileName);

status = 0; % init
if ~strcmp(SEARCH.Name,Mesh.Name)
    disp('Domain name does not match!');
    status = 1;
end

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

% get global coordinates from the local coordinates
XC = Mesh.referenceToCartesian(CI, Local_Ref_Coord);

% check difference between original points and "found" points
DIFF1 = Omega_Given_Points{2} - XC;
ERROR = max(abs(DIFF1(:)));
if (ERROR > 1e-14)
    disp(['Test Failed for Point Searching...']);
    status = 1;
end

end