function MATS = MatAssem_Flat_Beam_2D(deg_geo,deg_k)
%MatAssem_Flat_Beam_2D

% Copyright (c) 03-30-2018,  Shawn W. Walker

% define domain
Omega = Domain('triangle');
Gamma = Domain('interval') < Omega;
Skeleton_Plus  = Domain('interval') < Omega;
Skeleton_Minus = Domain('interval') < Omega;

% define finite element spaces
P_k_plus_1 = eval(['lagrange_deg', num2str(deg_k+1), '_dim2();']);
W_h = Element(Omega,P_k_plus_1); % piecewise linear
HHJ_k = eval(['hellan_herrmann_johnson_deg', num2str(deg_k), '_dim2();']);
V_h = Element(Omega,HHJ_k);

% define functions on FEM spaces
tau = Test(V_h);
sig = Trial(V_h);
v = Test(W_h);
u = Trial(W_h);

% proj_sig = Coef(V_h);
% discrete_hess = Coef(V_h);

% define geometric function on \Omega
gf = GeoFunc(Omega);
gf_sk_plus = GeoFunc(Skeleton_Plus);
gf_sk_minus = GeoFunc(Skeleton_Minus);

% define FEM matrices
Mass_Matrix = Bilinear(V_h,V_h);
Mass_Matrix = Mass_Matrix + Integral(Omega, sum(sum(tau.val .* sig.val)) );

Mass_Matrix_Scalar = Bilinear(W_h,W_h);
Mass_Matrix_Scalar = Mass_Matrix_Scalar + Integral(Omega, v.val * u.val );

% Stiff_Matrix_Scalar = Bilinear(W_h,W_h);
% Stiff_Matrix_Scalar = Stiff_Matrix_Scalar + Integral(Omega, v.grad' * u.grad );

Jump_Term = Bilinear(W_h,V_h);
Jump_Term = Jump_Term + Integral(Skeleton_Plus, (gf_sk_plus.N' * sig.val * gf_sk_plus.N) * (gf_sk_plus.N' * v.grad) );
Jump_Term = Jump_Term + Integral(Skeleton_Minus, (gf_sk_minus.N' * sig.val * gf_sk_minus.N) * (gf_sk_minus.N' * v.grad) );

Grad_Grad_Term = Bilinear(W_h,V_h);
Grad_Grad_Term = Grad_Grad_Term + Integral(Omega, sum(sum(sig.val .* v.hess)) );

% exact solution

% L2_Error_Sq = Real(1,1);
% L2_Error_Sq = L2_Error_Sq + Integral(Omega, sum(sum((proj_sig.val - exact_sig).^2)) );

% % compute exact div div (exact_sig)
% syms x y real;
% sym_sig = [sin(x^2 + y^2), cos(x^2 + y^2);
%            exp(-(x^2 + y^2)), (x^2 + y^2)];
% sym_sig = (1/2) * (sym_sig + sym_sig');
% div_sym_sig = [diff(sym_sig(1,1),'x',1) + diff(sym_sig(1,2),'y',1);
%                diff(sym_sig(2,1),'x',1) + diff(sym_sig(2,2),'y',1)];
% div_div_sym_sig = diff(div_sym_sig(1),'x',1) + diff(div_sym_sig(2),'y',1);
% div_div_exact_sig = div_div_sym_sig;
% div_div_exact_sig = subs(div_div_exact_sig,{'x', 'y'},{gf.X(1), gf.X(2)});

% % compute exact hessian
% syms x y real;
% rad = 0.5;
% sym_u = (rad^2 - (x^2 + y^2))^2 * sin(x) * cos(y);
% %sym_u = x^4 + x^3*y + x;
% sym_u_hess = [diff(sym_u,'x','x'), diff(sym_u,'x','y');
%               diff(sym_u,'y','x'), diff(sym_u,'y','y')];
% %
% hess_exact_u = simplify(sym_u_hess);
% hess_exact_u
% hess_exact_u = subs(hess_exact_u,{'x', 'y'},{gf.X(1), gf.X(2)});

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 10;

% define geometry representation - Domain, reference element
deg_surf_str = num2str(deg_geo);
Pk_Omega = eval(['lagrange_deg', deg_surf_str, '_dim2();']);
G_Space = GeoElement(Omega,Pk_Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G_Space);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Mass_Matrix_Scalar);
MATS = MATS.Append_Matrix(Jump_Term);
MATS = MATS.Append_Matrix(Grad_Grad_Term);
%MATS = MATS.Append_Matrix(L2_Error_Sq);

end