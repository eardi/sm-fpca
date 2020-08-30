function status = Execute_Mesh_Gen_With_Solving_PDE()
%Execute_Mesh_Gen_With_Solving_PDE
%
%   Demo code for generating a mesh, then solving a PDE on it.

% Copyright (c) 02-10-2018,  Shawn W. Walker

% create the (2-D) mesher object
Box_Dim = [-1, 1];
Num_BCC_Points = 61;
Use_Newton = false;
TOL = 1E-5; % tolerance to use in computing the cut points
% BCC mesh of the square [-1,1] x [-1,1]
MG = Mesher2Dmex(Box_Dim,Num_BCC_Points,Use_Newton,TOL);

% create a disk shaped domain with 3 holes in it
LS = LS_Many_Ellipses();
LS.Param.rad_x = [0.7, 0.15, 0.15, 0.15];
LS.Param.rad_y = [0.7, 0.15, 0.15, 0.15];
LS.Param.cx    = [0,  0,    0.35*(sqrt(3)/2), -0.35*(sqrt(3)/2)];
LS.Param.cy    = [0, -0.35, 0.35/2,            0.35/2];
LS.Param.sign  = [1, -1, -1, -1];

% setup up handle to interpolation routine
Interp_Handle = @(pt) LS.Interpolate(pt);

% mesh it!
MG = MG.Get_Cut_Info(Interp_Handle);
[TRI, VTX] = MG.run_mex(Interp_Handle);

% create a Mesh object
Mesh = MeshTriangle(TRI,VTX,'Omega');
% remove any vertices that are not referenced by the triangulation
Mesh = Mesh.Remove_Unused_Vertices;

% plot the domain Omega
figure;
Mesh.Plot;
title('Mesh of Domain \Omega');
AX = 0.8 * [-1 1 -1 1];
axis(AX);
axis equal;
axis(AX);
hold on;
text(0,0.74,'\Gamma');
text(0,-0.25,'\Sigma_1');
text(0.38,0.2,'\Sigma_2');
text(-0.43,0.2,'\Sigma_3');
hold off;

% find subdomains
Bdy_of_Omega = Mesh.freeBoundary(); % set of edges
% find the outer part: Gamma
Bdy_of_Omega_MidPt = 0.5 * (Mesh.Points(Bdy_of_Omega(:,1),:) + Mesh.Points(Bdy_of_Omega(:,2),:));
Bdy_of_Omega_MAG = sqrt(sum(Bdy_of_Omega_MidPt.^2,2));
Outer_Mask  = (Bdy_of_Omega_MAG > 0.65);
Gamma_Edges = Bdy_of_Omega(Outer_Mask,:);
% find the other parts:  Sigma_1, Sigma_2, Sigma_3.
Sigma_1_Mask = (Bdy_of_Omega_MidPt(:,2) < 0) & ~Outer_Mask;
Sigma_2_Mask = (Bdy_of_Omega_MidPt(:,1) > 0) & (Bdy_of_Omega_MidPt(:,2) > 0) & ~Outer_Mask;
Sigma_3_Mask = (Bdy_of_Omega_MidPt(:,1) < 0) & (Bdy_of_Omega_MidPt(:,2) > 0) & ~Outer_Mask;
Sigma_1_Edges = Bdy_of_Omega(Sigma_1_Mask,:);
Sigma_2_Edges = Bdy_of_Omega(Sigma_2_Mask,:);
Sigma_3_Edges = Bdy_of_Omega(Sigma_3_Mask,:);

% now define subdomains
Mesh = Mesh.Append_Subdomain('1D','Gamma',Gamma_Edges);
Mesh = Mesh.Append_Subdomain('1D','Sigma_1',Sigma_1_Edges);
Mesh = Mesh.Append_Subdomain('1D','Sigma_2',Sigma_2_Edges);
Mesh = Mesh.Append_Subdomain('1D','Sigma_3',Sigma_3_Edges);

% create subdomain embedding data
DoI_Names = {'Omega'; 'Gamma'};
Subdomain_Embed = Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);

% define function spaces (i.e. the DoFmaps)
P1_Space_DoFmap = uint32(Mesh.ConnectivityList);

% define finite element space object to handle (Dirichlet) boundary conditions
P1_RefElem = ReferenceFiniteElement(lagrange_deg1_dim2(),true);
P1_Lagrange_Space = FiniteElementSpace('Solution', P1_RefElem, Mesh, 'Omega');
% store DoFmap
P1_Lagrange_Space = P1_Lagrange_Space.Set_DoFmap(Mesh,P1_Space_DoFmap);
P1_Lagrange_Space = P1_Lagrange_Space.Set_Fixed_Subdomains(Mesh,{'Sigma_1', 'Sigma_2', 'Sigma_3'});

% assemble
disp(' ');
disp('Assemble Stiffness and Neumann Matrix:');
tic
FEM = DEMO_mex_Mesh_Gen_With_Solving_PDE_assemble([],Mesh.Points,P1_Space_DoFmap,[],Subdomain_Embed,P1_Lagrange_Space.DoFmap);
toc
%       OUTPUTS (in consecutive order) 
%       ---------------------------------------- 
%       Neumann_Matrix 
%       Stiff_Matrix 

disp('Setup Laplace equation with Dirichlet conditions on Sigma_1, Sigma_2, Sigma_3:');
Soln = zeros(P1_Lagrange_Space.num_dof,1); % init
A    = FEM(2).MAT;
disp('----> set u = -1 on Sigma_1.');
Sigma_1_DoFs = P1_Lagrange_Space.Get_DoFs_On_Subdomain(Mesh,'Sigma_1');
Soln(Sigma_1_DoFs,1) = -1;
disp('----> set u = +1 on Sigma_2 and Sigma_3.');
Sigma_2_DoFs = P1_Lagrange_Space.Get_DoFs_On_Subdomain(Mesh,'Sigma_2');
Soln(Sigma_2_DoFs,1) = 1;
Sigma_3_DoFs = P1_Lagrange_Space.Get_DoFs_On_Subdomain(Mesh,'Sigma_3');
Soln(Sigma_3_DoFs,1) = 1;
% adjust right-hand-side (RHS) data
RHS = FEM(1).MAT; % Neumann matrix
RHS = RHS - A * Soln;

% get the free DoFs of the system
FreeDoFs = P1_Lagrange_Space.Get_Free_DoFs(Mesh);
disp(' ');

disp('Solve linear system with backslash:');
tic
Soln(FreeDoFs,1) = A(FreeDoFs,FreeDoFs) \ RHS(FreeDoFs,1);
toc

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefFEMDataFileName = fullfile(Current_Dir,'Demo_Mesh_Gen_With_Solving_PDE_REF_Data.mat');
% Soln_REF = Soln;
% save(RefFEMDataFileName,'Soln_REF');
load(RefFEMDataFileName);

figure;
h1 = trisurf(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2),Soln);
shading interp;
title('Solution on \Omega','FontSize',14);
set(gca,'FontSize',14);
colorbar;
view(2);
axis(AX);
axis equal;
axis(AX);

status = 0; % init
% compare to reference data
ERROR = max(abs(Soln - Soln_REF));
if (ERROR > 1e-5)
    ERROR
    disp(['Test Failed...']);
    status = 1;
end

end