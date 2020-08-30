function INTERP = FEL_Interp_Lagrange_triangle(DIM,deg_k)
%FEL_Interp_Lagrange_triangle

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

% define functions on FE spaces
u0 = Coef(V_h);

% define expressions to interpolate
I_u0 = Interpolate(Omega, u0.val);

% define geometry representation - Domain, reference element
G_Space = GeoElement(Omega);

% define a set of interpolations to perform
INTERP = Interpolations(G_Space);

% collect all of the interpolations together
INTERP = INTERP.Append_Interpolation(I_u0);

end