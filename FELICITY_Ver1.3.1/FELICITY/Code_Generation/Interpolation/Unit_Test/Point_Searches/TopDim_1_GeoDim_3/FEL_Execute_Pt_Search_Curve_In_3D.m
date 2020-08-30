function status = FEL_Execute_Pt_Search_Curve_In_3D(mexName)
%FEL_Execute_Pt_Search_Curve_In_3D
%
%   test FELICITY Auto-Generated Point Search Code.

% Copyright (c) 07-25-2014,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get test mesh (interval [0, 9])
[Sigma_P1_Vtx, Sigma_Edge] = Standard_Edge_Mesh_Test_Data();
% add a y and z-component
y = 0*Sigma_P1_Vtx(:,1);
z = 0*Sigma_P1_Vtx(:,1);
Sigma_P1_Vtx = [Sigma_P1_Vtx, y, z];
Mesh = MeshInterval(Sigma_Edge, Sigma_P1_Vtx, 'Sigma');
% refine
for ind = 1:2
    Mesh = Mesh.Refine;
end
% make a parabola
x = Mesh.Points(:,1);
y = 0.1*(20 - (x - 4.5).^2);
z = 0.1*(20 - (x - 4.5).^2);
Mesh = Mesh.Set_Points([Mesh.Points(:,1), y, z]);

% define the global points
% NP = 100000;
% % set some random global points
% rx = 9*rand(NP,1);
% ry = 2*rand(NP,1);
% rz = 2*rand(NP,1);
% GX = [rx, ry, rz];
[XX,YY,ZZ] = meshgrid((0:2:9)',(-1:0.7:1)',(-1:0.7:1)');
GX = [XX(:), YY(:), ZZ(:)];
clear XX YY ZZ;
Cell_Indices = uint32(ones(size(GX,1),1));
%Cell_Indices = uint32(randi(Mesh.Num_Cell,size(GX,1),1));
Sigma_Neighbors = uint32(Mesh.neighbors);
Sigma_Given_Points = {Cell_Indices, GX, Sigma_Neighbors};

% search!
tic
SEARCH = feval(str2func(mexName),Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Sigma_Given_Points);
toc
RefSEARCHDataFileName = fullfile(Current_Dir,'FEL_Execute_Pt_Search_Curve_In_3D_REF_Data.mat');
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
Global_X = Sigma_Given_Points{2};
DIFF_VEC = Global_X - XC;

% look at some of the closest points
PT_Mask = (Global_X(:,1) > 1) & (Global_X(:,1) < 8);
%PT_Mask_Other = ~PT_Mask;
PTS_Closest_To_First_Vtx = [1, 2, 3, 16, 17, 31];
PTS_Closest_To_Last_Vtx  = [13, 14, 28];

% compute edge vectors
Edges = Mesh.edges;
EV = Mesh.Points(Edges(:,2),:) - Mesh.Points(Edges(:,1),:);
UNIT_EV = normalize_vec(EV);

% check "orthogonality"
UNIT_DIFF_VEC = normalize_vec(DIFF_VEC);
CHK_ORTHO = dot(UNIT_EV(CI,:),UNIT_DIFF_VEC,2);

% only the ones in set A will be ortho
CHK_A = CHK_ORTHO(PT_Mask);
ORTHO_ERROR = max(abs(CHK_A));
if (ORTHO_ERROR > 1e-13)
    ORTHO_ERROR
    disp(['Orthogonality Test Failed for Point Searching...']);
    status = 1;
end

% check that the other global points are closest to the ENDS of the parabola
XC_First = XC(PTS_Closest_To_First_Vtx,:);
First_Vtx = [0, -2.5e-02, -2.5e-02];
CHK_First = [XC_First(:,1) - First_Vtx(1), XC_First(:,2) - First_Vtx(2), XC_First(:,3) - First_Vtx(3)];
CHK_First_MAX = max(abs(CHK_First(:)));

XC_Last = XC(PTS_Closest_To_Last_Vtx,:);
Last_Vtx = [9, -2.5e-02, -2.5e-02];
CHK_Last = [XC_Last(:,1) - Last_Vtx(1), XC_Last(:,2) - Last_Vtx(2), XC_Last(:,3) - Last_Vtx(3)];
CHK_Last_MAX = max(abs(CHK_Last(:)));

if max(CHK_First_MAX,CHK_Last_MAX)
    disp(['Global Points Not Close To End Points...']);
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
axis([0 9 -1.5 2.5 -1.5 2.5]);
axis equal;
title('Closest Point Search On 3-D Curve Mesh');

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