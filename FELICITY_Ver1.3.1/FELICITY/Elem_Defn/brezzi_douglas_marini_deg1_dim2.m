function Elem = brezzi_douglas_marini_deg1_dim2(Type_STR)
%brezzi_douglas_marini_deg1_dim2
%
%   This defines a finite element to be used by FELICITY.

% Copyright (c) 09-12-2016,  Shawn W. Walker

% name it!
Elem.Name = mfilename;

% determine continuous or discontinuous galerkin space
if (nargin==0)
    Type_STR = 'CG'; % default
end
if strcmpi(Type_STR,'cg')
    Elem.Type = 'CG';
elseif strcmpi(Type_STR,'dg')
    Elem.Type = 'DG';
else
    error('Invalid input type!  Must be ''CG'' or ''DG''.');
end

% topological dimension and domain
Elem.Dim = 2;
Elem.Domain = 'triangle';

% basis function definitions
% note: there can be more than one set of basis functions if this is a
% vectorized element (i.e. velocity and pressure).
Elem.Basis(6).Func = []; % init
Elem.Basis(1).Func = {'4*x'; '-2*y'};
Elem.Basis(2).Func = {'-2*x'; '4*y'};
Elem.Basis(3).Func = {'2 - 6*y - 2*x'; '4*y'};
Elem.Basis(4).Func = {'4*x + 6*y - 4'; '-2*y'};
Elem.Basis(5).Func = {'-2*x'; '6*x + 4*y - 4'};
Elem.Basis(6).Func = {'4*x'; '2 - 2*y - 6*x'};
% local mapping transformation to use
Elem.Transformation = 'Hdiv_Trans';
Elem.Degree = 1;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(6).Data = []; % init
Elem.Nodal_Var(1).Data = {[0, 1, 0], '[1 - y]', 'int_facet', 1};
Elem.Nodal_Var(2).Data = {[0, 0, 1], '[y]', 'int_facet', 1};
Elem.Nodal_Var(3).Data = {[0, 0, 1], '[y]', 'int_facet', 2};
Elem.Nodal_Var(4).Data = {[1, 0, 0], '[1 - y]', 'int_facet', 2};
Elem.Nodal_Var(5).Data = {[1, 0, 0], '[1 - x]', 'int_facet', 3};
Elem.Nodal_Var(6).Data = {[0, 1, 0], '[x]', 'int_facet', 3};

%%%%% nodal (topological) arrangement
% note: there can be more than one set of nodal variables (see above)

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to (directed) edges
Elem.Nodal_Top.E = {[1, 2;
                     3, 4;
                     5, 6]};
%

% nodes attached to (triangles) faces
Elem.Nodal_Top.F = {[]}; % NONE

% nodes attached to tetrahedra
Elem.Nodal_Top.T = {[]}; % no tetrahedra in 2-D

end