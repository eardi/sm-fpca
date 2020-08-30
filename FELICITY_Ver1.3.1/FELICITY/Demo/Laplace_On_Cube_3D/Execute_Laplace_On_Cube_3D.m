function status = Execute_Laplace_On_Cube_3D()
%Execute_Laplace_On_Cube_3D
%
%   Demo code for Laplace's equation on 3-D cube.

% Copyright (c) 06-25-2012,  Shawn W. Walker

% BEGIN: define mesh of cube
disp(' ');
disp('Create Cube Mesh:');

tic
Num_Pts = 20+1; % max is 70+1 on my laptop (just barely worked!)
                %      Number of Free DoFs = 328509
                % can go much higher with AGMG!
[Omega_Tet, Omega_Vertex] = regular_tetrahedral_mesh(Num_Pts,Num_Pts,Num_Pts);
Mesh = MeshTetrahedron(Omega_Tet, Omega_Vertex, 'Omega');
%Mesh = Mesh.Reorder;
toc
clear Omega_Tet Omega_Vertex;
% END: define mesh of cube

% define subdomains
Bdy_Faces = Mesh.freeBoundary();
Mesh = Mesh.Append_Subdomain('2D','Bdy',Bdy_Faces);

% define function spaces (i.e. the DoFmaps)
P1_Space_DoFmap = uint32(Mesh.ConnectivityList);

% assemble
disp(' ');
disp('Assemble Stiffness matrix:');
tic
FEM = DEMO_mex_Laplace_On_Cube_3D_assemble([],Mesh.Points,P1_Space_DoFmap,[],[],P1_Space_DoFmap);
toc

A_from_scratch = FEM(1).MAT;

% doing re-assembly is at least 2 times (and up to 3 times) faster!
disp(' ');
disp('Assemble AGAIN!:');
tic
FEM = DEMO_mex_Laplace_On_Cube_3D_assemble(FEM,Mesh.Points,P1_Space_DoFmap,[],[],P1_Space_DoFmap);
toc

ERR1 = abs(FEM(1).MAT - A_from_scratch);
ERR1 = max(ERR1(:));
disp('Difference between Original Matrix and Re-assembled Matrix:');
ERR1

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefFEMDataFileName = fullfile(Current_Dir,'Demo_Laplace_On_Cube_3D_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp(' ');
disp('Summing the P1 stiffness matrix A should be close to 0.  Error is:');
sum(FEM(1).MAT(:)) - 0

disp('Setup Laplace equation with Dirichlet conditions on Bdy:');
Soln = zeros(Mesh.Num_Vtx,1); % init
A   = FEM(1).MAT;
disp('----> set u = sin(2*pi*x) + cos(2*pi*y) + sin(2*pi*z) on Bdy.');
% get Bdy Degrees-of-Freedom (DoF)
Bdy_Nodes = unique(Bdy_Faces(:));
% get Bdy DoF coordinates
Bdy_XC = Mesh.Points(Bdy_Nodes,:);
Soln(Bdy_Nodes,1) = sin(2*pi*Bdy_XC(:,1)) + cos(2*pi*Bdy_XC(:,2)) + sin(2*pi*Bdy_XC(:,3));
RHS = 0*Soln;
RHS = RHS - A * Soln;

% get the free nodes of the system
All_Vtx_Indices = (1:1:Mesh.Num_Vtx)';
FreeNodes = setdiff(All_Vtx_Indices,Bdy_Nodes);

disp(' ');
disp(['Size of A = ', num2str(size(A))]);
disp(['Number of Free DoFs = ', num2str(length(FreeNodes))]);
disp(' ');
MI = MEM_Info(A);
MEM_A = MI.bytes / (2^20);
disp(['Memory allocation for A = ', num2str(MEM_A), ' MB']);
disp(' ');

disp('Solve linear system with backslash:');
tic
Soln(FreeNodes,1) = A(FreeNodes,FreeNodes) \ RHS(FreeNodes,1);
toc

% % Note: you must have AGMG installed to run this!
% disp(' ');
% TOL = 1e-8;
% disp(['Solve linear system with AGMG with TOL = ', num2str(TOL,'%1.2G'), ':']);
% Soln_AGMG = Soln;
% tic
% Soln_AGMG(FreeNodes,1) = agmg(A(FreeNodes,FreeNodes),RHS(FreeNodes,1),[],TOL);
% toc
% Soln = Soln_AGMG;

% Soln_Diff = max(abs(Soln - Soln_AGMG));
% disp(' ');
% disp('Max difference between backslash and AGMG:');
% Soln_Diff

% % Note: you must have Pardiso installed to run this!  Almost as good as backslash
% disp(' ');
% disp(['Solve linear system with Pardiso (min degree ordering):']);
% Soln_Pardiso = Soln;
% info = pardisoinit(11,0);
% info.iparm(2) = 0; % min degree ordering
% info.iparm(3) = 2; % num cores
% tic
% info = pardisoreorder(A(FreeNodes,FreeNodes),info,true);
% info = pardisofactor(A(FreeNodes,FreeNodes),info,true);
% [Soln_Pardiso(FreeNodes,1), info] = pardisosolve(A(FreeNodes,FreeNodes),RHS(FreeNodes,1),info,true);
% toc
% pardisofree(info);
% clear info;
% Soln_Diff = max(abs(Soln - Soln_Pardiso));
% disp(' ');
% disp('Max difference between backslash and Pardiso:');
% Soln_Diff

% % Note: you must have SuperLU installed to run this!  Really slow compared to backslash
% disp(' ');
% disp(['Solve linear system with SuperLU:']);
% Soln_SuperLU = Soln;
% tic
% Soln_SuperLU(FreeNodes,1) = lusolve(A(FreeNodes,FreeNodes),RHS(FreeNodes,1));
% toc
% Soln_Diff = max(abs(Soln - Soln_SuperLU));
% disp(' ');
% disp('Max difference between backslash and SuperLU:');
% Soln_Diff

figure;
h1 = trisurf(Bdy_Faces,Mesh.Points(:,1),Mesh.Points(:,2),Mesh.Points(:,3),Soln(:,1));
title('Boundary Mesh and Boundary Condition','FontSize',12);
set(gca,'FontSize',14);
AX = [0 1 0 1 0 1];
axis(AX);
axis equal;
axis(AX);

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

function MI = MEM_Info(A)

MI = whos;

end