function status = FEL_Execute_Pt_Search_Surface_In_3D(mexName)
%FEL_Execute_Pt_Search_Surface_In_3D
%
%   test FELICITY Auto-Generated Point Search Code.

% Copyright (c) 07-24-2014,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get test mesh (square [0, 2] X [0, 2])
[Gamma_P1_Vtx, Gamma_Tri] = Standard_Triangle_Mesh_Test_Data();
%Gamma_Tri = Gamma_Tri(:,[3 1 2]);
% add a z-component
z = 0*Gamma_P1_Vtx(:,1);
Gamma_P1_Vtx = [Gamma_P1_Vtx, z];
Mesh = MeshTriangle(Gamma_Tri, Gamma_P1_Vtx, 'Gamma');
% refine
for ind = 1:0
    Mesh = Mesh.Refine;
end
% make a quadratic surface
z = 1 - ( (Mesh.Points(:,1) - 1).^2 + (Mesh.Points(:,2) - 1).^2 );
Mesh = Mesh.Set_Points([Mesh.Points(:,1:2), z]);

% define the global points
% NP = 1000;
% % set some random global points
% rx = 2*rand(NP,1);
% ry = 2*rand(NP,1);
% %rz = 2*rand(NP,1);
% rz = 1.5 + 0.2*(rand(NP,1) - 0.5);
% GX = [rx, ry, rz];
s_vec = linspace(0.1,1.9,4)';
[XX,YY] = meshgrid(s_vec,s_vec);
rx = XX(:);
ry = YY(:);
clear XX YY s_vec;
rz = 0*rx + 1.05;
GX = [rx, ry, rz;
      1, 1, 1.4;
      -0.3, 1, 0;
      1, -0.3, 0;
      2.3, 1, 0;
      1, 2.3, 0;
      -0.3, -0.3, -0.9;
      2.3, -0.3, -0.9;
      -0.3, 2.3, -0.9;
      2.3, 2.3, -0.9];
Cell_Indices = uint32(ones(size(GX,1),1));
%Cell_Indices = uint32(randi(Mesh.Num_Cell,size(GX,1),1));
Gamma_Neighbors = uint32(Mesh.neighbors);
Gamma_Given_Points = {Cell_Indices, GX, Gamma_Neighbors};

% search!
tic
SEARCH = feval(str2func(mexName),Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Gamma_Given_Points);
toc
RefSEARCHDataFileName = fullfile(Current_Dir,'FEL_Execute_Pt_Search_Surface_In_3D_REF_Data.mat');
% SEARCH_REF = SEARCH;
% save(RefSEARCHDataFileName,'SEARCH_REF');
load(RefSEARCHDataFileName);

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

% check that difference vector is "orthogonal" to the surface
XC = Mesh.referenceToCartesian(CI, Local_Ref_Coord);
Global_X = Gamma_Given_Points{2};
DIFF_VEC = Global_X - XC;

% compute edge vectors
Edges = Mesh.edges;
EV = Mesh.Points(Edges(:,2),:) - Mesh.Points(Edges(:,1),:);
EV11 = normalize_vec(EV(11,:));
EV12 = normalize_vec(EV(12,:));
EV18 = normalize_vec(EV(18,:));
EV19 = normalize_vec(EV(19,:));

EV07 = normalize_vec(EV(7,:));
EV14 = normalize_vec(EV(14,:));
EV17 = normalize_vec(EV(17,:));
EV20 = normalize_vec(EV(20,:));

% compute a few normal vectors
NV03 = normalize_vec(cross(EV11,EV07));
NV04 = normalize_vec(cross(EV14,EV11));
NV05 = normalize_vec(cross(EV07,EV12));
NV08 = normalize_vec(cross(EV17,EV12));

NV10 = normalize_vec(cross(EV14,EV18));
NV11 = normalize_vec(cross(EV20,EV18));
NV13 = normalize_vec(cross(EV19,EV20));
NV14 = normalize_vec(cross(EV17,EV19));

% check "orthogonality"
CHK = zeros(size(Global_X,1),1);
NORM_DIFF_VEC = normalize_vec(DIFF_VEC);

CHK(6) = dot(EV11,NORM_DIFF_VEC(6,:));
CHK(10) = dot(EV12,NORM_DIFF_VEC(10,:));
CHK(7) = dot(EV18,NORM_DIFF_VEC(7,:));
CHK(11) = dot(EV19,NORM_DIFF_VEC(11,:));

CHK(2)  = 1 - dot(NV04,NORM_DIFF_VEC(2,:));
CHK(5)  = 1 - dot(NV03,NORM_DIFF_VEC(5,:));
CHK(9)  = 1 - dot(NV05,NORM_DIFF_VEC(9,:));
CHK(14) = 1 - dot(NV08,NORM_DIFF_VEC(14,:));

CHK(15) = 1 - dot(NV14,NORM_DIFF_VEC(15,:));
CHK(12) = 1 - dot(NV13,NORM_DIFF_VEC(12,:));
CHK(8)  = 1 - dot(NV11,NORM_DIFF_VEC(8,:));
CHK(3)  = 1 - dot(NV10,NORM_DIFF_VEC(3,:));

ORTHO_ERROR = max(abs(CHK));
if (ORTHO_ERROR > 1e-15)
    disp(['Orthogonality Test Failed for Point Searching...']);
    status = 1;
end

% plot closest points
figure;
Mesh.Plot;
hold on;
plot3(Global_X(:,1),Global_X(:,2),Global_X(:,3),'k*','MarkerSize',10);
plot3(XC(:,1),XC(:,2),XC(:,3),'r.','MarkerSize',20);
plot3([XC(:,1), Global_X(:,1)]',[XC(:,2), Global_X(:,2)]',[XC(:,3), Global_X(:,3)]','b-');
hold off;
axis([-0.5 2.5 -0.5 2.5 -1 1.5]);
axis equal;
title('Closest Point Search On Triangulation');

% compare to reference data
for ind = 1:length(SEARCH)
    ECI = max(abs(SEARCH(ind).DATA{1} - SEARCH_REF(ind).DATA{1}));
    ELR = max(abs(SEARCH(ind).DATA{2} - SEARCH_REF(ind).DATA{2}));
    if (ECI > 0)
        disp(['Test Failed for SEARCH(', num2str(ind), ').DATA{1}...']);
        status = 1;
    end
    if (ELR > 4e-15)
        disp(['Test Failed for SEARCH(', num2str(ind), ').DATA{2}...']);
        status = 1;
    end
end

end

function UNIT_VEC = normalize_vec(VEC)

MAG0 = sqrt(sum(VEC.^2,2));

UNIT_VEC = VEC;
UNIT_VEC(:,1) = VEC(:,1) ./ MAG0;
UNIT_VEC(:,2) = VEC(:,2) ./ MAG0;
UNIT_VEC(:,3) = VEC(:,3) ./ MAG0;

end