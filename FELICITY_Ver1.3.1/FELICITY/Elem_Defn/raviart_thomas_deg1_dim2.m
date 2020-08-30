function Elem = raviart_thomas_deg1_dim2(Type_STR)
%raviart_thomas_deg1_dim2
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Raviart-Thomas H(div) Finite Element of degree = 1, in dimension = 2.
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
Elem.Basis(8).Func = []; % init
Elem.Basis(1).Func = {'4*x*(2*x - 1)'; '2*y*(4*x - 1)'};
Elem.Basis(2).Func = {'2*x*(4*y - 1)'; '4*y*(2*y - 1)'};
Elem.Basis(3).Func = {'8*x*y - 6*y - 2*x + 2'; '4*y*(2*y - 1)'};
Elem.Basis(4).Func = {'12*x + 6*y - 8*x*y - 8*x^2 - 4'; '-2*y*(4*x + 4*y - 3)'};
Elem.Basis(5).Func = {'-2*x*(4*x + 4*y - 3)'; '6*x + 12*y - 8*x*y - 8*y^2 - 4'};
Elem.Basis(6).Func = {'4*x*(2*x - 1)'; '8*x*y - 2*y - 6*x + 2'};
Elem.Basis(7).Func = {'-8*x*(2*x + y - 2)'; '-8*y*(2*x + y - 1)'};
Elem.Basis(8).Func = {'-8*x*(x + 2*y - 1)'; '-8*y*(x + 2*y - 2)'};
% local mapping transformation to use
Elem.Transformation = 'Hdiv_Trans';
Elem.Degree = 1;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(8).Data = []; % init
Elem.Nodal_Var(1).Data = {[0, 1, 0], '[1 - y]', 'int_facet', 1};
Elem.Nodal_Var(2).Data = {[0, 0, 1], '[y]', 'int_facet', 1};
Elem.Nodal_Var(3).Data = {[0, 0, 1], '[y]', 'int_facet', 2};
Elem.Nodal_Var(4).Data = {[1, 0, 0], '[1 - y]', 'int_facet', 2};
Elem.Nodal_Var(5).Data = {[1, 0, 0], '[1 - x]', 'int_facet', 3};
Elem.Nodal_Var(6).Data = {[0, 1, 0], '[x]', 'int_facet', 3};
Elem.Nodal_Var(7).Data = {[1/3, 1/3, 1/3], '[1; 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(8).Data = {[1/3, 1/3, 1/3], '[0; 1]', 'int_cell', 1, 'dof_set', 2};

%%%%% topological arrangement of nodal points %%%%%
% note: multiple sets of nodal variables can be associated with each topological entity.
%       This is done by defining multiple matrix arrays within each matlab cell.
%       See the FELICITY manual for more info.

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to edges
Elem.Nodal_Top.E = {...
                   [1, 2;
                    3, 4;
                    5, 6]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [7],...
                   [8]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end