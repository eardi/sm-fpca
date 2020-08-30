function status = FEL_Execute_Assemble_1D(mexName)
%FEL_Execute_Assemble_1D
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 06-25-2012,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% BEGIN: define 1-D mesh
Num_P1_Nodes = 101;
P1_Ind = (1:1:Num_P1_Nodes)';
P1_Mesh_DoFmap = uint32([P1_Ind(1:end-1,1), P1_Ind(2:end,1)]); % NOTE! unsigned integer

P2_Extra_Ind = (1:1:Num_P1_Nodes-1)' + Num_P1_Nodes;
P2_Mesh_DoFmap = [P1_Mesh_DoFmap, P2_Extra_Ind];

P1_t = linspace(0,1,Num_P1_Nodes)';
mid_t = 0.5*(P1_t(P1_Ind(1:end-1),1) + P1_t(P1_Ind(2:end),1));
P2_t = [P1_t; mid_t];
% domain is a helix
X1 = sin(2*pi*P2_t);
Y1 = cos(2*pi*P2_t);
Z1 = 2*pi*P2_t;
P2_Mesh_Nodes = [X1, Y1, Z1];
P1_Mesh_Nodes = P2_Mesh_Nodes(1:Num_P1_Nodes,:);
% END: define 1-D mesh

% define function spaces (i.e. the DoFmaps)
%Scalar_P2_Values = P2_Mesh_Nodes(:,1);
%Vector_P1_Values = P2_Mesh_Nodes(1:Num_P1_Nodes,1:3);
P1_DoFmap = P1_Mesh_DoFmap;
P2_DoFmap = P2_Mesh_DoFmap;

% define external coefficient functions
my_f_Values = sin(P1_Mesh_Nodes);
old_soln_Values = exp(P2_Mesh_Nodes(:,1));
%Func_DoFmap = P1_Mesh_DoFmap;

% assemble
% com_string = [mexName,...
%               '([],P2_Mesh_Nodes,P2_Mesh_DoFmap,[],P2_DoFmap,P1_DoFmap,my_f_Values,old_soln_Values);'];
tic
%FEM = eval(com_string);
FEM = feval(str2func(mexName),[],P2_Mesh_Nodes,P2_Mesh_DoFmap,[],[],P2_DoFmap,P1_DoFmap,my_f_Values,old_soln_Values);
toc
RefFEMDataFileName = fullfile(Current_Dir,'FEL_Execute_Assemble_1D_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the P2 mass matrix should be close to the (exact) length of the helix.  Error is:');
sum(sum(FEM(3).MAT)) - 2*pi*sqrt(2)

disp('Integrating d/ds sin(X[1]) over the helix should give 0.  Error is:');
sum(sum(FEM(8).MAT)) - 0

disp('Integrating (X[1], X[2], 0).T over the helix should give 0.  Error is:');
A_vec = [P1_Mesh_Nodes(:,1:2), 0*P1_Mesh_Nodes(:,3)];
A_vec(:)' * FEM(6).MAT

disp('The average curvature of the helix should be 0.5.  Error is (should be small):')
ERROR_CURV = sum(sum(FEM(2).MAT))/(2*pi*sqrt(2)) - 0.5;
abs(ERROR_CURV)

disp('The L^2 norm of (exp(X[1]) - old_soln[1]) should be small.  It is:')
ERROR_L2 = sqrt(full(FEM(4).MAT(1,1))); % don't forget the square root!
ERROR_L2

disp('The Integral of (d/ds old_soln) w.r.t. arc-length should be the difference at the end-points.')
disp('------> Error is (should be small):')
abs((old_soln_Values(Num_P1_Nodes) - old_soln_Values(1)) - FEM(4).MAT(1,2))

disp('The Integral of (d/ds my_f) w.r.t. arc-length should be the difference at the end-points.')
disp('------> Error is (should be small):')
abs((my_f_Values(Num_P1_Nodes) - my_f_Values(1)) - FEM(4).MAT(2,1))

figure;
p1 = plot3(P1_Mesh_Nodes(:,1),P1_Mesh_Nodes(:,2),P1_Mesh_Nodes(:,3),'LineWidth',2.0);
axis equal;
title('Helix');

disp('Solve the Laplace-Beltrami equation with RHS Body_Force_Matrix');
disp('      and set 0 Dirichlet conditions at the end points.');
Soln = zeros(size(FEM(5).MAT,1),1);
DirNodes = [1, Num_P1_Nodes];
FreeNodes = setdiff((1:1:length(Soln))',DirNodes);
Soln(FreeNodes,1) = FEM(5).MAT(FreeNodes,FreeNodes) \ FEM(1).MAT(FreeNodes,1);

disp('Plot the Solution:');
figure;
p2 = edgemesh(P1_Mesh_DoFmap, P1_Mesh_Nodes, Soln(1:Num_P1_Nodes,1));
set(p2,'LineWidth',1.5);
title('Color Plot Solution of Laplace-Beltrami (P1 Interpolant of P2 Solution)');
axis equal;
colorbar;

figure;
p3 = plot(P1_t,Soln(1:Num_P1_Nodes,1),'b-','LineWidth',1.5);
title('Solution of Laplace-Beltrami (P1 Interpolant of P2 Solution)');
xlabel('t (parameterization)');
ylabel('solution value');

status = 0; % init
% compare to reference data
ERRORS = zeros(length(FEM),1);
for ind = 1:length(FEM)
    ERRORS(ind) = max(abs(FEM(ind).MAT(:) - FEM_REF(ind).MAT(:)));
    if (ERRORS(ind) > 1e-13)
        ERRORS(ind)
        disp(['Test Failed for FEM(', num2str(ind), ').MAT...']);
        status = 1;
    end
end

end