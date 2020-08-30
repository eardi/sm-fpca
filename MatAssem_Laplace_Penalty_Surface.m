function MATS = MatAssem_Laplace_Penalty_Surface()
%MatAssem_triangle for closed 2D surface embedded in a 3D space

% define domain (2-D surface embedded in 3-D)
Gamma = Domain('triangle',3);

% define finite element spaces
Vh = Element(Gamma,lagrange_deg1_dim2,1); % piecewise linear on a surface mesh

% define functions on FE spaces
v = Test(Vh);
u = Trial(Vh);

% define FEM matrices
Mass_Matrix = Bilinear(Vh,Vh);
Mass_Matrix = Mass_Matrix + Integral(Gamma, v.val * u.val );

Stiff_Matrix = Bilinear(Vh,Vh);
Stiff_Matrix = Stiff_Matrix + Integral(Gamma, v.grad' * u.grad );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 3;

% define geometry representation - Domain, reference element
G1 = GeoElement(Gamma,lagrange_deg1_dim2);

% define geometry representation - Domain, (default to piecewise linear)
%G1 = GeoElement(Gamma);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Stiff_Matrix);
end
