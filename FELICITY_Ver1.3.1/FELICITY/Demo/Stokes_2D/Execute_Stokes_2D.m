function status = Execute_Stokes_2D()
%Execute_Stokes_2D
%
%   Demo code for Stokes 2-D.

% Copyright (c) 06-30-2012,  Shawn W. Walker

% BEGIN: define square mesh [0, 1] x [0, 1]
[Omega_Tri, Omega_Vertex] = bcc_triangle_mesh(5,5);
Mesh = MeshTriangle(Omega_Tri, Omega_Vertex, 'Omega');
clear Omega_Tri Omega_Vertex;
Mesh = Mesh.Refine;
% END: define square mesh [0, 1] x [0, 1]

% define subdomains
Bdy_Edges = Mesh.freeBoundary();
Mesh = Mesh.Append_Subdomain('1D','Bdy',Bdy_Edges);
% get centroids of boundary edges
EE_center = (1/2) * (Mesh.Points(Bdy_Edges(:,1),:) + Mesh.Points(Bdy_Edges(:,2),:));
% find edges on top
Top_Mask = (EE_center(:,2) > 1 - 1e-5);
Top_Edges = Bdy_Edges(Top_Mask,:);
Mesh = Mesh.Append_Subdomain('1D','Top',Top_Edges);
% find edges on bottom
Bot_Mask = (EE_center(:,2) < 0 + 1e-5);
Bot_Edges = Bdy_Edges(Bot_Mask,:);
Mesh = Mesh.Append_Subdomain('1D','Bottom',Bot_Edges);
% find edges on inlet
In_Mask = (EE_center(:,1) < 0 + 1e-5);
In_Edges = Bdy_Edges(In_Mask,:);
Mesh = Mesh.Append_Subdomain('1D','Inlet',In_Edges);
% find edges on outlet
Out_Mask = (EE_center(:,1) > 1 - 1e-5);
Out_Edges = Bdy_Edges(Out_Mask,:);
Mesh = Mesh.Append_Subdomain('1D','Outlet',Out_Edges);

% create embedding data
DoI_Names = {'Omega'; 'Outlet'};
Subdomain_Embed = Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);

% define FE spaces
P2_RefElem = ReferenceFiniteElement(lagrange_deg2_dim2(),true);
P2_Lagrange_Space = FiniteElementSpace('Velocity', P2_RefElem, Mesh, 'Omega', 2);

% allocate DoFs
Pressure_DoFmap = uint32(Mesh.ConnectivityList);
tic
Lag_P2_DoFmap = DEMO_mex_DoF_Lagrange_P2_Allocator_2D(uint32(Mesh.ConnectivityList));
P2_Lagrange_Space = P2_Lagrange_Space.Set_DoFmap(Mesh,uint32(Lag_P2_DoFmap));
toc

% get P2_Lagrange Node coordinates
P2_X = P2_Lagrange_Space.Get_DoF_Coord(Mesh);
% set stress boundary condition
BC_Out_Values = zeros(size(P2_X,1),2);
BC_Out_Values(:,2) = 0*sin(2*pi*P2_X(:,2)); % y-component

% assemble
tic
FEM = DEMO_mex_Stokes_2D_assemble([],Mesh.Points,uint32(Mesh.ConnectivityList),[],Subdomain_Embed,...
                                     Pressure_DoFmap,P2_Lagrange_Space.DoFmap,BC_Out_Values);
toc
% check reassembler!
tic
FEM = DEMO_mex_Stokes_2D_assemble(FEM,Mesh.Points,uint32(Mesh.ConnectivityList),[],Subdomain_Embed,...
                                     Pressure_DoFmap,P2_Lagrange_Space.DoFmap,BC_Out_Values);
toc
% put FEM into a nice object to make accessing the matrices easier
Stokes_Matrices = FEMatrixAccessor('Stokes',FEM);

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);
RefFEMDataFileName = fullfile(Current_Dir,'Demo_Stokes_2D_REF_Data.mat');
% FEM_REF = FEM;
% save(RefFEMDataFileName,'FEM_REF');
load(RefFEMDataFileName);

% do some checks
disp('Summing the P2 stress matrix should be close to zero.  Error is:');
sum(FEM(3).MAT(:)) - (0)

disp('Solve the 2-D Stokes system with mixed boundary conditions...');
Vel_DoFs      = unique(P2_Lagrange_Space.DoFmap(:));
Pressure_DoFs = unique(Pressure_DoFmap(:));
Num_Scalar_Vel_DoF = length(Vel_DoFs);
Num_Pressure_DoF   = length(Pressure_DoFs);
Vel_Soln      = zeros(Num_Scalar_Vel_DoF,2);
Pressure_Soln = zeros(Num_Pressure_DoF,1);

% create saddle point system
A = Stokes_Matrices.Get_Matrix('Stress_Matrix');
B = Stokes_Matrices.Get_Matrix('Div_Pressure');
Saddle = [A, B'; B, sparse(Num_Pressure_DoF,Num_Pressure_DoF)];

disp('Set parabolic velocity profile at Inlet:');
Inlet_DoFs = P2_Lagrange_Space.Get_DoFs_On_Subdomain(Mesh,'Inlet');
Parabolic_Profile = P2_X(:,2).*(1 - P2_X(:,2)); % y * (1 - y)
Vel_Soln(Inlet_DoFs,1) = Parabolic_Profile(Inlet_DoFs,1); % x-component of velocity
disp('Set zero velocity on top and bottom:');% already done...
Soln = [Vel_Soln(:); Pressure_Soln]; % init column vector

disp('Set Right-Hand-Side data:');
R1 = Stokes_Matrices.Get_Matrix('BC_Matrix');
RHS = [R1; zeros(Num_Pressure_DoF,1)];
RHS = RHS - Saddle * Soln;

% get the free nodes of the system
Top_DoFs = P2_Lagrange_Space.Get_DoFs_On_Subdomain(Mesh,'Top');
Bot_DoFs = P2_Lagrange_Space.Get_DoFs_On_Subdomain(Mesh,'Bottom');
Fixed_Scalar_Nodes = unique([Inlet_DoFs; Top_DoFs; Bot_DoFs]); % unique b/c of overlap
Fixed_Vector_Nodes = [Fixed_Scalar_Nodes; Fixed_Scalar_Nodes + Num_Scalar_Vel_DoF];
FreeNodes = setdiff((1:1:length(Soln))', Fixed_Vector_Nodes);

disp('Use backslash to solve:');
Soln(FreeNodes,1) = Saddle(FreeNodes,FreeNodes) \ RHS(FreeNodes,1);
Vel_Soln(:)   = Soln(1:2*Num_Scalar_Vel_DoF,1);
Pressure_Soln = Soln(2*Num_Scalar_Vel_DoF+1:end,1);

figure;
subplot(2,2,1);
h1 = Mesh.Plot;
title('Omega','FontSize',14);
set(gca,'FontSize',14);
AX = [0 1 0 1];
axis(AX);
axis equal;
axis(AX);

subplot(2,2,2);
h2 = quiver(P2_X(:,1),P2_X(:,2),Vel_Soln(:,1),Vel_Soln(:,2));
title('Vector Velocity Solution','FontSize',14);
set(gca,'FontSize',14);
axis(AX);
axis equal;
axis(AX);

subplot(2,2,3);
h3 = trisurf(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2),Pressure_Soln);
shading interp;
title('Pressure Solution','FontSize',14);
set(gca,'FontSize',14);
colorbar;
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