function Elem = lagrange_deg3_dim3(Type_STR)
%lagrange_deg3_dim3
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Lagrange H^1 Finite Element of degree = 3, in dimension = 3.
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
Elem.Basis(20).Func = []; % init
Elem.Basis(1).Func = {'18*x*y - (11*y)/2 - (11*z)/2 - (11*x)/2 + 18*x*z + 18*y*z - (27*x*y^2)/2 - (27*x^2*y)/2 - (27*x*z^2)/2 - (27*x^2*z)/2 - (27*y*z^2)/2 - (27*y^2*z)/2 + 9*x^2 - (9*x^3)/2 + 9*y^2 - (9*y^3)/2 + 9*z^2 - (9*z^3)/2 - 27*x*y*z + 1'};
Elem.Basis(2).Func = {'(x*(9*x^2 - 9*x + 2))/2'};
Elem.Basis(3).Func = {'(y*(9*y^2 - 9*y + 2))/2'};
Elem.Basis(4).Func = {'(z*(9*z^2 - 9*z + 2))/2'};
Elem.Basis(5).Func = {'(9*x*(6*x*y - 5*y - 5*z - 5*x + 6*x*z + 6*y*z + 3*x^2 + 3*y^2 + 3*z^2 + 2))/2'};
Elem.Basis(6).Func = {'-(9*x*(3*x - 1)*(x + y + z - 1))/2'};
Elem.Basis(7).Func = {'(9*y*(6*x*y - 5*y - 5*z - 5*x + 6*x*z + 6*y*z + 3*x^2 + 3*y^2 + 3*z^2 + 2))/2'};
Elem.Basis(8).Func = {'-(9*y*(3*y - 1)*(x + y + z - 1))/2'};
Elem.Basis(9).Func = {'(9*z*(6*x*y - 5*y - 5*z - 5*x + 6*x*z + 6*y*z + 3*x^2 + 3*y^2 + 3*z^2 + 2))/2'};
Elem.Basis(10).Func = {'-(9*z*(3*z - 1)*(x + y + z - 1))/2'};
Elem.Basis(11).Func = {'(9*x*y*(3*x - 1))/2'};
Elem.Basis(12).Func = {'(9*x*y*(3*y - 1))/2'};
Elem.Basis(13).Func = {'(9*y*z*(3*y - 1))/2'};
Elem.Basis(14).Func = {'(9*y*z*(3*z - 1))/2'};
Elem.Basis(15).Func = {'(9*x*z*(3*z - 1))/2'};
Elem.Basis(16).Func = {'(9*x*z*(3*x - 1))/2'};
Elem.Basis(17).Func = {'27*x*y*z'};
Elem.Basis(18).Func = {'-27*y*z*(x + y + z - 1)'};
Elem.Basis(19).Func = {'-27*x*z*(x + y + z - 1)'};
Elem.Basis(20).Func = {'-27*x*y*(x + y + z - 1)'};
% local mapping transformation to use
Elem.Transformation = 'H1_Trans';
Elem.Degree = 3;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(20).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0, 0, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1, 0, 0], 'eval_vertex', 2};
Elem.Nodal_Var(3).Data = {[0, 0, 1, 0], 'eval_vertex', 3};
Elem.Nodal_Var(4).Data = {[0, 0, 0, 1], 'eval_vertex', 4};
Elem.Nodal_Var(5).Data = {[2/3, 1/3, 0, 0], 'eval_edge', 1};
Elem.Nodal_Var(6).Data = {[1/3, 2/3, 0, 0], 'eval_edge', 1};
Elem.Nodal_Var(7).Data = {[2/3, 0, 1/3, 0], 'eval_edge', 2};
Elem.Nodal_Var(8).Data = {[1/3, 0, 2/3, 0], 'eval_edge', 2};
Elem.Nodal_Var(9).Data = {[2/3, 0, 0, 1/3], 'eval_edge', 3};
Elem.Nodal_Var(10).Data = {[1/3, 0, 0, 2/3], 'eval_edge', 3};
Elem.Nodal_Var(11).Data = {[0, 2/3, 1/3, 0], 'eval_edge', 4};
Elem.Nodal_Var(12).Data = {[0, 1/3, 2/3, 0], 'eval_edge', 4};
Elem.Nodal_Var(13).Data = {[0, 0, 2/3, 1/3], 'eval_edge', 5};
Elem.Nodal_Var(14).Data = {[0, 0, 1/3, 2/3], 'eval_edge', 5};
Elem.Nodal_Var(15).Data = {[0, 1/3, 0, 2/3], 'eval_edge', 6};
Elem.Nodal_Var(16).Data = {[0, 2/3, 0, 1/3], 'eval_edge', 6};
Elem.Nodal_Var(17).Data = {[0, 1/3, 1/3, 1/3], 'eval_facet', 1};
Elem.Nodal_Var(18).Data = {[1/3, 0, 1/3, 1/3], 'eval_facet', 2};
Elem.Nodal_Var(19).Data = {[1/3, 1/3, 0, 1/3], 'eval_facet', 3};
Elem.Nodal_Var(20).Data = {[1/3, 1/3, 1/3, 0], 'eval_facet', 4};

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
                   [5, 6;
                    7, 8;
                    9, 10;
                    11, 12;
                    13, 14;
                    15, 16]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [17;
                    18;
                    19;
                    20]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end