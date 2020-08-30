function New_Vtx = curve_deform_3D_mesh(Vtx,alpha,n_vec)
%curve_deform_3D_mesh
%
%   This takes a given 3-D mesh and deforms it along a given space curve.
%   The space curve is parameterized by \alpha:
%               \alpha : [-A, B] \to \R^3.
%
%   Let \nn = n_vec be a unit normal to \alpha, i.e.
%              |\nn|=1, \nn \cdot \alpha' = 0,
%                       |\nn \times \alpha'| > 0.
%
%   Let \bb = b_vec = \alpha' \times \nn
%
%   Define the deformation map by:
%              \Phi(x,y,z) = \alpha(z) + x * \nn(z) + y * \bb(z),
%   so the deformed mesh is obtained by applying \Phi to the mesh vertex
%   coordinates.
%
%   Note: the mesh you want to deform should (probably) be centered about
%   the z-axis (i.e. centered about x=y=0).
%
%   Matlab Command:
%   New_Vtx = curve_deform_3D_mesh(Vtx,alpha,n_vec);
%
%   Input:     
%       Vtx = list of vertex coordinates in 2-D.
%       alpha = symbolic function defining a space curve; should only be a
%               function of one variable.  Dimension of alpha must be 3.
%       n_vec = symbolic function defining a normal vector to \alpha';
%               should only be a function of one variable.  Dimension is 3.
%
%   Output:
%       New_Vtx = list of new vertex coordinates in 3-D.
%
%   Example:
%     Np = 5;
%     [Tet, Vtx] = regular_tetrahedral_mesh(Np+1,Np+1,4*Np+1);
%     Vtx = Vtx - 0.5;
%     Vtx(:,1:2) = 0.25*Vtx(:,1:2);
%     % define a space curve which will define the mesh deformation
%     syms t real;
%     alpha = [0*t, t.^2, t];
%     n_vec = [0*t + 1, 0*t, 0*t];
%     New_Vtx = curve_deform_3D_mesh(Vtx,alpha,n_vec);
%     tetramesh(Tet,New_Vtx);

% Copyright (c) 03-06-2018,  Shawn W. Walker

if ~isa(alpha,'sym')
    error('alpha must be a symbolic function of one variable!');
end
if (size(alpha,1)~=1)
    error('alpha should be a row vector.');
end
if (size(alpha,2)~=3)
    error('alpha should be a length 3 vector when n_vec is supplied.');
end
if (size(n_vec,2)~=3)
    error('n_vec should be a length 3 vector when it is supplied.');
end
if (size(Vtx,2)~=3)
    error('Vertices are not in 3-D!  Only 3-D coordinates are allowed.');
end

% get symbolic variable
t = symvar(alpha);
if (length(t)~=1)
    error('alpha must a function of one variable only!');
end

% make sure symvar is the same
t_chk = symvar(n_vec);
if ~isempty(t_chk)
    if (length(t_chk)~=t)
        error('n_vec must have the same sym var as alpha!');
    end
end

% compute bi-normal
alpha_prime = diff(alpha,t,1);
b_temp = cross(alpha_prime,n_vec);
b_temp_mag = sqrt(sum(b_temp.^2));
b_vec = b_temp / b_temp_mag;
b_vec = simplify(b_vec);

% define map
syms x y z real;
Phi_sym = subs(alpha,t,z) + x * subs(n_vec,t,z) + y * subs(b_vec,t,z);
Phi = matlabFunction(Phi_sym);
%Phi

% apply the map to the mesh vertices
New_Vtx = Phi(Vtx(:,1),Vtx(:,2),Vtx(:,3));

end