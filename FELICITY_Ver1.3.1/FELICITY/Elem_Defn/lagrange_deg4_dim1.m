function Elem = lagrange_deg4_dim1(Type_STR)
%lagrange_deg4_dim1
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Lagrange H^1 Finite Element of degree = 4, in dimension = 1.
%
%    Reference Domain: unit interval [0, 1].
%
%            |------------|--> x
%            0            1

% Copyright (c) 04-Apr-2018,  Shawn W. Walker

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
Elem.Dim = 1;
Elem.Domain = 'interval';

% nodal basis function definitions (in the order of their local Degree-of-Freedom index)
Elem.Basis(5).Func = []; % init
Elem.Basis(1).Func = {'(70*x^2)/3 - (25*x)/3 - (80*x^3)/3 + (32*x^4)/3 + 1'};
Elem.Basis(2).Func = {'(x*(22*x - 48*x^2 + 32*x^3 - 3))/3'};
Elem.Basis(3).Func = {'-(16*x*(13*x - 18*x^2 + 8*x^3 - 3))/3'};
Elem.Basis(4).Func = {'4*x*(19*x - 32*x^2 + 16*x^3 - 3)'};
Elem.Basis(5).Func = {'-(16*x*(7*x - 14*x^2 + 8*x^3 - 1))/3'};
% local mapping transformation to use
Elem.Transformation = 'H1_Trans';
Elem.Degree = 4;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(5).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1], 'eval_vertex', 2};
Elem.Nodal_Var(3).Data = {[3/4, 1/4], 'eval_cell', 1};
Elem.Nodal_Var(4).Data = {[1/2, 1/2], 'eval_cell', 1};
Elem.Nodal_Var(5).Data = {[1/4, 3/4], 'eval_cell', 1};

%%%%% topological arrangement of nodal points %%%%%
% note: multiple sets of nodal variables can be associated with each topological entity.
%       This is done by defining multiple matrix arrays within each matlab cell.
%       See the FELICITY manual for more info.

% nodes attached to vertices
Elem.Nodal_Top.V = {...
                   [1;
                    2]...
                   };
%

% nodes attached to edges
Elem.Nodal_Top.E = {...
                   [3, 4, 5]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {[]};

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end