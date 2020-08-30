function status = FEL_Execute_Flat_Beam_2D(deg_geo,deg_k)
%FEL_Execute_Flat_Beam_2D
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 03-30-2018,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

Refine_Vec = 4; %[0 1 2 3 4 5];
Num_Refine = length(Refine_Vec);

% % init two arrays, one for each mapping method
%Small_Matrix_Error_Vec = zeros(Num_Refine,1);
%L2_Error_Vec = zeros(Num_Refine,1);
%L2_Hess_Error_Vec = zeros(Num_Refine,1);

% % define domain parameterization
% Psi = @(u,v) [u, v + u.*(1-u).*(v-0.5)];
% Gamma_y_bot = @(x) x.*(1-x).*(-0.5);
% Gamma_y_top = @(x) 1 + x.*(1-x).*(1-0.5);

for kk = 1:Num_Refine

% BEGIN: define reference mesh
Refine_Level = Refine_Vec(kk);
% get mesh of rectangle
X_Len = 8;
Y_Len = 1;
NX = X_Len * 2^Refine_Level + 1;
NY = Y_Len * 2^Refine_Level + 1;
[Tri, Pts] = regular_triangle_mesh(NX, NY);
Pts(:,1) = X_Len * Pts(:,1);

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

% add the left edge
MidPt = (1/2)*(Mesh.Points(BDY(:,1),:) + Mesh.Points(BDY(:,2),:));
Left_Mask = (MidPt(:,1) < 1e-10);
Left_Edges = BDY(Left_Mask,:);
Mesh = Mesh.Append_Subdomain('1D','Left_Edge',Left_Edges);
% add the rest
Free_Edges = BDY(~Left_Mask,:);
Mesh = Mesh.Append_Subdomain('1D','Free_Edges',Free_Edges);

% add the skeleton
Mesh = Mesh.Append_Skeleton('Skeleton_Plus','Skeleton_Minus');

clear BDY;

% % plot mesh
% figure;
% Mesh.Plot;
% figure;
% Mesh.Plot_Subdomain('Left_Edge');
% %Mesh.Plot_Subdomain('Free_Edges');
% safdasfd

% create GeoElementSpace
Pk_Omega = eval(['lagrange_deg', num2str(deg_geo), '_dim2();']);
G_Space_RefElem = ReferenceFiniteElement(Pk_Omega);
G_Space = GeoElementSpace('G_h',G_Space_RefElem,Mesh);
if (deg_geo==1)
    G_DoFmap = uint32(Mesh.ConnectivityList);
else
    G_DoFmap = UNIT_TEST_mex_Flat_Beam_2D_G_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
end
G_Space = G_Space.Set_DoFmap(Mesh,uint32(G_DoFmap));
clear G_DoFmap;

% BEGIN: define the higher order domain
Geo_Points_hat = G_Space.Get_Mapping_For_Piecewise_Linear_Mesh(Mesh);
% initially starts as a piecewise quadratic polynomial (P2 function) interpolating a
% piecewise linear (P1) function (representing the initial mesh)

Geo_Points = Geo_Points_hat;
clear Geo_Points_hat;

% DoFs_on_Gamma = G_Space.Get_DoFs_On_Subdomain(Mesh,'Gamma');
% GP_Gamma = Geo_Points_hat(DoFs_on_Gamma,:);
% % normalize so they have distance 0.5 from origin
% GP_Dist = sqrt(sum(GP_Gamma.^2,2));
% GP_Gamma(:,1) = 0.5 * GP_Gamma(:,1) ./ GP_Dist;
% GP_Gamma(:,2) = 0.5 * GP_Gamma(:,2) ./ GP_Dist;
% Geo_Points = Geo_Points_hat;
% if (deg_geo > 1)
%     Geo_Points(DoFs_on_Gamma,:) = GP_Gamma;
% end
% clear DoFs_on_Gamma GP_Gamma GP_Dist Geo_Points_hat;
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
W_DoFmap = UNIT_TEST_mex_Flat_Beam_2D_W_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
W_Space = W_Space.Set_DoFmap(Mesh,uint32(W_DoFmap));
clear W_DoFmap;

% set fixed DoFs
W_Space = W_Space.Append_Fixed_Subdomain(Mesh,'Left_Edge');

HHJ_k = eval(['hellan_herrmann_johnson_deg', num2str(deg_k), '_dim2();']);
HHJ_RefElem = ReferenceFiniteElement(HHJ_k);
V_Space = FiniteElementSpace('V_h', HHJ_RefElem, Mesh, 'Omega');
V_DoFmap = UNIT_TEST_mex_Flat_Beam_2D_V_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
V_Space = V_Space.Set_DoFmap(Mesh,uint32(V_DoFmap));
clear V_DoFmap;

% set fixed DoFs
V_Space = V_Space.Append_Fixed_Subdomain(Mesh,'Free_Edges');

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
% discrete_hess = V_Space.Get_Zero_Function;
% proj_sig = V_Space.Get_Zero_Function;

% assemble
tic
FEM = UNIT_TEST_mex_Assemble_Flat_Beam_2D([],Geo_Points,G_Space.DoFmap,[],Omega_Subdomains,...
                V_Space.DoFmap,W_Space.DoFmap);
toc
% put FEM into a nice object to make accessing the matrices easier
my_Mats = FEMatrixAccessor('Rectangle Domain',FEM);
clear FEM;

% pull out the matrices
M = my_Mats.Get_Matrix('Mass_Matrix');
M_Scalar = my_Mats.Get_Matrix('Mass_Matrix_Scalar');
%K_Scalar = my_Mats.Get_Matrix('Stiff_Matrix_Scalar');
%RHS_L2_Proj = my_Mats.Get_Matrix('RHS_L2_Proj');
Jump_Term = my_Mats.Get_Matrix('Jump_Term');
Grad_Grad_Term = my_Mats.Get_Matrix('Grad_Grad_Term');
DivDiv_h_Term = Grad_Grad_Term - Jump_Term;
%Small_Matrix = my_Mats.Get_Matrix('Small_Matrix');
%L2_Error_Sq = my_Mats.Get_Matrix('L2_Error_Sq');

% define f
exact_f = @(x,y) 0*x - 0.005;
% evaluate given smooth function
G_Space = G_Space.Set_mex_Dir(Main_Dir,'UNIT_TEST_mex_Interp_G_Space_Flat_Beam_2D');
W_X = W_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);
f_h = exact_f(W_X(:,1),W_X(:,2));

% solve problem
Num_V_DoF = V_Space.num_dof;
Num_W_DoF = W_Space.num_dof;
MAT = [M,              -DivDiv_h_Term';
       -DivDiv_h_Term, sparse(Num_W_DoF,Num_W_DoF)];
%
RHS = [zeros(Num_V_DoF,1); -M_Scalar * f_h];

Free_V_DoFs = V_Space.Get_Free_DoFs(Mesh);
Free_W_DoFs = W_Space.Get_Free_DoFs(Mesh) + Num_V_DoF;
Free_DoFs = [Free_V_DoFs; Free_W_DoFs];

Soln = zeros(Num_V_DoF + Num_W_DoF,1);
disp('Solve mixed biharmonic problem:');
tic
Soln(Free_DoFs) = MAT(Free_DoFs,Free_DoFs) \ RHS(Free_DoFs,1);
toc

sig_soln = Soln(1:Num_V_DoF,1);
u_soln = Soln(Num_V_DoF+1:end,1);

% % compute HHJ function by L^2 projection
% proj_sig = M \ RHS_L2_Proj;
% 
% % evaluate given smooth function
% G_Space = G_Space.Set_mex_Dir(Main_Dir,'UNIT_TEST_mex_Interp_G_Space_Flat_Beam_2D');
% XC = W_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);
% rad = 0.5;
% exact_u = @(x,y) (rad^2 - (x.^2 + y.^2)).^2 .* sin(x) .* cos(y);
% u_h = exact_u(XC(:,1),XC(:,2));
% 
% % compute HHJ function by L^2 projection
% discrete_hess = M \ (u_h' * DivDiv_h_Term)';
% 
% tic
% FEM = UNIT_TEST_mex_Assemble_Flat_Beam_2D([],Geo_Points,G_Space.DoFmap,[],Omega_Subdomains,...
%                 V_Space.DoFmap,W_Space.DoFmap,discrete_hess,proj_sig);
% toc
% % put FEM into a nice object to make accessing the matrices easier
% my_Mats = FEMatrixAccessor('Disk Domain',FEM);
% clear FEM;
% 
% Small_Matrix = my_Mats.Get_Matrix('Small_Matrix');
% %Small_Matrix
% exact_small_mat = pi * (-cos(0.25) + sin(0.25) - exp(-0.25) + (1/2)^5 + 2);
% Small_Matrix_Error_Vec(kk) = abs(Small_Matrix - exact_small_mat);
% 
% L2_Error_Sq = my_Mats.Get_Matrix('L2_Error_Sq');
% L2_Error_Vec(kk) = sqrt(L2_Error_Sq);
% 
% L2_Hess_Error_Sq = my_Mats.Get_Matrix('L2_Hess_Error_Sq');
% L2_Hess_Error_Vec(kk) = sqrt(L2_Hess_Error_Sq);



% find points in mesh
Cell_Indices = uint32([1; 2]);
% set some random global points
Omega_Neighbors = uint32(Mesh.neighbors);
Omega_Given_Points = {Cell_Indices, [0.1, 0.1; 4.2, 0.6], Omega_Neighbors};

% Vtx = Geo_Points;
% Tri = double(G_Space.DoFmap);

% search!
tic
SEARCH = UNIT_TEST_mex_FEL_Pt_Search_Flat_Beam_2D(Geo_Points,G_Space.DoFmap,[],[],Omega_Given_Points);
toc
% SEARCH.DATA{1}
% SEARCH.DATA{2}

% now interpolate
Omega_Interp_Data = SEARCH.DATA;
Omega_Interp_Pts = Mesh.referenceToCartesian(double(Omega_Interp_Data{1}), Omega_Interp_Data{2});
Omega_Interp_Pts
INTERP = UNIT_TEST_mex_FEL_Interp_Flat_Beam_2D(Geo_Points,G_Space.DoFmap,[],[],Omega_Interp_Data,V_Space.DoFmap,sig_soln);
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

QT = mexQuadtree(W_X);
[Mesh_to_W_X, Dist] = QT.kNN_Search(Mesh.Points,1);
P1_u = u_soln(Mesh_to_W_X,1);

figure;
trisurf(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2),P1_u);
shading interp;
AX = Mesh.Bounding_Box;
view(2);
axis(AX);
axis equal;
axis(AX);


sadfsafd

% plot the error decay
Order_1_Line = 0.1 * 2.^(-Refine_Vec);
Order_2_Line = 0.1 * 4.^(-Refine_Vec);
FH_error = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
semilogy(Refine_Vec,L2_Error_Vec,'k-o',...
         Refine_Vec,L2_Hess_Error_Vec,'m-o',...
         Refine_Vec,Order_1_Line,'r-d',...
         Refine_Vec,Order_2_Line,'b-d');
xlabel('Refinement Level');
ylabel('Error');
title('Convergence Rate of L^2(\Omega) Projection');
axis([Refine_Vec(1) Refine_Vec(end) 1e-4 1e0]);
legend({'$\| \Pi_h \sigma - \sigma \|_{L^2(\Omega)}$','$\| \Pi_h \nabla^2_h (I_h u) - \nabla^2 u \|_{L^2(\Omega)}$',...
        '$O(h)$ line','$O(h^2)$ line'},'Interpreter','latex','FontSize',12,'Location','best');
grid;

Small_Matrix_Error_Vec
L2_Error_Vec
L2_Hess_Error_Vec

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

RefErrorDataFileName = fullfile(Main_Dir,'FEL_Execute_Flat_Beam_2D_REF_Data.mat');
% save(RefErrorDataFileName,'L2_Error_Vec','Small_Matrix_Error_Vec');
REF_DATA = load(RefErrorDataFileName);

% simple regression check
ERR_CHK1 = max(abs(REF_DATA.L2_Error_Vec - L2_Error_Vec));
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