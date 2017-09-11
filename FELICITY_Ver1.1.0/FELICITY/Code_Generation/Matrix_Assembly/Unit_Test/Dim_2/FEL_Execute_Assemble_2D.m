function status = FEL_Execute_Assemble_2D(mexName)
%FEL_Execute_Assemble_2D
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 06-25-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% create a piecewise quadratic surface mesh of unit sphere
[Tri, P1_Vtx] = triangle_mesh_of_sphere([0,0,0],1,4);
Num_P1_Nodes = size(P1_Vtx,1);

P2_Tri_DoFmap = Setup_Lagrange_P2_DoFmap(Tri,[]);
Num_P2_Nodes = max(P2_Tri_DoFmap(:));
P2_Vtx = zeros(Num_P2_Nodes,3);
P2_Vtx(P2_Tri_DoFmap(:,1),:) = P1_Vtx(P2_Tri_DoFmap(:,1),:);
P2_Vtx(P2_Tri_DoFmap(:,2),:) = P1_Vtx(P2_Tri_DoFmap(:,2),:);
P2_Vtx(P2_Tri_DoFmap(:,3),:) = P1_Vtx(P2_Tri_DoFmap(:,3),:);
P2_Vtx(P2_Tri_DoFmap(:,4),:) = 0.5 * (P1_Vtx(P2_Tri_DoFmap(:,2),:) + P1_Vtx(P2_Tri_DoFmap(:,3),:));
P2_Vtx(P2_Tri_DoFmap(:,5),:) = 0.5 * (P1_Vtx(P2_Tri_DoFmap(:,3),:) + P1_Vtx(P2_Tri_DoFmap(:,1),:));
P2_Vtx(P2_Tri_DoFmap(:,6),:) = 0.5 * (P1_Vtx(P2_Tri_DoFmap(:,1),:) + P1_Vtx(P2_Tri_DoFmap(:,2),:));
% project points to have unit distance from origin
MAG1 = sqrt(sum(P2_Vtx.^2,2));
P2_Vtx(:,1) = P2_Vtx(:,1) ./ MAG1;
P2_Vtx(:,2) = P2_Vtx(:,2) ./ MAG1;
P2_Vtx(:,3) = P2_Vtx(:,3) ./ MAG1;

% get P2 vertices
P2_Tri_DoFmap = uint32(P2_Tri_DoFmap);
P1_Tri_DoFmap = P2_Tri_DoFmap(:,1:3);

% BEGIN: define some stuff

% surface is a sphere
P2_Mesh_Nodes = P2_Vtx;
P1_Mesh_Nodes = P2_Vtx(1:Num_P1_Nodes,:);

%Scalar_P2_Values = P2_Mesh_Nodes(:,1);
%Vector_P1_Values = P1_Mesh_Nodes(:,1:3);
P1_DoFmap = P1_Tri_DoFmap;
P2_DoFmap = P2_Tri_DoFmap;

old_soln_Values = exp(P2_Mesh_Nodes(:,1));
% END: define some stuff

% assemble
tic
FEM = feval(str2func(mexName),[],P2_Mesh_Nodes,P2_Tri_DoFmap,[],[],P2_DoFmap,P1_DoFmap,old_soln_Values);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Assemble_2D_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the P2 mass matrix should be close to the area of the unit sphere.  Error is:');
sum(sum(FEM(3).MAT)) - 4*pi*(1^2)

disp('Integrating X.N over the unit sphere should give its area.  Error is:');
X_dot_N = full(P1_Mesh_Nodes(:)' * FEM(4).MAT);
X_dot_N - 4*pi*(1^2)

disp('The average (total) curvature of the unit sphere should be 2.  Error is:')
ERROR_CURV = sum(sum(FEM(2).MAT))/(4*pi*(1^2)) - 2;
ERROR_CURV

disp('The L^2 norm of (exp(X[1]) - old_soln[1]) should be small.  Error is:')
ERROR = sqrt(full(FEM(5).MAT(1,1)))

figure;
p1 = trimesh(P1_Tri_DoFmap,P1_Mesh_Nodes(:,1),P1_Mesh_Nodes(:,2),P1_Mesh_Nodes(:,3));
axis equal;
title('Unit Sphere');

disp('Solve the Laplace-Beltrami equation with RHS Body_Force_Matrix');
Soln = zeros(size(FEM(6).MAT,1),1);
Soln(2:end,1) = FEM(6).MAT(2:end,2:end) \ FEM(1).MAT(2:end,1);

disp('Plot the Solution:');
figure;
p2 = trisurf(P1_Tri_DoFmap,P1_Mesh_Nodes(:,1),P1_Mesh_Nodes(:,2),P1_Mesh_Nodes(:,3),...
             Soln(1:Num_P1_Nodes,1));
axis equal;
shading interp;
% set(p1,'edgecolor','k'); % make mesh black
colorbar;
title('Solution of Laplace-Beltrami (P1 Interpolant of P2 Solution)');

status = 0; % init
% compare to reference data
ERRORS = zeros(length(FEM),1);
for ind = 1:length(FEM)
    ERRORS(ind) = max(abs(FEM(ind).MAT(:) - FEM_REF(ind).MAT(:)));
    if (ERRORS(ind) > 1e-6) % 1e-13
        disp(['Test Failed for FEM(', num2str(ind), ').MAT...']);
        status = 1;
    end
end

% SWW: for some reason, my LINUX machine produces larger ERRORS...

end