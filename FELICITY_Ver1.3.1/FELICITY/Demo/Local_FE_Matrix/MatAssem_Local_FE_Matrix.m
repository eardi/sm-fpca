function MATS = MatAssem_Local_FE_Matrix(Domain_Type)
%MatAssem_Local_FE_Matrix

% Copyright (c) 08-10-2017,  Shawn W. Walker

% determine what dimension we are in
if strcmpi(Domain_Type,'interval')
    DIM = 1;
elseif strcmpi(Domain_Type,'triangle')
    DIM = 2;
elseif strcmpi(Domain_Type,'tetrahedron')
    DIM = 3;
else
    error('Invalid!');
end

% define domain
Omega = Domain(Domain_Type);

% define finite element spaces
Elem_Defn_Func = str2func(['lagrange_deg1_dim', num2str(DIM)]);
Scalar_P1 = Element(Omega,Elem_Defn_Func());

% define functions on FE space
v  = Test(Scalar_P1);
u  = Trial(Scalar_P1);

% define FE matrices
Mass_Matrix = Bilinear(Scalar_P1,Scalar_P1);
Mass_Matrix = Mass_Matrix + Integral(Omega,v.val * u.val);

Stiff_Matrix = Bilinear(Scalar_P1,Scalar_P1);
Stiff_Matrix = Stiff_Matrix + Integral(Omega,v.grad' * u.grad);

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 3;
% define geometry representation - Domain, (default to piecewise linear)
G1 = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Stiff_Matrix);

end