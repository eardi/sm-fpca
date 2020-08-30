function Elem = raviart_thomas_deg0_dim3(Type_STR)
%raviart_thomas_deg0_dim3
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Raviart-Thomas H(div) Finite Element of degree = 0, in dimension = 3.
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
Elem.Basis(4).Func = []; % init
Elem.Basis(1).Func = {'2*x'; '2*y'; '2*z'};
Elem.Basis(2).Func = {'2*x - 2'; '2*y'; '2*z'};
Elem.Basis(3).Func = {'2*x'; '2*y - 2'; '2*z'};
Elem.Basis(4).Func = {'2*x'; '2*y'; '2*z - 2'};
% local mapping transformation to use
Elem.Transformation = 'Hdiv_Trans';
Elem.Degree = 0;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(4).Data = []; % init
Elem.Nodal_Var(1).Data = {[0, 1/3, 1/3, 1/3], '[1]', 'int_facet', 1};
Elem.Nodal_Var(2).Data = {[1/3, 0, 1/3, 1/3], '[1]', 'int_facet', 2};
Elem.Nodal_Var(3).Data = {[1/3, 1/3, 0, 1/3], '[1]', 'int_facet', 3};
Elem.Nodal_Var(4).Data = {[1/3, 1/3, 1/3, 0], '[1]', 'int_facet', 4};

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
                   [1;
                    2;
                    3;
                    4]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end