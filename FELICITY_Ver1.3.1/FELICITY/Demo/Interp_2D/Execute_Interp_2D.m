function status = Execute_Interp_2D()
%Execute_Interp_2D
%
%   Demo code for FELICITY Auto-Generated Interpolation Code.

% Copyright (c) 02-11-2013,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% create mesh (Omega is the unit square)
Vtx = [0 0; 1 0; 1 1; 0 1];
Tri = [1 2 3; 1 3 4];
Mesh = MeshTriangle(Tri, Vtx, 'Omega');

% define FE space
P2_RefElem = ReferenceFiniteElement(lagrange_deg2_dim2(),true);
P2_Lagrange_Space = FiniteElementSpace('Scalar_P2', P2_RefElem, Mesh, 'Omega');
P2_DoFmap = uint32(Setup_Lagrange_P2_DoFmap(Mesh.ConnectivityList,[]));
P2_Lagrange_Space = P2_Lagrange_Space.Set_DoFmap(Mesh,P2_DoFmap);
P2_X = P2_Lagrange_Space.Get_DoF_Coord(Mesh);

% define coefficient function
p_func  = @(x,y) sin(x + y);
px_func = @(x,y) cos(x + y);
py_func = @(x,y) cos(x + y);
p_val = p_func(P2_X(:,1),P2_X(:,2)); % coefficient values

% exact interpolant function
I_grad_p_X = @(x,y) px_func(x,y) .* x + py_func(x,y) .* y;

% define interpolation points
% specify the triangle indices to interpolate within
Tri_Indices = [1;
               2];
% specify interpolation coordinates w.r.t. reference triangle
Ref_Coord = [(1/3), (1/3);
             (1/3), (1/3)];
% collect into a cell array
Omega_Interp_Data = {uint32(Tri_Indices), Ref_Coord};

% interpolate!
INTERP = DEMO_mex_Interp_Grad_P_X_2D(Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Omega_Interp_Data,P2_DoFmap,p_val);
RefINTERPDataFileName = fullfile(Current_Dir,'Demo_Interp_2D_REF_Data.mat');
% INTERP_REF = INTERP;
% save(RefINTERPDataFileName,'INTERP_REF');
load(RefINTERPDataFileName);

% compare the exact values with the interpolated ones
Interp_Pts_1 = Mesh.referenceToCartesian(Tri_Indices, Omega_Interp_Data{2});
I_grad_p_X_exact = I_grad_p_X(Interp_Pts_1(:,1),Interp_Pts_1(:,2));

% compute interpolation error (L_inf)
I_grad_p_X_err = max(abs(I_grad_p_X_exact - INTERP(1).DATA{1,1}));

disp(' ');
disp('L_inf errors for the interpolations:');
I_grad_p_X_err

% now interpolate at a lot more points
x_vec = (0:0.1:1);
y_vec = (0:0.1:1);
[XX, YY] = meshgrid(x_vec,y_vec);
Interp_Pts_2 = [XX(:), YY(:)];
% find which triangle the points belong to
BOT_TRI = (Interp_Pts_2(:,1) >= Interp_Pts_2(:,2));
Tri_Indices_2 = zeros(size(Interp_Pts_2,1),1);
Tri_Indices_2(BOT_TRI)  = 1; % bottom triangle cell index
Tri_Indices_2(~BOT_TRI) = 2; % top triangle cell index
Ref_Coord_2 = Mesh.cartesianToReference(Tri_Indices_2,Interp_Pts_2);
Omega_Interp_Data_2 = {uint32(Tri_Indices_2), Ref_Coord_2};

% interpolate!
INTERP_2 = DEMO_mex_Interp_Grad_P_X_2D(Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Omega_Interp_Data_2,P2_DoFmap,p_val);
Interp_Values = INTERP_2(1).DATA{1,1};

figure;
surf(XX, YY, I_grad_p_X(XX,YY)); % plot "exact" surface
hold on;
% plot the FE interpolated data as black dots
plot3(Interp_Pts_2(:,1),Interp_Pts_2(:,2),Interp_Values,'k.','MarkerSize',18);
hold off;
axis equal;
AZ = 70;
EL = 10;
view(AZ,EL);
title('Surface is Exact. Points Are Interpolated From FE Approximation','FontSize',12);
xlabel('x','FontSize',12);
ylabel('y','FontSize',12);
set(gca,'FontSize',12);

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