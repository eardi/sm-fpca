function Elem = raviart_thomas_deg1_dim3(Type_STR)
%raviart_thomas_deg1_dim3
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Raviart-Thomas H(div) Finite Element of degree = 1, in dimension = 3.
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
Elem.Dim = 3;
Elem.Domain = 'tetrahedron';

% nodal basis function definitions (in the order of their local Degree-of-Freedom index)
Elem.Basis(15).Func = []; % init
Elem.Basis(1).Func = {'6*x*(5*x - 2)'; '6*y*(5*x - 1)'; '6*z*(5*x - 1)'};
Elem.Basis(2).Func = {'6*x*(5*y - 1)'; '6*y*(5*y - 2)'; '6*z*(5*y - 1)'};
Elem.Basis(3).Func = {'6*x*(5*z - 1)'; '6*y*(5*z - 1)'; '6*z*(5*z - 2)'};
Elem.Basis(4).Func = {'48*x + 24*y + 24*z - 30*x*y - 30*x*z - 30*x^2 - 18'; '-6*y*(5*x + 5*y + 5*z - 4)'; '-6*z*(5*x + 5*y + 5*z - 4)'};
Elem.Basis(5).Func = {'30*x*z - 24*z - 6*x + 6'; '6*y*(5*z - 1)'; '6*z*(5*z - 2)'};
Elem.Basis(6).Func = {'30*x*y - 24*y - 6*x + 6'; '6*y*(5*y - 2)'; '6*z*(5*y - 1)'};
Elem.Basis(7).Func = {'-6*x*(5*x + 5*y + 5*z - 4)'; '24*x + 48*y + 24*z - 30*x*y - 30*y*z - 30*y^2 - 18'; '-6*z*(5*x + 5*y + 5*z - 4)'};
Elem.Basis(8).Func = {'6*x*(5*x - 2)'; '30*x*y - 6*y - 24*x + 6'; '6*z*(5*x - 1)'};
Elem.Basis(9).Func = {'6*x*(5*z - 1)'; '30*y*z - 24*z - 6*y + 6'; '6*z*(5*z - 2)'};
Elem.Basis(10).Func = {'-6*x*(5*x + 5*y + 5*z - 4)'; '-6*y*(5*x + 5*y + 5*z - 4)'; '24*x + 24*y + 48*z - 30*x*z - 30*y*z - 30*z^2 - 18'};
Elem.Basis(11).Func = {'6*x*(5*y - 1)'; '6*y*(5*y - 2)'; '30*y*z - 6*z - 24*y + 6'};
Elem.Basis(12).Func = {'6*x*(5*x - 2)'; '6*y*(5*x - 1)'; '30*x*z - 6*z - 24*x + 6'};
Elem.Basis(13).Func = {'-30*x*(2*x + y + z - 2)'; '-30*y*(2*x + y + z - 1)'; '-30*z*(2*x + y + z - 1)'};
Elem.Basis(14).Func = {'-30*x*(x + 2*y + z - 1)'; '-30*y*(x + 2*y + z - 2)'; '-30*z*(x + 2*y + z - 1)'};
Elem.Basis(15).Func = {'-30*x*(x + y + 2*z - 1)'; '-30*y*(x + y + 2*z - 1)'; '-30*z*(x + y + 2*z - 2)'};
% local mapping transformation to use
Elem.Transformation = 'Hdiv_Trans';
Elem.Degree = 1;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(15).Data = []; % init
Elem.Nodal_Var(1).Data = {[0, 1, 0, 0], '[1 - z - y]', 'int_facet', 1};
Elem.Nodal_Var(2).Data = {[0, 0, 1, 0], '[y]', 'int_facet', 1};
Elem.Nodal_Var(3).Data = {[0, 0, 0, 1], '[z]', 'int_facet', 1};
Elem.Nodal_Var(4).Data = {[1, 0, 0, 0], '[1 - z - y]', 'int_facet', 2};
Elem.Nodal_Var(5).Data = {[0, 0, 0, 1], '[z]', 'int_facet', 2};
Elem.Nodal_Var(6).Data = {[0, 0, 1, 0], '[y]', 'int_facet', 2};
Elem.Nodal_Var(7).Data = {[1, 0, 0, 0], '[1 - z - x]', 'int_facet', 3};
Elem.Nodal_Var(8).Data = {[0, 1, 0, 0], '[x]', 'int_facet', 3};
Elem.Nodal_Var(9).Data = {[0, 0, 0, 1], '[z]', 'int_facet', 3};
Elem.Nodal_Var(10).Data = {[1, 0, 0, 0], '[1 - y - x]', 'int_facet', 4};
Elem.Nodal_Var(11).Data = {[0, 0, 1, 0], '[y]', 'int_facet', 4};
Elem.Nodal_Var(12).Data = {[0, 1, 0, 0], '[x]', 'int_facet', 4};
Elem.Nodal_Var(13).Data = {[1/4, 1/4, 1/4, 1/4], '[1; 0; 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(14).Data = {[1/4, 1/4, 1/4, 1/4], '[0; 1; 0]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(15).Data = {[1/4, 1/4, 1/4, 1/4], '[0; 0; 1]', 'int_cell', 1, 'dof_set', 3};

%%%%% topological arrangement of nodal points %%%%%
% note: multiple sets of nodal variables can be associated with each topological entity.
%       This is done by defining multiple matrix arrays within each matlab cell.
%       See the FELICITY manual for more info.

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to edges
Elem.Nodal_Top.E = {[]};

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [1, 2, 3;
                    4, 5, 6;
                    7, 8, 9;
                    10, 11, 12]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {...
                   [13],...
                   [14],...
                   [15]...
                   };
%

end