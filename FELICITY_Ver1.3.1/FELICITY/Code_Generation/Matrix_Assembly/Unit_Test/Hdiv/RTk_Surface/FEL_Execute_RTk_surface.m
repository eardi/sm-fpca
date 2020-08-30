function status = FEL_Execute_RTk_surface(deg_surf, deg_sig, deg_p)
%FEL_Execute_RTk_surface
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 02-16-2018,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

Refine_Vec = [2 3 4 5 6]; % level 7 is too demanding of "weak" computers
Num_Refine = length(Refine_Vec);

% init arrays to store numerical errors
p_Error_Vec = zeros(Num_Refine,1);
sig_Error_Vec = zeros(Num_Refine,1);
div_sig_Error_Vec = zeros(Num_Refine,1);

% define domain parameterization
[surf_func, soln_func, soln_surf_grad_func, normal_vec_func, f_func] = DiffGeo_RTk_surface();
Psi = @(q1,q2) [q1, q2, surf_func(q1,q2)];

for kk = 1:Num_Refine

% BEGIN: define surface (piecewise linear mesh)
Refine_Level = Refine_Vec(kk);
% create mesh of unit square [0,1]^2
NP = 2^Refine_Level + 1;
[Tri, Pts_q] = bcc_triangle_mesh(NP,NP);
% apply parameterization
Pts_x_y_z = Psi(Pts_q(:,1), Pts_q(:,2));
Mesh = MeshTriangle(Tri, Pts_x_y_z, 'Gamma');
clear Tri Pts_q Pts_x_y_z;
% END: define surface (piecewise linear mesh)

% add the open boundary
BDY  = Mesh.freeBoundary();
Mesh = Mesh.Append_Subdomain('1D','d_Gamma',BDY);
clear BDY;
%Mesh.Plot;

% compute the embedding
DoI_Names = {'Gamma'; 'd_Gamma'}; % domains of integration
Mesh_Subdomains = Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);

% create GeoElementSpace
P_Surf_Gamma = eval(['lagrange_deg', num2str(deg_surf), '_dim2();']);
G_Space_RefElem = ReferenceFiniteElement(P_Surf_Gamma);
G_Space = GeoElementSpace('G_h',G_Space_RefElem,Mesh);
G_DoFmap = mex_RTk_Surf_G_Space_DoF_Alloc(uint32(Mesh.ConnectivityList));
G_Space = G_Space.Set_DoFmap(Mesh,uint32(G_DoFmap));

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

% figure;
% plot3(Geo_Points(:,1),Geo_Points(:,2),Geo_Points(:,3),'k*');

% define FE spaces
Sigma_RT_Gamma = eval(['raviart_thomas_deg', num2str(deg_sig), '_dim2();']);
RTk_RefElem = ReferenceFiniteElement(Sigma_RT_Gamma);
Sigma_Space = FiniteElementSpace('Sigma_Space', RTk_RefElem, Mesh, 'Gamma');
Sigma_DoFmap = mex_RTk_Surf_Sigma_DoF_Alloc(uint32(Mesh.ConnectivityList));
Sigma_Space = Sigma_Space.Set_DoFmap(Mesh,uint32(Sigma_DoFmap));
clear Sigma_DoFmap;

P_Lag_Gamma = eval(['lagrange_deg', num2str(deg_p), '_dim2(''DG'');']);
Pk_DG_RefElem = ReferenceFiniteElement(P_Lag_Gamma);
P_Space    = FiniteElementSpace('P_Space', Pk_DG_RefElem, Mesh, 'Gamma');
P_DoFmap   = mex_RTk_Surf_Pk_DG_DoF_Alloc(uint32(Mesh.ConnectivityList));
P_Space    = P_Space.Set_DoFmap(Mesh,uint32(P_DoFmap));
clear P_DoFmap;

P1_RefElem = ReferenceFiniteElement(lagrange_deg1_dim2());
V_Space    = FiniteElementSpace('V_Space', P1_RefElem, Mesh, 'Gamma');
V_DoFmap   = uint32(Mesh.ConnectivityList);
V_Space    = V_Space.Set_DoFmap(Mesh,uint32(V_DoFmap));
clear V_DoFmap;

% get facet info
Edges = Mesh.edges;
[Tri_Edge, Gamma_Orient] = Mesh.Get_Facet_Info(Edges);
% a true entry means the local edge of the given triangle is contained in the
% Tri_Edge array; false means the *reversed* edge is in the Tri_Edge array.

% init sigma and p variables
p_coef   = zeros(P_Space.num_dof(),1);
sig_coef = zeros(Sigma_Space.num_dof(),1);

% assemble
tic
FEM = UNIT_TEST_mex_Assemble_FEL_RTk_surface([],Geo_Points,G_Space.DoFmap,Gamma_Orient,Mesh_Subdomains,...
                        P_Space.DoFmap,Sigma_Space.DoFmap,V_Space.DoFmap,p_coef,sig_coef);
toc
% put FEM into a nice object to make accessing the matrices easier
mats = FEMatrixAccessor('RT1 on a Surface',FEM);

% pull out the matrices
Sigma_Mass_Matrix = mats.Get_Matrix('Sigma_Mass_Matrix');
P_Mass_Matrix = mats.Get_Matrix('P_Mass_Matrix');
Div_Matrix = mats.Get_Matrix('Div_Matrix');
RHS_Matrix = mats.Get_Matrix('RHS_Matrix');
CG_M = mats.Get_Matrix('CG_M');
Proj_Sigma_MAT = mats.Get_Matrix('Proj_Sigma_MAT');
Proj_P_MAT = mats.Get_Matrix('Proj_P_MAT');
% N_DOT_sigma = mats.Get_Matrix('N_DOT_sigma');
% L2_p_soln_sq = mats.Get_Matrix('L2_p_soln_sq');
% L2_sig_soln_sq = mats.Get_Matrix('L2_sig_soln_sq');
% L2_div_sig_soln_sq = mats.Get_Matrix('L2_div_sig_soln_sq');

% get coordinates of DoFs in V_Space
G_Space = G_Space.Set_mex_Dir(Main_Dir,'mex_RTk_Surface_G_Space_Interpolation');
P_Points = P_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);

% compute the exact solution (for boundary condition)
p_h_exact = soln_func(P_Points(:,1),P_Points(:,2));

% define RHS data
f_h = f_func(P_Points(:,1),P_Points(:,2));

disp('Solve mixed Laplace-Beltrami (two first order systems):');
% make the big matrix
P_Num = P_Space.num_dof;
Sig_Num = Sigma_Space.num_dof;
ZZ = sparse(P_Num,P_Num);
MAT = [Sigma_Mass_Matrix, Div_Matrix';
       Div_Matrix, ZZ];
RHS = -[RHS_Matrix*p_h_exact; P_Mass_Matrix*f_h];
% use backslash to solve
Soln = MAT \ RHS;

% parse the solution
sig_h = Soln(1:Sig_Num,1);
p_h = Soln(Sig_Num+1:end,1);

% compute errors in solution
tic
FEM = UNIT_TEST_mex_Assemble_FEL_RTk_surface(FEM,Geo_Points,G_Space.DoFmap,Gamma_Orient,Mesh_Subdomains,...
                        P_Space.DoFmap,Sigma_Space.DoFmap,V_Space.DoFmap,p_h,sig_h);
%
toc
% put FEM into a nice object to make accessing the matrices easier
Error_mats = FEMatrixAccessor('Errors',FEM);
clear FEM;

N_DOT_sigma = Error_mats.Get_Matrix('N_DOT_sigma');
disp('Integral of sig_h DOT normal vector');
max(abs(N_DOT_sigma))

% pull out the (squared) errors, and take sqrt!
L2_p_soln_sq = Error_mats.Get_Matrix('L2_p_soln_sq');
L2_sig_soln_sq = Error_mats.Get_Matrix('L2_sig_soln_sq');
L2_div_sig_soln_sq = Error_mats.Get_Matrix('L2_div_sig_soln_sq');

% record the error
p_Error_Vec(kk) = sqrt(L2_p_soln_sq);
sig_Error_Vec(kk) = sqrt(L2_sig_soln_sq + L2_div_sig_soln_sq);
div_sig_Error_Vec(kk) = sqrt(L2_div_sig_soln_sq);

end

% now we plot the solution on the last mesh

% do an L^2 projection of sigma and p onto P1 continuous
Num_P1 = size(CG_M,1)/3;
P1_sig_h = zeros(Num_P1,3);
P1_sig_h(:) = CG_M \ (Proj_Sigma_MAT * sig_h);
P1_p_h = CG_M \ (Proj_P_MAT * p_h);
P1_p_h = P1_p_h(1:Num_P1,1);

% plot p solution (and vector field \sigma)
disp('Plot Solution Of mixed Laplace-Beltrami:');
FH_p_h = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
trisurf(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2),Mesh.Points(:,3),P1_p_h);
shading interp;
colormap(jet);
%light;
% lightangle(80,-20);
% lightangle(-40,40);
% %camlight left;
% %camlight right;
% lighting phong;
colorbar;
caxis([min(P1_p_h) max(P1_p_h)]);
hold on;
quiver3(Mesh.Points(:,1),Mesh.Points(:,2),Mesh.Points(:,3),P1_sig_h(:,1),P1_sig_h(:,2),P1_sig_h(:,3));
hold off;
title('P1 p_h (and P1 sig_h) on \Gamma');
%title('plotu');
xlabel('X');
ylabel('Y');
zlabel('Z');
%set(gca,'FontSize',10);
AX = [0 1 0 1 0 1];
axis(AX);
axis equal;
axis(AX);
view([-35,30]);

% plot the error decay
Order_1_Line = 50 * 2.^(-Refine_Vec);
Order_2_Line = 32 * 4.^(-Refine_Vec);
FH_error = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
semilogy(Refine_Vec,p_Error_Vec,'k-.*',Refine_Vec,sig_Error_Vec,'r-.*',Refine_Vec,div_sig_Error_Vec,'g-.*',...
         Refine_Vec,Order_1_Line,'b-d',Refine_Vec,Order_2_Line,'m-d');
xlabel('Refinement Level');
ylabel('L^2 errors');
title('Numerical Convergence Rates');
% xlabel('reflev');
% ylabel('errors');
% title('convrate');
axis([2 6 1e-6 1e2]);
set(gca,'XTick',[2 3 4 5 6]);
legend({'$\| p - p_h \|_{L^2(\Gamma)}$', '$\| \sigma - \sigma_h \|_{H(div,\Gamma)}$',...
        '$\| \nabla_{\Gamma} \cdot \sigma - \nabla_{\Gamma} \cdot \sigma_h \|_{L^2(\Gamma)}$', ...
        '$O(h^1)$ line', '$O(h^2)$ line'},'Interpreter','latex','FontSize',12,'Location','best');
grid;

RefErrorDataFileName = fullfile(Main_Dir,'FEL_Execute_RT1_Surface_REF_Data.mat');
% save(RefErrorDataFileName,'p_Error_Vec','sig_Error_Vec');
REF_DATA = load(RefErrorDataFileName);

% simple regression check
ERR_CHK = zeros(2,1);
ERR_CHK(1) = max(abs(REF_DATA.p_Error_Vec(1:Num_Refine) - p_Error_Vec(1:Num_Refine)));
ERR_CHK(2) = max(abs(REF_DATA.sig_Error_Vec(1:Num_Refine) - sig_Error_Vec(1:Num_Refine)));

% different computers should compute the same errors (up to round-off!)
status = 0; % init
if (max(ERR_CHK) > 1e-10)
    disp('RTk on Surface convergence error failed!');
    status = 1;
end

end