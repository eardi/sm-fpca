function status = FEL_Execute_BDM1_triangle(mexName_DoF,mexName_assembly)
%FEL_Execute_BDM1_triangle
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 06-25-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% BEGIN: create mesh

% get standard example mesh
[Vtx, Tri] = Standard_Triangle_Mesh_Test_Data();
% domain is a square [0, 2] X [0, 2]
% refine it!
for ind = 1:2
    Marked_Tri = (1:1:size(Tri,1))';
    [Vtx, Tri] = Refine_Entire_Mesh(Vtx,Tri,[],Marked_Tri);
end
% compute barycenters
MT = MeshTriangle(Tri,Vtx,'Omega');
CC = MT.circumcenter;
Edges = MT.edges;
[Tri_Edge, Omega_Orient] = MT.Get_Facet_Info(Edges);
% a true entry means the local edge of the given triangle is contained in the
% Tri_Edge array; false means the *reversed* edge is in the Tri_Edge array.
clear MT;
% find closest triangle to the x-axis
[Y, Ind] = min(CC(:,2));
Fixed_Pressure_Node = Ind;

Omega_Vtx = Vtx;
Omega_DoFmap = uint32(Tri);
% END: create mesh

% BEGIN: define some stuff

% allocate DoFs
tic
BDM1_DoFmap = feval(str2func(mexName_DoF),Omega_DoFmap);
toc
% there are two distinct DoFs associated with each global mesh edge
Num_BDM1_Nodes = 2*size(Edges,1);
if (Num_BDM1_Nodes~=max(BDM1_DoFmap(:)))
    error('BDM_1 DoFmap is not formed correctly!');
end
% DoF_indices = (1:1:Num_BDM1_Nodes)';

Num_P0_Nodes = size(Omega_DoFmap,1);
P0_DoFmap = (1:1:Num_P0_Nodes)';
P0_DoFmap = uint32(P0_DoFmap);

F1 = @(X) [X(:,1), X(:,2)];
uu_VEC = Get_BDM1_Interpolant_of_Function(Omega_Vtx,Omega_DoFmap,BDM1_DoFmap,Omega_Orient,F1);
F2 = @(X) [exp(-X(:,1)), X(:,2).^2];
% store the coefficient function values
old_p   = zeros(Num_P0_Nodes,1);
old_vel = Get_BDM1_Interpolant_of_Function(Omega_Vtx,Omega_DoFmap,BDM1_DoFmap,Omega_Orient,F2);
% END: define some stuff

% assemble
tic
FEM = feval(str2func(mexName_assembly),[],Omega_Vtx,Omega_DoFmap,Omega_Orient,[],BDM1_DoFmap,P0_DoFmap,old_p,old_vel);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_BDM1_triangle_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the BDM1 mass matrix should be close to (960).  Error is:');
sum(sum(FEM(3).MAT)) - 960

disp('Compute integral of (x^2 + y^2) over [0, 2] x [0, 2] with BDM1 mass matrix.  Error is:');
uu_VEC' * FEM(3).MAT * uu_VEC - (32/3)

disp('Compute integral of div([x, y]) over [0, 2] x [0, 2] with BDM1 div-pressure matrix.  Error is:');
sum(uu_VEC' * FEM(1).MAT) - (8)

disp('Compute integral of div([exp(-x), y^2]) over [0, 2] x [0, 2] with small matrix.  Error is:');
FEM(5).MAT - (8 + 2*(exp(-2) - 1))

% figure;
% p1 = trimesh(Omega_DoFmap,Omega_Vtx(:,1),Omega_Vtx(:,2),0*Omega_Vtx(:,2));
% axis equal;
% set(p1,'edgecolor','k'); % make mesh black
% view(2);
% title('Square');

disp('Solve Mixed-Laplace Problem with RHS_Div Matrix');
MAT = [ FEM(3).MAT, -FEM(1).MAT;
       -FEM(1).MAT', sparse(Num_P0_Nodes,Num_P0_Nodes)];
RHS = [zeros(Num_BDM1_Nodes,1); -FEM(4).MAT];
Soln = zeros(size(MAT,1),1);
All_Nodes = (1:1:size(Soln,1))';
Free_Nodes = setdiff(All_Nodes,Fixed_Pressure_Node+Num_BDM1_Nodes);
Soln(Free_Nodes,1) = MAT(Free_Nodes,Free_Nodes) \ RHS(Free_Nodes,1);
P0_Soln = Soln(end-(Num_P0_Nodes-1):end,1); % extract pressure solution
disp(' ');
disp('L^2 *error* of pressure solution (less than 1.0):');
FEM_P0 = feval(str2func(mexName_assembly),[],Omega_Vtx,Omega_DoFmap,Omega_Orient,[],BDM1_DoFmap,P0_DoFmap,P0_Soln,old_vel);
FEM_P0 = full(FEM_P0(2).MAT);
sqrt(FEM_P0) % yes, you need the sqrt!

disp('Plot the ("pressure") Solution:');
figure;
Plot_P0_Data_On_Triangles(Omega_Vtx,Omega_DoFmap,P0_Soln);
AZ = -25;
EL = 40;
view(AZ,EL);
title('Solution of Mixed-Laplace Problem with BDM_1 (P0 Solution)');

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