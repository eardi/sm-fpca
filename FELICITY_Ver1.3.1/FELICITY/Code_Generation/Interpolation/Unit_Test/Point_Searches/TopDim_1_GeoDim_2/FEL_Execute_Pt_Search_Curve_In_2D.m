function status = FEL_Execute_Pt_Search_Curve_In_2D(mexName)
%FEL_Execute_Pt_Search_Curve_In_2D
%
%   test FELICITY Auto-Generated Point Search Code.

% Copyright (c) 07-26-2014,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get test mesh (interval [0, 9])
[Sigma_P1_Vtx, Sigma_Edge] = Standard_Edge_Mesh_Test_Data();
% add y-component
y = 0*Sigma_P1_Vtx(:,1);
Sigma_P1_Vtx = [Sigma_P1_Vtx, y];
Mesh = MeshInterval(Sigma_Edge, Sigma_P1_Vtx, 'Sigma');
% refine
for ind = 1:3
    Mesh = Mesh.Refine;
end
% make a sine wave
x = Mesh.Points(:,1);
y = sin(0.2*pi*x);
Mesh = Mesh.Set_Points([x, y]);

% define the global points
% NP = 1000;
% % set some random global points
% rx = 9*rand(NP,1);
% ry = 2*rand(NP,1);
% GX = [rx, ry];
[XX,YY] = meshgrid((0:2:9)',(-1:0.7:1)');
GX = [XX(:), YY(:)];
clear XX YY;
Cell_Indices = uint32(ones(size(GX,1),1));
%Cell_Indices = uint32(randi(Mesh.Num_Cell,size(GX,1),1));
Sigma_Neighbors = uint32(Mesh.neighbors);
Sigma_Given_Points = {Cell_Indices, GX, Sigma_Neighbors};

% search!
tic
SEARCH = feval(str2func(mexName),Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Sigma_Given_Points);
toc
RefSEARCHDataFileName = fullfile(Current_Dir,'FEL_Execute_Pt_Search_Curve_In_2D_REF_Data.mat');
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
PTS_Closest_To_First_End = [1, 2];
ALL_Other_PTS = setdiff((1:1:size(Global_X,1))',PTS_Closest_To_First_End);

% compute edge vectors
Edges = Mesh.edges;
EV = Mesh.Points(Edges(:,2),:) - Mesh.Points(Edges(:,1),:);
UNIT_EV = normalize_vec(EV);

% check "orthogonality"
UNIT_DIFF_VEC = normalize_vec(DIFF_VEC);
CHK_ORTHO = dot(UNIT_EV(CI,:),UNIT_DIFF_VEC,2);

% only the ones in the other set will be ortho
CHK_MAX = CHK_ORTHO(ALL_Other_PTS);
ORTHO_ERROR = max(abs(CHK_MAX));
if (ORTHO_ERROR > 1e-13)
    ORTHO_ERROR
    disp(['Orthogonality Test Failed for Point Searching...']);
    status = 1;
end

% check that the other global points are closest to the ENDS of the parabola
XC_First = XC(PTS_Closest_To_First_End,:);
First_End = [0, 0];
CHK_First = [XC_First(:,1) - First_End(1), XC_First(:,2) - First_End(2)];
CHK_First_MAX = max(abs(CHK_First(:)));

if CHK_First_MAX
    disp(['Global Points Not Close To First End Point...']);
    status = 1;
end

% plot closest points
figure;
Mesh.Plot;
hold on;
plot(Global_X(:,1),Global_X(:,2),'k*','MarkerSize',10);
plot(XC(:,1),XC(:,2),'r.','MarkerSize',20);
plot([XC(:,1), Global_X(:,1)]',[XC(:,2), Global_X(:,2)]','b-');
hold off;
axis([0 9 -1 1]);
axis equal;
title('Closest Point Search On 2-D Curve Mesh');

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

end