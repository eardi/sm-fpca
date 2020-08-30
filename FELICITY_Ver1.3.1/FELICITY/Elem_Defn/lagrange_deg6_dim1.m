function Elem = lagrange_deg6_dim1(Type_STR)
%lagrange_deg6_dim1
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Lagrange H^1 Finite Element of degree = 6, in dimension = 1.
%
%    Reference Domain: unit interval [0, 1].
%
%            |------------|--> x
%            0            1

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
Elem.Dim = 1;
Elem.Domain = 'interval';

% nodal basis function definitions (in the order of their local Degree-of-Freedom index)
Elem.Basis(7).Func = []; % init
Elem.Basis(1).Func = {'(406*x^2)/5 - (147*x)/10 - (441*x^3)/2 + 315*x^4 - (1134*x^5)/5 + (324*x^6)/5 + 1'};
Elem.Basis(2).Func = {'(x*(137*x - 675*x^2 + 1530*x^3 - 1620*x^4 + 648*x^5 - 10))/10'};
Elem.Basis(3).Func = {'-(18*x*(87*x - 290*x^2 + 465*x^3 - 360*x^4 + 108*x^5 - 10))/5'};
Elem.Basis(4).Func = {'(9*x*(117*x - 461*x^2 + 822*x^3 - 684*x^4 + 216*x^5 - 10))/2'};
Elem.Basis(5).Func = {'-4*x*(127*x - 558*x^2 + 1089*x^3 - 972*x^4 + 324*x^5 - 10)'};
Elem.Basis(6).Func = {'(9*x*(66*x - 307*x^2 + 642*x^3 - 612*x^4 + 216*x^5 - 5))/2'};
Elem.Basis(7).Func = {'-(18*x*(27*x - 130*x^2 + 285*x^3 - 288*x^4 + 108*x^5 - 2))/5'};
% local mapping transformation to use
Elem.Transformation = 'H1_Trans';
Elem.Degree = 6;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(7).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1], 'eval_vertex', 2};
Elem.Nodal_Var(3).Data = {[5/6, 1/6], 'eval_cell', 1};
Elem.Nodal_Var(4).Data = {[2/3, 1/3], 'eval_cell', 1};
Elem.Nodal_Var(5).Data = {[1/2, 1/2], 'eval_cell', 1};
Elem.Nodal_Var(6).Data = {[1/3, 2/3], 'eval_cell', 1};
Elem.Nodal_Var(7).Data = {[1/6, 5/6], 'eval_cell', 1};

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
                   [3, 4, 5, 6, 7]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {[]};

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end