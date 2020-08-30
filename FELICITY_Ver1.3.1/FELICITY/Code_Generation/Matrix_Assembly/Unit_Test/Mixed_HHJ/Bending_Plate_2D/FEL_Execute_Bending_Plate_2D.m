function status = FEL_Execute_Bending_Plate_2D(deg_geo,deg_k,omega,exact_u,exact_u_hess,...
                                               Mesh_type,BC_type)
%FEL_Execute_Bending_Plate_2D
%
%   test FELICITY Auto-Generated Assembly Code

% Copyright (c) 03-29-2018,  Shawn W. Walker

Main_Dir = fileparts(mfilename('fullpath'));

PD = [];
if strcmpi(Mesh_type,'square')
    Refine_Vec = [0 1 2 3 4 5 6 7]; % went to 9...
elseif strcmpi(Mesh_type,'pacman')
    Refine_Vec = [0 1 2 3 4 5 6]; % <= 6
elseif strcmpi(Mesh_type,'refined_disk')
    Refine_Vec = [0 1 2 3 4 5 6 7]; % <= 9
elseif strcmpi(Mesh_type,'refined_disk_alt')
    Refine_Vec = [0 1 2 3 4 5];% 7 8]; % <= 9
elseif strcmpi(Mesh_type,'disk_n_gon')
    Refine_Vec = [1 2 3 4]; % <= 6
elseif strcmpi(Mesh_type,'circle_alt')
    NumR = 7;
    Refine_Vec = (0:1:NumR)';
    Mesh_Name = 'Circle_Mesh';
    HHJ_Mesh_Dir = 'C:\FILES\FEM_Code\HHJ_Meshes\';
    [MR, PD] = Generate_Refined_HHJ_Meshes(Mesh_Name,HHJ_Mesh_Dir,NumR);
else
    error('Invalid!');
end
Num_Refine = length(Refine_Vec);

% init arrays for storing numerical errors
Error_Info.u_L_inf         = zeros(Num_Refine,1);
Error_Info.u_L2            = zeros(Num_Refine,1);
Error_Info.u_H1_semi       = zeros(Num_Refine,1);
Error_Info.u_H2_semi       = zeros(Num_Refine,1);
Error_Info.sig_L2          = zeros(Num_Refine,1);
Error_Info.sig_Gamma_L2    = zeros(Num_Refine,1);
Error_Info.sig_Skel_L2     = zeros(Num_Refine,1);
Error_Info.normal_L2       = zeros(Num_Refine,1);

% store u values at origin
u_origin = zeros(Num_Refine,1);

% % store the solution
% Soln_Level(Num_Refine).u = [];
% Soln_Level(Num_Refine).sig = [];

% create struct to hold output of simulation
Sim_Info.sides = zeros(Num_Refine,1);
Sim_Info.elems = zeros(Num_Refine,1);
Sim_Info.dofs  = zeros(Num_Refine,1);

for kk = 1:Num_Refine

% BEGIN: define reference mesh
Refine_Level = Refine_Vec(kk);
disp('==============================================');
disp(['Run refinement level: ', num2str(Refine_Level)]);

MM = [];
if strcmpi(Mesh_type,'square')
    % get mesh of [0, 1] x [0, 1]
    X_Len = 1;
    Y_Len = 1;
    NX = X_Len * 2^Refine_Level + 1;
    NY = Y_Len * 2^Refine_Level + 1;
    [Tri, Pts] = regular_triangle_mesh(NX, NY);
    Pts(:,1) = X_Len * Pts(:,1);
    Pts(:,2) = Y_Len * Pts(:,2);
elseif strcmpi(Mesh_type,'pacman')
%     % create a pac-man mesh
%     [Tri, Pts] = triangle_mesh_of_disk([0, 0],1,Refine_Level);
%     MT = MeshTriangle(Tri, Pts, 'Omega');
%     
%     % remove a section
%     CC = MT.Get_Cell_Centers();
%     ANG1 = atan2d(CC(:,2),CC(:,1));
%     Mask_Keep = (ANG1 < 135) & (ANG1 > -135);
%     Tri = Tri(Mask_Keep,:);
%     MT = MeshTriangle(Tri, Pts, 'Omega');
%     MT = MT.Remove_Unused_Vertices();
%     
%     Tri = MT.ConnectivityList;
%     Pts = MT.Points;
%     clear MT;
    
    % load up a mesh
    FN = ['C:\FILES\FELICITY\Demo\CiarletRaviart\ZZ_Pacman_Meshes\pacman_', num2str(Refine_Level), '.mat'];
    DD = load(FN);
    Tri = DD.Tri;
    Pts = DD.Pts;
    clear DD;
    
    % now scale the angle
    R = sqrt(sum(Pts.^2,2));
    THETA = atan2(Pts(:,2),Pts(:,1));
    ORIGIN = (R < 1e-14);
    Ref_omega = 3*pi/2;
    New_omega = omega;
    THETA = (New_omega/Ref_omega) * THETA;
    XX = R .* cos(THETA);
    YY = R .* sin(THETA);
    Pts = [XX, YY];
    Pts(ORIGIN,:) = [0, 0];
    clear R THETA XX YY;
elseif strcmpi(Mesh_type,'refined_disk')
    % create a disk mesh
    [Tri, Pts] = triangle_mesh_of_disk([0, 0],1,Refine_Level);
    
%     % create mesher object
%     Box_Dim = [-1.2, 1.2];
%     Num_BCC_Points = 2^Refine_Level + 4;
%     Use_Newton = true;
%     TOL = 1E-12; % tolerance to use in computing the cut points
%     % BCC mesh of the unit square [0,1] x [0,1]
%     MG = Mesher2Dmex(Box_Dim,Num_BCC_Points,Use_Newton,TOL);
%     
%     LS = LS_Disk();
%     LS.Param.rad = [1.0];
%     LS.Param.cx    = [0];
%     LS.Param.cy    = [0];
%     
%     Interp_Handle = @(pt) LS.Interpolate(pt);
%     
%     MG = MG.Get_Cut_Info(Interp_Handle);
%     [Tri, Pts] = MG.run_mex(Interp_Handle);

elseif strcmpi(Mesh_type,'refined_disk_alt')
    % create a disk mesh
    [Tri, Pts] = bcc_triangle_mesh(2,2);
    for rr = 1:Refine_Level
        Marked = (1:1:size(Tri,1))';
        [Pts, Tri] = Refine_Entire_Mesh(Pts,Tri,[],Marked);
    end
    % shift it
    Pts(:,1) = Pts(:,1) - 0.5;
    Pts(:,2) = Pts(:,2) - 0.5;
    % scale it!
    Pts = ((1/sqrt(2))/0.5) * Pts;
    
elseif strcmpi(Mesh_type,'disk_n_gon')
    % load up a mesh
    Num_Sides_Vec = [8 16 32 64 136 264];
    NS = Num_Sides_Vec(Refine_Level);
    FN = ['C:\FILES\FELICITY\Code_Generation\Matrix_Assembly\Unit_Test\Hdivdiv\Bending_Plate_2D\disk_n_gon_', num2str(NS), '.mat'];
    DD = load(FN);
    Tri = DD.Tri;
    Pts = DD.Pts;
    clear DD;
    
elseif strcmpi(Mesh_type,'circle_alt')
    % load up a mesh
    MM = MR(kk);
    Tri = MM.TRI;
    Pts = MM.VTX;
    %MR(kk+1).TRI, MR(kk+1).VTX, MR(kk+1).BdyEDGE, MR(kk+1).BdyChart_Ind, MR(kk+1).BdyChart_Var, MR(kk+1).BdyTRI_Ind
else
    error('Invalid!');
end

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

%Pts = [Pts, 0*Pts(:,1)];
Mesh = MeshTriangle(Tri, Pts, 'Omega');
clear Tri Pts;
% END: define reference mesh

% add the boundary
if isempty(MM)
    Mesh = Mesh.Remove_Unused_Vertices();
    Mesh = Mesh.Reorder();
    BDY  = Mesh.freeBoundary();
    Mesh = Mesh.Append_Subdomain('1D','Gamma',BDY);
else
    Mesh = Mesh.Append_Subdomain('1D','Gamma',MM.BdyEDGE);
end
% add the skeleton
Mesh = Mesh.Append_Skeleton('Skeleton_Plus','Skeleton_Minus');

% % plot mesh
% figure;
% Mesh.Plot;
% hold on;
% Mesh.Plot_Subdomain('Gamma');
% hold off;

% % plot mesh
% figure;
% % Mesh.Plot;
% hold on;
% Mesh.Plot_Subdomain('Skeleton_Plus');
% %Mesh.Plot_Subdomain('Skeleton_Minus');
% hold off;
% axis equal;

if (kk==Num_Refine)
    % plot the exact solution
    exact_u_func = matlabFunction(exact_u);
    
    %exact_u_func
    xp = Mesh.Points(:,1);
    yp = Mesh.Points(:,2);
    exact_u_interp = exact_u_func(xp,yp);
    
    figure;
    trisurf(Mesh.ConnectivityList,xp,yp,exact_u_interp);
    shading interp;
    AX = Mesh.Bounding_Box;
    AX = AX(1:4);
    view(2);
    axis(AX);
    axis equal;
    axis(AX);
    title('True Exact Solution');
    colorbar;
    
    %safdsadf
end

% compute embedding data
Domain_Names = {'Omega'; 'Gamma'; 'Skeleton_Plus'; 'Skeleton_Minus'};
Omega_Subdomains = Mesh.Generate_Subdomain_Embedding_Data(Domain_Names);

[G_Space, Geo_Points, Geo_Points_hat, V_Space, W_Space, SkDG_Space, OmegaDG_Space] =...
          create_FE_spaces(Main_Dir,Mesh,deg_geo,deg_k,Mesh_type,BC_type,PD,MM);
%

% % update P1 mesh with deformed coordinates
% DM_13 = W_Space.DoFmap(:,1:3);
% P1_pts = 0*Mesh.Points; % init
% TRI = Mesh.ConnectivityList;
% P1_pts(TRI(:),:) = Geo_Points(DM_13(:),:);
% Mesh = Mesh.Set_Points(P1_pts);

% disp('Points:');
% Mesh.Points
% 
% disp('Triangulation:');
% uint32(Mesh.ConnectivityList)
% 
% disp('V_Space DoFmap:');
% V_Space.DoFmap

% evaluate exact functions
exact_u_func = matlabFunction(exact_u);
W_X = W_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);
I_u_exact = exact_u_func(W_X(:,1),W_X(:,2));

exact_u_hess_11 = matlabFunction(exact_u_hess(1,1));
exact_u_hess_12 = matlabFunction(exact_u_hess(1,2));
exact_u_hess_21 = matlabFunction(exact_u_hess(2,1));
exact_u_hess_22 = matlabFunction(exact_u_hess(2,2));
% exact_u_hess_11
% exact_u_hess_12
% exact_u_hess_21
% exact_u_hess_22

eps1 = 1e-20; % to avoid 0/0
sig_exact_W_X = [exact_u_hess_11(W_X(:,1) + eps1,W_X(:,2) + eps1), exact_u_hess_12(W_X(:,1) + eps1,W_X(:,2) + eps1),...
                 exact_u_hess_21(W_X(:,1) + eps1,W_X(:,2) + eps1), exact_u_hess_22(W_X(:,1) + eps1,W_X(:,2) + eps1)];
%
% I_sig_exact_11 = sig_exact_W_X(:,1);
% I_sig_exact_12 = sig_exact_W_X(:,2);
% I_sig_exact_22 = sig_exact_W_X(:,4);

% I_sig_exact_11
% I_sig_exact_12
% I_sig_exact_22

sig_soln = V_Space.Get_Zero_Function;
u_soln = W_Space.Get_Zero_Function;

% assemble
tic
FEM = UNIT_TEST_mex_Assemble_Bending_Plate_2D([],Geo_Points,G_Space.DoFmap,[],Omega_Subdomains,...
                V_Space.DoFmap,W_Space.DoFmap,sig_soln,u_soln);
toc
tic
FEM_hat = UNIT_TEST_mex_Assemble_Bending_Plate_2D([],Geo_Points_hat,G_Space.DoFmap,[],Omega_Subdomains,...
                V_Space.DoFmap,W_Space.DoFmap,sig_soln,u_soln);
toc
% put FEM into a nice object to make accessing the matrices easier
my_Mats = FEMatrixAccessor('Bending Plate',FEM);
my_Mats_hat = FEMatrixAccessor('Bending Plate',FEM_hat);
clear FEM;

% pull out the matrices
M = my_Mats.Get_Matrix('Mass_Matrix');
M_hat = my_Mats_hat.Get_Matrix('Mass_Matrix');
M_Scalar = my_Mats.Get_Matrix('Mass_Matrix_Scalar');
Jump_Term = my_Mats.Get_Matrix('Jump_Term');
Jump_Term_hat = my_Mats_hat.Get_Matrix('Jump_Term');
Grad_Grad_Term = my_Mats.Get_Matrix('Grad_Grad_Term');
Grad_Grad_Term_hat = my_Mats_hat.Get_Matrix('Grad_Grad_Term');
DivDiv_h_Term = Grad_Grad_Term - Jump_Term;
DivDiv_h_Term_hat = Grad_Grad_Term_hat - Jump_Term_hat;
RHS_F = my_Mats.Get_Matrix('RHS_F');
RHS_F_hat = my_Mats_hat.Get_Matrix('RHS_F');
RHS_B = my_Mats.Get_Matrix('RHS_B');
u_H1_Norm = sqrt(my_Mats.Get_Matrix('u_H1_Error_Sq'));
sig_L2_Norm = sqrt(my_Mats.Get_Matrix('sig_L2_Error_Sq'));

u_H1_Norm
sig_L2_Norm

% disp('Mass Matrix:');
% full(M)
% 
% disp('Grad_Grad_Term:');
% full(Grad_Grad_Term)
% 
% disp('Jump_Term:');
% full(Jump_Term)

% disp('Compute difference of DivDiv_h_Term and DivDiv_h_Term_hat:');
% DivDiv_h_ERR = abs(DivDiv_h_Term - DivDiv_h_Term_hat);
% TEMP = DivDiv_h_ERR * inv(M_hat) * (DivDiv_h_ERR');
% %max(DivDiv_h_ERR(:))
% norm(full(TEMP),2)

% figure;
% imagesc(DivDiv_h_ERR);
% colorbar;
% axis equal;

% % define f
% exact_f = @(x,y) 0*x - 0.1;
% % evaluate given smooth function
% G_Space = G_Space.Set_mex_Dir(Main_Dir,'UNIT_TEST_mex_Interp_G_Space_Bending_Plate_2D');
% W_X = W_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);
% f_h = exact_f(W_X(:,1),W_X(:,2));

% solve problem
Num_V_DoF = V_Space.num_dof;
Num_W_DoF = W_Space.num_dof;
MAT = [M,              -DivDiv_h_Term';
       -DivDiv_h_Term, sparse(Num_W_DoF,Num_W_DoF)];
%
RHS = [zeros(Num_V_DoF,1); - RHS_F - RHS_B];

BDY = Mesh.Get_Global_Subdomain('Gamma');
Sim_Info.sides(kk) = size(BDY,1);
Sim_Info.elems(kk) = Mesh.Num_Cell();
Sim_Info.dofs(kk)  = length(RHS);

Fixed_V_DoFs = V_Space.Get_Fixed_DoFs(Mesh);

Free_V_DoFs = V_Space.Get_Free_DoFs(Mesh);
Free_W_DoFs = W_Space.Get_Free_DoFs(Mesh);

% find the fixed DoFs a different way
% Mesh.Subdomain(1).Data
% 
% V_Space.RefElem.Nodal_Top.V
% 
% V_Space.RefElem.Nodal_Top.E{1}(Mesh.Subdomain(1).Data,:)
% 
% V_Space.RefElem.Nodal_Top.F
% 
% V_Space.RefElem.Nodal_Top.T

% Local_Edge_DoFs = V_Space.RefElem.Nodal_Top.E{1}(Mesh.Subdomain(1).Data(:,2),:);
% 
% SubDoFmap = V_Space.DoFmap(Mesh.Subdomain(1).Data(:,1),:);
% 
% LI = (1:1:size(Local_Edge_DoFs,1))';
% % Local_Edge_DoFs_1 = [LI, Local_Edge_DoFs(:,1)];
% % Local_Edge_DoFs_2 = [LI, Local_Edge_DoFs(:,2)];
% % Local_Edge_DoFs_3 = [LI, Local_Edge_DoFs(:,3)];
% 
% % Local_Edge_DoFs_1
% % Local_Edge_DoFs_2
% % Local_Edge_DoFs_3
% 
% IND_1 = sub2ind(size(SubDoFmap),LI,Local_Edge_DoFs(:,1));
% IND_2 = sub2ind(size(SubDoFmap),LI,Local_Edge_DoFs(:,2));
% IND_3 = sub2ind(size(SubDoFmap),LI,Local_Edge_DoFs(:,3));
% 
% DoF_1 = SubDoFmap(IND_1);
% DoF_2 = SubDoFmap(IND_2);
% DoF_3 = SubDoFmap(IND_3);
% 
% Fixed_V_DoFs_ALT = [DoF_1; DoF_2; DoF_3];
% 
% Fixed_V_DoFs_ALT = unique(Fixed_V_DoFs_ALT);
% 
% disp('DoF Difference:');
% max(abs(Fixed_V_DoFs - Fixed_V_DoFs_ALT))

% [LIA, LOCB] = ismember(Fixed_V_DoFs,double(V_Space.DoFmap(:,1:9)));
% LIA

% disp('BB:');
% BB = DivDiv_h_Term(Free_W_DoFs,Free_V_DoFs);
% size(BB)
% S = svd(full(BB), 'econ');
% length(S)
% disp('Ratio:');
% S(1)/S(end)

if or(strcmpi(BC_type,'free'),strcmpi(BC_type,'alternate'))
    % need to get mean value zero part of displacement
    [~, ind_1] = min(W_X(:,1) + W_X(:,2));
    [~, ind_2] = max(W_X(:,1) + W_X(:,2));
    [~, ind_3] = min(W_X(:,1) - W_X(:,2));
    Fixed_W_DoFs = [ind_1, ind_2, ind_3]';
    Free_W_DoFs = setdiff(Free_W_DoFs,Fixed_W_DoFs); % remove three more DoFs
    Free_DoFs = [Free_V_DoFs; Free_W_DoFs + Num_V_DoF];
    % i.e. just remove one DoF for now, which means we are setting the
    % displacement to zero there
else
    Free_DoFs = [Free_V_DoFs; Free_W_DoFs + Num_V_DoF];
end

Soln = zeros(Num_V_DoF + Num_W_DoF,1);

% add in BCs
disp('Add in stress boundary conditions:');
Proj_hess = my_Mats.Get_Matrix('Proj_sig');
%L2_Proj_hess = 0*sig_soln;
L2_Proj_hess = M \ Proj_hess;
L2_Proj_hess(Free_V_DoFs,1) = 0;
displace_val = zeros(Num_W_DoF,1);
displace_val(Fixed_W_DoFs,1) = I_u_exact(Fixed_W_DoFs,1);
Soln_BC = [L2_Proj_hess; displace_val];
RHS = RHS - MAT*Soln_BC;

disp('Solve mixed HHJ system:');
tic
Soln(Free_DoFs) = MAT(Free_DoFs,Free_DoFs) \ RHS(Free_DoFs,1);
toc

sig_soln = Soln(1:Num_V_DoF,1);
u_soln = Soln(Num_V_DoF+1:Num_V_DoF+Num_W_DoF,1);

disp('Set solution at points:');
u_soln(Fixed_W_DoFs,1) = displace_val(Fixed_W_DoFs,1);
u_soln(Fixed_W_DoFs,1)

% disp('Compute "discrete" norms:');
% DivDiv_h_ERR = DivDiv_h_Term - DivDiv_h_Term_hat;
% TEMP = M_hat(Free_V_DoFs,Free_V_DoFs) \ (DivDiv_h_ERR(:,Free_V_DoFs)') * u_soln;
% u_norm = sqrt(abs(u_soln' * DivDiv_h_ERR(:,Free_V_DoFs) * TEMP));
% u_norm


disp('Check \sigma DoFs on \Gamma:');
max(abs(sig_soln(Fixed_V_DoFs)))

if or(strcmpi(BC_type,'free'),strcmpi(BC_type,'alternate'))
    % need to get mean value zero part of displacement
    
    % compute average value
    Area_Domain = full(sum(M_Scalar(:)));
    Ave_u_value = sum(M_Scalar * u_soln) / Area_Domain;
    
%     % subtract off
%     u_soln = u_soln - Ave_u_value;
%     % SWW: this can cause an issue for computing the L2 norm of the error,
%     % because the exact solution may differ by a constant.
end

% compute the HHJ interpolant of the exact hessian
if (deg_k==0)
    FEM = UNIT_TEST_mex_Assemble_HHJ_Interp_2D([],Geo_Points,G_Space.DoFmap,[],Omega_Subdomains,...
                        SkDG_Space.DoFmap,V_Space.DoFmap);
else
    FEM = UNIT_TEST_mex_Assemble_HHJ_Interp_2D([],Geo_Points,G_Space.DoFmap,[],Omega_Subdomains,...
                        OmegaDG_Space.DoFmap,SkDG_Space.DoFmap,V_Space.DoFmap);
end

% put FEM into a nice object to make accessing the matrices easier
HHJ_Interp_Mats = FEMatrixAccessor('HHJ Interp',FEM);
clear FEM;

% pull out the matrices
NN_DoF = HHJ_Interp_Mats.Get_Matrix('NN_DoF');
NN_RHS = HHJ_Interp_Mats.Get_Matrix('NN_RHS');

% compute the interpolant
if (deg_k==0)
    %Free_SkDG_DoFs = SkDG_Space.Get_Free_DoFs(Mesh);
    %HHJ_Interp_sig = V_Space.Get_Zero_Function();
    %HHJ_Interp_sig(Free_V_DoFs,1) = NN_DoF(Free_SkDG_DoFs,Free_V_DoFs) \ NN_RHS(Free_V_DoFs,1);
    HHJ_Interp_sig = NN_DoF \ NN_RHS;
    HHJ_Interp_sig(Fixed_V_DoFs,1) = 0; % set boundary values to zero
else
    Internal_DoF_11 = HHJ_Interp_Mats.Get_Matrix('Internal_DoF_11');
    Internal_DoF_12 = HHJ_Interp_Mats.Get_Matrix('Internal_DoF_12');
    Internal_DoF_22 = HHJ_Interp_Mats.Get_Matrix('Internal_DoF_22');
    
    Internal_RHS_11 = HHJ_Interp_Mats.Get_Matrix('Internal_RHS_11');
    Internal_RHS_12 = HHJ_Interp_Mats.Get_Matrix('Internal_RHS_12');
    Internal_RHS_22 = HHJ_Interp_Mats.Get_Matrix('Internal_RHS_22');
    
    HHJ_MAT = [NN_DoF; Internal_DoF_11; Internal_DoF_12; Internal_DoF_22];
    HHJ_RHS = [NN_RHS; Internal_RHS_11; Internal_RHS_12; Internal_RHS_22];
    
    HHJ_Interp_sig = HHJ_MAT \ HHJ_RHS;
    HHJ_Interp_sig(Fixed_V_DoFs,1) = 0; % set boundary values to zero
end
%sig_soln = HHJ_Interp_sig;

% % store the solution
% Soln_Level(kk).sig = sig_soln;
% Soln_Level(kk).u = u_soln;

% % load the solution info
% SL_Data = load(fullfile(Main_Dir, 'Soln_Data.mat'));
% Soln_Level = SL_Data.Soln_Level;
% clear SL_Data;
% % sig_soln = Soln_Level(kk).sig;
% % u_soln = Soln_Level(kk).u;

tic
FEM = UNIT_TEST_mex_Assemble_Bending_Plate_2D([],Geo_Points,G_Space.DoFmap,[],Omega_Subdomains,...
                V_Space.DoFmap,W_Space.DoFmap,sig_soln,u_soln);
toc
% put FEM into a nice object to make accessing the matrices easier
my_Mats = FEMatrixAccessor('Bending Plate',FEM);
clear FEM;

% Proj_hess = my_Mats.Get_Matrix('Proj_sig');
% L2_Proj_hess = 0*sig_soln;
% 
% RR = (DivDiv_h_Term') * u_soln;
% %L2_Proj_hess(Free_V_DoFs,1) = M(Free_V_DoFs,Free_V_DoFs) \ Proj_hess(Free_V_DoFs,1);
% L2_Proj_hess(Free_V_DoFs,1) = M(Free_V_DoFs,Free_V_DoFs) \ RR(Free_V_DoFs,1);
% %L2_Proj_hess = M \ RR;
% sig_soln = L2_Proj_hess;
% 
% % Discrete_Diff = L2_Proj_hess - sig_soln;
% % Discrete_L2_Error = sqrt(Discrete_Diff' * M * Discrete_Diff);
% % Discrete_L2_Error
% tic
% FEM = UNIT_TEST_mex_Assemble_Bending_Plate_2D([],Geo_Points,G_Space.DoFmap,[],Omega_Subdomains,...
%                 V_Space.DoFmap,W_Space.DoFmap,L2_Proj_hess,u_soln);
% toc
% % put FEM into a nice object to make accessing the matrices easier
% my_Mats = FEMatrixAccessor('Bending Plate',FEM);
% clear FEM;

%disp('nn_Gamma:');
%nn_Gamma = my_Mats.Get_Matrix('nn_Gamma');
nn_Gamma_Mass_Matrix = my_Mats.Get_Matrix('nn_Gamma_Mass_Matrix');

sig_soln_test = sig_soln;
%sig_soln_test(Fixed_V_DoFs,1) = 0;
nn_Gamma_sig_test_L2_norm = sqrt(sig_soln_test' * nn_Gamma_Mass_Matrix * sig_soln_test);
nn_Gamma_sig_test_L2_norm

u_L2_Error_Sq = my_Mats.Get_Matrix('u_L2_Error_Sq');
Error_Info.u_L2(kk) = sqrt(u_L2_Error_Sq);

u_H1_Error_Sq = my_Mats.Get_Matrix('u_H1_Error_Sq');
Error_Info.u_H1_semi(kk) = sqrt(u_H1_Error_Sq);

u_H2_Error_Sq = my_Mats.Get_Matrix('u_H2_Error_Sq');
Error_Info.u_H2_semi(kk) = sqrt(u_H2_Error_Sq);

sig_L2_Error_Sq = my_Mats.Get_Matrix('sig_L2_Error_Sq');
Error_Info.sig_L2(kk) = sqrt(sig_L2_Error_Sq);

% % overwrite!
% sig_other = Soln_Level(kk).sig;
% sig_diff = (sig_soln - sig_other);
% Error_Info.sig_L2(kk) = sqrt(abs(sig_diff' * M * sig_diff));

sig_Gamma_L2_Error_Sq = my_Mats.Get_Matrix('sig_Gamma_L2_Error_Sq');
Error_Info.sig_Gamma_L2(kk) = sqrt(sig_Gamma_L2_Error_Sq);

sig_Skel_L2_Error_Sq = my_Mats.Get_Matrix('sig_Skel_L2_Error_Sq');
Error_Info.sig_Skel_L2(kk) = sqrt(sig_Skel_L2_Error_Sq);

normal_L2_error_Sq = my_Mats.Get_Matrix('normal_L2_error_Sq');
Error_Info.normal_L2(kk) = sqrt(normal_L2_error_Sq);

Error_Info.u_L_inf(kk) = max(abs(u_soln - I_u_exact));

% get value at origin
Origin_ind = sqrt(sum(W_X.^2,2)) < 1e-13;
u_origin(kk) = u_soln(Origin_ind,1);

% store number of triangles

Sim_Info.elems(kk) = Mesh.Num_Cell();

% find points in mesh
Cell_Indices = uint32([1; 2]);
% set some random global points
Omega_Neighbors = uint32(Mesh.neighbors);
Omega_Given_Points = {Cell_Indices, [0.234, 0.112; 0.114, 0.009], Omega_Neighbors};

% % find points in mesh
% Cell_Indices = uint32(ones(size(W_X,1),1));
% % set some random global points
% Omega_Neighbors = uint32(Mesh.neighbors);
% Omega_Given_Points = {Cell_Indices, W_X, Omega_Neighbors};

% hold on;
% plot(W_X(:,1),W_X(:,2),'bd');
% hold off;

% Vtx = Geo_Points;
% Tri = double(G_Space.DoFmap);

% search!
tic
SEARCH = UNIT_TEST_mex_FEL_Pt_Search_Bending_Plate_2D(Geo_Points(:,1:2),G_Space.DoFmap,[],[],Omega_Given_Points);
toc
SEARCH.DATA{1}
SEARCH.DATA{2}

% skip the search, you know how they are embedded...
CI = zeros(size(W_X,1),1);
RefCoord = zeros(size(W_X,1),2);
Local_RefCoord = W_Space.RefElem.Nodal_Data.BC_Coord(:,2:3);
DM = double(W_Space.DoFmap);
for di = 1:size(Local_RefCoord,1)
    RefCoord(DM(:,di),1) = Local_RefCoord(di,1);
    RefCoord(DM(:,di),2) = Local_RefCoord(di,2);
    CI(DM(:,di),1) = (1:1:size(DM,1))';
end
SEARCH.DATA = {uint32(CI), RefCoord};

% now interpolate
Omega_Interp_Data = SEARCH.DATA;
% Omega_Interp_Pts = Mesh.referenceToCartesian(double(Omega_Interp_Data{1}), Omega_Interp_Data{2});
% Omega_Interp_Pts
INTERP = UNIT_TEST_mex_FEL_Interp_Bending_Plate_2D(Geo_Points(:,1:2),G_Space.DoFmap,[],[],Omega_Interp_Data,V_Space.DoFmap,sig_soln);
% extract data
%INTERP.DATA
% sig_hess_1 = [INTERP.DATA{1,1}(1), INTERP.DATA{1,2}(1);
%               INTERP.DATA{2,1}(1), INTERP.DATA{2,2}(1)];
% sig_hess_2 = [INTERP.DATA{1,1}(2), INTERP.DATA{1,2}(2);
%               INTERP.DATA{2,1}(2), INTERP.DATA{2,2}(2)];
% %
% sig_hess_1
% sig_hess_2

sig_soln_W_X = [INTERP(1).DATA{1,1}, INTERP(1).DATA{1,2}, INTERP(1).DATA{2,1}, INTERP(1).DATA{2,2}];

sig_error_W_X = -(sig_exact_W_X - sig_soln_W_X);

sig_abs_error_W_X = sum(abs(sig_error_W_X),2);

end

% % save the solution info
% save(fullfile(Main_Dir, 'Soln_Data.mat'),'Soln_Level');

TXT_DUMP_FN = ['HHJ_Conv_', Mesh_type, '_', BC_type,...
               '_degGEO_', num2str(deg_geo), '_degHHJ_', num2str(deg_k), '.txt'];
text_FN = fullfile(Main_Dir, TXT_DUMP_FN);
delete(text_FN);
diary(text_FN);
disp(' ');
disp(' ');
disp(['              Mesh Type: ', Mesh_type]);
disp(['Boundary Condition Type: ', BC_type]);
disp(' ');
disp(['Degree of Geometry: ', num2str(deg_geo)]);
disp(['Degree of      HHJ: ', num2str(deg_k)]);
disp(' ');
% disp('Number of triangles = N_T');
% disp(' ');
disp('Error Stats for w in L^2(\Omega) and H^1(\Omega):');
disp(' ');
display_error_stats(Sim_Info,'w, L^2(O)',Error_Info.u_L2,'w, H^1(O)',Error_Info.u_H1_semi);
disp(' ');

disp('Error Stats for \sigma in L^2(\Omega) and h^{1/2} * L^2(Skel):');
disp(' ');
kk_vec = (1:1:Num_Refine)';
h_vec = 0.5.^kk_vec;
Skel_L2_h_half = Error_Info.sig_Skel_L2 .* h_vec.^(1/2);
display_error_stats(Sim_Info,'sig, L^2(O)',Error_Info.sig_L2,'sig, ~L^2(Sk)',Skel_L2_h_half);
disp(' ');

% disp('    N_T  (4^k)   |  EOC for u (H^1) |  EOC for \sigma (L^2(Omega)) |');
% u_H1_EOC = -log2(Error_Info.u_H1_semi(2:end)./Error_Info.u_H1_semi(1:end-1));
% u_H2_EOC = -log2(Error_Info.u_H2_semi(2:end)./Error_Info.u_H2_semi(1:end-1));
% sig_EOC  = -log2(Error_Info.sig_L2(2:end)./Error_Info.sig_L2(1:end-1));

% OUT_1 = [log2(Sim_Info.elems)/2, [0; u_H1_EOC], [0; sig_EOC]];
% OUT_1

disp('Error Stats for w in L^\infty(\Omega) and w in H^2(T_{h}):');
disp(' ');
display_error_stats(Sim_Info,'w, L^inf(O)',Error_Info.u_L_inf,'w, H^2(T_h)',Error_Info.u_H2_semi);
disp(' ');

disp('Error Stats for \sigma in L^2(\Gamma) and normal vector in L^2(\Gamma):');
disp(' ');
display_error_stats(Sim_Info,'sig, L^2(G)',Error_Info.sig_Gamma_L2,'n, L^2(G)',Error_Info.normal_L2);
disp(' ');

% disp(' ');
% disp('    N_T  (4^k)   |  EOC for \sigma (L^2(Gamma)) |  EOC for h^{1/2} (n'' \sigma n) (L^2(Skel))');
% sig_nn_Gamma_EOC = -log2(Error_Info.sig_Gamma_L2(2:end)./Error_Info.sig_Gamma_L2(1:end-1));
% sig_nn_Skel_EOC = -log2(Error_Info.sig_Skel_L2(2:end)./Error_Info.sig_Skel_L2(1:end-1));
% OUT_2 = [log2(Sim_Info.elems)/2, [0; sig_nn_Gamma_EOC], [0; (sig_nn_Skel_EOC + 0.5)]];
% OUT_2

% disp(' ');
% disp('    N_T  (4^k)   |  EOC for normal (L^2(Gamma)) |  EOC for u (H^2_h) ');
% normal_Gamma_EOC = -log2(Error_Info.normal_L2(2:end)./Error_Info.normal_L2(1:end-1));
% OUT_3 = [log2(Sim_Info.elems)/2, [0; normal_Gamma_EOC], [0; u_H2_EOC]];
% OUT_3

disp('Error Stats for the point displacement error at the center:');
disp(' ');
displace_err = u_origin - exact_u_func(0,0);
display_displacement_stats(Sim_Info,u_origin,displace_err);
disp(' ');

% evaluate given smooth function
%W_X = W_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);
BB = Mesh.Bounding_Box();
BB(1) = BB(1) - 0.1;
BB(2) = BB(2) + 0.1;
BB(3) = BB(3) - 0.1;
BB(4) = BB(4) + 0.1;
BB = BB(1:4);
QT = mexQuadtree(W_X(:,1:2),BB);
[Mesh_to_W_X, Dist] = QT.kNN_Search(Mesh.Points(:,1:2),1);
P1_u = u_soln(Mesh_to_W_X,1);
%[Center_W_X_ind, Dist] = QT.kNN_Search([0 0],1);
%Dist
delete(QT);

P1_u_error = P1_u - I_u_exact(Mesh_to_W_X,1);

disp('Displacement L^\infty error:');
Error_Info.u_L_inf(end)
%max(abs(u_soln - I_u_exact))

figure;
trisurf(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2),P1_u_error);
shading interp;
% AX = Mesh.Bounding_Box;
% view(2);
% axis(AX);
% axis equal;
% axis(AX);
title('Numerical Solution (displacement error)');
xlabel('X');
ylabel('Y');
colorbar;

% compute t, n
W_X_MAG = sqrt(sum(W_X.^2,2)) + 1e-15;
W_X_normal = W_X;
W_X_normal(:,1) = W_X(:,1) ./ W_X_MAG;
W_X_normal(:,2) = W_X(:,2) ./ W_X_MAG;
W_X_tangent = [-W_X_normal(:,2), W_X_normal(:,1)];

sig_error_nn = sig_error_W_X(:,1) .* W_X_normal(:,1) .* W_X_normal(:,1)...
             + sig_error_W_X(:,2) .* W_X_normal(:,1) .* W_X_normal(:,2)...
             + sig_error_W_X(:,3) .* W_X_normal(:,2) .* W_X_normal(:,1)...
             + sig_error_W_X(:,4) .* W_X_normal(:,2) .* W_X_normal(:,2);
%
sig_error_nt = sig_error_W_X(:,1) .* W_X_normal(:,1) .* W_X_tangent(:,1)...
             + sig_error_W_X(:,2) .* W_X_normal(:,1) .* W_X_tangent(:,2)...
             + sig_error_W_X(:,3) .* W_X_normal(:,2) .* W_X_tangent(:,1)...
             + sig_error_W_X(:,4) .* W_X_normal(:,2) .* W_X_tangent(:,2);
%
sig_error_tt = sig_error_W_X(:,1) .* W_X_tangent(:,1) .* W_X_tangent(:,1)...
             + sig_error_W_X(:,2) .* W_X_tangent(:,1) .* W_X_tangent(:,2)...
             + sig_error_W_X(:,3) .* W_X_tangent(:,2) .* W_X_tangent(:,1)...
             + sig_error_W_X(:,4) .* W_X_tangent(:,2) .* W_X_tangent(:,2);
%
sig_error_ortho = [sig_error_nn, sig_error_nt, sig_error_nt, sig_error_tt];

sig_error_Mask = W_X_MAG > (1 + 4e-2);
sig_error_ortho(sig_error_Mask,:) = 0;

% disp('Max sig_error_W_X:');
% max(abs(sig_error_W_X(:)))
% 
% T1 = abs(sig_error_W_X(:));
% T1 = sort(T1);
% T1(1:10,1)
% 
% T1(end-10:end,1)
% 
% max(abs(sig_error_ortho(:)))

figure;
for kk = 1:4
    subplot(2,2,kk);
    %trisurf(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2),sig_soln_W_X(Mesh_to_W_X,kk));
    %trisurf(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2),sig_error_W_X(Mesh_to_W_X,kk));
    trisurf(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2),sig_error_ortho(Mesh_to_W_X,kk));
    %plot3(W_X(:,1),W_X(:,2),sig_error_W_X,'k.','MarkerSize',4);
    shading interp;
    AX = Mesh.Bounding_Box;
    % view(2);
    % axis(AX);
    % axis equal;
    % axis(AX);
    %index_str = {'11', '12', '21', '22'};
    index_str = {'nn', 'nt', 'tn', 'tt'};
    title(['Numerical Solution (\sigma_{', index_str{kk}, '} error)']);
    xlabel('X');
    ylabel('Y');
    colorbar;
end

figure;
trisurf(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2),P1_u);
shading interp;
%trimesh(Mesh.ConnectivityList,Mesh.Points(:,1),Mesh.Points(:,2));
% hold on;
% % W_DoFs_Gamma = W_Space.Get_DoFs_On_Subdomain(Mesh,'Gamma');
% % W_X_Gamma = W_X(W_DoFs_Gamma,:);
% % plot(W_X_Gamma(:,1),W_X_Gamma(:,2),'md');
% V_DoFs_Gamma = V_Space.Get_Fixed_DoFs(Mesh);
% V_X = V_Space.Get_DoF_Coord(Mesh,G_Space,Geo_Points);
% V_X_Gamma = V_X(V_DoFs_Gamma,:);
% disp('Number of V-DoFs on boundary:');
% length(V_DoFs_Gamma)
% disp('Error Check: number of edges in boundary:');
% GM = Mesh.Get_Global_Subdomain('Gamma');
% size(GM,1)
% plot(V_X_Gamma(:,1),V_X_Gamma(:,2),'md');
% hold off;
AX = Mesh.Bounding_Box;
AX = AX(1:4);
view(2);
axis(AX);
axis equal;
axis(AX);
title('Numerical Solution (displacement)');
xlabel('X');
ylabel('Y');
colorbar;

% plot the error decay
FH_error = figure('Renderer','painters','PaperPositionMode','auto','Color','w');
Order_1_Line = 10.0 * 2.^(-Refine_Vec);
Order_2_Line = 15.0 * 4.^(-Refine_Vec);
Order_3_Line = 15.0 * 8.^(-Refine_Vec);
Order_4_Line = 15.0 * 16.^(-Refine_Vec);
semilogy(Refine_Vec,Error_Info.u_H1_semi,'k-*',...
         Refine_Vec,Error_Info.sig_L2,'m-*',...
         Refine_Vec,Order_1_Line,'r-d',...
         Refine_Vec,Order_2_Line,'b-d',...
         Refine_Vec,Order_3_Line,'g-d',...
         Refine_Vec,Order_4_Line,'y-d');
xlabel('Refinement Level');
ylabel('Error');
title('Convergence Rate of Numerical Solution');
%axis([Refine_Vec(1) Refine_Vec(end) 1e-3 1e2]);
legend({'$\| u_h - u \|_{H^1(\Omega)}$','$\| \sigma_h - \sigma \|_{L^2(\Omega)}$',...
        '$O(h)$ line','$O(h^2)$ line','$O(h^3)$ line','$O(h^4)$ line'},...
        'Interpreter','latex','FontSize',12,'Location','best');
grid;

% u_origin
% 
% Error_Info.u_H1_semi
% Error_Info.u_H2_semi
% Error_Info.sig_L2
% Error_Info.sig_Gamma_L2

Mesh

diary off;

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

RefErrorDataFileName = fullfile(Main_Dir,'FEL_Execute_Bending_Plate_2D_REF_Data.mat');
% save(RefErrorDataFileName,'L2_Error_Vec','Small_Matrix_Error_Vec');
REF_DATA = load(RefErrorDataFileName);

% simple regression check
ERR_CHK1 = max(abs(REF_DATA.L2_Error_Vec - Error_Info.u_H1_semi));
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

function [G_Space, Geo_Points, Geo_Points_hat, V_Space, W_Space, SkDG_Space, OmegaDG_Space] =...
                   create_FE_spaces(Main_Dir,Mesh,deg_geo,deg_k,Mesh_type,BC_type,PD,MM)
%

% create GeoElementSpace
Pk_Omega = eval(['lagrange_deg', num2str(deg_geo), '_dim2();']);
G_Space_RefElem = ReferenceFiniteElement(Pk_Omega);
G_Space = GeoElementSpace('G_h',G_Space_RefElem,Mesh);
if (deg_geo==1)
    G_DoFmap = uint32(Mesh.ConnectivityList);
else
    G_DoFmap = UNIT_TEST_mex_Bending_Plate_2D_G_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
end
G_Space = G_Space.Set_DoFmap(Mesh,uint32(G_DoFmap));

G_Space = G_Space.Set_mex_Dir(Main_Dir,'UNIT_TEST_mex_Interp_G_Space_Bending_Plate_2D');

% BEGIN: define the higher order domain
Geo_Points_hat = G_Space.Get_Mapping_For_Piecewise_Linear_Mesh(Mesh);
% initially starts as a piecewise deg k polynomial (Pk function) interpolating a
% piecewise linear (P1) function (representing the initial mesh)

Geo_Points = Geo_Points_hat;

if or(strcmp(Mesh_type,'refined_disk'),strcmp(Mesh_type,'disk_n_gon'))
    if (deg_geo > 1)
        
        SI = Mesh.Get_Subdomain_Index('Gamma');
        Bdy_Tri_Data = double(Mesh.Subdomain(SI).Data);
        %     Bdy_Tri_Data
        
        %     figure;
        %     Mesh.Plot_Subdomain('Gamma');
        
        Geo_Points = Higher_Order_Elem(G_Space,Geo_Points_hat(:,1:2),Bdy_Tri_Data(:,1),Bdy_Tri_Data(:,2));
        %Geo_Points = [Geo_Points, 0*Geo_Points(:,1)];
        
    end
    
elseif strcmp(Mesh_type,'circle_alt')
    if (deg_geo > 1)
        
        SI = Mesh.Get_Subdomain_Index('Gamma');
        Bdy_Tri_Data = double(Mesh.Subdomain(SI).Data);
        % this comes out sorted!
        % need to correlate
        [LIA, LOCB] = ismember(MM.BdyTRI_Ind,Bdy_Tri_Data(:,1));
        Bdy_Tri_Data_Alt = Bdy_Tri_Data(LOCB,:);
%         Bdy_Tri_Data_Alt(:,2)
%         Mesh.ConnectivityList(Bdy_Tri_Data_Alt(:,1),:)
%         MM.BdyEDGE

        Geo_Points = Get_Curved_Element_Mapping(G_Space,Geo_Points_hat(:,1:2),MM,Bdy_Tri_Data_Alt(:,1),Bdy_Tri_Data_Alt(:,2));
        %Geo_Points = [Geo_Points, 0*Geo_Points(:,1)];
    end
    
elseif strcmp(Mesh_type,'refined_disk_alt')
    % here we take a special square mesh, and deform all elements
    
    % find four separate groups of vertices
    ANG = atan2(Geo_Points_hat(:,2),Geo_Points_hat(:,1));
    
    Right_SEC = (ANG <= 45 * (pi/180)) & (ANG >= -45 * (pi/180));
    Top_SEC = (ANG < 135 * (pi/180)) & (ANG > 45 * (pi/180));
    Bot_SEC = (ANG > -135 * (pi/180)) & (ANG < -45 * (pi/180));
    Left_SEC = ~(Right_SEC | Top_SEC | Bot_SEC);
    
    % get other masks
    Pos_x = Geo_Points_hat(:,1) >= 0;
    Neg_x = ~Pos_x;
    Pos_y = Geo_Points_hat(:,2) >= 0;
    Neg_y = ~Pos_y;
    
    % define disk function
    f_disk = @(s) sqrt(1 - s.^2);
    
    Geo_Points = Geo_Points_hat; % init
    
    % map the right
    displace_pos = @(x,y) ( (f_disk(y) - x) ./ (1e-15 + (1/sqrt(2)) - y) ) .* (x - y) + x;
    displace_neg = @(x,y) ( (f_disk(y) - x) ./ (1e-15 + (1/sqrt(2)) + y) ) .* (x + y) + x;
    Rt_Pos_y = Pos_y & Right_SEC;
    Rt_Neg_y = Neg_y & Right_SEC;
    Geo_Points(Rt_Pos_y,:) = [displace_pos(Geo_Points_hat(Rt_Pos_y,1),Geo_Points_hat(Rt_Pos_y,2)),...
                              Geo_Points_hat(Rt_Pos_y,2)];
    %
    Geo_Points(Rt_Neg_y,:) = [displace_neg(Geo_Points_hat(Rt_Neg_y,1),Geo_Points_hat(Rt_Neg_y,2)),...
                              Geo_Points_hat(Rt_Neg_y,2)];
    %
    
    % map the left
    displace_pos = @(x,y) ( (-f_disk(y) - x) ./ (-1e-15 + (-1/sqrt(2)) + y) ) .* (x + y) + x;
    displace_neg = @(x,y) ( (-f_disk(y) - x) ./ (-1e-15 + (-1/sqrt(2)) - y) ) .* (x - y) + x;
    Lt_Pos_y = Pos_y & Left_SEC;
    Lt_Neg_y = Neg_y & Left_SEC;
    Geo_Points(Lt_Pos_y,:) = [displace_pos(Geo_Points_hat(Lt_Pos_y,1),Geo_Points_hat(Lt_Pos_y,2)),...
                              Geo_Points_hat(Lt_Pos_y,2)];
    %
    Geo_Points(Lt_Neg_y,:) = [displace_neg(Geo_Points_hat(Lt_Neg_y,1),Geo_Points_hat(Lt_Neg_y,2)),...
                              Geo_Points_hat(Lt_Neg_y,2)];
    %
    
    % map the top
    displace_pos = @(x,y) ( (f_disk(x) - y) ./ (1e-15 + (1/sqrt(2)) - x) ) .* (y - x) + y;
    displace_neg = @(x,y) ( (f_disk(x) - y) ./ (1e-15 + (1/sqrt(2)) + x) ) .* (y + x) + y;
    Top_Pos_x = Pos_x & Top_SEC;
    Top_Neg_x = Neg_x & Top_SEC;
    Geo_Points(Top_Pos_x,:) = [Geo_Points_hat(Top_Pos_x,1),...
                               displace_pos(Geo_Points_hat(Top_Pos_x,1),Geo_Points_hat(Top_Pos_x,2))];
    %
    Geo_Points(Top_Neg_x,:) = [Geo_Points_hat(Top_Neg_x,1),...
                               displace_neg(Geo_Points_hat(Top_Neg_x,1),Geo_Points_hat(Top_Neg_x,2))];
    %
    
    % map the bottom
    displace_pos = @(x,y) ( (-f_disk(x) - y) ./ (-1e-15 + (-1/sqrt(2)) + x) ) .* (y + x) + y;
    displace_neg = @(x,y) ( (-f_disk(x) - y) ./ (-1e-15 + (-1/sqrt(2)) - x) ) .* (y - x) + y;
    Bot_Pos_x = Pos_x & Bot_SEC;
    Bot_Neg_x = Neg_x & Bot_SEC;
    Geo_Points(Bot_Pos_x,:) = [Geo_Points_hat(Bot_Pos_x,1),...
                               displace_pos(Geo_Points_hat(Bot_Pos_x,1),Geo_Points_hat(Bot_Pos_x,2))];
    %
    Geo_Points(Bot_Neg_x,:) = [Geo_Points_hat(Bot_Neg_x,1),...
                               displace_neg(Geo_Points_hat(Bot_Neg_x,1),Geo_Points_hat(Bot_Neg_x,2))];
    %
    
else
    disp('WARNING! Assuming mesh is a square...');
    disp('No need to have a fancy mapping!');
end
% END: define the higher order domain

% % plot the higher order domain
% figure;
% Temp_Pts = Mesh.Points;
% qm = trimesh(Mesh.ConnectivityList,Temp_Pts(:,1),Temp_Pts(:,2),0*Temp_Pts(:,2));
% set(qm,'EdgeColor','k');
% hold on;
% plot(Geo_Points_hat(:,1),Geo_Points_hat(:,2),'gs');
% plot(Geo_Points(:,1),Geo_Points(:,2),'k*');
% % quiver(vx(1).dof(:,1),vx(1).dof(:,2),Tri_to_Gamma_vn(:,1),Tri_to_Gamma_vn(:,2),'color','r');
% % quiver(vx(2).dof(:,1),vx(2).dof(:,2),Tri_to_Gamma_vn(:,1),Tri_to_Gamma_vn(:,2),'color','b');
% 
% % Vec_Internal = Geo_Points(Internal_DoF,:) - Geo_Points_hat(Internal_DoF,:);
% % VEC_INT = Normalize_Vector_Field(Vec_Internal);
% % quiver(Geo_Points_hat(Internal_DoF,1),Geo_Points_hat(Internal_DoF,2),VEC_INT(:,1),VEC_INT(:,2),'color','m');
% % plot(Geo_Points_hat(Internal_DoF,1),Geo_Points_hat(Internal_DoF,2),'pc');
% 
% PD.Plot_Boundary(10000);
% % %cylinder(1,10000);
% 
% % plot(Geo_Points_hat(Tri_to_Gamma_DoF(:,2),1),Geo_Points_hat(Tri_to_Gamma_DoF(:,2),2),'rd');
% % plot(Geo_Points_hat(Tri_to_Gamma_DoF(:,3),1),Geo_Points_hat(Tri_to_Gamma_DoF(:,3),2),'bp');
% % plot(Geo_Points_hat(DoFs_on_Gamma_Edge,1),Geo_Points_hat(DoFs_on_Gamma_Edge,2),'mp');
% % plot(new_dof_ave(:,1),new_dof_ave(:,2),'rd');
% % plot(old_dof_ave(:,1),old_dof_ave(:,2),'mp');
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

clear DoFs_on_Gamma GP_Gamma GP_Dist;

% define FE spaces
P_k_plus_1 = eval(['lagrange_deg', num2str(deg_k+1), '_dim2();']);
P_k_plus_1_RefElem = ReferenceFiniteElement(P_k_plus_1);
W_Space = FiniteElementSpace('W_h', P_k_plus_1_RefElem, Mesh, 'Omega');
W_DoFmap = UNIT_TEST_mex_Bending_Plate_2D_W_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
W_Space = W_Space.Set_DoFmap(Mesh,uint32(W_DoFmap));

if or(strcmpi('clamped',BC_type),strcmpi('simply_supported',BC_type))
    % set fixed DoFs
    W_Space = W_Space.Append_Fixed_Subdomain(Mesh,'Gamma');
else
    % don't impose anything!
end

HHJ_k = eval(['hellan_herrmann_johnson_deg', num2str(deg_k), '_dim2();']);
HHJ_RefElem = ReferenceFiniteElement(HHJ_k);
V_Space = FiniteElementSpace('V_h', HHJ_RefElem, Mesh, 'Omega');
V_DoFmap = UNIT_TEST_mex_Bending_Plate_2D_V_Space_DoF_Allocator(uint32(Mesh.ConnectivityList));
V_Space = V_Space.Set_DoFmap(Mesh,uint32(V_DoFmap));

if or(strcmpi('free',BC_type),strcmpi('simply_supported',BC_type))
    % set fixed DoFs
    V_Space = V_Space.Append_Fixed_Subdomain(Mesh,'Gamma');
else
    % don't impose anything!
end

% define DG spaces
P_k_DG = eval(['lagrange_deg', num2str(deg_k), '_dim1(''DG'');']);
P_k_DG_RefElem = ReferenceFiniteElement(P_k_DG);
SkDG_Space = FiniteElementSpace('SkDG', P_k_DG_RefElem, Mesh, 'Skeleton_Plus');
SkEdges = Mesh.Get_Global_Subdomain('Skeleton_Plus');
Num_Edges = size(SkEdges,1);
Num_Edge_DoF = deg_k + 1;
Dmap_transpose = zeros(Num_Edges,Num_Edge_DoF)';
DoF_Indices = (1:1:(Num_Edges*Num_Edge_DoF))';
Dmap_transpose(:) = DoF_Indices;
SkDG_DoFmap = Dmap_transpose';
SkDG_Space = SkDG_Space.Set_DoFmap(Mesh,uint32(SkDG_DoFmap));
if or(strcmpi('free',BC_type),strcmpi('simply_supported',BC_type))
    % set fixed DoFs
    SkDG_Space = SkDG_Space.Append_Fixed_Subdomain(Mesh,'Gamma');
else
    % don't impose anything!
end

if (deg_k > 0)
    P_k_minus_1_DG = eval(['lagrange_deg', num2str(deg_k-1), '_dim2(''DG'');']);
    P_k_minus_1_DG_RefElem = ReferenceFiniteElement(P_k_minus_1_DG);
    OmegaDG_Space = FiniteElementSpace('OmegaDG', P_k_minus_1_DG_RefElem, Mesh, 'Omega');
    Num_Tri = Mesh.Num_Cell();
    Num_Tri_DoF = round((1/2) * deg_k * (deg_k + 1));
    Dmap_transpose = zeros(Num_Tri,Num_Tri_DoF)';
    DoF_Indices = (1:1:(Num_Tri*Num_Tri_DoF))';
    Dmap_transpose(:) = DoF_Indices;
    OmegaDG_DoFmap = Dmap_transpose';
    OmegaDG_Space = OmegaDG_Space.Set_DoFmap(Mesh,uint32(OmegaDG_DoFmap));
else
    OmegaDG_Space = [];
end

end

function status = display_displacement_stats(SI,displace,err_vec)

EOC = -log2( abs(err_vec(2:end)) ./ abs(err_vec(1:end-1)) );
EOC = [0; EOC];

NR = length(displace);
STR_sides = num2str(SI.sides);
STR_elems = num2str(SI.elems);
STR_dofs  = num2str(SI.dofs);
STR_displ = num2str(displace,'%1.7G');
STR_err   = num2str(err_vec,'%1.7G');
STR_rel_err = num2str(err_vec ./ displace,'%1.7G');
STR_EOC   = num2str(EOC,'%1.7G');

disp([blanks(size(STR_sides,2)-3), 'sides', ' |', blanks(size(STR_elems,2)-4), 'elems', ' |',...
      blanks(size(STR_dofs,2)-3), 'DoFs',  ' |', blanks(size(STR_displ,2)-7), 'displace', ' |',...
      blanks(size(STR_err,2)-4), 'error', ' |', blanks(size(STR_rel_err,2)-9), 'rel. error', ' |',...
      blanks(size(STR_EOC,2)-5), 'EOC']);
disp([repmat('  ',NR,1), ...
      STR_sides, repmat(' | ',NR,1), ...
      STR_elems, repmat(' | ',NR,1), ...
      STR_dofs,  repmat(' | ',NR,1), ...
      STR_displ, repmat(' | ',NR,1), ...
      STR_err, repmat(' | ',NR,1), ...
      STR_rel_err, repmat(' | ',NR,1), ...
      STR_EOC ])
%

status = 0;

end

function status = display_error_stats(SI,name_err_1,err_1,name_err_2,err_2)

EOC_1 = -log2( abs(err_1(2:end)) ./ abs(err_1(1:end-1)) );
EOC_1 = [0; EOC_1];
EOC_2 = -log2( abs(err_2(2:end)) ./ abs(err_2(1:end-1)) );
EOC_2 = [0; EOC_2];

NR = length(err_1);
STR_sides = num2str(SI.sides);
STR_elems = num2str(SI.elems);
STR_dofs  = num2str(SI.dofs);
STR_err_1 = num2str(err_1,'%1.10G');
STR_err_2 = num2str(err_2,'%1.10G');
STR_EOC_1 = num2str(EOC_1,'%1.10G');
STR_EOC_2 = num2str(EOC_2,'%1.10G');

disp([blanks(size(STR_sides,2)-3), 'sides', ' |', blanks(size(STR_elems,2)-4), 'elems', ' |',...
      blanks(size(STR_dofs,2)-3), 'DoFs',  ' |',...
      blanks(size(STR_err_1,2)-length(name_err_1)+1), name_err_1, ' |', blanks(size(STR_EOC_1,2)-2), 'EOC', ' |', ...
      blanks(size(STR_err_2,2)-length(name_err_2)+1), name_err_2, ' |', blanks(size(STR_EOC_2,2)-2), 'EOC']);
disp([repmat('  ',NR,1), ...
      STR_sides, repmat(' | ',NR,1), ...
      STR_elems, repmat(' | ',NR,1), ...
      STR_dofs,  repmat(' | ',NR,1), ...
      STR_err_1, repmat(' | ',NR,1), ...
      STR_EOC_1, repmat(' | ',NR,1), ...
      STR_err_2, repmat(' | ',NR,1), ...
      STR_EOC_2 ])
%

status = 0;

end