function Elem = lagrange_deg4_dim2(Type_STR)
%lagrange_deg4_dim2
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Lagrange H^1 Finite Element of degree = 4, in dimension = 2.
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

% nodal basis function definitions (in the order of their local Degree-of-Freedom index)
Elem.Basis(15).Func = []; % init
Elem.Basis(1).Func = {'64*x^2*y^2 - (25*y)/3 - (25*x)/3 + (140*x*y)/3 - 80*x*y^2 - 80*x^2*y + (128*x*y^3)/3 + (128*x^3*y)/3 + (70*x^2)/3 - (80*x^3)/3 + (32*x^4)/3 + (70*y^2)/3 - (80*y^3)/3 + (32*y^4)/3 + 1'};
Elem.Basis(2).Func = {'(x*(22*x - 48*x^2 + 32*x^3 - 3))/3'};
Elem.Basis(3).Func = {'(y*(22*y - 48*y^2 + 32*y^3 - 3))/3'};
Elem.Basis(4).Func = {'(16*x*y*(8*x^2 - 6*x + 1))/3'};
Elem.Basis(5).Func = {'4*x*y*(4*x - 1)*(4*y - 1)'};
Elem.Basis(6).Func = {'(16*x*y*(8*y^2 - 6*y + 1))/3'};
Elem.Basis(7).Func = {'-(16*y*(x + y - 1)*(8*y^2 - 6*y + 1))/3'};
Elem.Basis(8).Func = {'4*y*(4*y - 1)*(8*x*y - 7*y - 7*x + 4*x^2 + 4*y^2 + 3)'};
Elem.Basis(9).Func = {'-(16*y*(13*x + 13*y - 36*x*y + 24*x*y^2 + 24*x^2*y - 18*x^2 + 8*x^3 - 18*y^2 + 8*y^3 - 3))/3'};
Elem.Basis(10).Func = {'-(16*x*(13*x + 13*y - 36*x*y + 24*x*y^2 + 24*x^2*y - 18*x^2 + 8*x^3 - 18*y^2 + 8*y^3 - 3))/3'};
Elem.Basis(11).Func = {'4*x*(4*x - 1)*(8*x*y - 7*y - 7*x + 4*x^2 + 4*y^2 + 3)'};
Elem.Basis(12).Func = {'-(16*x*(x + y - 1)*(8*x^2 - 6*x + 1))/3'};
Elem.Basis(13).Func = {'32*x*y*(8*x*y - 7*y - 7*x + 4*x^2 + 4*y^2 + 3)'};
Elem.Basis(14).Func = {'-32*x*y*(4*x - 1)*(x + y - 1)'};
Elem.Basis(15).Func = {'-32*x*y*(4*y - 1)*(x + y - 1)'};
% local mapping transformation to use
Elem.Transformation = 'H1_Trans';
Elem.Degree = 4;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(15).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1, 0], 'eval_vertex', 2};
Elem.Nodal_Var(3).Data = {[0, 0, 1], 'eval_vertex', 3};
Elem.Nodal_Var(4).Data = {[0, 3/4, 1/4], 'eval_facet', 1};
Elem.Nodal_Var(5).Data = {[0, 1/2, 1/2], 'eval_facet', 1};
Elem.Nodal_Var(6).Data = {[0, 1/4, 3/4], 'eval_facet', 1};
Elem.Nodal_Var(7).Data = {[1/4, 0, 3/4], 'eval_facet', 2};
Elem.Nodal_Var(8).Data = {[1/2, 0, 1/2], 'eval_facet', 2};
Elem.Nodal_Var(9).Data = {[3/4, 0, 1/4], 'eval_facet', 2};
Elem.Nodal_Var(10).Data = {[3/4, 1/4, 0], 'eval_facet', 3};
Elem.Nodal_Var(11).Data = {[1/2, 1/2, 0], 'eval_facet', 3};
Elem.Nodal_Var(12).Data = {[1/4, 3/4, 0], 'eval_facet', 3};
Elem.Nodal_Var(13).Data = {[1/2, 1/4, 1/4], 'eval_cell', 1};
Elem.Nodal_Var(14).Data = {[1/4, 1/2, 1/4], 'eval_cell', 1};
Elem.Nodal_Var(15).Data = {[1/4, 1/4, 1/2], 'eval_cell', 1};

%%%%% topological arrangement of nodal points %%%%%
% note: multiple sets of nodal variables can be associated with each topological entity.
%       This is done by defining multiple matrix arrays within each matlab cell.
%       See the FELICITY manual for more info.

% nodes attached to vertices
Elem.Nodal_Top.V = {...
                   [1;
                    2;
                    3]...
                   };
%

% nodes attached to edges
Elem.Nodal_Top.E = {...
                   [4, 5, 6;
                    7, 8, 9;
                    10, 11, 12]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [13, 14, 15]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end