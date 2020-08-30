function status = FEL_Execute_Interp_Shape_Op_2D(mexName)
%FEL_Execute_Interp_Shape_Op_2D
%
%   test FELICITY Auto-Generated Interpolation Code.

% Copyright (c) 08-16-2014,  Shawn W. Walker

% current_file = mfilename('fullpath');
% Current_Dir  = fileparts(current_file);

% get test mesh
[Omega_P1_Vtx, Omega_Tri] = Standard_Triangle_Mesh_Test_Data();
% domain is a square [0, 2] X [0, 2]
Mesh = MeshTriangle(Omega_Tri, Omega_P1_Vtx, 'Gamma');
% refine
for ind = 1:2
    Mesh = Mesh.Refine;
end

% define other FE space stuff
P1_DoFmap = uint32(Mesh.ConnectivityList);
P2_DoFmap = uint32(Setup_Lagrange_P2_DoFmap(Mesh.ConnectivityList,[]));

% get P2_Lagrange Node coordinates
P2_RefElem = ReferenceFiniteElement(lagrange_deg2_dim2());
P2_Lagrange_Space = FiniteElementSpace('Scalar_P2', P2_RefElem, Mesh, 'Gamma');
P2_Lagrange_Space = P2_Lagrange_Space.Set_DoFmap(Mesh,uint32(P2_DoFmap));
P2_X = P2_Lagrange_Space.Get_DoF_Coord(Mesh);
% add the z-component
P2_X = [P2_X, 0*P2_X(:,1)];

% % make it a paraboloid
% P2_X(:,3) = 1 - P2_X(:,1).^2 - P2_X(:,2).^2;
% make it a sine wave
P2_X(:,3) = sin(2*pi*P2_X(:,1).*P2_X(:,2));

% define the interpolation points
Cell_Indices = (1:1:Mesh.Num_Cell)';
% interpolate at the barycenter of reference triangle
Gamma_Interp_Data = {uint32(Cell_Indices), (1/3) * ones(Mesh.Num_Cell,2)};
%BC = Mesh.refToBary(Gamma_Interp_Data{2});
%Interp_Pts = Mesh.baryToCart(Cell_Indices, BC);

% interpolate!
tic
INTERP = feval(str2func(mexName),P2_X,P2_DoFmap,[],[],Gamma_Interp_Data);
toc

kappa = INTERP(1).DATA{1};
kappa_G = INTERP(2).DATA{1};
Num_Pts = length(Gamma_Interp_Data{1});
NV = zeros(Num_Pts,3);
NV(:) = cell2mat(INTERP(3).DATA);
Shape_Op = zeros(3,3,Num_Pts);
for ii = 1:3
    for jj = 1:3
        Shape_Op(ii,jj,:) = INTERP(4).DATA{ii,jj};
    end
end

% error check
CHK_NV = 0;
CHK_kappa = 0;
CHK_kappa_G = 0;
for pt = 1:Num_Pts
    % get interpolated value at each point
    kappa_pt = kappa(pt);
    kappa_G_pt = kappa_G(pt);
    NV_pt = NV(pt,:)';
    Shape_Op_pt = Shape_Op(:,:,pt);
    
    % check that the normal vector gets mapped to the zero vector
    CHK_NV = max(max(abs(Shape_Op_pt * NV_pt)), CHK_NV);
    % check the eigenvalues of the shape operator against the total and gauss curvatures
    lambda = eig(Shape_Op_pt);
    lambda = remove_smallest_mag_element(lambda);
    CHK_kappa = max(abs(sum(lambda) - kappa_pt), CHK_kappa);
    CHK_kappa_G = max(prod(lambda) - kappa_G_pt, CHK_kappa_G);
end

status = 0; % init
TOL = 1e-11;
if (CHK_NV > TOL)
    CHK_NV
    disp('Normal vector is not in the null space of the shape operator.');
    status = 1;
end
if (CHK_kappa > TOL)
    CHK_kappa
    disp('Sum of the principle curvatures does not match the trace of the shape operator.');
    status = 1;
end
if (CHK_kappa_G > TOL)
    CHK_kappa_G
    disp('Gaussian curvature does not match the product of the (non-zero) eigenvalues of the shape operator.');
    status = 1;
end

end

function new_vec = remove_smallest_mag_element(vec)

[~, Ind] = min(abs(vec));

new_vec = vec;
new_vec(Ind) = [];

end