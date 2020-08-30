function status = test_LEPP_Bisection_2D()
%test_LEPP_Bisection_2D
%
%   Test code for FELICITY class.

% Copyright (c) 09-12-2011,  Shawn W. Walker

% define single triangle mesh
Vtx = [0 0; 1 0; 0 1];
Tri = uint32([1 2 3]);
Neighbor = uint32([0 0 0]);

% init
New_Vtx = Vtx;
New_Tri = Tri;
New_Neighbor = Neighbor;
tic
for ind = 1:16
    Num_Tri = size(New_Tri,1);
    % rearrange (stress test!)
    New_Tri(1:ceil(Num_Tri/2),:) = New_Tri(1:ceil(Num_Tri/2),[3 1 2]);
    New_Neighbor(1:ceil(Num_Tri/2),:) = New_Neighbor(1:ceil(Num_Tri/2),[3 1 2]);
    
    % find triangles that are close to x=0
    MIN_X = min([New_Vtx(New_Tri(:,1),1), New_Vtx(New_Tri(:,2),1), New_Vtx(New_Tri(:,3),1)],[],2);
    Mask = MIN_X < 1e-2;
    ALL_IND = uint32((1:1:Num_Tri)');
    Marked = ALL_IND(Mask);
    
    % should be able to mix things up (stress test!)
    p0 = randperm(length(Marked));
    Marked = [Marked(p0); Marked];
    NEW_MESH = {New_Vtx, New_Tri};
    [NEW_MESH, New_Neighbor] = mexLEPP_Bisection_2D(NEW_MESH, New_Neighbor, Marked);
    New_Vtx = NEW_MESH{1};
    New_Tri = NEW_MESH{2};
end
toc

% BEGIN: regression testing
status = 0; % init

% check neighbors
New_TR = TriRep(double(New_Tri),New_Vtx);
CHK_Neighbor = uint32(neighbors(New_TR));
N_ERR = abs(CHK_Neighbor - New_Neighbor);
%disp('Error check for neighbors (0 is GOOD):');
if max(N_ERR(:)) > 0
    disp('Neighbors do not match!  See ''test_LEPP_Bisection_2D''.');
    status = 1;
end

all_areas = TRI_AREA(New_Vtx,New_Tri);
total_area = sum(all_areas);
%disp('Total Area of Triangulation:')
AREA_ERR = abs(total_area - 0.5);
if AREA_ERR > 1e-15
    disp('AREA of bisected mesh does not equal 0.5!  See ''test_LEPP_Bisection_2D''.');
    status = 1;
end
% END: regression testing

figure;
p1 = trimesh(New_Tri,New_Vtx(:,1),New_Vtx(:,2),0*New_Vtx(:,1));
view(2);
shading interp;
set(p1,'edgecolor','k'); % make mesh black
% hold on;
% plot(Gamma_P1_Vtx(:,1),Gamma_P1_Vtx(:,2),'m','LineWidth',2.5);
% hold off;
axis equal
title('Triangle Mesh (Adaptively Bisected)');

end

% compute area of each triangle in a (flat) 2-D mesh
function AREA = TRI_AREA(p,t)

d12=p(t(:,2),:)-p(t(:,1),:);
d13=p(t(:,3),:)-p(t(:,1),:);
AREA = (d12(:,1).*d13(:,2)-d12(:,2).*d13(:,1))/2;

end