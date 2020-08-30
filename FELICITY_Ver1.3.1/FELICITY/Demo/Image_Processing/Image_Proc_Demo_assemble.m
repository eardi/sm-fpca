function MATS = Image_Proc_Demo_assemble()
%Image_Proc_Demo_assemble

% Copyright (c) 06-29-2012,  Shawn W. Walker

% define domain (1-D curve embedded in 2-D)
Sigma = Domain('interval',2);

% define finite element spaces
Scalar_P1    = Element(Sigma,lagrange_deg1_dim1,1);
Vector_P1    = Element(Sigma,lagrange_deg1_dim1,2);

% define functions on FE spaces
vv = Test(Vector_P1);
uu = Trial(Vector_P1);

F  = Coef(Scalar_P1);

% define geometric function on 'Sigma' domain
gf = GeoFunc(Sigma);

% define FEM matrices
Mass_Matrix = Bilinear(Vector_P1,Vector_P1);
Mass_Matrix = Mass_Matrix + Integral(Sigma,vv.val' * uu.val);

Stiff_Matrix = Bilinear(Vector_P1,Vector_P1);
Stiff_Matrix = Stiff_Matrix + Integral(Sigma,vv.ds' * uu.ds);

Curv_Vector = Linear(Vector_P1);
Curv_Vector = Curv_Vector + Integral(Sigma,gf.T' * vv.ds);

F_Normal_Vector = Linear(Vector_P1);
F_Normal_Vector = F_Normal_Vector + Integral(Sigma,F.val * (gf.N' * vv.val));

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 5;
% define geometry representation - Domain, reference element
G1 = GeoElement(Sigma,lagrange_deg1_dim1);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G1);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Curv_Vector);
MATS = MATS.Append_Matrix(F_Normal_Vector);
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Stiff_Matrix);

end