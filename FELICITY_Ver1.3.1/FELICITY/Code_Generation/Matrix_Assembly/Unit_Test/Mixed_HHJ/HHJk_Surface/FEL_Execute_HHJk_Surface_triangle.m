function status = FEL_Execute_HHJk_Surface_triangle(deg_geo,deg_k,surf_func,soln_tilde)
%FEL_Execute_HHJk_Surface_triangle
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 03-30-2018,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

Refine_Vec = [0 1 2 3 4 5 6 7 8]; % <= 7
Num_Refine = length(Refine_Vec);

% init error arrays
L2_Proj_Error_Vec = zeros(Num_Refine,1);
L2_Hess_Error_Vec = zeros(Num_Refine,1);
L2_Proj_Hess_Error_Vec = zeros(Num_Refine,1);
L2_Hess_FE_Error_Vec = zeros(Num_Refine,1);
L2_Soln_FE_Error_Vec = zeros(Num_Refine,1);
H1_Soln_FE_Error_Vec = zeros(Num_Refine,1);

% define domain parameterization
Psi = @(q1,q2) [q1, q2, surf_func(q1,q2)];

% exact function
exact_u = matlabFunction(soln_tilde);

for kk = 1:Num_Refine

% BEGIN: define surface (piecewise linear mesh)
Refine_Level = Refine_Vec(kk);
% get mesh of [0, 1] x [0, 1]
X_Len = 1;
Y_Len = 1;
NX = X_Len * 2^Refine_Level + 1;
NY = Y_Len * 2^Refine_Level + 1;
[Tri, Pts] = regular_triangle_mesh(NX, NY);
Pts(:,1) = X_Len * Pts(:,1);
Pts(:,2) = Y_Len * Pts(:,2);

% disk of radius 0.5
% Pts = 1*[0, 0; 1, 0; 0, 1];
% Tri = [1 2 3];

% Pts = 1*[0, 0; 1, 0; 0.5, 1];
% Tri = [1 2 3];

% Pts = [0, 0; 1, 0; 1, 1; 0, 1];
% Tri = [1 2 3; 1 3 4];

% Pts = [0, 0; 1, 0; 1, 1; 0, 1; 0.3, 0.4];
% Tri = [1 2 5; 2 3 5; 3 4 5; 4 1 5];

% Pts = [0, 0; 1, 0; 0, 1; 1, 1];
% Tri = [1 2 3; 2 4 3];

% apply parameterization
Pts_x_y_z = Psi(Pts(:,1), Pts(:,2));
Mesh = MeshTriangle(Tri, Pts_x_y_z, 'Gamma');
clear Tri Pts Pts_x_y_z;
% END: define surface (piecewise linear mesh)

% add the boundary
BDY  = Mesh.freeBoundary();
Mesh = Mesh.Append_Subdomain('1D','dGamma',BDY);

% add the skeleton
Mesh = Mesh.Append_Skeleton('Skeleton_Plus','Skeleton_Minus');

% % plot mesh
% figure;
% Mesh.Plot;

% create GeoElementSpace
Pk_Gamma = eval(['lagrange_deg', num2str(deg_geo), '_dim2();']);
G_Space_RefElem = ReferenceFiniteElement(Pk_Gamma);
G_Space = GeoElementSpace('G_h',G_Space_RefElem,Mesh);
if (deg_geo==1)
    G_DoFmap = uint32(Mesh.ConnectivityList);
else
    G_DoFmap = UNIT_TEST_mex_HHJ_Surface_G_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
end
G_Space = G_Space.Set_DoFmap(Mesh,uint32(G_DoFmap));
clear G_DoFmap;

% BEGIN: define the higher order surface
Geo_Points_hat = G_Space.Get_Mapping_For_Piecewise_Linear_Mesh(Mesh);
% initially starts as a piecewise Pk polynomial (e.g. P2 function) interpolating a
% piecewise linear (P1) function (representing the PW linear surface mesh)

% map back to (q_1,q_2) plane
Geo_q = Geo_Points_hat(:,1:2);

% apply parameterization
Geo_Points = Psi(Geo_q(:,1), Geo_q(:,2));
clear Geo_Points_hat Geo_q;
% END: define the higher order surface

% % plot the higher order domain
% figure;
% Temp_Pts = Mesh.Points;
% qm = trimesh(Mesh.ConnectivityList,Temp_Pts(:,1),Temp_Pts(:,2),Temp_Pts(:,3));
% set(qm,'EdgeColor','k');
% hold on;
% plot3(Geo_Points(:,1),Geo_Points(:,2),Geo_Points(:,3),'k*');
% hold off;
% view(2);
% axis equal;

% % plot skeleton
% figure;
% subplot(1,2,1);
% SK_plus = Mesh.Output_Subdomain_Mesh('Skeleton_Plus');
% SK_plus.Plot;
% subplot(1,2,2);
% SK_minus = Mesh.Output_Subdomain_Mesh('Skeleton_Minus');
% SK_minus.Plot;

% define FE spaces
P_k_plus_1 = eval(['lagrange_deg', num2str(deg_k+1), '_dim2();']);
P_k_plus_1_RefElem = ReferenceFiniteElement(P_k_plus_1);
W_Space = FiniteElementSpace('W_h', P_k_plus_1_RefElem, Mesh, 'Gamma');
W_DoFmap = UNIT_TEST_mex_HHJ_Surface_Pk_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
W_Space = W_Space.Set_DoFmap(Mesh,uint32(W_DoFmap));
clear W_DoFmap;

W_Space = W_Space.Append_Fixed_Subdomain(Mesh,'dGamma');

HHJ_k = eval(['hellan_herrmann_johnson_deg', num2str(deg_k), '_dim2();']);
HHJ_RefElem = ReferenceFiniteElement(HHJ_k);
V_Space = FiniteElementSpace('V_h', HHJ_RefElem, Mesh, 'Gamma');
V_DoFmap = UNIT_TEST_mex_HHJk_Surface_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
V_Space = V_Space.Set_DoFmap(Mesh,uint32(V_DoFmap));
clear V_DoFmap;

% disp('Points:');
% Mesh.Points
% 
% disp('Triangulation:');
% uint32(Mesh.ConnectivityList)
% 
% disp('V_Space DoFmap:');
% V_Space.DoFmap

% compute embedding data
Domain_Names = {'Gamma'; 'dGamma'; 'Skeleton_Plus'; 'Skeleton_Minus'};
Gamma_Subdomains = Mesh.Generate_Subdomain_Embedding_Data(Domain_Names);

%old_u = W_Space.Get_Zero_Function;
discrete_hess = V_Space.Get_Zero_Function;
proj_sig = V_Space.Get_Zero_Function;
u0 = W_Space.Get_Zero_Function;

% assemble
tic
FEM = UNIT_TEST_mex_Assemble_FEL_HHJk_Surface_triangle([],Geo_Points,G_Space.DoFmap,[],Gamma_Subdomains,...
                V_Space.DoFmap,W_Space.DoFmap,discrete_hess,0*discrete_hess,proj_sig,u0);
toc
% put FEM into a nice object to make accessing the matrices easier
my_Mats = FEMatrixAccessor('Surface',FEM);
clear FEM;

% pull out the matrices
M = my_Mats.Get_Matrix('Mass_Matrix');
%M_Scalar = my_Mats.Get_Matrix('Mass_Matrix_Scalar');
%K_Scalar = my_Mats.Get_Matrix('Stiff_Matrix_Scalar');
RHS_L2_Proj = my_Mats.Get_Matrix('RHS_L2_Proj');
Jump_Term = my_Mats.Get_Matrix('Jump_Term');
Grad_Grad_Term = my_Mats.Get_Matrix('Grad_Grad_Term');
DivDiv_Term = Grad_Grad_Term - Jump_Term;
RHS_f = my_Mats.Get_Matrix('RHS_f');

% disp('Mass Matrix:');
% full(M)
% 
% disp('Grad_Grad_Term:');
% full(Grad_Grad_Term)
% 
% disp('Jump_Term:');
% full(Jump_Term)


% compute HHJ function by L^2 projection
proj_sig = M \ RHS_L2_Proj;

% evaluate given smooth function
G_Space = G_Space.Set_mex_Dir(Main_Dir,'UNIT_TEST_mex_Interp_G_Space_HHJk_Surface_triangle');
XC = W_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);
u_h = exact_u(XC(:,1),XC(:,2));

% compute HHJ function by L^2 projection
discrete_hess = M \ (u_h' * DivDiv_Term)';

disp('Crude Error:');
max(abs(proj_sig - discrete_hess))

% now solve the Laplace-Beltrami problem!
Num_V_DoF = V_Space.num_dof;
Num_W_DoF = W_Space.num_dof;
MAT = [M,              -DivDiv_Term';
       -DivDiv_Term, sparse(Num_W_DoF,Num_W_DoF)];
%
RHS = [zeros(Num_V_DoF,1); -RHS_f];

Free_V_DoFs = V_Space.Get_Free_DoFs(Mesh);
Free_W_DoFs = W_Space.Get_Free_DoFs(Mesh) + Num_V_DoF;

Free_DoFs = [Free_V_DoFs; Free_W_DoFs];

Soln = zeros(Num_V_DoF + Num_W_DoF,1);
disp('Solve mixed biharmonic problem:');
tic
Soln(Free_DoFs) = MAT(Free_DoFs,Free_DoFs) \ RHS(Free_DoFs,1);
toc

sig_FE = Soln(1:Num_V_DoF,1);
u_FE   = Soln(Num_V_DoF+1:end,1);

tic
FEM = UNIT_TEST_mex_Assemble_FEL_HHJk_Surface_triangle([],Geo_Points,G_Space.DoFmap,[],Gamma_Subdomains,...
                V_Space.DoFmap,W_Space.DoFmap,discrete_hess,sig_FE,proj_sig,u_FE);
toc
% put FEM into a nice object to make accessing the matrices easier
my_Mats = FEMatrixAccessor('Surface',FEM);
clear FEM;

% Small_Matrix = my_Mats.Get_Matrix('Small_Matrix');
% %Small_Matrix
% exact_small_mat = pi * (-cos(0.25) + sin(0.25) - exp(-0.25) + (1/2)^5 + 2);
% Small_Matrix_Error_Vec(kk) = abs(Small_Matrix - exact_small_mat);

L2_Proj_Error_Sq = my_Mats.Get_Matrix('L2_Proj_Error_Sq');
L2_Proj_Error_Vec(kk) = sqrt(L2_Proj_Error_Sq);

L2_Hess_Error_Sq = my_Mats.Get_Matrix('L2_Hess_Error_Sq');
L2_Hess_Error_Vec(kk) = sqrt(L2_Hess_Error_Sq);

L2_Proj_Hess_Error_Sq = my_Mats.Get_Matrix('L2_Proj_Hess_Error_Sq');
L2_Proj_Hess_Error_Vec(kk) = sqrt(L2_Proj_Hess_Error_Sq);

L2_Hess_FE_Error_Sq = my_Mats.Get_Matrix('L2_Hess_FE_Error_Sq');
L2_Hess_FE_Error_Vec(kk) = sqrt(L2_Hess_FE_Error_Sq);

L2_Soln_FE_Error_Sq = my_Mats.Get_Matrix('L2_Soln_FE_Error_Sq');
L2_Soln_FE_Error_Vec(kk) = sqrt(L2_Soln_FE_Error_Sq);

H1_Soln_FE_Error_Sq = my_Mats.Get_Matrix('H1_Soln_FE_Error_Sq');
H1_Soln_FE_Error_Vec(kk) = sqrt(H1_Soln_FE_Error_Sq);

% find points in mesh
Cell_Indices = uint32([1; 2]);
% set some random global points
Gamma_Neighbors = uint32(Mesh.neighbors);
Gamma_Given_Points = {Cell_Indices, [0.5, 0.5, 1; 0.2, 0.3, 0.5], Gamma_Neighbors};

% Vtx = Geo_Points;
% Tri = double(G_Space.DoFmap);

% search!
tic
SEARCH = UNIT_TEST_mex_FEL_Pt_Search_HHJk_Surface_triangle(Geo_Points,G_Space.DoFmap,[],[],Gamma_Given_Points);
toc
% SEARCH.DATA{1}
% SEARCH.DATA{2}

% now interpolate
Gamma_Interp_Data = SEARCH.DATA;
Gamma_Interp_Pts = Mesh.referenceToCartesian(double(Gamma_Interp_Data{1}), Gamma_Interp_Data{2});
Gamma_Interp_Pts
INTERP_proj = UNIT_TEST_mex_FEL_Interp_HHJk_Surface_triangle(Geo_Points,G_Space.DoFmap,[],[],Gamma_Interp_Data,V_Space.DoFmap,proj_sig);
INTERP_discrete_hess = UNIT_TEST_mex_FEL_Interp_HHJk_Surface_triangle(Geo_Points,G_Space.DoFmap,[],[],Gamma_Interp_Data,V_Space.DoFmap,discrete_hess);
% extract data
%INTERP.DATA
proj_sig_1 = [INTERP_proj.DATA{1,1}(1), INTERP_proj.DATA{1,2}(1), INTERP_proj.DATA{1,3}(1);
              INTERP_proj.DATA{2,1}(1), INTERP_proj.DATA{2,2}(1), INTERP_proj.DATA{2,3}(1);
              INTERP_proj.DATA{3,1}(1), INTERP_proj.DATA{3,2}(1), INTERP_proj.DATA{3,3}(1);];
proj_sig_2 = [INTERP_proj.DATA{1,1}(2), INTERP_proj.DATA{1,2}(2), INTERP_proj.DATA{1,3}(2);
              INTERP_proj.DATA{2,1}(2), INTERP_proj.DATA{2,2}(2), INTERP_proj.DATA{2,3}(2);
              INTERP_proj.DATA{3,1}(2), INTERP_proj.DATA{3,2}(2), INTERP_proj.DATA{3,3}(2);];
%
discrete_hess_1 = [INTERP_discrete_hess.DATA{1,1}(1), INTERP_discrete_hess.DATA{1,2}(1), INTERP_discrete_hess.DATA{1,3}(1);
                   INTERP_discrete_hess.DATA{2,1}(1), INTERP_discrete_hess.DATA{2,2}(1), INTERP_discrete_hess.DATA{2,3}(1);
                   INTERP_discrete_hess.DATA{3,1}(1), INTERP_discrete_hess.DATA{3,2}(1), INTERP_discrete_hess.DATA{3,3}(1);];
discrete_hess_2 = [INTERP_discrete_hess.DATA{1,1}(2), INTERP_discrete_hess.DATA{1,2}(2), INTERP_discrete_hess.DATA{1,3}(2);
                   INTERP_discrete_hess.DATA{2,1}(2), INTERP_discrete_hess.DATA{2,2}(2), INTERP_discrete_hess.DATA{2,3}(2);
                   INTERP_discrete_hess.DATA{3,1}(2), INTERP_discrete_hess.DATA{3,2}(2), INTERP_discrete_hess.DATA{3,3}(2);];
%

proj_sig_1
proj_sig_2

eig(proj_sig_1)
eig(proj_sig_2)

discrete_hess_1
discrete_hess_2

end

% evaluate given smooth function
W_X = W_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);
BB = Mesh.Bounding_Box();
BB(1) = BB(1) - 0.1;
BB(2) = BB(2) + 0.1;
BB(3) = BB(3) - 0.1;
BB(4) = BB(4) + 0.1;
BB(5) = BB(5) - 0.1;
BB(6) = BB(6) + 0.1;
OT = mexOctree(W_X,BB);
[Mesh_to_W_X, Dist] = OT.kNN_Search(Mesh.Points,1);
P1_u = u_FE(Mesh_to_W_X,1);
%[Center_W_X_ind, Dist] = QT.kNN_Search([0 0],1);
%Dist
delete(OT);

figure;
trisurf(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2),Mesh.Points(:,3),P1_u);
shading interp;
% hold on;
% V_DoFs_Gamma = V_Space.Get_DoFs_On_Subdomain(Mesh,'Gamma');
% V_X = V_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);
% V_X_Gamma = V_X(V_DoFs_Gamma,:);
% plot(V_X_Gamma(:,1),V_X_Gamma(:,2),'k*');
% hold off;
AX = Mesh.Bounding_Box;
%view(2);
%view([10, 10]);
axis(AX);
axis equal;
axis(AX);
title('Numerical Solution');
colorbar;

% plot the error decay
Order_1_Line = 0.5e-1 * 2.^(-Refine_Vec);
Order_2_Line = 1e-1 * 4.^(-Refine_Vec);
Order_3_Line = 1e-1 * 8.^(-Refine_Vec);
Order_4_Line = 0.5e-1 * 16.^(-Refine_Vec);
FH_error = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
semilogy(Refine_Vec,L2_Proj_Error_Vec,'k-o',...
         Refine_Vec,L2_Hess_Error_Vec,'m-o',...
         Refine_Vec,Order_1_Line,'r-d',...
         Refine_Vec,Order_2_Line,'b-d',...
         Refine_Vec,Order_3_Line,'g-d',...
         Refine_Vec,Order_4_Line,'y-d');
xlabel('Refinement Level');
ylabel('Error');
title('Convergence Rate of L^2(\Gamma) Projection');
%axis([Refine_Vec(1) Refine_Vec(end) 1e-6 1e-1]);
legend({'$\| \Pi_h \sigma - \sigma \|_{L^2(\Gamma_h)}$','$\| \Pi_h (\nabla^2_{\Gamma_h})_h (I_h u) - \nabla^2_{\Gamma} u \|_{L^2(\Gamma_h)}$',...
        '$O(h)$ line','$O(h^2)$ line','$O(h^3)$ line','$O(h^4)$ line'},...
        'Interpreter','latex','FontSize',12,'Location','best');
grid;

%Small_Matrix_Error_Vec
L2_Proj_Error_Vec
L2_Hess_Error_Vec
L2_Proj_Hess_Error_Vec

disp('Errors for FE solution:');

L2_Hess_FE_Error_Vec
L2_Soln_FE_Error_Vec
H1_Soln_FE_Error_Vec

disp('Estimated Order of Convergence:');

L2_Hess_EOC = -log2(L2_Hess_FE_Error_Vec(2:end,1) ./ L2_Hess_FE_Error_Vec(1:end-1,1));
L2_Soln_EOC = -log2(L2_Soln_FE_Error_Vec(2:end,1) ./ L2_Soln_FE_Error_Vec(1:end-1,1));
H1_Soln_EOC = -log2(H1_Soln_FE_Error_Vec(2:end,1) ./ H1_Soln_FE_Error_Vec(1:end-1,1));
L2_Hess_EOC
L2_Soln_EOC
H1_Soln_EOC

Mesh

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

asfdasf

RefErrorDataFileName = fullfile(Main_Dir,'FEL_Execute_HHJk_Flat_2D_REF_Data.mat');
% save(RefErrorDataFileName,'L2_Error_Vec','Small_Matrix_Error_Vec');
REF_DATA = load(RefErrorDataFileName);

% simple regression check
ERR_CHK1 = max(abs(REF_DATA.L2_Error_Vec - L2_Proj_Error_Vec));
ERR_CHK2 = max(abs(REF_DATA.Small_Matrix_Error_Vec - Small_Matrix_Error_Vec));
ERR_CHK = max(ERR_CHK1,ERR_CHK2);

% different computers should compute the same errors (up to round-off!)
status = 0; % init
if (ERR_CHK > 1e-10)
    disp('HHJk on a curved disk in 2-D: convergence error failed!');
    ERR_CHK
    status = 1;
end

end