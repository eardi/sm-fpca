function status = Execute_Curved_Domain_2D()
%Execute_Curved_Domain_2D
%
%   Demo code for defining a curved, iso-parametric domain.

% Copyright (c) 04-15-2017,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

Refine_Vec = [0 1 2 3 4 5];
Num_Refine = length(Refine_Vec);

% init two arrays, one for each mapping method
Neumann_Error_Vec = {zeros(Num_Refine,1); zeros(Num_Refine,1)};

% define domain parameterization
Psi = @(u,v) [u, v + u.*(1-u).*(v-0.5)];
Gamma_y_bot = @(x) x.*(1-x).*(-0.5);
Gamma_y_top = @(x) 1 + x.*(1-x).*(1-0.5);

% mm==1 % square
% mm==2 % mapped square
for mm = 1:2
for kk = 1:Num_Refine

% BEGIN: define reference mesh
Refine_Level = Refine_Vec(kk);
Np = 2^Refine_Level + 1;
[Tri, Pts_u_v] = bcc_triangle_mesh(Np,Np);

if (mm==1)
    Mesh_Pts = Pts_u_v;
else
    % apply parameterization
    Mesh_Pts = Psi(Pts_u_v(:,1), Pts_u_v(:,2));
end
Mesh = MeshTriangle(Tri, Mesh_Pts, 'Omega');
clear Tri Pts_u_v Mesh_Pts;
% END: define reference mesh

% add the open boundary
BDY  = Mesh.freeBoundary();
Mesh = Mesh.Append_Subdomain('1D','Gamma',BDY);
clear BDY;
%Mesh.Plot;

% create GeoElementSpace
P2_RefElem = ReferenceFiniteElement(lagrange_deg2_dim2());
G_Space  = GeoElementSpace('G_h',P2_RefElem,Mesh);
G_DoFmap = DEMO_Curved_Domain_mex_V_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
G_Space  = G_Space.Set_DoFmap(Mesh,uint32(G_DoFmap));

% BEGIN: define the higher order domain
Geo_Points_hat = G_Space.Get_Mapping_For_Piecewise_Linear_Mesh(Mesh);
% initially starts as a piecewise quadratic polynomial (P2 function) interpolating a
% piecewise linear (P1) function (representing the initial square mesh)

if (mm==1)
    % apply parameterization
    Geo_Points = Psi(Geo_Points_hat(:,1), Geo_Points_hat(:,2)); 
else
    DoFs_on_Gamma = G_Space.Get_DoFs_On_Subdomain(Mesh,'Gamma');
    GP_Gamma = Geo_Points_hat(DoFs_on_Gamma,:);
    Bot_Mask = GP_Gamma(:,2) < 0 + 1e-12; % <= zero
    Top_Mask = GP_Gamma(:,2) > 1 - 1e-12; % >= 1
    GP_Gamma(Bot_Mask,2) = Gamma_y_bot(GP_Gamma(Bot_Mask,1));
    GP_Gamma(Top_Mask,2) = Gamma_y_top(GP_Gamma(Top_Mask,1));
    Geo_Points = Geo_Points_hat;
    Geo_Points(DoFs_on_Gamma,:) = GP_Gamma;
    clear DoFs_on_Gamma GP_Gamma Bot_Mask Top_Mask;
end
clear Geo_Points_hat;
% END: define the higher order domain

% figure;
% if strcmpi(hat_mesh_type{mm},'square')
%     Temp_Pts = Psi(Mesh.Points(:,1),Mesh.Points(:,2));
% else
%     Temp_Pts = Mesh.Points;
% end
% qm = trimesh(Mesh.ConnectivityList,Temp_Pts(:,1),Temp_Pts(:,2),0*Temp_Pts(:,2));
% set(qm,'EdgeColor','k');
% hold on;
% plot(Geo_Points(:,1),Geo_Points(:,2),'k*');
% hold off;
% view(2);

% define FE spaces
V_Space = FiniteElementSpace('V_h', P2_RefElem, Mesh, 'Omega');
%V_DoFmap = DEMO_Curved_Domain_mex_V_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
V_Space = V_Space.Set_DoFmap(Mesh,uint32(G_DoFmap)); % G_Space has the same DoFmap
clear G_DoFmap;

% compute embedding data
Domain_Names = {'Omega'; 'Gamma'};
Omega_Embed = Mesh.Generate_Subdomain_Embedding_Data(Domain_Names);

% assemble
tic
FEM = DEMO_mex_MatAssem_Curved_Domain_2D([],Geo_Points,G_Space.DoFmap,[],...
                        Omega_Embed,V_Space.DoFmap);
toc
% put FEM into a nice object to make accessing the matrices easier
my_Mats = FEMatrixAccessor('Curved Domain',FEM);
clear FEM;

% pull out the matrices
M = my_Mats.Get_Matrix('M');
M_Gamma = my_Mats.Get_Matrix('M_Gamma');
B_neu = my_Mats.Get_Matrix('B_neu');

% check domain measures
Area_by_matrix = sum(M(:));
Len_by_matrix = sum(M_Gamma(:));

disp('Area by FE matrix: error is (small):');
Area_by_matrix - (7/6)
disp('Length by FE matrix: error is (small):');
Len_by_matrix - 4.080457638869102

% get coordinates of DoFs in V_Space
G_Space = G_Space.Set_mex_Dir(Main_Dir,'mex_Curved_Domain_G_h_Interpolation');
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

% define known exact function
f_exact = @(x,y) sin(y);
f_h = f_exact(V_Points(:,1),V_Points(:,2));

% compute Neumann data for known function
Neumann_data_exact = -5.277816286458646e-01;
Neumann_data_by_matrix = f_h' * B_neu;
Neumann_Error = abs(Neumann_data_exact - Neumann_data_by_matrix);
Neumann_Error_Vec{mm}(kk) = Neumann_Error;

end

end

% plot the mesh and bdy!
FH_mesh = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
Mesh.Plot;
hold on;
Mesh.Plot_Subdomain('Gamma');
hold off;
title('Curved Domain \Omega (Piecewise Linear Approximation)');
%title('Om');
grid on;
axis([-0.2 1.2 -0.2 1.2]);
axis equal;
axis([-0.2 1.2 -0.2 1.2]);

% plot the error decay
Order_2_Line = 0.1 * 4.^(-Refine_Vec);
FH_error = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
semilogy(Refine_Vec,Neumann_Error_Vec{1},'r-o',...
         Refine_Vec,Neumann_Error_Vec{2},'b-o',...
         Refine_Vec,Order_2_Line,'m-d');
xlabel('Refinement Level');
ylabel('Error');
title('Numerical Convergence Rate');
axis([0 5 1e-5 1e-1]);
legend({'$| Q - \int_{\Gamma} \nabla v_h \cdot \mathbf{\nu} |$ (method 1)',...
        '$| Q - \int_{\Gamma} \nabla v_h \cdot \mathbf{\nu} |$ (method 2)',...
        '$O(h^2)$ line'},'Interpreter','latex','FontSize',12,'Location','best');
grid;

RefErrorDataFileName = fullfile(Main_Dir,'FEL_Execute_Curved_Domain_2D_REF_Data.mat');
% save(RefErrorDataFileName,'Neumann_Error_Vec');
REF_DATA = load(RefErrorDataFileName);

% simple regression check
ERR_CHK1 = max(abs(REF_DATA.Neumann_Error_Vec{1} - Neumann_Error_Vec{1}));
ERR_CHK2 = max(abs(REF_DATA.Neumann_Error_Vec{2} - Neumann_Error_Vec{2}));
ERR_CHK = max(ERR_CHK1,ERR_CHK2);

% different computers should compute the same errors (up to round-off!)
status = 0; % init
if (ERR_CHK > 1e-10)
    disp('Curved Domain (2D) convergence error failed!');
    ERR_CHK
    status = 1;
end

% %--------------------------------------------------
% 
% % code to generate plots for FELICITY paper
% FigDir = 'C:\FILES\LaTex\Manual\FELICITY_book\Figures';
% 
% % % set filename
% % SaveFig = 'Curved_Domain_Example';
% % FN = fullfile(FigDir,SaveFig);
% % %export_fig(FN, '-pdf', '-eps', '-transparent');
% % %export_fig(FN, '-pdf', '-transparent');
% % 
% % %print(FH,'-deps',FN); % black and white
% % print(FH_mesh,'-depsc',FN); % color
% 
% % set filename
% SaveFig = 'Curved_Domain_Conv_Rate';
% FN = fullfile(FigDir,SaveFig);
% %export_fig(FN, '-pdf', '-eps', '-transparent');
% %export_fig(FN, '-pdf', '-transparent');
% 
% %print(FH,'-deps',FN); % black and white
% print(FH_error,'-depsc',FN); % color
% %--------------------------------------------------

end