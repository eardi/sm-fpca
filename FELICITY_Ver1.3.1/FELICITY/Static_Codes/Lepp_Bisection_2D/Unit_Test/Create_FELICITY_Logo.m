% this runs bisection to create a mesh that is adapted to the word FELICITY
%
% Create_FELICITY_Logo
close all;
clear all;

% define input triangulation
Vtx = [0 0; 1 0; 2 0; 3 0;
       0 1; 1 1; 2 1; 3 1;
       4 0; 4 1];
Tri = uint32([1 6 5; 1 2 6; 2 7 6; 2 3 7; 3 8 7; 3 4 8; 4 10 8; 4 9 10]);
TEMP_TR = TriRep(double(Tri),Vtx);
Neighbor = uint32(neighbors(TEMP_TR));

[LOGO, LS] = FELICITY_Logo();

% init
New_Vtx = Vtx;
New_Tri = Tri;
New_Neighbor = Neighbor;
tic
for ind = 1:12
    Num_Tri = size(New_Tri,1);
    
    % find triangles that are close to x=0
    TEMP_TR = TriRep(double(New_Tri),New_Vtx);
    [IC, RIC] = incenters(TEMP_TR);
    DIST = 0*IC + 1000;
    for i0 = 1:length(LS)
        DIST_temp = Min_Dist_Line_Seg(IC,LS(i0).Line(1,:),LS(i0).Line(2,:));
        DIST = min([DIST, DIST_temp],[],2);
    end
    Mask = (DIST < 1.1*RIC);
    ALL_IND = uint32((1:1:Num_Tri)');
    Marked = ALL_IND(Mask);
    
    % do the refinement
    NEW_MESH = {New_Vtx, New_Tri};
    [NEW_MESH, New_Neighbor] = mexLEPP_Bisection_2D(NEW_MESH, New_Neighbor, Marked);
    New_Vtx = NEW_MESH{1};
    New_Tri = NEW_MESH{2};
end
toc

% check neighbors
New_TR = MeshTriangle(double(New_Tri),New_Vtx,'Logo');
CHK_Neighbor = uint32(neighbors(New_TR));
N_ERR = abs(CHK_Neighbor - New_Neighbor);
disp('Error check for neighbors (0 is GOOD):');
max(N_ERR(:))

all_areas = New_TR.Volume;
total_area = sum(all_areas);
disp('Total Area of Triangulation is 4.  Error is (should be 0):')
total_area - 4

figure;
p1 = trimesh(New_Tri,New_Vtx(:,1),New_Vtx(:,2),0*New_Vtx(:,1));
view(2);
shading interp;
set(p1,'edgecolor','k'); % make mesh black
plot_FELICITY_logo();
axis([0 4 0 1.0001]);
axis equal
axis([0 4 0 1.0001]);
axis off;

% END %