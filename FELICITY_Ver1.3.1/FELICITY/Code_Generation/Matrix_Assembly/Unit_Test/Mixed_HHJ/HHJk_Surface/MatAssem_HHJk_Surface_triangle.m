function MATS = MatAssem_HHJk_Surface_triangle(deg_geo,deg_k,surf_func,soln_tilde,vars)
%MatAssem_HHJk_Surface_triangle

% Copyright (c) 03-30-2018,  Shawn W. Walker

% define domain
Gamma = Domain('triangle',3);
dGamma = Domain('interval') < Gamma;
Skeleton_Plus  = Domain('interval') < Gamma;
Skeleton_Minus = Domain('interval') < Gamma;

% define finite element spaces
P_k_plus_1 = eval(['lagrange_deg', num2str(deg_k+1), '_dim2();']);
W_h = Element(Gamma,P_k_plus_1); % piecewise linear
HHJ_k = eval(['hellan_herrmann_johnson_deg', num2str(deg_k), '_dim2();']);
V_h = Element(Gamma,HHJ_k);

% define functions on FEM spaces
tau = Test(V_h);
sig = Trial(V_h);
v = Test(W_h);
u = Trial(W_h);

proj_sig = Coef(V_h);
discrete_hess = Coef(V_h);
hess_soln = Coef(V_h);
u_soln = Coef(W_h);

% define geometric function on \Omega
gf = GeoFunc(Gamma);
gf_sk_plus = GeoFunc(Skeleton_Plus);
gf_sk_minus = GeoFunc(Skeleton_Minus);

% define exact solution and it's surface gradient
[soln_func, soln_surf_grad_func, soln_surf_hess, f_func, normal_vec_func] = DiffGeo_HHJk_Surface(surf_func,soln_tilde,vars);

% define FEM matrices
Mass_Matrix = Bilinear(V_h,V_h);
Mass_Matrix = Mass_Matrix + Integral(Gamma, sum(sum(tau.val .* sig.val)) );

% Mass_Matrix_Scalar = Bilinear(W_h,W_h);
% Mass_Matrix_Scalar = Mass_Matrix_Scalar + Integral(Omega, v.val * u.val );
% 
% Stiff_Matrix_Scalar = Bilinear(W_h,W_h);
% Stiff_Matrix_Scalar = Stiff_Matrix_Scalar + Integral(Omega, v.grad' * u.grad );

xi_plus = cross(gf_sk_plus.T,gf.N);
xi_minus = cross(gf_sk_minus.T,gf.N);

Jump_Term = Bilinear(W_h,V_h);
Jump_Term = Jump_Term + Integral(Skeleton_Plus, (xi_plus' * sig.val * xi_plus) * (xi_plus' * v.grad) );
Jump_Term = Jump_Term + Integral(Skeleton_Minus, (xi_minus' * sig.val * xi_minus) * (xi_minus' * v.grad) );

Grad_Grad_Term = Bilinear(W_h,V_h);
Grad_Grad_Term = Grad_Grad_Term + Integral(Gamma, sum(sum(sig.val .* v.hess)) );

% exact matrix-valued function
%soln_tilde
%soln_surf_hess
exact_sig = subs(soln_surf_hess,{vars(1), vars(2)},{gf.X(1), gf.X(2)});

%exact_sig = eye(3);
% exact_sig(3,3) = 0;
%
%exact_sig = (1/2) * (exact_sig + exact_sig');
%exact_sig = gf.Tangent_Space_Proj * exact_sig * gf.Tangent_Space_Proj;

RHS_L2_Proj = Linear(V_h);
RHS_L2_Proj = RHS_L2_Proj + Integral(Gamma, sum(sum(tau.val .* exact_sig)) );

L2_Proj_Error_Sq = Real(1,1);
L2_Proj_Error_Sq = L2_Proj_Error_Sq + Integral(Gamma, sum(sum((proj_sig.val - exact_sig).^2)) );

RHS_f = Linear(W_h);
RHS_f = RHS_f + Integral(Gamma, v.val * f_func(gf.X(1),gf.X(2)) );

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

% compute numerical error
L2_Hess_Error_Sq = Real(1,1);
L2_Hess_Error_Sq = L2_Hess_Error_Sq + Integral(Gamma, sum(sum((discrete_hess.val - exact_sig).^2)) );

L2_Proj_Hess_Error_Sq = Real(1,1);
L2_Proj_Hess_Error_Sq = L2_Proj_Hess_Error_Sq + Integral(Gamma, sum(sum((discrete_hess.val - proj_sig.val).^2)) );

% compute laplace-beltrami solution error
L2_Hess_FE_Error_Sq = Real(1,1);
L2_Hess_FE_Error_Sq = L2_Hess_FE_Error_Sq + Integral(Gamma, sum(sum((hess_soln.val - exact_sig).^2)) );

L2_Soln_FE_Error_Sq = Real(1,1);
L2_Soln_FE_Error_Sq = L2_Soln_FE_Error_Sq + Integral(Gamma, (u_soln.val - soln_func(gf.X(1),gf.X(2))).^2 );

H1_Soln_FE_Error_Sq = Real(1,1);
H1_Soln_FE_Error_Sq = H1_Soln_FE_Error_Sq + Integral(Gamma, sum(sum((u_soln.grad - soln_surf_grad_func(gf.X(1),gf.X(2))).^2)) );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 30;

% define geometry representation - Domain, reference element
deg_surf_str = num2str(deg_geo);
Pk_Gamma = eval(['lagrange_deg', deg_surf_str, '_dim2();']);
G_Space = GeoElement(Gamma,Pk_Gamma);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G_Space);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Jump_Term);
MATS = MATS.Append_Matrix(Grad_Grad_Term);
MATS = MATS.Append_Matrix(RHS_L2_Proj);
MATS = MATS.Append_Matrix(RHS_f);
MATS = MATS.Append_Matrix(L2_Proj_Error_Sq);
MATS = MATS.Append_Matrix(L2_Hess_Error_Sq);
MATS = MATS.Append_Matrix(L2_Proj_Hess_Error_Sq);
MATS = MATS.Append_Matrix(L2_Hess_FE_Error_Sq);
MATS = MATS.Append_Matrix(L2_Soln_FE_Error_Sq);
MATS = MATS.Append_Matrix(H1_Soln_FE_Error_Sq);

end