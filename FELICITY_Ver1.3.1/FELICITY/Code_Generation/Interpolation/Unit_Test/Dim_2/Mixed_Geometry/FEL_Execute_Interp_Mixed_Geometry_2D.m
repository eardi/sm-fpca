function status = FEL_Execute_Interp_Mixed_Geometry_2D(mexName)
%FEL_Execute_Interp_Mixed_Geometry_2D
%
%   test FELICITY Auto-Generated Interpolation Code.

% Copyright (c) 01-25-2014,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get test mesh
[Gamma_Vtx, Gamma_Tri] = Standard_Triangle_Mesh_Test_Data();
Gamma_Vtx = [Gamma_Vtx, zeros(size(Gamma_Vtx,1),1)]; % make it in 3-D
Mesh = MeshTriangle(Gamma_Tri, Gamma_Vtx, 'Gamma');

% append the Sigma subdomain (edge of square along x-axis)
Mesh = Mesh.Append_Subdomain('1D','Sigma',[1, 2; 2, 3]);

% uniform refinement
for ind = 1:3
    Mesh = Mesh.Refine;
end

% deform mesh
X = Mesh.Points;
X(:,3) = X(:,1) .* X(:,2); % z = x*y
% domain is a square sheet that is deformed in the Z direction
Mesh = Mesh.Set_Points(X);
clear X;

% create embedding data
DoI_Names = {'Gamma'; 'Sigma'};
Subdomain_Embed = Mesh.Generate_Subdomain_Embedding_Data(DoI_Names);

Sigma_Mesh = Mesh.Output_Subdomain_Mesh('Sigma');
temp_edge  = Sigma_Mesh.ConnectivityList;
Num_Sigma_Vtx = max(temp_edge(:));
V_Space_DoFmap = [temp_edge, (1:1:size(temp_edge,1))' + Num_Sigma_Vtx];
V_Space_DoFmap = uint32(V_Space_DoFmap);
%V_Space_DoFmap

% get P2 Lagrange Node coordinates
P2_RefElem = ReferenceFiniteElement(lagrange_deg2_dim1());
V_Space = FiniteElementSpace('V_Space', P2_RefElem, Mesh, 'Sigma', 3);
V_Space = V_Space.Set_DoFmap(Mesh,uint32(V_Space_DoFmap));
X_Sigma = V_Space.Get_DoF_Coord(Mesh);

% setup coefficient functions
N1_func = @(theta) 0*theta;
N2_func = @(theta) -sin(theta);
N3_func = @(theta)  cos(theta);
theta_func = @(x,y) atan2(x,y);
theta = theta_func(X_Sigma(:,1), 1 + 0*X_Sigma(:,1));
% compute "exact" normal vector on \Sigma
NN_val = [N1_func(theta), N2_func(theta), N3_func(theta)];

% define the interpolation points
Cell_Indices = (1:1:Sigma_Mesh.Num_Cell)';
% interpolate at a point in the reference edge
Sigma_Interp_Data = {uint32(Cell_Indices), (0.25) * ones(Sigma_Mesh.Num_Cell,1)};
Interp_Pts = Sigma_Mesh.referenceToCartesian(Cell_Indices, Sigma_Interp_Data{2});

% interpolate!
tic
INTERP = feval(str2func(mexName),Mesh.Points,uint32(Mesh.ConnectivityList),[],Subdomain_Embed,...
                                 Sigma_Interp_Data,V_Space_DoFmap,NN_val);
toc
RefINTERPDataFileName = fullfile(Current_Dir,'FEL_Execute_Interp_Mixed_Geometry_2D_REF_Data.mat');
% INTERP_REF = INTERP;
% save(RefINTERPDataFileName,'INTERP_REF');
load(RefINTERPDataFileName);

%       INPUTS                                                          ORDER 
%       -------------------                                             ----- 
%       Gamma_Mesh_Vertices                                               0 
%       Gamma_Mesh_DoFmap                                                 1 
%       EMPTY_1                                                           2 
%       Gamma_Mesh_Subdomains                                             3 
%       Sigma_Interp_Data                                                 4 
%       V_Space_DoFmap                                                    5 
%       NN_Values                                                         6 
% 
%       OUTPUTS (in consecutive order) 
%       ---------------------------------------- 
%       I_N 
%       I_N_dot_NN 
%       I_N_dot_T 

% compare the exact values with the interpolated ones
th1 = theta_func(Interp_Pts(:,1), 1 + 0*Interp_Pts(:,1));
I_NN_exact = [N1_func(th1), N2_func(th1), N3_func(th1)];

% these errors satisfy the order of accuracy estimates when refining...
I_NN1_err = max(abs(I_NN_exact(:,1) - INTERP(1).DATA{1}));
I_NN2_err = max(abs(I_NN_exact(:,2) - INTERP(1).DATA{2}));
I_NN3_err = max(abs(I_NN_exact(:,3) - INTERP(1).DATA{3}));

disp(' ');
disp('L_inf error for the interpolation of N (of Gamma) on Sigma:');
MAX_ERR = max([I_NN1_err, I_NN2_err, I_NN3_err]);
% error is 1st order
MAX_ERR

% check that discrete N dotted with exact N is approximately 1
disp(' ');
disp('L_inf error of discrete N \cdot exact N is approximately 1.0.  Error is:');
% error is 2nd order
max(abs(INTERP(2).DATA{1} - 1))

% check that discrete N dotted with discrete T is exactly 0
disp(' ');
disp('L_inf error of discrete N \cdot discrete T is exactly 0.0.  Error is:');
% should be exactly 0
max(abs(INTERP(3).DATA{1} - 0))

status = 0; % init
% compare to reference data
for ind = 1:length(INTERP)
    [nr, nc] = size(INTERP(ind).DATA);
    for ir = 1:nr
        for ic = 1:nc
            ERROR = max(abs(INTERP(ind).DATA{ir,ic} - INTERP_REF(ind).DATA{ir,ic}));
            if (ERROR > 4e-15)
                disp(['Test Failed for INTERP(', num2str(ind), ').DATA...']);
                status = 1;
            end
        end
    end
end

end