function status = FEL_Execute_HHJk_triangle(deg_geo,deg_k,exact_u)
%FEL_Execute_HHJk_triangle
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 03-28-2018,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

Refine_Vec = [0 1 2 3 4 5 6];
Num_Refine = length(Refine_Vec);

% init two arrays, one for each mapping method
Small_Matrix_Error_Vec = zeros(Num_Refine,1);
L2_Proj_Error_Vec = zeros(Num_Refine,1);
L2_Hess_Error_Vec = zeros(Num_Refine,1);
L2_Proj_Hess_Error_Vec = zeros(Num_Refine,1);

for kk = 1:Num_Refine

% BEGIN: define reference mesh
Refine_Level = Refine_Vec(kk);
% % get mesh of disk
% [Tri, Pts] = triangle_mesh_of_disk([0, 0],0.5,Refine_Level);

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

Mesh = MeshTriangle(Tri, Pts, 'Omega');
clear Tri Pts;
% END: define reference mesh

% add the boundary
BDY  = Mesh.freeBoundary();
Mesh = Mesh.Append_Subdomain('1D','Gamma',BDY);

% add the skeleton
Mesh = Mesh.Append_Skeleton('Skeleton_Plus','Skeleton_Minus');

% % plot mesh
% figure;
% Mesh.Plot;

% create GeoElementSpace
Pk_Omega = eval(['lagrange_deg', num2str(deg_geo), '_dim2();']);
G_Space_RefElem = ReferenceFiniteElement(Pk_Omega);
G_Space = GeoElementSpace('G_h',G_Space_RefElem,Mesh);
if (deg_geo==1)
    G_DoFmap = uint32(Mesh.ConnectivityList);
else
    G_DoFmap = UNIT_TEST_mex_HHJ_G_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
end
G_Space = G_Space.Set_DoFmap(Mesh,uint32(G_DoFmap));
clear G_DoFmap;

% BEGIN: define the higher order domain
Geo_Points_hat = G_Space.Get_Mapping_For_Piecewise_Linear_Mesh(Mesh);
% initially starts as a piecewise quadratic polynomial (P2 function) interpolating a
% piecewise linear (P1) function (representing the initial mesh)

DoFs_on_Gamma = G_Space.Get_DoFs_On_Subdomain(Mesh,'Gamma');
GP_Gamma = Geo_Points_hat(DoFs_on_Gamma,:);
% normalize so they have distance 0.5 from origin
GP_Dist = sqrt(sum(GP_Gamma.^2,2));
GP_Gamma(:,1) = 0.5 * GP_Gamma(:,1) ./ GP_Dist;
GP_Gamma(:,2) = 0.5 * GP_Gamma(:,2) ./ GP_Dist;
Geo_Points = Geo_Points_hat;
if (deg_geo > 1)
    Geo_Points(DoFs_on_Gamma,:) = GP_Gamma;
end
clear DoFs_on_Gamma GP_Gamma GP_Dist Geo_Points_hat;
% END: define the higher order domain

% % plot the higher order domain
% figure;
% Temp_Pts = Mesh.Points;
% qm = trimesh(Mesh.ConnectivityList,Temp_Pts(:,1),Temp_Pts(:,2),0*Temp_Pts(:,2));
% set(qm,'EdgeColor','k');
% hold on;
% plot(Geo_Points(:,1),Geo_Points(:,2),'k*');
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
W_Space = FiniteElementSpace('W_h', P_k_plus_1_RefElem, Mesh, 'Omega');
W_DoFmap = UNIT_TEST_mex_HHJ_Pk_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
W_Space = W_Space.Set_DoFmap(Mesh,uint32(W_DoFmap));
clear W_DoFmap;

HHJ_k = eval(['hellan_herrmann_johnson_deg', num2str(deg_k), '_dim2();']);
HHJ_RefElem = ReferenceFiniteElement(HHJ_k);
V_Space = FiniteElementSpace('V_h', HHJ_RefElem, Mesh, 'Omega');
V_DoFmap = UNIT_TEST_mex_HHJk_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
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
Domain_Names = {'Omega'; 'Gamma'; 'Skeleton_Plus'; 'Skeleton_Minus'};
Omega_Subdomains = Mesh.Generate_Subdomain_Embedding_Data(Domain_Names);

%old_u = W_Space.Get_Zero_Function;
discrete_hess = V_Space.Get_Zero_Function;
proj_hess = V_Space.Get_Zero_Function;

% assemble
tic
FEM = UNIT_TEST_mex_Assemble_FEL_HHJk_triangle([],Geo_Points,G_Space.DoFmap,[],Omega_Subdomains,...
                V_Space.DoFmap,W_Space.DoFmap,discrete_hess,proj_hess);
toc
% put FEM into a nice object to make accessing the matrices easier
my_Mats = FEMatrixAccessor('HHJk',FEM);
clear FEM;

% pull out the matrices
M = my_Mats.Get_Matrix('Mass_Matrix');
%M_Scalar = my_Mats.Get_Matrix('Mass_Matrix_Scalar');
%K_Scalar = my_Mats.Get_Matrix('Stiff_Matrix_Scalar');
RHS_L2_Proj = my_Mats.Get_Matrix('RHS_L2_Proj');
Jump_Term = my_Mats.Get_Matrix('Jump_Term');
Grad_Grad_Term = my_Mats.Get_Matrix('Grad_Grad_Term');
DivDiv_Term = Grad_Grad_Term - Jump_Term;

% compute HHJ function by L^2 projection
proj_hess = M \ RHS_L2_Proj;

% evaluate given smooth function
G_Space = G_Space.Set_mex_Dir(Main_Dir,'UNIT_TEST_mex_Interp_G_Space_HHJk_triangle');
XC = W_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);
exact_u_func = matlabFunction(exact_u);
%exact_u_func
u_h = exact_u_func(XC(:,1),XC(:,2));
% rad = 0.5;
% exact_u = @(x,y) (rad^2 - (x.^2 + y.^2)).^2 .* sin(x) .* cos(y);
% u_h = exact_u(XC(:,1),XC(:,2));

% compute HHJ function by L^2 projection
discrete_hess = M \ (u_h' * DivDiv_Term)';

tic
FEM = UNIT_TEST_mex_Assemble_FEL_HHJk_triangle([],Geo_Points,G_Space.DoFmap,[],Omega_Subdomains,...
                V_Space.DoFmap,W_Space.DoFmap,discrete_hess,proj_hess);
toc
% put FEM into a nice object to make accessing the matrices easier
my_Mats = FEMatrixAccessor('HHJk',FEM);
clear FEM;

Small_Matrix = my_Mats.Get_Matrix('Small_Matrix');
%Small_Matrix
exact_small_mat = pi * (-cos(0.25) + sin(0.25) - exp(-0.25) + (1/2)^5 + 2);
Small_Matrix_Error_Vec(kk) = abs(Small_Matrix - exact_small_mat);
% SWW: fix this!!!!

L2_Proj_Error_Sq = my_Mats.Get_Matrix('L2_Proj_Error_Sq');
L2_Proj_Error_Vec(kk) = sqrt(L2_Proj_Error_Sq);

L2_Hess_Error_Sq = my_Mats.Get_Matrix('L2_Hess_Error_Sq');
L2_Hess_Error_Vec(kk) = sqrt(L2_Hess_Error_Sq);

L2_Proj_Hess_Error_Sq = my_Mats.Get_Matrix('L2_Proj_Hess_Error_Sq');
L2_Proj_Hess_Error_Vec(kk) = sqrt(L2_Proj_Hess_Error_Sq);

% find points in mesh
Cell_Indices = uint32([1; 2]);
% set some random global points
Omega_Neighbors = uint32(Mesh.neighbors);
Omega_Given_Points = {Cell_Indices, [0, 0; 0.2, 0.3], Omega_Neighbors};

% Vtx = Geo_Points;
% Tri = double(G_Space.DoFmap);

% search!
tic
SEARCH = UNIT_TEST_mex_FEL_Pt_Search_HHJk_triangle(Geo_Points,G_Space.DoFmap,[],[],Omega_Given_Points);
toc
% SEARCH.DATA{1}
% SEARCH.DATA{2}

% now interpolate
Omega_Interp_Data = SEARCH.DATA;
Omega_Interp_Pts = Mesh.referenceToCartesian(double(Omega_Interp_Data{1}), Omega_Interp_Data{2});
Omega_Interp_Pts
INTERP = UNIT_TEST_mex_FEL_Interp_HHJk_triangle(Geo_Points,G_Space.DoFmap,[],[],Omega_Interp_Data,V_Space.DoFmap,discrete_hess);
% extract data
%INTERP.DATA
sig_hess_1 = [INTERP.DATA{1,1}(1), INTERP.DATA{1,2}(1);
              INTERP.DATA{2,1}(1), INTERP.DATA{2,2}(1)];
sig_hess_2 = [INTERP.DATA{1,1}(2), INTERP.DATA{1,2}(2);
              INTERP.DATA{2,1}(2), INTERP.DATA{2,2}(2)];
%
sig_hess_1
sig_hess_2

end

% plot the error decay
Order_1_Line = 0.1 * 2.^(-Refine_Vec);
Order_2_Line = 0.1 * 4.^(-Refine_Vec);
Order_3_Line = 0.1 * 8.^(-Refine_Vec);
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
title('Convergence Rate of L^2(\Omega) Projection');
%axis([Refine_Vec(1) Refine_Vec(end) 1e-4 1e0]);
legend({'$\| \Pi_h \sigma - \sigma \|_{L^2(\Omega)}$','$\| \Pi_h \nabla^2_h (I_h u) - \nabla^2 u \|_{L^2(\Omega)}$',...
        '$O(h)$ line','$O(h^2)$ line','$O(h^3)$ line','$O(h^4)$ line'},...
        'Interpreter','latex','FontSize',12,'Location','best');
grid;

Small_Matrix_Error_Vec
L2_Proj_Error_Vec
L2_Hess_Error_Vec
L2_Proj_Hess_Error_Vec

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