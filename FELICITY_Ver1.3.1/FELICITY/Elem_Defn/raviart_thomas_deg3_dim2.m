function Elem = raviart_thomas_deg3_dim2(Type_STR)
%raviart_thomas_deg3_dim2
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Raviart-Thomas H(div) Finite Element of degree = 3, in dimension = 2.
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
%
%    The basis functions are vector-valued (number of components = topological dimension).
%
%    The basis functions associated with Degrees-of-Freedom (DoFs) on a facet
%    have an orientation dictated by the facet's orientation.
%
%    For simplicity, the basis functions specified in this file assume a
%    fixed orientation on the reference element, which is that all facets
%    are oriented with the normal vector pointing *OUT* of the reference
%    element.
%
%    Thus, one needs to introduce appropriate +/- sign changes when mapping
%    these basis functions to the *actual* element in the mesh.  This is
%    handled by the "guts" of FELICITY to auto-generate code to take care of
%    these sign changes (e.g. when assembling matrices, interpolation, etc.).
%    Note: only sign changes are made; there is no permuting of DoFs.

% Copyright (c) 12-Oct-2016,  Shawn W. Walker

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
Elem.Basis(24).Func = []; % init
Elem.Basis(1).Func = {'16*x*(9*x - 21*x^2 + 14*x^3 - 1)'; '4*y*(18*x - 63*x^2 + 56*x^3 - 1)'};
Elem.Basis(2).Func = {'4*x*(18*y - 63*y^2 + 56*y^3 - 1)'; '16*y*(9*y - 21*y^2 + 14*y^3 - 1)'};
Elem.Basis(3).Func = {'(4*x*(540*x + 378*y - 2016*x*y + 1008*x*y^2 + 2016*x^2*y - 924*x^2 + 448*x^3 - 315*y^2 + 56*y^3 - 81))/27'; '(8*y*(270*x + 108*y - 882*x*y + 504*x*y^2 + 1008*x^2*y - 504*x^2 + 224*x^3 - 105*y^2 + 28*y^3 - 27))/27'};
Elem.Basis(4).Func = {'(8*x*(108*x + 270*y - 882*x*y + 1008*x*y^2 + 504*x^2*y - 105*x^2 + 28*x^3 - 504*y^2 + 224*y^3 - 27))/27'; '(4*y*(378*x + 540*y - 2016*x*y + 2016*x*y^2 + 1008*x^2*y - 315*x^2 + 56*x^3 - 924*y^2 + 448*y^3 - 81))/27'};
Elem.Basis(5).Func = {'72*x*y - 60*y - 4*x - 252*x*y^2 + 224*x*y^3 + 180*y^2 - 140*y^3 + 4'; '16*y*(9*y - 21*y^2 + 14*y^3 - 1)'};
Elem.Basis(6).Func = {'160*x + 120*y - 672*x^2*y^2 - 720*x*y + 840*x*y^2 + 1260*x^2*y - 224*x*y^3 - 672*x^3*y - 480*x^2 + 560*x^3 - 224*x^4 - 240*y^2 + 140*y^3 - 16'; '-4*y*(60*x + 60*y - 210*x*y + 168*x*y^2 + 168*x^2*y - 105*x^2 + 56*x^3 - 105*y^2 + 56*y^3 - 10)'};
Elem.Basis(7).Func = {'(200*y)/9 - (112*x)/27 - (224*x^2*y^2)/9 + 16*x*y + (1120*x*y^2)/9 - (476*x^2*y)/3 - (2464*x*y^3)/27 + (1120*x^3*y)/9 + (104*x^2)/9 + (56*x^3)/27 - (224*x^4)/27 - (680*y^2)/9 + (1540*y^3)/27 - 32/27'; '-(4*y*(384*y - 84*x + 294*x*y + 168*x*y^2 - 840*x^2*y + 147*x^2 + 56*x^3 - 945*y^2 + 616*y^3 - 38))/27'};
Elem.Basis(8).Func = {'(76*x)/27 - (380*y)/9 + (2240*x^2*y^2)/9 + 200*x*y - (2884*x*y^2)/9 - (784*x^2*y)/3 + (2464*x*y^3)/27 + (896*x^3*y)/9 - (608*x^2)/9 + (3472*x^3)/27 - (1792*x^4)/27 + (860*y^2)/9 - (1540*y^3)/27 + 68/27'; '(8*y*(66*x + 300*y - 798*x*y + 840*x*y^2 + 336*x^2*y + 168*x^2 - 224*x^3 - 567*y^2 + 308*y^3 - 37))/27'};
Elem.Basis(9).Func = {'-4*x*(60*x + 60*y - 210*x*y + 168*x*y^2 + 168*x^2*y - 105*x^2 + 56*x^3 - 105*y^2 + 56*y^3 - 10)'; '120*x + 160*y - 672*x^2*y^2 - 720*x*y + 1260*x*y^2 + 840*x^2*y - 672*x*y^3 - 224*x^3*y - 240*x^2 + 140*x^3 - 480*y^2 + 560*y^3 - 224*y^4 - 16'};
Elem.Basis(10).Func = {'16*x*(9*x - 21*x^2 + 14*x^3 - 1)'; '72*x*y - 4*y - 60*x - 252*x^2*y + 224*x^3*y + 180*x^2 - 140*x^3 + 4'};
Elem.Basis(11).Func = {'(8*x*(300*x + 66*y - 798*x*y + 336*x*y^2 + 840*x^2*y - 567*x^2 + 308*x^3 + 168*y^2 - 224*y^3 - 37))/27'; '(76*y)/27 - (380*x)/9 + (2240*x^2*y^2)/9 + 200*x*y - (784*x*y^2)/3 - (2884*x^2*y)/9 + (896*x*y^3)/9 + (2464*x^3*y)/27 + (860*x^2)/9 - (1540*x^3)/27 - (608*y^2)/9 + (3472*y^3)/27 - (1792*y^4)/27 + 68/27'};
Elem.Basis(12).Func = {'-(4*x*(384*x - 84*y + 294*x*y - 840*x*y^2 + 168*x^2*y - 945*x^2 + 616*x^3 + 147*y^2 + 56*y^3 - 38))/27'; '(200*x)/9 - (112*y)/27 - (224*x^2*y^2)/9 + 16*x*y - (476*x*y^2)/3 + (1120*x^2*y)/9 + (1120*x*y^3)/9 - (2464*x^3*y)/27 - (680*x^2)/9 + (1540*x^3)/27 + (104*y^2)/9 + (56*y^3)/27 - (224*y^4)/27 - 32/27'};
Elem.Basis(13).Func = {'-24*x*(180*x + 135*y - 378*x*y + 168*x*y^2 + 252*x^2*y - 252*x^2 + 112*x^3 - 126*y^2 + 28*y^3 - 40)'; '-24*y*(90*x + 45*y - 252*x*y + 168*x*y^2 + 252*x^2*y - 189*x^2 + 112*x^3 - 63*y^2 + 28*y^3 - 10)'};
Elem.Basis(14).Func = {'-24*x*(4*x + 3*y - 4)*(28*x^2 - 21*x + 3)'; '-24*y*(48*x + 3*y - 42*x*y + 84*x^2*y - 147*x^2 + 112*x^3 - 3)'};
Elem.Basis(15).Func = {'-72*x*(2*x + 27*y - 28*x*y + 56*x*y^2 - 63*y^2 + 28*y^3 - 2)'; '-72*y*(28*y^2 - 21*y + 3)*(2*x + y - 1)'};
Elem.Basis(16).Func = {'-6*x*(183*x + 222*y - 798*x*y + 504*x*y^2 + 588*x^2*y - 259*x^2 + 112*x^3 - 273*y^2 + 84*y^3 - 36)'; '-6*y*(174*x + 129*y - 672*x*y + 504*x*y^2 + 588*x^2*y - 273*x^2 + 112*x^3 - 189*y^2 + 84*y^3 - 24)'};
Elem.Basis(17).Func = {'6*x*(198*y - 78*x - 462*x*y + 336*x*y^2 + 252*x^2*y + 189*x^2 - 112*x^3 - 252*y^2 + 56*y^3 + 1)'; '6*y*(36*x + 81*y - 378*x*y + 336*x*y^2 + 252*x^2*y + 63*x^2 - 112*x^3 - 126*y^2 + 56*y^3 - 11)'};
Elem.Basis(18).Func = {'-12*x*(18*y - 60*x + 63*x*y - 84*x^2*y + 112*x^2 - 56*x^3 - 42*y^2 + 14*y^3 + 4)'; '-12*y*(6*y - 30*x + 42*x*y - 84*x^2*y + 84*x^2 - 56*x^3 - 21*y^2 + 14*y^3 + 1)'};
Elem.Basis(19).Func = {'-24*x*(45*x + 90*y - 252*x*y + 252*x*y^2 + 168*x^2*y - 63*x^2 + 28*x^3 - 189*y^2 + 112*y^3 - 10)'; '-24*y*(135*x + 180*y - 378*x*y + 252*x*y^2 + 168*x^2*y - 126*x^2 + 28*x^3 - 252*y^2 + 112*y^3 - 40)'};
Elem.Basis(20).Func = {'-72*x*(28*x^2 - 21*x + 3)*(x + 2*y - 1)'; '-72*y*(27*x + 2*y - 28*x*y + 56*x^2*y - 63*x^2 + 28*x^3 - 2)'};
Elem.Basis(21).Func = {'-24*x*(3*x + 48*y - 42*x*y + 84*x*y^2 - 147*y^2 + 112*y^3 - 3)'; '-24*y*(3*x + 4*y - 4)*(28*y^2 - 21*y + 3)'};
Elem.Basis(22).Func = {'-6*x*(129*x + 174*y - 672*x*y + 588*x*y^2 + 504*x^2*y - 189*x^2 + 84*x^3 - 273*y^2 + 112*y^3 - 24)'; '-6*y*(222*x + 183*y - 798*x*y + 588*x*y^2 + 504*x^2*y - 273*x^2 + 84*x^3 - 259*y^2 + 112*y^3 - 36)'};
Elem.Basis(23).Func = {'-12*x*(6*x - 30*y + 42*x*y - 84*x*y^2 - 21*x^2 + 14*x^3 + 84*y^2 - 56*y^3 + 1)'; '-12*y*(18*x - 60*y + 63*x*y - 84*x*y^2 - 42*x^2 + 14*x^3 + 112*y^2 - 56*y^3 + 4)'};
Elem.Basis(24).Func = {'6*x*(81*x + 36*y - 378*x*y + 252*x*y^2 + 336*x^2*y - 126*x^2 + 56*x^3 + 63*y^2 - 112*y^3 - 11)'; '6*y*(198*x - 78*y - 462*x*y + 252*x*y^2 + 336*x^2*y - 252*x^2 + 56*x^3 + 189*y^2 - 112*y^3 + 1)'};
% local mapping transformation to use
Elem.Transformation = 'Hdiv_Trans';
Elem.Degree = 3;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(24).Data = []; % init
Elem.Nodal_Var(1).Data = {[0, 1, 0], '[9*y^2 - (11*y)/2 - (9*y^3)/2 + 1]', 'int_facet', 1};
Elem.Nodal_Var(2).Data = {[0, 0, 1], '[(y*(9*y^2 - 9*y + 2))/2]', 'int_facet', 1};
Elem.Nodal_Var(3).Data = {[0, 2/3, 1/3], '[(9*y*(3*y^2 - 5*y + 2))/2]', 'int_facet', 1};
Elem.Nodal_Var(4).Data = {[0, 1/3, 2/3], '[-(9*y*(3*y^2 - 4*y + 1))/2]', 'int_facet', 1};
Elem.Nodal_Var(5).Data = {[0, 0, 1], '[(11*y)/2 + 9*(y - 1)^2 + (9*(y - 1)^3)/2 - 9/2]', 'int_facet', 2};
Elem.Nodal_Var(6).Data = {[1, 0, 0], '[-((y - 1)*(9*y + 9*(y - 1)^2 - 7))/2]', 'int_facet', 2};
Elem.Nodal_Var(7).Data = {[1/3, 0, 2/3], '[-(9*(y - 1)*(5*y + 3*(y - 1)^2 - 3))/2]', 'int_facet', 2};
Elem.Nodal_Var(8).Data = {[2/3, 0, 1/3], '[(9*(y - 1)*(4*y + 3*(y - 1)^2 - 3))/2]', 'int_facet', 2};
Elem.Nodal_Var(9).Data = {[1, 0, 0], '[9*x^2 - (11*x)/2 - (9*x^3)/2 + 1]', 'int_facet', 3};
Elem.Nodal_Var(10).Data = {[0, 1, 0], '[(x*(9*x^2 - 9*x + 2))/2]', 'int_facet', 3};
Elem.Nodal_Var(11).Data = {[2/3, 1/3, 0], '[(9*x*(3*x^2 - 5*x + 2))/2]', 'int_facet', 3};
Elem.Nodal_Var(12).Data = {[1/3, 2/3, 0], '[-(9*x*(3*x^2 - 4*x + 1))/2]', 'int_facet', 3};
Elem.Nodal_Var(13).Data = {[1, 0, 0], '[4*x*y - 3*y - 3*x + 2*x^2 + 2*y^2 + 1; 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(14).Data = {[0, 1, 0], '[x*(2*x - 1); 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(15).Data = {[0, 0, 1], '[y*(2*y - 1); 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(16).Data = {[0, 1/2, 1/2], '[4*x*y; 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(17).Data = {[1/2, 0, 1/2], '[-4*y*(x + y - 1); 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(18).Data = {[1/2, 1/2, 0], '[-4*x*(x + y - 1); 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(19).Data = {[1, 0, 0], '[0; 4*x*y - 3*y - 3*x + 2*x^2 + 2*y^2 + 1]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(20).Data = {[0, 1, 0], '[0; x*(2*x - 1)]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(21).Data = {[0, 0, 1], '[0; y*(2*y - 1)]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(22).Data = {[0, 1/2, 1/2], '[0; 4*x*y]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(23).Data = {[1/2, 0, 1/2], '[0; -4*y*(x + y - 1)]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(24).Data = {[1/2, 1/2, 0], '[0; -4*x*(x + y - 1)]', 'int_cell', 1, 'dof_set', 2};

%%%%% topological arrangement of nodal points %%%%%
% note: multiple sets of nodal variables can be associated with each topological entity.
%       This is done by defining multiple matrix arrays within each matlab cell.
%       See the FELICITY manual for more info.

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to edges
Elem.Nodal_Top.E = {...
                   [1, 2, 3, 4;
                    5, 6, 7, 8;
                    9, 10, 11, 12]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [13, 14, 15, 16, 17, 18],...
                   [19, 20, 21, 22, 23, 24]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end