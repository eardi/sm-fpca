function status = FEL_Execute_Interp_with_Symbolic_Constant(mexName)
%FEL_Execute_Interp_with_Symbolic_Constant
%
%   test FELICITY Auto-Generated Interpolation Code.

% Copyright (c) 01-20-2018,  Shawn W. Walker

% get test mesh
[Omega_P1_Vtx, Omega_Tri] = Standard_Triangle_Mesh_Test_Data();
% domain is a square [0, 2] X [0, 2]
Mesh = MeshTriangle(Omega_Tri, Omega_P1_Vtx, 'Omega');
% refine
for ind = 1:0
    Mesh = Mesh.Refine;
end

% define other FE space stuff
P2_DoFmap = uint32(Setup_Lagrange_P2_DoFmap(Mesh.ConnectivityList,[]));

% get P2_Lagrange Node coordinates
P2_RefElem = ReferenceFiniteElement(lagrange_deg2_dim2(),true);
P2_Lagrange_Space = FiniteElementSpace('Scalar_P2', P2_RefElem, Mesh, 'Omega');
P2_Lagrange_Space = P2_Lagrange_Space.Set_DoFmap(Mesh,uint32(P2_DoFmap));
P2_X = P2_Lagrange_Space.Get_DoF_Coord(Mesh);

% setup coefficient functions
f_func  = @(x,y) sin(pi*(x + y));
fx_func = @(x,y) pi * cos(pi*(x + y));
fy_func = @(x,y) pi * cos(pi*(x + y));
f_val = f_func(P2_X(:,1),P2_X(:,2));

c0 = [(1/3), -(1/7)];

% exact interpolant functions
I_f = @(x,y) fx_func(x,y) .* c0(1) + fy_func(x,y) .* c0(2);

% define the interpolation points
Cell_Indices = (1:1:Mesh.Num_Cell)';
% interpolate at the barycenter of reference triangle
Omega_Interp_Data = {uint32(Cell_Indices), (1/3) * ones(Mesh.Num_Cell,2)};
Interp_Pts = Mesh.referenceToCartesian(Cell_Indices, Omega_Interp_Data{2});

% interpolate!
tic
INTERP = feval(str2func(mexName),Mesh.Points,uint32(Mesh.ConnectivityList),[],[],Omega_Interp_Data,...
                                 P2_DoFmap,c0,f_val);
toc
I_f_computed = INTERP(1).DATA{1,1};

% compare the exact values with the interpolated ones
I_f_exact = I_f(Interp_Pts(:,1),Interp_Pts(:,2));

% these errors satisfy the order of accuracy estimates when refining...
I_f_err = max(abs(I_f_exact - I_f_computed));

disp(' ');
disp('L_inf errors for the interpolation:');
I_f_err

status = 0; % init
% compare to reference data
I_f_computed_REF = ...
   [-2.539682539682540e-01;
    -2.539682539682539e-01;
    -2.539682539682540e-01;
    -2.539682539682540e-01;
     2.539682539682538e-01;
     2.539682539682538e-01;
     2.539682539682540e-01;
     2.539682539682540e-01;
     2.539682539682538e-01;
     2.539682539682538e-01;
     2.539682539682540e-01;
     2.539682539682540e-01;
    -2.539682539682537e-01;
    -2.539682539682538e-01;
    -2.539682539682541e-01;
    -2.539682539682541e-01];
%
ERR_CHK = max(abs(I_f_computed - I_f_computed_REF));
if (ERR_CHK > 1e-13)
    ERR_CHK
    disp(['Test Failed!']);
    status = 1;
end

end