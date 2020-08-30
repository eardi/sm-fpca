function status = FEL_Execute_Pt_Search_3D(mexName)
%FEL_Execute_Pt_Search_3D
%
%   test FELICITY Auto-Generated Point Search Code.

% Copyright (c) 07-25-2014,  Shawn W. Walker

% current_file = mfilename('fullpath');
% Current_Dir  = fileparts(current_file);

% get test mesh (unit cube)
[Omega_Tet, Omega_P1_Vtx] = regular_tetrahedral_mesh(5,5,5);
Mesh = MeshTetrahedron(Omega_Tet, Omega_P1_Vtx, 'Omega');

% define the global points
NP = 1000;
%Cell_Indices = uint32(randi(Mesh.Num_Cell,NP,1));
% set some random global points
Omega_Neighbors = uint32(Mesh.neighbors);
Omega_Given_Points = {[], rand(NP,3), Omega_Neighbors};

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

% get corresponding local reference tetrahedron coordinates
Local_Ref_Coord = SEARCH.DATA{2};
N1 = 1 - sum(Local_Ref_Coord,2);
CHK = [N1, Local_Ref_Coord];
MIN_VAL = min(CHK(:));
MAX_VAL = max(CHK(:));
% make sure the coordinates are inside the ref tetrahedron
if ~and(MIN_VAL >= -1e-15, MAX_VAL <= 1 + 1e-15)
    disp('Some local points are outside reference tetrahedron!');
    status = 1;
end

% get global coordinates from the local coordinates
XC = Mesh.referenceToCartesian(CI, Local_Ref_Coord);

% check difference between original points and "found" points
GX = Omega_Given_Points{2};
DIFF1 = GX - XC;
ERROR = max(abs(DIFF1(:)));
if (ERROR > 1e-14)
    disp(['Test Failed for Point Searching...']);
    status = 1;
end

end