function status = Execute_Laplace_1D()
%Execute_Laplace_1D
%
%   Demo code for Laplace 1-D.

% Copyright (c) 06-25-2012,  Shawn W. Walker

% BEGIN: define 1-D mesh
Num_Vertices   = 101;
Indices        = (1:1:Num_Vertices)';
% you must use unsigned integer
Omega_Mesh     = uint32([Indices(1:end-1,1), Indices(2:end,1)]);
Omega_Vertices = linspace(0,1,Num_Vertices)';
% END: define 1-D mesh

% define function spaces (i.e. the DoFmaps)
P1_DoFmap = Omega_Mesh;

% assemble
tic
FEM = DEMO_mex_Laplace_1D([],Omega_Vertices,Omega_Mesh,[],[],P1_DoFmap);
toc

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefFEMDataFileName = fullfile(Current_Dir,'Matrix_Assembly_Laplace_1D_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the P1 mass matrix should be close to 1.  Error is:');
sum(sum(FEM(1).MAT)) - 1

disp('Summing the P1 stiffness matrix should be close to 0.  Error is:');
sum(sum(FEM(3).MAT)) - 0

disp('Solve the Laplace equation with Dirichlet conditions:');
disp('----> set u=0 at the left, and u''=0 on the right.');
Soln = zeros(size(FEM(3).MAT,1),1); % init
RHS = FEM(2).MAT;
A   = FEM(3).MAT;
disp('Set right-hand-side (f = -1) with Neumann condition at s = 1');
alpha = 0;
RHS(end) = RHS(end) + alpha;
disp('Use backslash to solve (impose Dirichlet condition at s=0):');
Soln(2:end,1) = A(2:end,2:end) \ RHS(2:end,1);

figure;
h1 = plot(Omega_Vertices,Soln,'b-','LineWidth',2.0);
title('Solution of PDE: -d^2/ds^2 u = -1, u(0) = 0, d/ds u(1) = 0','FontSize',14);
xlabel('x (domain = [0, 1])','FontSize',14);
ylabel('u (solution value)','FontSize',14);
set(gca,'FontSize',14);
axis([0 1 -0.6 0]);
axis equal;
axis([0 1 -0.6 0]);

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
if (status==0)
    disp('Test passed!');
end

end