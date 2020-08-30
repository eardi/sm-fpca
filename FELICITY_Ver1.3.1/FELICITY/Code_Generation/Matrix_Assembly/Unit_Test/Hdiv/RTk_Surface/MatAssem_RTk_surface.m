function MATS = MatAssem_RTk_surface(deg_surf,deg_sig,deg_p)
%MatAssem_RTk_surface

% Copyright (c) 02-16-2018,  Shawn W. Walker

% define domain (surface in R^3)
Gamma = Domain('triangle',3);
d_Gamma = Domain('interval') < Gamma;

% define finite element spaces
deg_sig_str = num2str(deg_sig);
Sigma_RT_Gamma = eval(['raviart_thomas_deg', deg_sig_str, '_dim2();']);
Sigma_Space = Element(Gamma,Sigma_RT_Gamma);
deg_p_str = num2str(deg_p);
P_Lag_Gamma = eval(['lagrange_deg', deg_p_str, '_dim2(''DG'');']);
P_Space = Element(Gamma,P_Lag_Gamma); % discontin. piecewise linears

% define finite element spaces
V_Space = Element(Gamma,lagrange_deg1_dim2(),3); % Contin. piecewise linears

% define functions on FEM spaces
tau = Test(Sigma_Space);
sig = Trial(Sigma_Space);
q  = Test(P_Space);
p  = Trial(P_Space);

eta = Test(V_Space);
phi = Trial(V_Space);

sig_coef = Coef(Sigma_Space);
p_coef = Coef(P_Space);

% define geometric function on \Omega
gf = GeoFunc(Gamma);
dG_f = GeoFunc(d_Gamma);

% define exact solution and it's surface gradient
[surf_func, soln_func, soln_surf_grad_func, normal_vec_func, f_func] = DiffGeo_RTk_surface();

% define FE matrices
Sigma_Mass_Matrix = Bilinear(Sigma_Space,Sigma_Space);
Sigma_Mass_Matrix = Sigma_Mass_Matrix + Integral(Gamma,tau.val' * sig.val);

P_Mass_Matrix = Bilinear(P_Space,P_Space);
P_Mass_Matrix = P_Mass_Matrix + Integral(Gamma, q.val * p.val);

% divergence constraint
Div_Matrix = Bilinear(P_Space,Sigma_Space);
Div_Matrix = Div_Matrix + Integral(Gamma, -sig.div * q.val);

% RHS natural Dirichlet condition
tang = dG_f.T;
nu = gf.N;
xi_val = cross(tang,nu);
RHS_Matrix = Bilinear(Sigma_Space,P_Space);
RHS_Matrix = RHS_Matrix + Integral(d_Gamma, (tau.val' * xi_val) * p.val);

% matrices for projection
CG_M = Bilinear(V_Space,V_Space);
CG_M = CG_M + Integral(Gamma, eta.val' * phi.val);

Proj_Sigma_MAT = Bilinear(V_Space,Sigma_Space);
Proj_Sigma_MAT = Proj_Sigma_MAT + Integral(Gamma, eta.val' * sig.val);

Proj_P_MAT = Bilinear(V_Space,P_Space);
Proj_P_MAT = Proj_P_MAT + Integral(Gamma, eta.val(1) * p.val);

% other matrices
N_DOT_sigma = Real(1,1);
N_DOT_sigma = N_DOT_sigma + Integral(Gamma, sig_coef.val' * gf.N );

% compute errors
L2_p_soln_sq = Real(1,1);
L2_p_soln_sq = L2_p_soln_sq + Integral(Gamma, ( p_coef.val - soln_func(gf.X(1),gf.X(2)) )^2 );

L2_sig_soln_sq = Real(1,1);
vec_diff = sig_coef.val - ( -soln_surf_grad_func(gf.X(1),gf.X(2)) );
L2_sig_soln_sq = L2_sig_soln_sq + Integral(Gamma, vec_diff' * vec_diff );

L2_div_sig_soln_sq = Real(1,1);
L2_div_sig_soln_sq = L2_div_sig_soln_sq + Integral(Gamma, (sig_coef.div - f_func(gf.X(1),gf.X(2)))^2 );

% set the minimum order of accuracy for the quad rule
Quadrature_Order = 10;

% define geometry representation - Domain, reference element
deg_surf_str = num2str(deg_surf);
P_Surf_Gamma = eval(['lagrange_deg', deg_surf_str, '_dim2();']);
G_Space = GeoElement(Gamma,P_Surf_Gamma);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G_Space);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Sigma_Mass_Matrix);
MATS = MATS.Append_Matrix(P_Mass_Matrix);
MATS = MATS.Append_Matrix(Div_Matrix);
MATS = MATS.Append_Matrix(RHS_Matrix);
MATS = MATS.Append_Matrix(CG_M);
MATS = MATS.Append_Matrix(Proj_Sigma_MAT);
MATS = MATS.Append_Matrix(Proj_P_MAT);
MATS = MATS.Append_Matrix(N_DOT_sigma);
MATS = MATS.Append_Matrix(L2_p_soln_sq);
MATS = MATS.Append_Matrix(L2_sig_soln_sq);
MATS = MATS.Append_Matrix(L2_div_sig_soln_sq);

end