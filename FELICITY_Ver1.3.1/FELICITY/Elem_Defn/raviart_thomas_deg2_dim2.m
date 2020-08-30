function Elem = raviart_thomas_deg2_dim2(Type_STR)
%raviart_thomas_deg2_dim2
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Raviart-Thomas H(div) Finite Element of degree = 2, in dimension = 2.
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
Elem.Basis(15).Func = []; % init
Elem.Basis(1).Func = {'9*x*(5*x^2 - 5*x + 1)'; '3*y*(15*x^2 - 10*x + 1)'};
Elem.Basis(2).Func = {'3*x*(15*y^2 - 10*y + 1)'; '9*y*(5*y^2 - 5*y + 1)'};
Elem.Basis(3).Func = {'(3*x*(60*x*y - 30*y - 25*x + 15*x^2 + 15*y^2 + 8))/4'; '(3*y*(60*x*y - 25*y - 30*x + 15*x^2 + 15*y^2 + 8))/4'};
Elem.Basis(4).Func = {'3*x + 24*y - 30*x*y + 45*x*y^2 - 30*y^2 - 3'; '9*y*(5*y^2 - 5*y + 1)'};
Elem.Basis(5).Func = {'54*x + 36*y - 120*x*y + 45*x*y^2 + 90*x^2*y - 90*x^2 + 45*x^3 - 30*y^2 - 9'; '3*y*(30*x*y - 20*y - 20*x + 15*x^2 + 15*y^2 + 6)'};
Elem.Basis(6).Func = {'(9*x)/4 - 15*y + (75*x*y)/2 - (45*x*y^2)/2 - (45*x^2*y)/2 - 15*x^2 + (45*x^3)/4 + 15*y^2 + 3/2'; '-(3*y*(30*x*y - 35*y - 15*x^2 + 30*y^2 + 7))/4'};
Elem.Basis(7).Func = {'3*x*(30*x*y - 20*y - 20*x + 15*x^2 + 15*y^2 + 6)'; '36*x + 54*y - 120*x*y + 90*x*y^2 + 45*x^2*y - 30*x^2 - 90*y^2 + 45*y^3 - 9'};
Elem.Basis(8).Func = {'9*x*(5*x^2 - 5*x + 1)'; '24*x + 3*y - 30*x*y + 45*x^2*y - 30*x^2 - 3'};
Elem.Basis(9).Func = {'-(3*x*(30*x*y - 35*x + 30*x^2 - 15*y^2 + 7))/4'; '(9*y)/4 - 15*x + (75*x*y)/2 - (45*x*y^2)/2 - (45*x^2*y)/2 + 15*x^2 - 15*y^2 + (45*y^3)/4 + 3/2'};
Elem.Basis(10).Func = {'30*x*(12*x*y - 10*y - 15*x + 9*x^2 + 3*y^2 + 6)'; '30*y*(12*x*y - 5*y - 10*x + 9*x^2 + 3*y^2 + 2)'};
Elem.Basis(11).Func = {'-30*x*(3*x - 1)*(3*x + 2*y - 3)'; '-30*y*(6*x*y - y - 8*x + 9*x^2 + 1)'};
Elem.Basis(12).Func = {'-60*x*(6*x*y - 6*y - x + 3*y^2 + 1)'; '-60*y*(3*y - 1)*(2*x + y - 1)'};
Elem.Basis(13).Func = {'30*x*(12*x*y - 10*y - 5*x + 3*x^2 + 9*y^2 + 2)'; '30*y*(12*x*y - 15*y - 10*x + 3*x^2 + 9*y^2 + 6)'};
Elem.Basis(14).Func = {'-60*x*(3*x - 1)*(x + 2*y - 1)'; '-60*y*(6*x*y - y - 6*x + 3*x^2 + 1)'};
Elem.Basis(15).Func = {'-30*x*(6*x*y - 8*y - x + 9*y^2 + 1)'; '-30*y*(3*y - 1)*(2*x + 3*y - 3)'};
% local mapping transformation to use
Elem.Transformation = 'Hdiv_Trans';
Elem.Degree = 2;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(15).Data = []; % init
Elem.Nodal_Var(1).Data = {[0, 1, 0], '[2*y^2 - 3*y + 1]', 'int_facet', 1};
Elem.Nodal_Var(2).Data = {[0, 0, 1], '[y*(2*y - 1)]', 'int_facet', 1};
Elem.Nodal_Var(3).Data = {[0, 1/2, 1/2], '[-4*y*(y - 1)]', 'int_facet', 1};
Elem.Nodal_Var(4).Data = {[0, 0, 1], '[3*y + 2*(y - 1)^2 - 2]', 'int_facet', 2};
Elem.Nodal_Var(5).Data = {[1, 0, 0], '[(2*y - 1)*(y - 1)]', 'int_facet', 2};
Elem.Nodal_Var(6).Data = {[1/2, 0, 1/2], '[-4*y*(y - 1)]', 'int_facet', 2};
Elem.Nodal_Var(7).Data = {[1, 0, 0], '[2*x^2 - 3*x + 1]', 'int_facet', 3};
Elem.Nodal_Var(8).Data = {[0, 1, 0], '[x*(2*x - 1)]', 'int_facet', 3};
Elem.Nodal_Var(9).Data = {[1/2, 1/2, 0], '[-4*x*(x - 1)]', 'int_facet', 3};
Elem.Nodal_Var(10).Data = {[1, 0, 0], '[1 - y - x; 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(11).Data = {[0, 1, 0], '[x; 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(12).Data = {[0, 0, 1], '[y; 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(13).Data = {[1, 0, 0], '[0; 1 - y - x]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(14).Data = {[0, 1, 0], '[0; x]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(15).Data = {[0, 0, 1], '[0; y]', 'int_cell', 1, 'dof_set', 2};

%%%%% topological arrangement of nodal points %%%%%
% note: multiple sets of nodal variables can be associated with each topological entity.
%       This is done by defining multiple matrix arrays within each matlab cell.
%       See the FELICITY manual for more info.

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to edges
Elem.Nodal_Top.E = {...
                   [1, 2, 3;
                    4, 5, 6;
                    7, 8, 9]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [10, 11, 12],...
                   [13, 14, 15]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end