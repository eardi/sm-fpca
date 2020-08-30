function New_Vtx = curve_deform_2D_mesh(Vtx,alpha,n_vec)
%curve_deform_2D_mesh
%
%   This takes a given 2-D mesh and deforms it along a given space curve.
%   The space curve is parameterized by \alpha:
%               \alpha : [-A, B] \to \R^2 or \R^3.
%
%   Let \nn be a unit normal to \alpha, i.e.
%              |\nn|=1, \nn \cdot \alpha' = 0,
%                       \nn \times \alpha' \cdot [0,0,1] > 0.
%
%   Define the deformation map by:
%              \Phi(x,y) = \alpha(y) + x * \nn (y),
%   so the deformed mesh is obtained by applying \Phi to the mesh vertex
%   coordinates.
%
%   Note: the mesh you want to deform should (probably) be centered about
%   the y-axis (i.e. centered about x=0).
%
%   Matlab Command:
%   New_Vtx = curve_deform_2D_mesh(Vtx,alpha);
%
%   Input:     
%       Vtx = list of vertex coordinates in 2-D.
%       alpha = symbolic function defining a space curve; should only be a
%               function of one variable.  Dimension of alpha must be 2.
%
%   Output:
%       New_Vtx = list of new vertex coordinates in 2-D.
%
%   New_Vtx = curve_deform_2D_mesh(Vtx,alpha,n_vec);
%
%   Input:
%       n_vec = symbolic function defining a normal vector to \alpha';
%               should only be a function of one variable.
%       Note: in this case, dimension of alpha AND n_vec must be 3, i.e.
%             for a 3-D curve, user must supply one of the normal fields.
%
%   Output:
%       New_Vtx = list of new vertex coordinates in 3-D.
%
%   Example:
%     nx = 10;
%     ny = 150;
%     [Tri,Vtx] = bcc_triangle_mesh(nx,ny);
%     X_Len = 0.2/1;
%     Y_Len = 0.5/1;
%     Vtx(:,1) = Vtx(:,1) - 0.5;
%     Vtx(:,1) = X_Len * Vtx(:,1);
%     Vtx(:,2) = Y_Len * Vtx(:,2);
%     % define a space curve which will define the mesh deformation
%     syms t real;
%     alpha = 2*[cos(pi*t), sin(pi*t)];
%     New_Vtx = curve_deform_2D_mesh(Vtx,alpha);
%     trimesh(Tri,New_Vtx(:,1),New_Vtx(:,2),0*New_Vtx(:,1));
%     view(2);

% Copyright (c) 03-06-2018,  Shawn W. Walker

if (nargin<3)
    n_vec = [];
end
if ~isa(alpha,'sym')
    error('alpha must be a symbolic function of one variable!');
end
if (size(alpha,1)~=1)
    error('alpha should be a row vector.');
end
if isempty(n_vec)
    if (size(alpha,2)~=2)
        error('alpha should be a length 2 vector.');
    end
else
    if (size(alpha,2)~=3)
        error('alpha should be a length 3 vector when n_vec is supplied.');
    end
    if (size(n_vec,2)~=3)
        error('n_vec should be a length 3 vector when it is supplied.');
    end
end
if (size(Vtx,2)~=2)
    error('Vertices are not in 2-D!  Only 2-D coordinates are allowed.');
end

% get symbolic variable
t = symvar(alpha);
if (length(t)~=1)
    error('alpha must a function of one variable only!');
end

% compute normal vec if necessary
if isempty(n_vec)
    alpha_prime = diff(alpha,t,1);
    n_temp = [alpha_prime(2), -alpha_prime(1)];
    n_vec = n_temp / sqrt(n_temp(1)^2 + n_temp(2)^2);
    n_vec = simplify(n_vec);
else
    % make sure symvar is the same
    t_chk = symvar(n_vec);
    if ~isempty(t_chk)
        if (length(t_chk)~=t)
            error('n_vec must have the same sym var as alpha!');
        end
    end
end

% define map
syms x y real;
Phi_sym = subs(alpha,t,y) + x * subs(n_vec,t,y);
Phi = matlabFunction(Phi_sym);
%Phi

% apply the map to the mesh vertices
New_Vtx = Phi(Vtx(:,1),Vtx(:,2));

end