function Elem = lagrange_deg6_dim2(Type_STR)
%lagrange_deg6_dim2
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Lagrange H^1 Finite Element of degree = 6, in dimension = 2.
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
Elem.Dim = 2;
Elem.Domain = 'triangle';

% nodal basis function definitions (in the order of their local Degree-of-Freedom index)
Elem.Basis(28).Func = []; % init
Elem.Basis(1).Func = {'1890*x^2*y^2 - (147*y)/10 - (147*x)/10 - 2268*x^2*y^3 - 2268*x^3*y^2 + 972*x^2*y^4 + 1296*x^3*y^3 + 972*x^4*y^2 + (812*x*y)/5 - (1323*x*y^2)/2 - (1323*x^2*y)/2 + 1260*x*y^3 + 1260*x^3*y - 1134*x*y^4 - 1134*x^4*y + (1944*x*y^5)/5 + (1944*x^5*y)/5 + (406*x^2)/5 - (441*x^3)/2 + 315*x^4 - (1134*x^5)/5 + (324*x^6)/5 + (406*y^2)/5 - (441*y^3)/2 + 315*y^4 - (1134*y^5)/5 + (324*y^6)/5 + 1'};
Elem.Basis(2).Func = {'(x*(137*x - 675*x^2 + 1530*x^3 - 1620*x^4 + 648*x^5 - 10))/10'};
Elem.Basis(3).Func = {'(y*(137*y - 675*y^2 + 1530*y^3 - 1620*y^4 + 648*y^5 - 10))/10'};
Elem.Basis(4).Func = {'(18*x*y*(105*x^2 - 25*x - 180*x^3 + 108*x^4 + 2))/5'};
Elem.Basis(5).Func = {'(9*x*y*(6*y - 1)*(11*x - 36*x^2 + 36*x^3 - 1))/2'};
Elem.Basis(6).Func = {'4*x*y*(18*x^2 - 9*x + 1)*(18*y^2 - 9*y + 1)'};
Elem.Basis(7).Func = {'(9*x*y*(6*x - 1)*(11*y - 36*y^2 + 36*y^3 - 1))/2'};
Elem.Basis(8).Func = {'(18*x*y*(105*y^2 - 25*y - 180*y^3 + 108*y^4 + 2))/5'};
Elem.Basis(9).Func = {'-(18*y*(x + y - 1)*(105*y^2 - 25*y - 180*y^3 + 108*y^4 + 2))/5'};
Elem.Basis(10).Func = {'(9*y*(11*y - 36*y^2 + 36*y^3 - 1)*(12*x*y - 11*y - 11*x + 6*x^2 + 6*y^2 + 5))/2'};
Elem.Basis(11).Func = {'-4*y*(18*y^2 - 9*y + 1)*(37*x + 37*y - 90*x*y + 54*x*y^2 + 54*x^2*y - 45*x^2 + 18*x^3 - 45*y^2 + 18*y^3 - 10)'};
Elem.Basis(12).Func = {'(9*y*(6*y - 1)*(216*x^2*y^2 - 57*y - 57*x + 238*x*y - 324*x*y^2 - 324*x^2*y + 144*x*y^3 + 144*x^3*y + 119*x^2 - 108*x^3 + 36*x^4 + 119*y^2 - 108*y^3 + 36*y^4 + 10))/2'};
Elem.Basis(13).Func = {'-(18*y*(87*x + 87*y - 2160*x^2*y^2 + 1080*x^2*y^3 + 1080*x^3*y^2 - 580*x*y + 1395*x*y^2 + 1395*x^2*y - 1440*x*y^3 - 1440*x^3*y + 540*x*y^4 + 540*x^4*y - 290*x^2 + 465*x^3 - 360*x^4 + 108*x^5 - 290*y^2 + 465*y^3 - 360*y^4 + 108*y^5 - 10))/5'};
Elem.Basis(14).Func = {'-(18*x*(87*x + 87*y - 2160*x^2*y^2 + 1080*x^2*y^3 + 1080*x^3*y^2 - 580*x*y + 1395*x*y^2 + 1395*x^2*y - 1440*x*y^3 - 1440*x^3*y + 540*x*y^4 + 540*x^4*y - 290*x^2 + 465*x^3 - 360*x^4 + 108*x^5 - 290*y^2 + 465*y^3 - 360*y^4 + 108*y^5 - 10))/5'};
Elem.Basis(15).Func = {'(9*x*(6*x - 1)*(216*x^2*y^2 - 57*y - 57*x + 238*x*y - 324*x*y^2 - 324*x^2*y + 144*x*y^3 + 144*x^3*y + 119*x^2 - 108*x^3 + 36*x^4 + 119*y^2 - 108*y^3 + 36*y^4 + 10))/2'};
Elem.Basis(16).Func = {'-4*x*(18*x^2 - 9*x + 1)*(37*x + 37*y - 90*x*y + 54*x*y^2 + 54*x^2*y - 45*x^2 + 18*x^3 - 45*y^2 + 18*y^3 - 10)'};
Elem.Basis(17).Func = {'(9*x*(11*x - 36*x^2 + 36*x^3 - 1)*(12*x*y - 11*y - 11*x + 6*x^2 + 6*y^2 + 5))/2'};
Elem.Basis(18).Func = {'-(18*x*(x + y - 1)*(105*x^2 - 25*x - 180*x^3 + 108*x^4 + 2))/5'};
Elem.Basis(19).Func = {'-36*x*y*(6*y - 1)*(x + y - 1)*(18*x^2 - 9*x + 1)'};
Elem.Basis(20).Func = {'-36*x*y*(6*x - 1)*(x + y - 1)*(18*y^2 - 9*y + 1)'};
Elem.Basis(21).Func = {'54*x*y*(216*x^2*y^2 - 57*y - 57*x + 238*x*y - 324*x*y^2 - 324*x^2*y + 144*x*y^3 + 144*x^3*y + 119*x^2 - 108*x^3 + 36*x^4 + 119*y^2 - 108*y^3 + 36*y^4 + 10)'};
Elem.Basis(22).Func = {'36*x*y*(18*y^2 - 9*y + 1)*(12*x*y - 11*y - 11*x + 6*x^2 + 6*y^2 + 5)'};
Elem.Basis(23).Func = {'-36*x*y*(6*y - 1)*(37*x + 37*y - 90*x*y + 54*x*y^2 + 54*x^2*y - 45*x^2 + 18*x^3 - 45*y^2 + 18*y^3 - 10)'};
Elem.Basis(24).Func = {'-54*x*y*(x + y - 1)*(11*x - 36*x^2 + 36*x^3 - 1)'};
Elem.Basis(25).Func = {'-36*x*y*(6*x - 1)*(37*x + 37*y - 90*x*y + 54*x*y^2 + 54*x^2*y - 45*x^2 + 18*x^3 - 45*y^2 + 18*y^3 - 10)'};
Elem.Basis(26).Func = {'36*x*y*(18*x^2 - 9*x + 1)*(12*x*y - 11*y - 11*x + 6*x^2 + 6*y^2 + 5)'};
Elem.Basis(27).Func = {'-54*x*y*(x + y - 1)*(11*y - 36*y^2 + 36*y^3 - 1)'};
Elem.Basis(28).Func = {'27*x*y*(6*x - 1)*(6*y - 1)*(12*x*y - 11*y - 11*x + 6*x^2 + 6*y^2 + 5)'};
% local mapping transformation to use
Elem.Transformation = 'H1_Trans';
Elem.Degree = 6;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(28).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1, 0], 'eval_vertex', 2};
Elem.Nodal_Var(3).Data = {[0, 0, 1], 'eval_vertex', 3};
Elem.Nodal_Var(4).Data = {[0, 5/6, 1/6], 'eval_facet', 1};
Elem.Nodal_Var(5).Data = {[0, 2/3, 1/3], 'eval_facet', 1};
Elem.Nodal_Var(6).Data = {[0, 1/2, 1/2], 'eval_facet', 1};
Elem.Nodal_Var(7).Data = {[0, 1/3, 2/3], 'eval_facet', 1};
Elem.Nodal_Var(8).Data = {[0, 1/6, 5/6], 'eval_facet', 1};
Elem.Nodal_Var(9).Data = {[1/6, 0, 5/6], 'eval_facet', 2};
Elem.Nodal_Var(10).Data = {[1/3, 0, 2/3], 'eval_facet', 2};
Elem.Nodal_Var(11).Data = {[1/2, 0, 1/2], 'eval_facet', 2};
Elem.Nodal_Var(12).Data = {[2/3, 0, 1/3], 'eval_facet', 2};
Elem.Nodal_Var(13).Data = {[5/6, 0, 1/6], 'eval_facet', 2};
Elem.Nodal_Var(14).Data = {[5/6, 1/6, 0], 'eval_facet', 3};
Elem.Nodal_Var(15).Data = {[2/3, 1/3, 0], 'eval_facet', 3};
Elem.Nodal_Var(16).Data = {[1/2, 1/2, 0], 'eval_facet', 3};
Elem.Nodal_Var(17).Data = {[1/3, 2/3, 0], 'eval_facet', 3};
Elem.Nodal_Var(18).Data = {[1/6, 5/6, 0], 'eval_facet', 3};
Elem.Nodal_Var(19).Data = {[1/6, 1/2, 1/3], 'eval_cell', 1};
Elem.Nodal_Var(20).Data = {[1/6, 1/3, 1/2], 'eval_cell', 1};
Elem.Nodal_Var(21).Data = {[2/3, 1/6, 1/6], 'eval_cell', 1};
Elem.Nodal_Var(22).Data = {[1/3, 1/6, 1/2], 'eval_cell', 1};
Elem.Nodal_Var(23).Data = {[1/2, 1/6, 1/3], 'eval_cell', 1};
Elem.Nodal_Var(24).Data = {[1/6, 2/3, 1/6], 'eval_cell', 1};
Elem.Nodal_Var(25).Data = {[1/2, 1/3, 1/6], 'eval_cell', 1};
Elem.Nodal_Var(26).Data = {[1/3, 1/2, 1/6], 'eval_cell', 1};
Elem.Nodal_Var(27).Data = {[1/6, 1/6, 2/3], 'eval_cell', 1};
Elem.Nodal_Var(28).Data = {[1/3, 1/3, 1/3], 'eval_cell', 1};

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
                   [4, 5, 6, 7, 8;
                    9, 10, 11, 12, 13;
                    14, 15, 16, 17, 18]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [19, 20, 21, 22, 23, 24, 25, 26, 27, 28]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end