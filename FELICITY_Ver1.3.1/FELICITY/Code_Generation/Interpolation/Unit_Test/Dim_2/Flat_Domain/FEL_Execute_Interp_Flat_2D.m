function status = FEL_Execute_Interp_Flat_2D(mexName)
%FEL_Execute_Interp_Flat_2D
%
%   test FELICITY Auto-Generated Interpolation Code.

% Copyright (c) 02-07-2013,  Shawn W. Walker

current_file = mfilename('fullpath');
Current_Dir  = fileparts(current_file);

% get test mesh
[Omega_P1_Vtx, Omega_Tri] = Standard_Triangle_Mesh_Test_Data();
% domain is a square [0, 2] X [0, 2]
Mesh = MeshTriangle(Omega_Tri, Omega_P1_Vtx, 'Omega');
% refine
for ind = 1:0
    Mesh = Mesh.Refine;
end

% define other FE space stuff
P1_DoFmap = uint32(Mesh.ConnectivityList);
P2_DoFmap = uint32(Setup_Lagrange_P2_DoFmap(Mesh.ConnectivityList,[]));

% get P2_Lagrange Node coordinates
P2_RefElem = ReferenceFiniteElement(lagrange_deg2_dim2(),true);
P2_Lagrange_Space = FiniteElementSpace('Scalar_P2', P2_RefElem, Mesh, 'Omega');
P2_Lagrange_Space = P2_Lagrange_Space.Set_DoFmap(Mesh,uint32(P2_DoFmap));
P2_X = P2_Lagrange_Space.Get_DoF_Coord(Mesh);

% setup coefficient functions
p_func  = @(x,y) sin(pi*(x + y));
px_func = @(x,y) pi * cos(pi*(x + y));
py_func = @(x,y) pi * cos(pi*(x + y));
p_val = p_func(P2_X(:,1),P2_X(:,2));
xc = Mesh.Points;
v1_func = @(x,y) x.^4 .* y.^3;
v2_func = @(x,y) exp(-0.5 * x .* y);
v_val = [v1_func(xc(:,1),xc(:,2)), v2_func(xc(:,1),xc(:,2))];
v1x_func = @(x,y) 4*x.^3 .* y.^3;
v1y_func = @(x,y) 3*x.^4 .* y.^2;
v2x_func = @(x,y) -0.5*y .* exp(-0.5 * x .* y);
v2y_func = @(x,y) -0.5*x .* exp(-0.5 * x .* y);

% exact interpolant functions
I_v = @(x,y) {v1x_func(x,y), v1y_func(x,y);
              v2x_func(x,y), v2y_func(x,y)};
I_p = @(x,y) px_func(x,y) .* x + py_func(x,y) .* y;

% define the interpolation points
Cell_Indices = (1:1:Mesh.Num_Cell)';
% interpolate at the barycenter of reference triangle
Omega_Interp_Data = {uint32(Cell_Indices), (1/3) * ones(Mesh.Num_Cell,2)};
Interp_Pts = Mesh.referenceToCartesian(Cell_Indices, Omega_Interp_Data{2});

% interpolate!
tic
INTERP = feval(str2func(mexName),Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Omega_Interp_Data,P2_DoFmap,P1_DoFmap,p_val,v_val);
toc
RefINTERPDataFileName = fullfile(Current_Dir,'FEL_Execute_Interp_Flat_2D_REF_Data.mat');
% INTERP_REF = INTERP;
% save(RefINTERPDataFileName,'INTERP_REF');
load(RefINTERPDataFileName);

% compare the exact values with the interpolated ones
I_p_exact = I_p(Interp_Pts(:,1),Interp_Pts(:,2));
I_v_exact = I_v(Interp_Pts(:,1),Interp_Pts(:,2));

% these errors satisfy the order of accuracy estimates when refining...
I_p_err = max(abs(I_p_exact - INTERP(1).DATA{1,1}));
I_v11_err = max(abs(I_v_exact{1,1} - INTERP(2).DATA{1,1}));
I_v12_err = max(abs(I_v_exact{1,2} - INTERP(2).DATA{1,2}));
I_v21_err = max(abs(I_v_exact{2,1} - INTERP(2).DATA{2,1}));
I_v22_err = max(abs(I_v_exact{2,2} - INTERP(2).DATA{2,2}));

disp(' ');
disp('L_inf errors for the interpolations:');
I_p_err
I_v11_err
I_v12_err
I_v21_err
I_v22_err

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