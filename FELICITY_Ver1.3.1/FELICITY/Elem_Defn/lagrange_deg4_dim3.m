function Elem = lagrange_deg4_dim3(Type_STR)
%lagrange_deg4_dim3
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Lagrange H^1 Finite Element of degree = 4, in dimension = 3.
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
Elem.Basis(35).Func = []; % init
Elem.Basis(1).Func = {'64*x^2*y^2 - (25*y)/3 - (25*z)/3 - (25*x)/3 + 64*x^2*z^2 + 64*y^2*z^2 + (140*x*y)/3 + (140*x*z)/3 + (140*y*z)/3 - 80*x*y^2 - 80*x^2*y + (128*x*y^3)/3 + (128*x^3*y)/3 - 80*x*z^2 - 80*x^2*z + (128*x*z^3)/3 + (128*x^3*z)/3 - 80*y*z^2 - 80*y^2*z + (128*y*z^3)/3 + (128*y^3*z)/3 + (70*x^2)/3 - (80*x^3)/3 + (32*x^4)/3 + (70*y^2)/3 - (80*y^3)/3 + (32*y^4)/3 + (70*z^2)/3 - (80*z^3)/3 + (32*z^4)/3 + 128*x*y*z^2 + 128*x*y^2*z + 128*x^2*y*z - 160*x*y*z + 1'};
Elem.Basis(2).Func = {'(x*(22*x - 48*x^2 + 32*x^3 - 3))/3'};
Elem.Basis(3).Func = {'(y*(22*y - 48*y^2 + 32*y^3 - 3))/3'};
Elem.Basis(4).Func = {'(z*(22*z - 48*z^2 + 32*z^3 - 3))/3'};
Elem.Basis(5).Func = {'-(16*x*(13*x + 13*y + 13*z - 36*x*y - 36*x*z - 36*y*z + 24*x*y^2 + 24*x^2*y + 24*x*z^2 + 24*x^2*z + 24*y*z^2 + 24*y^2*z - 18*x^2 + 8*x^3 - 18*y^2 + 8*y^3 - 18*z^2 + 8*z^3 + 48*x*y*z - 3))/3'};
Elem.Basis(6).Func = {'4*x*(4*x - 1)*(8*x*y - 7*y - 7*z - 7*x + 8*x*z + 8*y*z + 4*x^2 + 4*y^2 + 4*z^2 + 3)'};
Elem.Basis(7).Func = {'-(16*x*(8*x^2 - 6*x + 1)*(x + y + z - 1))/3'};
Elem.Basis(8).Func = {'-(16*y*(13*x + 13*y + 13*z - 36*x*y - 36*x*z - 36*y*z + 24*x*y^2 + 24*x^2*y + 24*x*z^2 + 24*x^2*z + 24*y*z^2 + 24*y^2*z - 18*x^2 + 8*x^3 - 18*y^2 + 8*y^3 - 18*z^2 + 8*z^3 + 48*x*y*z - 3))/3'};
Elem.Basis(9).Func = {'4*y*(4*y - 1)*(8*x*y - 7*y - 7*z - 7*x + 8*x*z + 8*y*z + 4*x^2 + 4*y^2 + 4*z^2 + 3)'};
Elem.Basis(10).Func = {'-(16*y*(8*y^2 - 6*y + 1)*(x + y + z - 1))/3'};
Elem.Basis(11).Func = {'-(16*z*(13*x + 13*y + 13*z - 36*x*y - 36*x*z - 36*y*z + 24*x*y^2 + 24*x^2*y + 24*x*z^2 + 24*x^2*z + 24*y*z^2 + 24*y^2*z - 18*x^2 + 8*x^3 - 18*y^2 + 8*y^3 - 18*z^2 + 8*z^3 + 48*x*y*z - 3))/3'};
Elem.Basis(12).Func = {'4*z*(4*z - 1)*(8*x*y - 7*y - 7*z - 7*x + 8*x*z + 8*y*z + 4*x^2 + 4*y^2 + 4*z^2 + 3)'};
Elem.Basis(13).Func = {'-(16*z*(8*z^2 - 6*z + 1)*(x + y + z - 1))/3'};
Elem.Basis(14).Func = {'(16*x*y*(8*x^2 - 6*x + 1))/3'};
Elem.Basis(15).Func = {'4*x*y*(4*x - 1)*(4*y - 1)'};
Elem.Basis(16).Func = {'(16*x*y*(8*y^2 - 6*y + 1))/3'};
Elem.Basis(17).Func = {'(16*y*z*(8*y^2 - 6*y + 1))/3'};
Elem.Basis(18).Func = {'4*y*z*(4*y - 1)*(4*z - 1)'};
Elem.Basis(19).Func = {'(16*y*z*(8*z^2 - 6*z + 1))/3'};
Elem.Basis(20).Func = {'(16*x*z*(8*z^2 - 6*z + 1))/3'};
Elem.Basis(21).Func = {'4*x*z*(4*x - 1)*(4*z - 1)'};
Elem.Basis(22).Func = {'(16*x*z*(8*x^2 - 6*x + 1))/3'};
Elem.Basis(23).Func = {'32*x*y*z*(4*x - 1)'};
Elem.Basis(24).Func = {'32*x*y*z*(4*y - 1)'};
Elem.Basis(25).Func = {'32*x*y*z*(4*z - 1)'};
Elem.Basis(26).Func = {'32*y*z*(8*x*y - 7*y - 7*z - 7*x + 8*x*z + 8*y*z + 4*x^2 + 4*y^2 + 4*z^2 + 3)'};
Elem.Basis(27).Func = {'-32*y*z*(4*z - 1)*(x + y + z - 1)'};
Elem.Basis(28).Func = {'-32*y*z*(4*y - 1)*(x + y + z - 1)'};
Elem.Basis(29).Func = {'32*x*z*(8*x*y - 7*y - 7*z - 7*x + 8*x*z + 8*y*z + 4*x^2 + 4*y^2 + 4*z^2 + 3)'};
Elem.Basis(30).Func = {'-32*x*z*(4*x - 1)*(x + y + z - 1)'};
Elem.Basis(31).Func = {'-32*x*z*(4*z - 1)*(x + y + z - 1)'};
Elem.Basis(32).Func = {'32*x*y*(8*x*y - 7*y - 7*z - 7*x + 8*x*z + 8*y*z + 4*x^2 + 4*y^2 + 4*z^2 + 3)'};
Elem.Basis(33).Func = {'-32*x*y*(4*y - 1)*(x + y + z - 1)'};
Elem.Basis(34).Func = {'-32*x*y*(4*x - 1)*(x + y + z - 1)'};
Elem.Basis(35).Func = {'-256*x*y*z*(x + y + z - 1)'};
% local mapping transformation to use
Elem.Transformation = 'H1_Trans';
Elem.Degree = 4;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(35).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0, 0, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1, 0, 0], 'eval_vertex', 2};
Elem.Nodal_Var(3).Data = {[0, 0, 1, 0], 'eval_vertex', 3};
Elem.Nodal_Var(4).Data = {[0, 0, 0, 1], 'eval_vertex', 4};
Elem.Nodal_Var(5).Data = {[3/4, 1/4, 0, 0], 'eval_edge', 1};
Elem.Nodal_Var(6).Data = {[1/2, 1/2, 0, 0], 'eval_edge', 1};
Elem.Nodal_Var(7).Data = {[1/4, 3/4, 0, 0], 'eval_edge', 1};
Elem.Nodal_Var(8).Data = {[3/4, 0, 1/4, 0], 'eval_edge', 2};
Elem.Nodal_Var(9).Data = {[1/2, 0, 1/2, 0], 'eval_edge', 2};
Elem.Nodal_Var(10).Data = {[1/4, 0, 3/4, 0], 'eval_edge', 2};
Elem.Nodal_Var(11).Data = {[3/4, 0, 0, 1/4], 'eval_edge', 3};
Elem.Nodal_Var(12).Data = {[1/2, 0, 0, 1/2], 'eval_edge', 3};
Elem.Nodal_Var(13).Data = {[1/4, 0, 0, 3/4], 'eval_edge', 3};
Elem.Nodal_Var(14).Data = {[0, 3/4, 1/4, 0], 'eval_edge', 4};
Elem.Nodal_Var(15).Data = {[0, 1/2, 1/2, 0], 'eval_edge', 4};
Elem.Nodal_Var(16).Data = {[0, 1/4, 3/4, 0], 'eval_edge', 4};
Elem.Nodal_Var(17).Data = {[0, 0, 3/4, 1/4], 'eval_edge', 5};
Elem.Nodal_Var(18).Data = {[0, 0, 1/2, 1/2], 'eval_edge', 5};
Elem.Nodal_Var(19).Data = {[0, 0, 1/4, 3/4], 'eval_edge', 5};
Elem.Nodal_Var(20).Data = {[0, 1/4, 0, 3/4], 'eval_edge', 6};
Elem.Nodal_Var(21).Data = {[0, 1/2, 0, 1/2], 'eval_edge', 6};
Elem.Nodal_Var(22).Data = {[0, 3/4, 0, 1/4], 'eval_edge', 6};
Elem.Nodal_Var(23).Data = {[0, 1/2, 1/4, 1/4], 'eval_facet', 1};
Elem.Nodal_Var(24).Data = {[0, 1/4, 1/2, 1/4], 'eval_facet', 1};
Elem.Nodal_Var(25).Data = {[0, 1/4, 1/4, 1/2], 'eval_facet', 1};
Elem.Nodal_Var(26).Data = {[1/2, 0, 1/4, 1/4], 'eval_facet', 2};
Elem.Nodal_Var(27).Data = {[1/4, 0, 1/4, 1/2], 'eval_facet', 2};
Elem.Nodal_Var(28).Data = {[1/4, 0, 1/2, 1/4], 'eval_facet', 2};
Elem.Nodal_Var(29).Data = {[1/2, 1/4, 0, 1/4], 'eval_facet', 3};
Elem.Nodal_Var(30).Data = {[1/4, 1/2, 0, 1/4], 'eval_facet', 3};
Elem.Nodal_Var(31).Data = {[1/4, 1/4, 0, 1/2], 'eval_facet', 3};
Elem.Nodal_Var(32).Data = {[1/2, 1/4, 1/4, 0], 'eval_facet', 4};
Elem.Nodal_Var(33).Data = {[1/4, 1/4, 1/2, 0], 'eval_facet', 4};
Elem.Nodal_Var(34).Data = {[1/4, 1/2, 1/4, 0], 'eval_facet', 4};
Elem.Nodal_Var(35).Data = {[1/4, 1/4, 1/4, 1/4], 'eval_cell', 1};

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
                   [5, 6, 7;
                    8, 9, 10;
                    11, 12, 13;
                    14, 15, 16;
                    17, 18, 19;
                    20, 21, 22]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [23, 24, 25;
                    26, 27, 28;
                    29, 30, 31;
                    32, 33, 34]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {...
                   [35]...
                   };
%

end