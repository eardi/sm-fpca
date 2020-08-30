function status = FEL_Execute_Pt_Search_2D_Codim_1(mexName)
%FEL_Execute_Pt_Search_2D_Codim_1
%
%   test FELICITY Auto-Generated Point Search Code.

% Copyright (c) 04-12-2018,  Shawn W. Walker

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

FBY = Mesh.freeBoundary();
Mesh = Mesh.Append_Subdomain('1D','Gamma',FBY);

% create embedding data (if needed)
DoI_Names = {'Omega'; 'Gamma'}; % domains of integration
Embed = Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);

% create a sub-mesh
Gamma_Conn = Mesh.Get_Global_Subdomain('Gamma');
Gamma_Mesh = MeshInterval(Gamma_Conn,Mesh.Points,'Gamma');
Gamma_Neighbors = uint32(Gamma_Mesh.neighbors);

% define the global points
NP = 10; % 1000
Global_Points = 2*rand(NP,2);

% use a search tree to find good initial guess
BC = Gamma_Mesh.Get_Cell_Centers();
QT = mexQuadtree(BC,[-1 3 -1 3]);
[Mesh_Cell_Indices, OT_dist] = QT.kNN_Search(Global_Points,1);
delete(QT);

% next, do a local search
Cell_Indices = uint32(Mesh_Cell_Indices);
if min(Cell_Indices)==0
    error('A point was not found!');
end
Gamma_Given_Points = {Cell_Indices, Global_Points, Gamma_Neighbors};

% search!
tic
SEARCH = feval(str2func(mexName),Mesh.Points,uint32(Mesh.ConnectivityList),[],Embed,Gamma_Given_Points);
toc
% RefSEARCHDataFileName = fullfile(Current_Dir,'FEL_Execute_XXXXX_REF_Data.mat');
% % SEARCH_REF = SEARCH;
% % save(RefSEARCHDataFileName,'SEARCH_REF');
% load(RefSEARCHDataFileName);

status = 0; % init
if ~strcmp(SEARCH.Name,'Gamma')
    disp('Domain name does not match!');
    status = 1;
end

% get closest cell indices
CI = double(SEARCH.DATA{1});
if (min(CI) <= 0)
    disp('At least one point was not found in the mesh!');
    status = 1;
end

% get corresponding local reference interval coordinates
Local_Ref_Coord = SEARCH.DATA{2};
N1 = 1 - sum(Local_Ref_Coord,2);
CHK = [N1, Local_Ref_Coord];
MIN_VAL = min(CHK(:));
MAX_VAL = max(CHK(:));
% make sure the coordinates are inside the ref triangle
if ~and(MIN_VAL >= -1e-15, MAX_VAL <= 1 + 1e-15)
    disp('Some local points are outside reference interval!');
    status = 1;
end

% get global coordinates from the local coordinates
XC = Gamma_Mesh.referenceToCartesian(CI, Local_Ref_Coord);

figure;
plot(Gamma_Given_Points{2}(:,1),Gamma_Given_Points{2} (:,2),'k*','MarkerSize',16);
hold on;
plot(XC(:,1),XC(:,2),'r.','MarkerSize',16);
hold off;

% % check difference between original points and "found" points
% DIFF1 = Gamma_Given_Points{2} - XC;
% ERROR = max(abs(DIFF1(:)));
% if (ERROR > 1e-14)
%     disp(['Test Failed for Point Searching...']);
%     status = 1;
% end

end