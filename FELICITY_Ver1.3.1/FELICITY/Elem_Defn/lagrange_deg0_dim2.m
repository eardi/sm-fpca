function Elem = lagrange_deg0_dim2(Type_STR)
%lagrange_deg0_dim2
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Lagrange H^1 Finite Element of degree = 0, in dimension = 2.
%
%    Reference Domain: unit triangle with vertex coordinates: (0, 0), (1, 0), (0, 1).
%
%              y
%              ^
%              |
%            1 + 
%              |\ 
%              | \ 
%              |  \ 
%              |   \ 
%              |    \ 
%              |     \ 
%              |      \ 
%              |       \ 
%            0-+--------+--> x
%              0        1

% Copyright (c) 04-Apr-2018,  Shawn W. Walker

% name it!
Elem.Name = mfilename;

% space must be discontinuous galerkin for piecewise constant
Elem.Type = 'DG';

% topological dimension and domain
Elem.Dim = 2;
Elem.Domain = 'triangle';

% nodal basis function definitions (in the order of their local Degree-of-Freedom index)
Elem.Basis(1).Func = []; % init
Elem.Basis(1).Func = {'1'};
% local mapping transformation to use
Elem.Transformation = 'H1_Trans';
Elem.Degree = 0;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(1).Data = []; % init
Elem.Nodal_Var(1).Data = {[1/3, 1/3, 1/3], 'eval_cell', 1};

%%%%% topological arrangement of nodal points %%%%%
% note: multiple sets of nodal variables can be associated with each topological entity.
%       This is done by defining multiple matrix arrays within each matlab cell.
%       See the FELICITY manual for more info.

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to edges
Elem.Nodal_Top.E = {[]};

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [1]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end