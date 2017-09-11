function status = test_L1_Matrices()
%test_L1_Matrices
%
%   Test code for FELICITY class.

% Copyright (c) 08-01-2011,  Shawn W. Walker

status = 0;

% define some domains
Omega = Domain('triangle');
Sigma = Domain('interval') < Omega;
% define FEM spaces
V1 = Element(Sigma,lagrange_deg1_dim1,2);

v = Test(V1);
u = Trial(V1);
f = Coef(V1);

% just test Bilinear
Mass_Matrix = Bilinear(V1,V1);
I1 = Integral(Sigma,f.val(1) * v.val' * u.val);
Mass_Matrix = Mass_Matrix.Add_Integral(I1);

% test one matrix
Quadrature_Order = 8;
G1 = GeoElement(Omega,lagrange_deg1_dim2);
MATS = Matrices(Quadrature_Order,G1);
MATS = MATS.Append_Matrix(Mass_Matrix);

if ~strcmp(MATS.GeoElem.Name,'G1')
    status = 1;
end
if ~strcmp(MATS.Matrix_Data{1}.Name,'Mass_Matrix')
    status = 1;
end

%%%%%%%%%%%%%
if (status==0)
    disp('Test passed!');
else
    disp('Test failed!');
end

end