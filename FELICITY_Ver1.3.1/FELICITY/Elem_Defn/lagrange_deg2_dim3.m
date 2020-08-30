function Elem = lagrange_deg2_dim3(Type_STR)
%lagrange_deg2_dim3
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Lagrange H^1 Finite Element of degree = 2, in dimension = 3.
%
%    Reference Domain: unit tetrahedron with vertex coordinates: (0, 0, 0), (1, 0, 0), (0, 1, 0), (0, 0, 1).
%
%                        z
%                        ^
%                        |
%                      1 +
%                       /|\ 
%                      / | \ 
%                     |  |  \ 
%                    |   |   \ 
%                   |    |    \ 
%                   |    |     \ 
%                  |     |      \ 
%                  |     |       \ 
%                 |    0-+--------+--> y
%                 |     /0     __/1
%                |    /     __/
%                |  /    __/
%               | /   __/
%              |/  __/
%            1 +--/
%             \/
%             x

% Copyright (c) 15-Aug-2019,  Shawn W. Walker

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
Elem.Dim = 3;
Elem.Domain = 'tetrahedron';

% nodal basis function definitions (in the order of their local Degree-of-Freedom index)
Elem.Basis(10).Func = []; % init
Elem.Basis(1).Func = {'4*x*y - 3*y - 3*z - 3*x + 4*x*z + 4*y*z + 2*x^2 + 2*y^2 + 2*z^2 + 1'};
Elem.Basis(2).Func = {'x*(2*x - 1)'};
Elem.Basis(3).Func = {'y*(2*y - 1)'};
Elem.Basis(4).Func = {'z*(2*z - 1)'};
Elem.Basis(5).Func = {'-4*x*(x + y + z - 1)'};
Elem.Basis(6).Func = {'-4*y*(x + y + z - 1)'};
Elem.Basis(7).Func = {'-4*z*(x + y + z - 1)'};
Elem.Basis(8).Func = {'4*x*y'};
Elem.Basis(9).Func = {'4*y*z'};
Elem.Basis(10).Func = {'4*x*z'};
% local mapping transformation to use
Elem.Transformation = 'H1_Trans';
Elem.Degree = 2;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(10).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0, 0, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1, 0, 0], 'eval_vertex', 2};
Elem.Nodal_Var(3).Data = {[0, 0, 1, 0], 'eval_vertex', 3};
Elem.Nodal_Var(4).Data = {[0, 0, 0, 1], 'eval_vertex', 4};
Elem.Nodal_Var(5).Data = {[1/2, 1/2, 0, 0], 'eval_edge', 1};
Elem.Nodal_Var(6).Data = {[1/2, 0, 1/2, 0], 'eval_edge', 2};
Elem.Nodal_Var(7).Data = {[1/2, 0, 0, 1/2], 'eval_edge', 3};
Elem.Nodal_Var(8).Data = {[0, 1/2, 1/2, 0], 'eval_edge', 4};
Elem.Nodal_Var(9).Data = {[0, 0, 1/2, 1/2], 'eval_edge', 5};
Elem.Nodal_Var(10).Data = {[0, 1/2, 0, 1/2], 'eval_edge', 6};

%%%%% topological arrangement of nodal points %%%%%
% note: multiple sets of nodal variables can be associated with each topological entity.
%       This is done by defining multiple matrix arrays within each matlab cell.
%       See the FELICITY manual for more info.

% nodes attached to vertices
Elem.Nodal_Top.V = {...
                   [1;
                    2;
                    3;
                    4]...
                   };
%

% nodes attached to edges
Elem.Nodal_Top.E = {...
                   [5;
                    6;
                    7;
                    8;
                    9;
                    10]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {[]};

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end