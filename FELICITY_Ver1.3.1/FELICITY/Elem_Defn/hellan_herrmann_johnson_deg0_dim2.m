function Elem = hellan_herrmann_johnson_deg0_dim2(Type_STR)
%hellan_herrmann_johnson_deg0_dim2
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Hellan-Herrmann-Johnson H(div div) Finite Element of degree = 0, in dimension = 2.
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
%    The basis functions are matrix-valued (size = topological dimension X topological dimension).
%
%    The basis functions associated with Degrees-of-Freedom (DoFs) on a facet
%    are "normal-normal" components of the matrix, so facet orientation is *not* needed.

% Copyright (c) 28-Mar-2018,  Shawn W. Walker

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
Elem.Basis(3).Func = []; % init
Elem.Basis(1).Func = {'0', '1/2'; '1/2', '0'};
Elem.Basis(2).Func = {'1', '-1/2'; '-1/2', '0'};
Elem.Basis(3).Func = {'0', '-1/2'; '-1/2', '1'};
% local mapping transformation to use
Elem.Transformation = 'Hdivdiv_Trans';
Elem.Degree = 0;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(3).Data = []; % init
Elem.Nodal_Var(1).Data = {[0, 1/2, 1/2], '[1]', 'int_facet', 1};
Elem.Nodal_Var(2).Data = {[1/2, 0, 1/2], '[1]', 'int_facet', 2};
Elem.Nodal_Var(3).Data = {[1/2, 1/2, 0], '[1]', 'int_facet', 3};

%%%%% topological arrangement of nodal points %%%%%
% note: multiple sets of nodal variables can be associated with each topological entity.
%       This is done by defining multiple matrix arrays within each matlab cell.
%       See the FELICITY manual for more info.

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to edges
Elem.Nodal_Top.E = {...
                   [1;
                    2;
                    3]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {[]};

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end