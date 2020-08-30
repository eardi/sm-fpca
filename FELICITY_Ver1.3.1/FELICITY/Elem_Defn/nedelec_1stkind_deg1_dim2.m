function Elem = nedelec_1stkind_deg1_dim2(Type_STR)
%nedelec_1stkind_deg1_dim2
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Nedelec (1st-kind) H(curl) Finite Element of degree = 1, in dimension = 2.
%
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
%    The basis functions associated with Degrees-of-Freedom (DoFs) on an edge
%    have an orientation dictated by the edge's orientation.
%    The orientation of an edge is defined to point from the vertex of
%    lower index toward the vertex of higher index.  In other words, given an
%    edge [V_i, V_j], where i < j, the tangent vector points from V_i toward V_j.
%
%    The basis functions associated with Degrees-of-Freedom (DoFs) on a facet (in 3-D)
%    have an orientation dictated by the tangent vectors of the facet.
%    In this case, we use the Paul Wesson trick.  Given a facet, we order its
%    vertices [V_i, V_j, V_k] so that i < j < k.  Then the tangent vectors are:
%    tangent_1 = V_j - V_i,  tangent_2 = V_k - V_i.
%
%    For simplicity, the basis functions specified in this file assume the
%    global vertices of the 2-D element [V_1, V_2, V_3] are ordered as:
%    V1 < V2 < V3  (ascending order)
%
%    Thus, one needs to introduce sign changes of the basis functions when mapping to
%    the *actual* element in the mesh.  This is because the actual element will
%    not (in general) have its vertices ordered in ascending index order.
%    Note: a different ordering induces a sign change of the edge tangent vectors,
%    so you only need to flip signs of associated basis functions.
%
%    FELICITY handles these sign changes automatically when assembling matrices,
%    evaluating interpolations, etc.  So you do not have to "worry" about it,
%    but you should *know* about it.

% Copyright (c) 11-Nov-2016,  Shawn W. Walker

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
Elem.Basis(1).Func = {'-y'; 'x'};
Elem.Basis(2).Func = {'y'; '1 - x'};
Elem.Basis(3).Func = {'1 - y'; 'x'};
% local mapping transformation to use
Elem.Transformation = 'Hcurl_Trans';
Elem.Degree = 1;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(3).Data = []; % init
Elem.Nodal_Var(1).Data = {[0, 1/2, 1/2], '[-2^(1/2)/2; 2^(1/2)/2]', 'int_edge', 1};
Elem.Nodal_Var(2).Data = {[1/2, 0, 1/2], '[0; 1]', 'int_edge', 2};
Elem.Nodal_Var(3).Data = {[1/2, 1/2, 0], '[1; 0]', 'int_edge', 3};

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