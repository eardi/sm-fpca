function MATS = MatAssem_Lagrange_triangle(DIM,deg_k,exact_soln,vars)
%MatAssem_Lagrange_triangle

% Copyright (c) 04-04-2018,  Shawn W. Walker

% define domain
if (DIM==1)
    Omega = Domain('interval');
    %Gamma = Domain('point') < Omega;
elseif (DIM==2)
    Omega = Domain('triangle');
    %Gamma = Domain('interval') < Omega;
elseif (DIM==3)
    Omega = Domain('tetrahedron');
    %Gamma = Domain('triangle') < Omega;
else
    error('Invalid!');
end

% define finite element spaces
P_k = eval(['lagrange_deg', num2str(deg_k), '_dim', num2str(DIM), '();']);
V_h = Element(Omega,P_k);

% define functions on FEM spaces
v = Test(V_h);
u = Trial(V_h);

discrete_soln = Coef(V_h);

% define geometric function on \Omega
gf = GeoFunc(Omega);

% define exact solution and it's surface gradient
[soln_func, soln_grad_func, f_func] = Compute_Exact_Soln_Lagrange_triangle(exact_soln,vars);

% define FEM matrices
Mass_Matrix = Bilinear(V_h,V_h);
Mass_Matrix = Mass_Matrix + Integral(Omega, v.val * u.val );

Stiff_Matrix = Bilinear(V_h,V_h);
Stiff_Matrix = Stiff_Matrix + Integral(Omega, v.grad' * u.grad );

% exact RHS
if (DIM==1)
    exact_f = f_func(gf.X(1));
    exact_soln = soln_func(gf.X(1));
    exact_soln_grad = soln_grad_func(gf.X(1));
    Quadrature_Order = 40; % set the minimum order of accuracy for the quad rule
elseif (DIM==2)
    exact_f = f_func(gf.X(1),gf.X(2));
    exact_soln = soln_func(gf.X(1),gf.X(2));
    exact_soln_grad = soln_grad_func(gf.X(1),gf.X(2));
    Quadrature_Order = 30; % set the minimum order of accuracy for the quad rule
elseif (DIM==3)
    exact_f = f_func(gf.X(1),gf.X(2),gf.X(3));
    exact_soln = soln_func(gf.X(1),gf.X(2),gf.X(3));
    exact_soln_grad = soln_grad_func(gf.X(1),gf.X(2),gf.X(3));
    Quadrature_Order = 30; % set the minimum order of accuracy for the quad rule
else
    error('Invalid!');
end

RHS = Linear(V_h);
RHS = RHS + Integral(Omega, v.val * exact_f );

% numerical errors
L2_Error_Sq = Real(1,1);
L2_Error_Sq = L2_Error_Sq + Integral(Omega, (discrete_soln.val - exact_soln)^2 );

L2_Grad_Error_Sq = Real(1,1);
L2_Grad_Error_Sq = L2_Grad_Error_Sq + Integral(Omega, (discrete_soln.grad - exact_soln_grad)' * (discrete_soln.grad - exact_soln_grad) );

% define geometry representation - Domain, reference element
G_Space = GeoElement(Omega);
% define a set of matrices
MATS = Matrices(Quadrature_Order,G_Space);

% collect all of the matrices together
MATS = MATS.Append_Matrix(Mass_Matrix);
MATS = MATS.Append_Matrix(Stiff_Matrix);
MATS = MATS.Append_Matrix(RHS);
MATS = MATS.Append_Matrix(L2_Error_Sq);
MATS = MATS.Append_Matrix(L2_Grad_Error_Sq);

end