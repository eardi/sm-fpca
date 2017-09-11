function status = FEL_Execute_Assemble_3D(mexName)
%FEL_Execute_Assemble_3D
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 06-25-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
DataFileName1 = fullfile(Current_Dir,'right_cylinder.mat');
DataFileName2 = fullfile(Current_Dir,'right_cylinder_surf.mat');
load(DataFileName1);
pause(0.05); % let data file finish loading...
load(DataFileName2);

% get surface mesh
Surf_Tri = Tri;

P1_Mesh_Nodes = Vtx;
P1_Tet_DoFmap = Tet;
P1_Tet_DoFmap = uint32(P1_Tet_DoFmap);
P1_DoFmap = P1_Tet_DoFmap;

% BEGIN: define some stuff
%Num_P1_Nodes = size(P1_Mesh_Nodes,1);

%Scalar_P1_Values = P1_Mesh_Nodes(:,1);
%Vector_P1_Values = P1_Mesh_Nodes(:,1:3);

my_f_Values = [sin(P1_Mesh_Nodes(:,1)), P1_Mesh_Nodes(:,2), cos(P1_Mesh_Nodes(:,3))];
old_soln_Values = exp(P1_Mesh_Nodes(:,1));
%Func_DoFmap = P1_Tet_DoFmap;
% END: define some stuff

% assemble
tic
FEM = feval(str2func(mexName),[],P1_Mesh_Nodes,P1_Tet_DoFmap,[],[],P1_DoFmap,P1_DoFmap,my_f_Values,old_soln_Values);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Assemble_3D_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the P1 mass matrix should be close to the volume of the cylinder pi*(0.5^2)*2.  Error is:');
sum(sum(FEM(3).MAT)) - pi*(0.5^2)*2

disp('Integrating (d/dy y) * sin(x) over the cylinder gives (pi*(0.5^2))*(1 - cos(2)).  Error is:');
sum(sum(FEM(6).MAT)) - (pi*(0.5^2))*(1 - cos(2))

disp('The L^2 norm of (exp(X[1]) - old_soln[1]) should be small.  Error is:')
ERROR = sqrt(full(FEM(2).MAT(1,1)))

figure;
p1 = tetramesh(P1_Tet_DoFmap,P1_Mesh_Nodes);
title('Right Circular Cylinder');
xlabel('X');
ylabel('Y');
zlabel('Z');

disp('Solve the Laplace equation with RHS Body_Force_Matrix');
Soln = zeros(size(FEM(4).MAT,1),1);
Soln(2:end,1) = FEM(4).MAT(2:end,2:end) \ FEM(1).MAT(2:end,1);

%Bdy_Vtx = unique(Surf_Tri(:));

disp('Plot the Solution:');
figure;
p2 = trisurf(Surf_Tri,P1_Mesh_Nodes(:,1),P1_Mesh_Nodes(:,2),P1_Mesh_Nodes(:,3),...
             Soln(:,1));
axis equal;
shading interp;
% set(p1,'edgecolor','k'); % make mesh black
colorbar;
title('Solution of the Laplace Equation (P1 Solution on Cylinder Boundary)');

status = 0; % init
% compare to reference data
ERRORS = zeros(length(FEM),1);
for ind = 1:length(FEM)
    ERRORS(ind) = max(abs(FEM(ind).MAT(:) - FEM_REF(ind).MAT(:)));
    if (ERRORS(ind) > 1e-13)
        disp(['Test Failed for FEM(', num2str(ind), ').MAT...']);
        status = 1;
    end
end

end