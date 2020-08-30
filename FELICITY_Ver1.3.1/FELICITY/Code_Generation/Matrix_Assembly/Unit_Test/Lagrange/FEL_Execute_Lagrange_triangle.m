function status = FEL_Execute_Lagrange_triangle(DIM,deg_k)
%FEL_Execute_Lagrange_triangle
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 04-04-2018,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

%Refine_Vec = [1 2 3 4 5 6 7 8 9];
Refine_Vec = [1 2 3 4 5 6];
%Refine_Vec = [1 2 3];
Num_Refine = length(Refine_Vec);

% init error arrays
L2_Error_Vec = zeros(Num_Refine,1);
L2_Grad_Error_Vec = zeros(Num_Refine,1);

for kk = 1:Num_Refine
%
Refine_Level = Refine_Vec(kk);
% define mesh
if (DIM==1)
    % get mesh of [0, 1]
    NX = 2^Refine_Level + 1;
    [Edge, Pts] = regular_interval_mesh(NX);
    Mesh = MeshInterval(Edge, Pts, 'Omega');
    clear Edge Pts;
    
    % add the boundary
    BDY  = Mesh.freeBoundary();
    Mesh = Mesh.Append_Subdomain('0D','Gamma',BDY);
elseif (DIM==2)
    % get mesh of [0, 1] x [0, 1]
    NX = 2^Refine_Level + 1;
    NY = 2^Refine_Level + 1;
    [Tri, Pts] = regular_triangle_mesh(NX, NY);
    Mesh = MeshTriangle(Tri, Pts, 'Omega');
    clear Tri Pts;
    
    % add the boundary
    BDY  = Mesh.freeBoundary();
    Mesh = Mesh.Append_Subdomain('1D','Gamma',BDY);
elseif (DIM==3)
    % get mesh of [0, 1] x [0, 1] x [0, 1]
    NX = 2^Refine_Level + 1;
    NY = 2^Refine_Level + 1;
    NZ = 2^Refine_Level + 1;
    [Tet, Pts] = regular_tetrahedral_mesh(NX, NY, NZ);
    Mesh = MeshTetrahedron(Tet, Pts, 'Omega');
    clear Tet Pts;
    
    % add the boundary
    BDY  = Mesh.freeBoundary();
    Mesh = Mesh.Append_Subdomain('2D','Gamma',BDY);
else
    error('Invalid!');
end

% % plot mesh
% figure;
% Mesh.Plot;

% create GeoElementSpace
G_DoFmap = uint32(Mesh.ConnectivityList);

% define FE spaces
P_k = eval(['lagrange_deg', num2str(deg_k), '_dim', num2str(DIM), '();']);
P_k_RefElem = ReferenceFiniteElement(P_k);
V_Space = FiniteElementSpace('V_h', P_k_RefElem, Mesh, 'Omega');
V_DoFmap = UNIT_TEST_mex_Lagrange_triangle_DoF_Allocator(uint32(Mesh.ConnectivityList));
V_Space = V_Space.Set_DoFmap(Mesh,uint32(V_DoFmap));
clear V_DoFmap;
V_Space = V_Space.Append_Fixed_Subdomain(Mesh,'Gamma');

% disp('Points:');
% Mesh.Points
% 
% disp('Triangulation:');
% uint32(Mesh.ConnectivityList)
% 
% disp('V_Space DoFmap:');
% V_Space.DoFmap

discrete_soln = V_Space.Get_Zero_Function;

% assemble
tic
FEM = UNIT_TEST_mex_Assemble_FEL_Lagrange_triangle([],Mesh.Points,G_DoFmap,[],[],...
                V_Space.DoFmap,discrete_soln);
toc
% put FEM into a nice object to make accessing the matrices easier
my_Mats = FEMatrixAccessor('Lagrange',FEM);
clear FEM;

% pull out the matrices
M = my_Mats.Get_Matrix('Mass_Matrix');
K = my_Mats.Get_Matrix('Stiff_Matrix');
RHS = my_Mats.Get_Matrix('RHS');

% disp('Mass Matrix:');
% full(M)
% 
% disp('Grad_Grad_Term:');
% full(Grad_Grad_Term)
% 
% disp('Jump_Term:');
% full(Jump_Term)

% solve -\Delta u + u = f, with zero Dirichlet BCs
MAT = K + M;
Free_DoFs = V_Space.Get_Free_DoFs(Mesh);
if (DIM==3)
    RESTART = 1;
    TOL = 1E-10;
    MAXIT = 1000;
    disp(['Solve linear system with AGMG with TOL = ', num2str(TOL,'%1.2G'), ':']);
    tic
    discrete_soln(Free_DoFs,1) =...
        agmg(MAT(Free_DoFs,Free_DoFs),RHS(Free_DoFs,1),RESTART,TOL,MAXIT,[],[]);
    toc
else
    discrete_soln(Free_DoFs,1) = MAT(Free_DoFs,Free_DoFs) \ RHS(Free_DoFs,1);
end

tic
FEM = UNIT_TEST_mex_Assemble_FEL_Lagrange_triangle([],Mesh.Points,G_DoFmap,[],[],...
                V_Space.DoFmap,discrete_soln);
toc
% put FEM into a nice object to make accessing the matrices easier
my_Mats = FEMatrixAccessor('Lagrange',FEM);
clear FEM;

L2_Error_Sq = my_Mats.Get_Matrix('L2_Error_Sq');
L2_Error_Vec(kk) = sqrt(L2_Error_Sq);

L2_Grad_Error_Sq = my_Mats.Get_Matrix('L2_Grad_Error_Sq');
L2_Grad_Error_Vec(kk) = sqrt(L2_Grad_Error_Sq);

% find points in mesh
Cell_Indices = uint32([1; 2]);
% set some random global points
Omega_Neighbors = uint32(Mesh.neighbors);
Omega_Given_Points = {Cell_Indices, 0.5*ones(2,DIM), Omega_Neighbors};

% Vtx = Geo_Points;
% Tri = double(G_Space.DoFmap);

% search!
tic
SEARCH = UNIT_TEST_mex_FEL_Pt_Search_Lagrange_triangle(Mesh.Points,G_DoFmap,[],[],Omega_Given_Points);
toc
% SEARCH.DATA{1}
% SEARCH.DATA{2}

% now interpolate
Omega_Interp_Data = SEARCH.DATA;
Omega_Interp_Pts = Mesh.referenceToCartesian(double(Omega_Interp_Data{1}), Omega_Interp_Data{2});
Omega_Interp_Pts
INTERP_u0 = UNIT_TEST_mex_FEL_Interp_Lagrange_triangle(Mesh.Points,G_DoFmap,[],[],Omega_Interp_Data,V_Space.DoFmap,discrete_soln);
% extract data
%INTERP.DATA
u0_interp = INTERP_u0.DATA{1,1};
u0_interp

end

% figure;
% plot(Mesh.Points,discrete_soln,'k-');

% plot the error decay
C0_Vec = [0.6e0, 1e-1, 1e-1, 1e-2, 1e-2, 1e-2];
C1_Vec = [1e-1, 0.5e-1, 0.6e-2, 1e-4, 1e-5, 1e-4];
Order_k_Line        = C0_Vec(deg_k) * (2^deg_k).^(-Refine_Vec);
Order_k_plus_1_Line = C1_Vec(deg_k) * (2^(deg_k+1)).^(-Refine_Vec);
FH_error = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
semilogy(Refine_Vec,L2_Grad_Error_Vec,'r-d',...
         Refine_Vec,L2_Error_Vec,'k-d',...
         Refine_Vec,Order_k_Line,'r--',...
         Refine_Vec,Order_k_plus_1_Line,'k--');
xlabel('Refinement Level');
ylabel('Error');
title(['Conv. Rate of Solution to -\Delta u + u = f | deg. k = ', num2str(deg_k)]);
%axis([Refine_Vec(1) Refine_Vec(end) 1e-6 1e-1]);
legend({'$\| \nabla (u_h - u) \|_{L^2(\Omega)}$','$\| u_h - u \|_{L^2(\Omega)}$',...
        '$O(h^k)$ line','$O(h^{k+1})$ line'},'Interpreter','latex','FontSize',12,'Location','best');
grid;

L2_Error_Vec
L2_Grad_Error_Vec

%V_Space.num_dof

% % save mesh
% Vtx = Geo_Points;
% Tri = double(G_Space.DoFmap);
% 
% % Vtx = Mesh.Points;
% % Tri = Mesh.ConnectivityList;
% 
% MT = MeshTriangle(Tri,Vtx,'Test');
% figure;
% MT.Plot;
% 
% xmlmesh(Vtx,Tri,'xmlmesh_disk_2D.xml');

RefErrorDataFileName = fullfile(Main_Dir,'FEL_Execute_Lagrange_triangle_REF_Data.mat');
% save(RefErrorDataFileName,'L2_Error_Vec','L2_Grad_Error_Vec');
REF_DATA = load(RefErrorDataFileName);

% simple regression check
ERR_CHK1 = max(abs(REF_DATA.L2_Error_Vec - L2_Error_Vec));
ERR_CHK2 = max(abs(REF_DATA.L2_Grad_Error_Vec - L2_Grad_Error_Vec));
ERR_CHK = max(ERR_CHK1,ERR_CHK2);

% different computers should compute the same errors (up to round-off!)
status = 0; % init
if (ERR_CHK > 1e-10)
    disp('Lagrange triangle: convergence error failed!');
    ERR_CHK
    status = 1;
end

end