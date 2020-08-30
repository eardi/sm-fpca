function Elem = lagrange_deg5_dim2(Type_STR)
%lagrange_deg5_dim2
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Lagrange H^1 Finite Element of degree = 5, in dimension = 2.
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
Elem.Basis(21).Func = []; % init
Elem.Basis(1).Func = {'(1875*x^2*y^2)/4 - (137*y)/12 - (137*x)/12 - (3125*x^2*y^3)/12 - (3125*x^3*y^2)/12 + (375*x*y)/4 - (2125*x*y^2)/8 - (2125*x^2*y)/8 + (625*x*y^3)/2 + (625*x^3*y)/2 - (3125*x*y^4)/24 - (3125*x^4*y)/24 + (375*x^2)/8 - (2125*x^3)/24 + (625*x^4)/8 - (625*x^5)/24 + (375*y^2)/8 - (2125*y^3)/24 + (625*y^4)/8 - (625*y^5)/24 + 1'};
Elem.Basis(2).Func = {'(x*(875*x^2 - 250*x - 1250*x^3 + 625*x^4 + 24))/24'};
Elem.Basis(3).Func = {'(y*(875*y^2 - 250*y - 1250*y^3 + 625*y^4 + 24))/24'};
Elem.Basis(4).Func = {'(25*x*y*(55*x - 150*x^2 + 125*x^3 - 6))/24'};
Elem.Basis(5).Func = {'(25*x*y*(5*y - 1)*(25*x^2 - 15*x + 2))/12'};
Elem.Basis(6).Func = {'(25*x*y*(5*x - 1)*(25*y^2 - 15*y + 2))/12'};
Elem.Basis(7).Func = {'(25*x*y*(55*y - 150*y^2 + 125*y^3 - 6))/24'};
Elem.Basis(8).Func = {'-(25*y*(x + y - 1)*(55*y - 150*y^2 + 125*y^3 - 6))/24'};
Elem.Basis(9).Func = {'(25*y*(25*y^2 - 15*y + 2)*(10*x*y - 9*y - 9*x + 5*x^2 + 5*y^2 + 4))/12'};
Elem.Basis(10).Func = {'-(25*y*(5*y - 1)*(47*x + 47*y - 120*x*y + 75*x*y^2 + 75*x^2*y - 60*x^2 + 25*x^3 - 60*y^2 + 25*y^3 - 12))/12'};
Elem.Basis(11).Func = {'(25*y*(750*x^2*y^2 - 154*y - 154*x + 710*x*y - 1050*x*y^2 - 1050*x^2*y + 500*x*y^3 + 500*x^3*y + 355*x^2 - 350*x^3 + 125*x^4 + 355*y^2 - 350*y^3 + 125*y^4 + 24))/24'};
Elem.Basis(12).Func = {'(25*x*(750*x^2*y^2 - 154*y - 154*x + 710*x*y - 1050*x*y^2 - 1050*x^2*y + 500*x*y^3 + 500*x^3*y + 355*x^2 - 350*x^3 + 125*x^4 + 355*y^2 - 350*y^3 + 125*y^4 + 24))/24'};
Elem.Basis(13).Func = {'-(25*x*(5*x - 1)*(47*x + 47*y - 120*x*y + 75*x*y^2 + 75*x^2*y - 60*x^2 + 25*x^3 - 60*y^2 + 25*y^3 - 12))/12'};
Elem.Basis(14).Func = {'(25*x*(25*x^2 - 15*x + 2)*(10*x*y - 9*y - 9*x + 5*x^2 + 5*y^2 + 4))/12'};
Elem.Basis(15).Func = {'-(25*x*(x + y - 1)*(55*x - 150*x^2 + 125*x^3 - 6))/24'};
Elem.Basis(16).Func = {'-(125*x*y*(5*x - 1)*(5*y - 1)*(x + y - 1))/4'};
Elem.Basis(17).Func = {'-(125*x*y*(47*x + 47*y - 120*x*y + 75*x*y^2 + 75*x^2*y - 60*x^2 + 25*x^3 - 60*y^2 + 25*y^3 - 12))/6'};
Elem.Basis(18).Func = {'(125*x*y*(5*y - 1)*(10*x*y - 9*y - 9*x + 5*x^2 + 5*y^2 + 4))/4'};
Elem.Basis(19).Func = {'-(125*x*y*(x + y - 1)*(25*x^2 - 15*x + 2))/6'};
Elem.Basis(20).Func = {'(125*x*y*(5*x - 1)*(10*x*y - 9*y - 9*x + 5*x^2 + 5*y^2 + 4))/4'};
Elem.Basis(21).Func = {'-(125*x*y*(x + y - 1)*(25*y^2 - 15*y + 2))/6'};
% local mapping transformation to use
Elem.Transformation = 'H1_Trans';
Elem.Degree = 5;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(21).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1, 0], 'eval_vertex', 2};
Elem.Nodal_Var(3).Data = {[0, 0, 1], 'eval_vertex', 3};
Elem.Nodal_Var(4).Data = {[0, 4/5, 1/5], 'eval_facet', 1};
Elem.Nodal_Var(5).Data = {[0, 3/5, 2/5], 'eval_facet', 1};
Elem.Nodal_Var(6).Data = {[0, 2/5, 3/5], 'eval_facet', 1};
Elem.Nodal_Var(7).Data = {[0, 1/5, 4/5], 'eval_facet', 1};
Elem.Nodal_Var(8).Data = {[1/5, 0, 4/5], 'eval_facet', 2};
Elem.Nodal_Var(9).Data = {[2/5, 0, 3/5], 'eval_facet', 2};
Elem.Nodal_Var(10).Data = {[3/5, 0, 2/5], 'eval_facet', 2};
Elem.Nodal_Var(11).Data = {[4/5, 0, 1/5], 'eval_facet', 2};
Elem.Nodal_Var(12).Data = {[4/5, 1/5, 0], 'eval_facet', 3};
Elem.Nodal_Var(13).Data = {[3/5, 2/5, 0], 'eval_facet', 3};
Elem.Nodal_Var(14).Data = {[2/5, 3/5, 0], 'eval_facet', 3};
Elem.Nodal_Var(15).Data = {[1/5, 4/5, 0], 'eval_facet', 3};
Elem.Nodal_Var(16).Data = {[1/5, 2/5, 2/5], 'eval_cell', 1};
Elem.Nodal_Var(17).Data = {[3/5, 1/5, 1/5], 'eval_cell', 1};
Elem.Nodal_Var(18).Data = {[2/5, 1/5, 2/5], 'eval_cell', 1};
Elem.Nodal_Var(19).Data = {[1/5, 3/5, 1/5], 'eval_cell', 1};
Elem.Nodal_Var(20).Data = {[2/5, 2/5, 1/5], 'eval_cell', 1};
Elem.Nodal_Var(21).Data = {[1/5, 1/5, 3/5], 'eval_cell', 1};

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
                   [4, 5, 6, 7;
                    8, 9, 10, 11;
                    12, 13, 14, 15]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [16, 17, 18, 19, 20, 21]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end