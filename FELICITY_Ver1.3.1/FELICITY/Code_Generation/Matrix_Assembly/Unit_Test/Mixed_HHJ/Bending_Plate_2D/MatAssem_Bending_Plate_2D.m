function MATS = MatAssem_Bending_Plate_2D(deg_geo,deg_k,exact_u,exact_u_grad,exact_u_hess,exact_f,exact_b)
%MatAssem_Bending_Plate_2D

% Copyright (c) 03-25-2019,  Shawn W. Walker

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

u_soln = Coef(W_h);
sig_soln = Coef(V_h);

% define geometric function on \Omega
gf = GeoFunc(Omega);
gf_Gamma = GeoFunc(Gamma);
gf_sk_plus = GeoFunc(Skeleton_Plus);
gf_sk_minus = GeoFunc(Skeleton_Minus);

% define FEM matrices
Mass_Matrix = Bilinear(V_h,V_h);
Mass_Matrix = Mass_Matrix + Integral(Omega, sum(sum(tau.val .* sig.val)) );

Mass_Matrix_Scalar = Bilinear(W_h,W_h);
Mass_Matrix_Scalar = Mass_Matrix_Scalar + Integral(Omega, v.val * u.val );

% construct the RHS load
exact_f_eval = subs(exact_f,{'x', 'y'},{gf.X(1), gf.X(2)});
RHS_F = Linear(W_h);
RHS_F = RHS_F + Integral(Omega, exact_f_eval * v.val );

Jump_Term = Bilinear(W_h,V_h);
sk_plus_N = gf_sk_plus.N;
%sk_plus_N = [gf_sk_plus.T(2); -gf_sk_plus.T(1); 0];
sk_minus_N = gf_sk_minus.N;
%sk_minus_N = [gf_sk_minus.T(2); -gf_sk_minus.T(1); 0];
Jump_Term = Jump_Term + Integral(Skeleton_Plus, (sk_plus_N' * sig.val * sk_plus_N) * (sk_plus_N' * v.grad) );
Jump_Term = Jump_Term + Integral(Skeleton_Minus, (sk_minus_N' * sig.val * sk_minus_N) * (sk_minus_N' * v.grad) );

Grad_Grad_Term = Bilinear(W_h,V_h);
Grad_Grad_Term = Grad_Grad_Term + Integral(Omega, sum(sum(sig.val .* v.hess)) );

% weird "natural" boundary condition
exact_b_eval = subs(exact_b,{'x', 'y'},{gf.X(1), gf.X(2)});
RHS_B = Linear(W_h);
RHS_B = RHS_B + Integral(Gamma, exact_b_eval * v.val );

% compute error in solution
exact_u_eval  = subs(exact_u,{'x', 'y'},{gf.X(1), gf.X(2)});
%exact_u_grad = [diff(exact_u,'x'); diff(exact_u,'y')];
exact_u_grad_eval = subs(exact_u_grad,{'x', 'y'},{gf.X(1), gf.X(2)});
u_L2_Error_Sq = Real(1,1);
u_L2_Error_Sq = u_L2_Error_Sq + Integral(Omega, (u_soln.val - exact_u_eval)^2 );

u_H1_Error_Sq = Real(1,1);
u_H1_Error_Sq = u_H1_Error_Sq + Integral(Omega, sum((u_soln.grad(1:2,1) - exact_u_grad_eval).^2) );

exact_u_hess_eval = subs(exact_u_hess,{'x', 'y'},{gf.X(1), gf.X(2)});
u_H2_Error_Sq = Real(1,1);
u_H2_Error_Sq = u_H2_Error_Sq + Integral(Omega, sum(sum((u_soln.hess - exact_u_hess_eval).^2)) );

sig_L2_Error_Sq = Real(1,1);
sig_L2_Error_Sq = sig_L2_Error_Sq + Integral(Omega, sum(sum((sig_soln.val(1:2,1:2) - exact_u_hess_eval).^2)) );

Proj_sig = Linear(V_h);
Proj_sig = Proj_sig + Integral(Omega, sum(sum(tau.val(1:2,1:2) .* exact_u_hess_eval)) );

nn_Gamma = Linear(V_h);
gamma_N = gf_Gamma.N;
%gamma_N = [gf_Gamma.T(2); -gf_Gamma.T(1); 0];
nn_Gamma = nn_Gamma + Integral(Gamma, (gamma_N' * tau.val * gamma_N) );

nn_Gamma_Mass_Matrix = Bilinear(V_h,V_h);
nn_Gamma_Mass_Matrix = nn_Gamma_Mass_Matrix + Integral(Gamma, (gamma_N' * sig.val * gamma_N) * (gamma_N' * tau.val * gamma_N) );

% compute some other "skeleton" terms
sig_Gamma_L2_Error_Sq = Real(1,1);
% sig_Gamma_L2_Error_Sq = sig_Gamma_L2_Error_Sq + Integral(Gamma, ( (gamma_N' * sig_soln.val * gamma_N) ...
%                                                                 - (gamma_N(1:2,1)' * exact_u_hess_eval * gamma_N(1:2,1)) )^2 );
sig_Gamma_L2_Error_Sq = sig_Gamma_L2_Error_Sq + Integral(Gamma, sum(sum((sig_soln.val(1:2,1:2) - exact_u_hess_eval).^2)) );
%

sig_Skel_L2_Error_Sq = Real(1,1);
sig_Skel_L2_Error_Sq = sig_Skel_L2_Error_Sq + Integral(Skeleton_Plus, ( (sk_plus_N' * sig_soln.val * sk_plus_N)...
                                                                      - (sk_plus_N(1:2,1)' * exact_u_hess_eval * sk_plus_N(1:2,1)) )^2 );

% compute accuracy of normal vector
normal_L2_error_Sq = Real(1,1);
M0 = sqrt(gf.X(1)^2 + gf.X(2)^2);
exact_normal = gf.X / M0;
normal_L2_error_Sq = normal_L2_error_Sq + Integral(Gamma, sum((gamma_N - exact_normal).^2) );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 30;

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
MATS = MATS.Append_Matrix(RHS_F);
MATS = MATS.Append_Matrix(RHS_B);
MATS = MATS.Append_Matrix(u_L2_Error_Sq);
MATS = MATS.Append_Matrix(u_H1_Error_Sq);
MATS = MATS.Append_Matrix(u_H2_Error_Sq);
MATS = MATS.Append_Matrix(sig_L2_Error_Sq);
MATS = MATS.Append_Matrix(Proj_sig);
MATS = MATS.Append_Matrix(nn_Gamma);
MATS = MATS.Append_Matrix(nn_Gamma_Mass_Matrix);
MATS = MATS.Append_Matrix(sig_Gamma_L2_Error_Sq);
MATS = MATS.Append_Matrix(sig_Skel_L2_Error_Sq);
MATS = MATS.Append_Matrix(normal_L2_error_Sq);

end