function status = Execute_LapBel_Open_Surface()
%Execute_LapBel_Open_Surface
%
%   Demo code for solving the Laplace-Beltrami on a piecewise quadratic
%   surface with boundary.

% Copyright (c) 11-07-2017,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

Refine_Vec = [2 3 4 5 6]; % level 7 is too demanding of "weak" computers
Num_Refine = length(Refine_Vec);

% init arrays to store numerical errors
u_Error_Vec = zeros(Num_Refine,1);
lambda_Error_Vec = zeros(Num_Refine,1);
NV_Error_Vec = zeros(Num_Refine,1);
TV_Error_Vec = zeros(Num_Refine,1);
Neumann_Error_Vec = zeros(Num_Refine,1);

% define domain parameterization
Psi = @(q1,q2) [q1, q2, 0.5*(q1.^2 - q2.^2)];

for kk = 1:Num_Refine

% BEGIN: define saddle surface (piecewise linear mesh)
Refine_Level = Refine_Vec(kk);
% create mesh of unit disk centered at origin
[Tri, Pts_q] = triangle_mesh_of_disk([0 0 0],1,Refine_Level);
% apply parameterization
Pts_x_y_z = Psi(Pts_q(:,1), Pts_q(:,2));
Mesh = MeshTriangle(Tri, Pts_x_y_z, 'Gamma');
clear Tri Pts_q Pts_x_y_z;
% END: define saddle surface (piecewise linear mesh)

% add the open boundary
BDY  = Mesh.freeBoundary();
Mesh = Mesh.Append_Subdomain('1D','dGamma',BDY);
clear BDY;
%Mesh.Plot;

% create GeoElementSpace
P2_RefElem = ReferenceFiniteElement(lagrange_deg2_dim2());
G_Space = GeoElementSpace('G_h',P2_RefElem,Mesh);
G_DoFmap = mex_LapBel_DoF_Alloc_G_Space(uint32(Mesh.ConnectivityList));
G_Space = G_Space.Set_DoFmap(Mesh,uint32(G_DoFmap));

% BEGIN: define the higher order surface
Geo_Points_hat = G_Space.Get_Mapping_For_Piecewise_Linear_Mesh(Mesh);
% initially starts as a piecewise quadratic polynomial (P2 function) interpolating a
% piecewise linear (P1) function (representing the PW linear saddle surface mesh)

% map back to (q_1,q_2) plane
Geo_q = Geo_Points_hat(:,1:2);
% Geo_q is a piecewise linear approximation of the unit disk
dGamma_DoF_Indices = G_Space.Get_DoFs_On_Subdomain(Mesh,'dGamma');
Geo_q_on_bdy = Geo_q(dGamma_DoF_Indices,:);
% ensure the (q_1,q_2) points on the bdy of the mesh lie *exactly* on the
% boundary of the unit disk: {q_1^2 + q_2^2 < 1}
Norm_on_bdy = sqrt(sum(Geo_q_on_bdy.^2,2));
Geo_q_on_bdy(:,1) = Geo_q_on_bdy(:,1) ./ Norm_on_bdy; % normalize
Geo_q_on_bdy(:,2) = Geo_q_on_bdy(:,2) ./ Norm_on_bdy; % normalize
% update boundary points in global array (all other nodal values are unaffected)
Geo_q(dGamma_DoF_Indices,:) = Geo_q_on_bdy;
% Geo_q is now a piecewise quadratic approximation of the unit disk

% apply parameterization
Geo_Points = Psi(Geo_q(:,1), Geo_q(:,2));
clear Geo_Points_hat Geo_q Geo_q_on_bdy;
% END: define the higher order surface

% figure;
% plot3(Geo_Points(:,1),Geo_Points(:,2),Geo_Points(:,3),'k*');

% define FE spaces
V_Space    = FiniteElementSpace('V_h', P2_RefElem, Mesh, 'Gamma');
%V_DoFmap   = mex_DoF_Allocator_V_h(uint32(Mesh.ConnectivityList));
V_Space    = V_Space.Set_DoFmap(Mesh,uint32(G_DoFmap)); % G_Space has the same DoFmap
clear G_DoFmap;

P1_RefElem = ReferenceFiniteElement(lagrange_deg1_dim1());
W_Space    = FiniteElementSpace('W_h', P1_RefElem, Mesh, 'dGamma');
W_DoFmap   = mex_LapBel_DoF_Alloc_W_h(uint32(Mesh.Get_Global_Subdomain('dGamma')));
W_Space    = W_Space.Set_DoFmap(Mesh,uint32(W_DoFmap));
clear W_DoFmap;

% compute embedding data
Domain_Names = {'Gamma'; 'dGamma'};
Gamma_Embed = Mesh.Generate_Subdomain_Embedding_Data(Domain_Names);

% assemble
tic
FEM = mex_MatAssem_LapBel_Open_Surface([],Geo_Points,G_Space.DoFmap,[],...
                        Gamma_Embed,V_Space.DoFmap,W_Space.DoFmap);
toc
% put FEM into a nice object to make accessing the matrices easier
LB_Mats = FEMatrixAccessor('Laplace-Beltrami',FEM);
clear FEM;

% pull out the matrices
M = LB_Mats.Get_Matrix('M');
K = LB_Mats.Get_Matrix('K');
B = LB_Mats.Get_Matrix('B');

% check the B matrix
dGamma_Subdomain = Mesh.Output_Subdomain_Mesh('dGamma');
disp('Check length of boundary curve:');
Len_mesh = sum(dGamma_Subdomain.Volume());
Len_by_matrix = sum(B(:));
disp('Length by mesh: error is (small):');
Len_mesh - 7.640395578055425e+00
disp('Length by B matrix: error is (small):');
Len_by_matrix - 7.640395578055425e+00

% get coordinates of DoFs in V_Space
G_Space = G_Space.Set_mex_Dir(Main_Dir,'mex_LapBel_Open_Surface_G_Space_Interpolation');
V_Points = V_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);
% note: in this case, V_Points should be the same as Geo_Points, because
% the V_Space has the same reference element as G_Space
D1 = abs(V_Points(:) - Geo_Points(:));
if (max(D1) > 1e-14)
    disp('Geo_Points and V_Points do not match!');
    max(D1)
    status = 1;
    return;
end

% exact solution
u_exact = @(u,v) cos(v.*pi.*2.0).*sin(u.*pi.*2.0);
% rhs f
f_exact = @(u,v) pi.*1.0./(u.^2+v.^2+1.0).^2.*(-u.^3.*cos(u.*pi.*2.0).*cos(v.*pi.*2.0)+v.^3.*sin(u.*pi.*2.0).*sin(v.*pi.*2.0)+pi.*cos(v.*pi.*2.0).*sin(u.*pi.*2.0).*4.0+u.^2.*pi.*cos(v.*pi.*2.0).*sin(u.*pi.*2.0).*6.0+u.^4.*pi.*cos(v.*pi.*2.0).*sin(u.*pi.*2.0).*2.0+v.^2.*pi.*cos(v.*pi.*2.0).*sin(u.*pi.*2.0).*6.0+v.^4.*pi.*cos(v.*pi.*2.0).*sin(u.*pi.*2.0).*2.0+u.*v.^2.*cos(u.*pi.*2.0).*cos(v.*pi.*2.0)-u.^2.*v.*sin(u.*pi.*2.0).*sin(v.*pi.*2.0)+u.*v.^3.*pi.*cos(u.*pi.*2.0).*sin(v.*pi.*2.0).*4.0+u.^3.*v.*pi.*cos(u.*pi.*2.0).*sin(v.*pi.*2.0).*4.0+u.^2.*v.^2.*pi.*cos(v.*pi.*2.0).*sin(u.*pi.*2.0).*4.0+u.*v.*pi.*cos(u.*pi.*2.0).*sin(v.*pi.*2.0).*4.0).*2.0;

% define RHS data
f_h = f_exact(V_Points(:,1),V_Points(:,2));
g_h = u_exact(V_Points(:,1),V_Points(:,2));

disp('Solve Laplace-Beltrami with Weak BC''s:');
% make the big matrix
W_Num = W_Space.num_dof;
ZZ = sparse(W_Num,W_Num);
MAT = [K, B';
       B, ZZ];
RHS = [M*f_h; B*g_h];
% use backslash to solve
Soln = MAT \ RHS;

% parse the solution
V_Num = V_Space.num_dof;
u_h = Soln(1:V_Num,1);
lambda_h = Soln(V_Num+1:end,1);

% define exact normal and tangent vectors on dGamma
NV_func = @(u,v) [-u ./ sqrt(u.^2 + v.^2 + 1), v ./ sqrt(u.^2 + v.^2 + 1), 1 ./ sqrt(u.^2 + v.^2 + 1)];
TV_func = @(u,v) [-v ./ sqrt(u.^2 + v.^2 + 4*u.^2.*v.^2), u ./ sqrt(u.^2 + v.^2 + 4*u.^2.*v.^2), -2*u.*v ./ sqrt(u.^2 + v.^2 + 4*u.^2.*v.^2)];
% interpolate normal and tangent vectors using the G_Space nodal coordinates
NV_h = NV_func(Geo_Points(:,1),Geo_Points(:,2));
TV_h = TV_func(Geo_Points(:,1),Geo_Points(:,2));

% compute errors in solution
tic
FEM = mex_Compute_Errors_LapBel_Open_Surface([],Geo_Points,G_Space.DoFmap,[],...
                        Gamma_Embed,G_Space.DoFmap,V_Space.DoFmap,W_Space.DoFmap,...
                        NV_h,TV_h,lambda_h,u_h);
toc
% put FEM into a nice object to make accessing the matrices easier
Error_MATS = FEMatrixAccessor('Errors',FEM);
clear FEM;

% pull out the (squared) errors, and take sqrt!
u_L2_Error = sqrt(Error_MATS.Get_Matrix('u_L2_Error_sq'));
lambda_L2_Error = sqrt(Error_MATS.Get_Matrix('lambda_L2_Error_sq'));
NV_Error = sqrt(Error_MATS.Get_Matrix('NV_Error_sq'));
TV_Error = sqrt(Error_MATS.Get_Matrix('TV_Error_sq'));
Neumann_L2_Error = sqrt(Error_MATS.Get_Matrix('Neumann_L2_Error_sq'));

% record the error
u_Error_Vec(kk) = u_L2_Error;
lambda_Error_Vec(kk) = lambda_L2_Error;
NV_Error_Vec(kk) = NV_Error;
TV_Error_Vec(kk) = TV_Error;
Neumann_Error_Vec(kk) = Neumann_L2_Error;

end

% now we plot the solution on the last mesh

% BEGIN: process P2 solution
% need to interpolate the P2 solution at the points of the piecewise linear
% mesh so that we can plot it

% find the mapping from mesh points to P2 nodes
disp('create Octree...');
BB = [-1.001, 1.001, -1.001, 1.001, -1.001, 1.001];
OT = mexOctree(V_Points,BB);

% find the mapping via closest point
[P1_to_P2, OT_dist] = OT.kNN_Search(Mesh.Points,1);
if max(OT_dist) > 1e-14
    error('Points should be right on top of each other.');
end

% interpolate solution back onto piecewise linear mesh for plotting
u_h_P1 = u_h(P1_to_P2,1);

delete(OT); % clear the octree object!
% END: process P2 solution

% plot u solution
disp('Plot Solution Of Laplace-Beltrami:');
FH_u_h = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
trisurf(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2),Mesh.Points(:,3),u_h_P1);
shading interp;
colormap(jet);
%light;
lightangle(80,-20);
lightangle(-40,40);
%camlight left;
%camlight right;
lighting phong;
colorbar;
caxis([0 max(u_h)]);
title('Color plot of u_h on \Gamma');
%title('plotu');
xlabel('X');
ylabel('Y');
zlabel('Z');
%set(gca,'FontSize',10);
AX = [-1 1 -1 1 -0.5 0.5];
axis(AX);
axis equal;
axis(AX);
view([-35,30]);

% Plot the \lambda solution:
Bdy_X = W_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);
FH_lambda_h = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
p2 = edgemesh(W_Space.DoFmap, Bdy_X, lambda_h);
set(p2,'LineWidth',2.0);
shading interp;
title('Color plot of \lambda_h on \partial \Gamma');
%title('plotlam');
xlabel('X');
ylabel('Y');
zlabel('Z');
axis equal;
colorbar;
view([-35,30]);

% % define exact solution
% lambda_exact = @(u,v)pi.*1.0./sqrt(u.^2+v.^2+1.0).*1.0./sqrt(u.^2.*v.^2.*4.0+u.^2+v.^2).*(v.*sin(u.*pi.*2.0).*sin(v.*pi.*2.0)-u.*cos(u.*pi.*2.0).*cos(v.*pi.*2.0)-u.*v.^2.*cos(u.*pi.*2.0).*cos(v.*pi.*2.0).*2.0+u.^2.*v.*sin(u.*pi.*2.0).*sin(v.*pi.*2.0).*2.0).*2.0;
% % plot the exact \lambda along the parameterization variable
% FH_lambda_exact = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
% t_vec = linspace(0,2*pi,1001);
% uv = cos(t_vec);
% vv = sin(t_vec);
% lambda_eval = lambda_exact(uv,vv);
% plot(t_vec,lambda_eval,'b-');
% title('Plot of exact \lambda');
% xlabel('Parameterization variable');

% plot the error decay
Order_2_Line = 4 * 4.^(-Refine_Vec);
Order_3_Line = 1.0 * 8.^(-Refine_Vec);
FH_error = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
semilogy(Refine_Vec,u_Error_Vec,'k-*',Refine_Vec,lambda_Error_Vec,'r-.',...
         Refine_Vec,NV_Error_Vec,'b-d',Refine_Vec,TV_Error_Vec,'g-s',...
         Refine_Vec,Neumann_Error_Vec,'r--o',...
         Refine_Vec,Order_2_Line,'m-d',...
         Refine_Vec,Order_3_Line,'k-d');
xlabel('Refinement Level');
ylabel('L^2 errors');
title('Numerical Convergence Rates');
% xlabel('reflev');
% ylabel('errors');
% title('convrate');
axis([2 6 1e-8 1e1]);
set(gca,'XTick',[2 3 4 5 6]);
legend({'$\| u - u_h \|_{L^2(\Gamma)}$', '$\| \lambda - \lambda_h \|_{L^2(\Gamma)}$', ...
        '$\| I_h \mathbf{\nu}_s - \boldmath{\nu}_h \|_{L^2(\Gamma)}$', '$\| I_h \mathbf{\tau}_s - \mathbf{\tau}_h \|_{L^2(\Gamma)}$',...
        '$\| \lambda_h - (-\mathbf{\xi}_h \cdot \nabla_{\Gamma} u_h) \|_{L^2(\Gamma)}$',...
        '$O(h^2)$ line', '$O(h^3)$ line'},'Interpreter','latex','FontSize',12,'Location','best');
grid;

RefErrorDataFileName = fullfile(Main_Dir,'FEL_Execute_LapBel_Open_Surface_REF_Data.mat');
% save(RefErrorDataFileName,'u_Error_Vec','lambda_Error_Vec','NV_Error_Vec','TV_Error_Vec','Neumann_Error_Vec');
REF_DATA = load(RefErrorDataFileName);

% simple regression check
ERR_CHK = zeros(5,1);
ERR_CHK(1) = max(abs(REF_DATA.u_Error_Vec(1:Num_Refine) - u_Error_Vec(1:Num_Refine)));
ERR_CHK(2) = max(abs(REF_DATA.lambda_Error_Vec(1:Num_Refine) - lambda_Error_Vec(1:Num_Refine)));
ERR_CHK(3) = max(abs(REF_DATA.NV_Error_Vec(1:Num_Refine) - NV_Error_Vec(1:Num_Refine)));
ERR_CHK(4) = max(abs(REF_DATA.TV_Error_Vec(1:Num_Refine) - TV_Error_Vec(1:Num_Refine)));
ERR_CHK(5) = max(abs(REF_DATA.Neumann_Error_Vec(1:Num_Refine) - Neumann_Error_Vec(1:Num_Refine)));

% different computers should compute the same errors (up to round-off!)
status = 0; % init
if (max(ERR_CHK) > 1e-10)
    disp('Laplace-Beltrami on Open Surface convergence error failed!');
    status = 1;
end


% %--------------------------------------------------
% 
% % code to generate plots for FELICITY paper
% %FigDir = 'C:\FILES\LaTex\Papers_New\FELICITY_SISC_Paper\Figures';
% FigDir = 'C:\TEMP\';
% 
% % % set filename
% % SaveFig = 'Laplace_Beltrami_Open_Surface_Soln_u_h';
% % FN = fullfile(FigDir,SaveFig);
% % %export_fig(FN, '-pdf', '-eps', '-transparent');
% % %export_fig(FN, '-pdf', '-transparent');
% % 
% % print(FH_u_h,'-depsc',FN); % color
% % %print(FH_u_h,'-djpeg',FN); % color
% % 
% % 
% % % set filename
% % SaveFig = 'Laplace_Beltrami_Open_Surface_Soln_lambda_h';
% % FN = fullfile(FigDir,SaveFig);
% % %export_fig(FN, '-pdf', '-eps', '-transparent');
% % %export_fig(FN, '-pdf', '-transparent');
% % 
% % print(FH_lambda_h,'-depsc',FN); % color
% % %print(FH_lambda_h,'-djpeg',FN); % color
% 
% 
% % % set filename
% % SaveFig = 'Laplace_Beltrami_Open_Surface_Conv_Rate';
% % FN = fullfile(FigDir,SaveFig);
% % %export_fig(FN, '-pdf', '-eps', '-transparent');
% % %export_fig(FN, '-pdf', '-transparent');
% % 
% % %print(FH,'-deps',FN); % black and white
% % print(FH_error,'-depsc',FN); % color
% % %print(FH_error,'-djpeg',FN); % color
% 
% %--------------------------------------------------

end