function status = Execute_EWOD_FalkWalker()
%Execute_EWOD_FalkWalker
%
%   Demo code for solving the EWOD problem (using the formulation by Falk
%   and Walker, 2013).

% Copyright (c) 12-05-2017,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

% define initial disk surface
Refine_Level = 5;
[Tri, Pts] = triangle_mesh_of_disk([0 0],1,Refine_Level);
Mesh = MeshTriangle(Tri, Pts, 'Omega');

% add the open boundary
BDY  = Mesh.freeBoundary();
Mesh = Mesh.Append_Subdomain('1D','Gamma',BDY);
clear BDY;
%Mesh.Plot;

% define parameters
alpha = 0.01;
beta = 1;
dt = 0.1;
Num_Steps = 30;

% create GeoElementSpace
P1_RefElem_2D = ReferenceFiniteElement(lagrange_deg1_dim2());
G_Space = GeoElementSpace('G_h',P1_RefElem_2D,Mesh);
G_Space = G_Space.Set_DoFmap(Mesh,uint32(Mesh.ConnectivityList));
G_Space = G_Space.Append_Fixed_Subdomain(Mesh,'Gamma');

% store mesh vertex coordinates
x_h_i = G_Space.Get_Mapping_For_Piecewise_Linear_Mesh(Mesh); % initialize
x_h_evolve(Num_Steps+1).data = [];
x_h_evolve(1).data = x_h_i; % store it

% define FE spaces
BDM1_RefElem = ReferenceFiniteElement(brezzi_douglas_marini_deg1_dim2());
V_Space      = FiniteElementSpace('V_h', BDM1_RefElem, Mesh, 'Omega');
V_DoFmap     = mex_EWOD_DoF_Alloc_V_h(uint32(Mesh.ConnectivityList));
V_Space      = V_Space.Set_DoFmap(Mesh,uint32(V_DoFmap));
clear V_DoFmap;

P0_RefElem = ReferenceFiniteElement(lagrange_deg0_dim2());
Q_Space    = FiniteElementSpace('Q_h', P0_RefElem, Mesh, 'Omega');
Q_DoFmap   = (1:1:Mesh.Num_Cell)'; % only one DoF per element
Q_Space    = Q_Space.Set_DoFmap(Mesh,uint32(Q_DoFmap));
clear Q_DoFmap;

P1_RefElem = ReferenceFiniteElement(lagrange_deg1_dim1());
M_Space    = FiniteElementSpace('M_h', P1_RefElem, Mesh, 'Gamma');
M_DoFmap   = mex_EWOD_DoF_Alloc_M_h(uint32(Mesh.Get_Global_Subdomain('Gamma')));
M_Space    = M_Space.Set_DoFmap(Mesh,uint32(M_DoFmap));

Y_Space    = FiniteElementSpace('M_h', P1_RefElem, Mesh, 'Gamma', 2);
Y_Space    = Y_Space.Set_DoFmap(Mesh,uint32(M_DoFmap)); % can reuse it!
clear M_DoFmap;

% initialize u_h:
u_h = zeros(V_Space.num_dof,1);

% BEGIN: find the mapping from M_h and Y_h nodes to G_h nodes
disp('create Quadtree...');
BB = 2*[-1.001, 1.001, -1.001, 1.001]; % bounding box
QT = mexQuadtree(x_h_i,BB);

% get coordinates of DoFs in M_h and Y_h
M_Points = M_Space.Get_DoF_Coord(Mesh);
Y_Points = Y_Space.Get_DoF_Coord(Mesh);

% find the mapping via closest point
[M_h_to_G_h, QT_dist] = QT.kNN_Search(M_Points,1);
if max(QT_dist) > 1e-14
    error('Points should be right on top of each other.');
end
[Y_h_to_G_h, QT_dist] = QT.kNN_Search(Y_Points,1);
if max(QT_dist) > 1e-14
    error('Points should be right on top of each other.');
end
delete(QT); % delete quadtree object
% END: find the mapping from M_h and Y_h nodes to G_h nodes

% get the DoF indices (of G_h) that are NOT on \Gamma
G_h_Free_DoFs = G_Space.Get_Free_DoFs(Mesh,'all');

% compute embedding data
Domain_Names = {'Omega'; 'Gamma'};
Omega_Embed = Mesh.Generate_Subdomain_Embedding_Data(Domain_Names);

% must choose an orientation of the mesh facets (for BDM_1 space)
Edges = Mesh.edges;
[~, Omega_Orient] = Mesh.Get_Facet_Info(Edges);

% time-stepping
for ii = 1:Num_Steps
%
disp('-------------------------------------------------------');
disp(['Time Index: ', num2str(ii), ' of ', num2str(Num_Steps)]);

% assemble
tic
FEM = mex_MatAssem_EWOD_FalkWalker([],x_h_i,G_Space.DoFmap,Omega_Orient,Omega_Embed,...
                        G_Space.DoFmap,M_Space.DoFmap,Q_Space.DoFmap,V_Space.DoFmap,Y_Space.DoFmap);
toc
% put FEM into a nice object to make accessing the matrices easier
EWOD_Mats = FEMatrixAccessor('EWOD',FEM);
clear FEM;

% pull out the matrices
M = EWOD_Mats.Get_Matrix('M');
K = EWOD_Mats.Get_Matrix('K');
B = EWOD_Mats.Get_Matrix('B');
C = EWOD_Mats.Get_Matrix('C');
D = EWOD_Mats.Get_Matrix('D');
chi = EWOD_Mats.Get_Matrix('chi');

% define EWOD forcing as function over \R^2
%E_exact = @(x,y) 1 - x.^2;
E_exact = @(x,y) 3*ewod_force_1(x,y);

% interpolate over \Omega
E_Omega_h = E_exact(x_h_i(:,1),x_h_i(:,2));

% extract the part that is on \Gamma
E_h = E_Omega_h(M_h_to_G_h,1);

disp('Solve the EWOD system:');
% make the big matrix
VN = V_Space.num_dof;
QN = Q_Space.num_dof;
YN = 2*Y_Space.num_dof;
MN = M_Space.num_dof;
MAT = [((alpha/dt)+beta)*M,           -B', sparse(VN,YN),            C';
                        -B, sparse(QN,QN), sparse(QN,YN), sparse(QN,MN);
             sparse(YN,VN), sparse(YN,QN),             K,           -D';
                         C, sparse(MN,QN),     -(1/dt)*D, sparse(MN,MN)];
RHS = [(alpha/dt)*M*u_h - C'*E_h; zeros(QN,1); zeros(YN,1); -(1/dt)*chi];
% use backslash to solve
Soln = MAT \ RHS;

% parse the solution
u_h = Soln(1:VN,1);
p_h = Soln(VN+1:VN+QN,1);
x_h_new_bdy = zeros(YN/2,2);
x_h_new_bdy(:) = Soln(VN+QN+1:VN+QN+YN,1);
lambda_h = Soln(VN+QN+YN+1:end,1);

% BEGIN: update \Omega
x_h_old_bdy = x_h_i(Y_h_to_G_h,:);
Displace_bdy = x_h_new_bdy - x_h_old_bdy; % bdy displacement

% init domain displacement
Displace = G_Space.Get_Zero_Function;
Displace(Y_h_to_G_h,:) = Displace_bdy;
D_Soln = Displace(:);

% solve for Laplace smoothing
A = EWOD_Mats.Get_Matrix('A');
R1 = -A * D_Soln; % set boundary conditions
D_Soln(G_h_Free_DoFs,1) = A(G_h_Free_DoFs,G_h_Free_DoFs) \ R1(G_h_Free_DoFs,1);
Displace(:) = D_Soln; % put back into two-column matrix format

Inf_Norm_Displace = max(abs(Displace(:)));
disp(['L^\infty norm of \Omega Displacement: ', num2str(Inf_Norm_Displace,'%1.10G')]);

% update domain coordinates
x_h_new = x_h_i + Displace;
% END: update \Omega

% store solution
x_h_evolve(ii+1).data = x_h_new; % store it
x_h_i = x_h_new; % update for next time-step
end

% plot solution
disp('Plot Droplet Evolution:');
FH_evol = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
BDY = Mesh.Get_Global_Subdomain('Gamma');
hold on;
time_vec = [1, 2, 5, length(x_h_evolve)];
for tt = 1:length(time_vec)
    em = edgemesh(BDY,x_h_evolve(time_vec(tt)).data);
    set(em,'LineWidth',1.4);
end
hold off;
title('domain \Omega at four time steps');
%title('plotomega');
xlabel('X');
ylabel('Y');
grid on;
%set(gca,'FontSize',10);
AX = [-2 2 -1 1];
axis(AX);
axis equal;
axis(AX);
view(2);

% plot solution
disp('Plot Droplet Domain at Final Time:');
FH_x_h = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
tm = trimesh(Mesh.ConnectivityList,x_h_i(:,1),x_h_i(:,2),0*x_h_i(:,2));
set(tm,'EdgeColor','k');
hold on;
BDY = Mesh.Get_Global_Subdomain('Gamma');
em = edgemesh(BDY,x_h_i);
set(em,'LineWidth',1.5);
hold off;
title('domain \Omega at final time');
%title('plotomega');
xlabel('X');
ylabel('Y');
grid on;
%set(gca,'FontSize',10);
AX = [-1.7 1.7 -0.7 0.7];
axis(AX);
axis equal;
axis(AX);
view(2);

% Plot the \lambda solution:
Gamma_X = x_h_i(M_h_to_G_h,:);
FH_lambda_h = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
p2 = edgemesh(M_Space.DoFmap, [Gamma_X, 0*Gamma_X(:,1)], lambda_h);
set(p2,'LineWidth',2.0);
shading interp;
title('Color plot of \lambda_h on \Gamma');
%title('plotlam');
xlabel('X');
ylabel('Y');
grid on;
axis(AX);
axis equal;
axis(AX);
colorbar;
view(2);

% error check
RefErrorDataFileName = fullfile(Main_Dir,'FEL_Execute_EWOD_FalkWalker_REF_Data.mat');
% save(RefErrorDataFileName,'x_h_i');
REF_DATA = load(RefErrorDataFileName);

% check the difference with previous run
x_h_i_REF = REF_DATA.x_h_i;
ERR_CHK = abs(x_h_i_REF - x_h_i);
ERR_CHK = max(ERR_CHK(:));

% different computers should compute the same errors (up to round-off!)
status = 0; % init
if (max(ERR_CHK) > 1e-10)
    disp('EWOD error check failed!');
    ERR_CHK
    status = 1;
end

% %--------------------------------------------------
% 
% % code to generate plots for FELICITY paper
% FigDir = 'C:\FILES\LaTex\Papers_New\FELICITY_SISC_Paper\Figures';
% %FigDir = 'C:\FILES\FELICITY\Wiki\Images';
% 
% 
% % set filename
% SaveFig = 'EWOD_FalkWalker_x_h_bdy_Evolve';
% FN = fullfile(FigDir,SaveFig);
% %export_fig(FN, '-pdf', '-eps', '-transparent');
% %export_fig(FN, '-pdf', '-transparent');
% 
% print(FH_evol,'-depsc',FN); % color
% %print(FH_evol,'-djpeg',FN); % color
% 
% 
% % set filename
% SaveFig = 'EWOD_FalkWalker_Omega_Final';
% FN = fullfile(FigDir,SaveFig);
% %export_fig(FN, '-pdf', '-eps', '-transparent');
% %export_fig(FN, '-pdf', '-transparent');
% 
% print(FH_x_h,'-depsc',FN); % color
% %print(FH_x_h,'-djpeg',FN); % color
% 
% 
% % set filename
% SaveFig = 'EWOD_FalkWalker_lambda_h_Final';
% FN = fullfile(FigDir,SaveFig);
% %export_fig(FN, '-pdf', '-eps', '-transparent');
% %export_fig(FN, '-pdf', '-transparent');
% 
% %print(FH,'-deps',FN); % black and white
% print(FH_lambda_h,'-depsc',FN); % color
% %print(FH_lambda_h,'-djpeg',FN); % color
% 
% %--------------------------------------------------

end

function E_exact = ewod_force_1(x,y)

% like the electrode case
EL = 0.5*((2/pi)*atan( (x+0.5)/0.02) - 1);
ER = 0.5*((2/pi)*atan(-(x-0.5)/0.02) - 1);

E_exact = EL + ER;

end