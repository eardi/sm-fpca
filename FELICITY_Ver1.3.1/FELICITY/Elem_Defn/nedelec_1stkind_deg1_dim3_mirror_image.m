function Elem = nedelec_1stkind_deg1_dim3_mirror_image(Type_STR)
%nedelec_1stkind_deg1_dim3_mirror_image
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Nedelec (1st-kind) H(curl) Finite Element of degree = 1, in dimension = 3.
%
%    This assumes the tetrahedral element [V_1, V_2, V_3, V_4] satisfies:
%    V_1 < V_3 < V_2 < V_4  (mirror image the ascending order case)
%    (see below for more information.)
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
%    global vertices of the 3-D element [V_1, V_2, V_3, V_4] are ordered as:
%    V1 < V3 < V2 < V4  (mirror image the ascending order case)
%
%    Thus, one needs to ensure that the *actual* element vertices are ordered this
%    way when mapping the basis functions.  If the actual element does not have this
%    ordering, then you need to use a different set of basis functions!  For example,
%    if the actual element vertices are defined as [a_i, a_j, a_k, a_l], but the
%    ordering is i < k < l < j, then you must use the correct set of basis functions
%    for that ordering (*not* this file!).
%
%    FELICITY stores two sets of basis functions: one for each of these orderings:
%    V1 < V2 < V3 < V4  (ascending order)
%    V1 < V3 < V2 < V4  (mirror image the ascending order case)
%    Therefore, make sure that your 3-D triangulations contain only these orderings;
%    otherwise, you get an **error** message.
%    Note: there is a MeshTetrahedron method to set this ordering, with all mesh
%          elements having positive volume.
%
%    FELICITY's code generation automatically handles this, so you do not need to
%    "worry" about it, but you should *know* about it.
%    Note: if a mesh element does not satisfy either ordering, then you will get
%          an error message when you assemble matrices or evaluate interpolations.

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
Elem.Dim = 3;
Elem.Domain = 'tetrahedron';

% nodal basis function definitions (in the order of their local Degree-of-Freedom index)
Elem.Basis(6).Func = []; % init
Elem.Basis(1).Func = {'1 - z - y'; 'x'; 'x'};
Elem.Basis(2).Func = {'y'; '1 - z - x'; 'y'};
Elem.Basis(3).Func = {'z'; 'z'; '1 - y - x'};
Elem.Basis(4).Func = {'y'; '-x'; '0'};
Elem.Basis(5).Func = {'0'; '-z'; 'y'};
Elem.Basis(6).Func = {'-z'; '0'; 'x'};
% local mapping transformation to use
Elem.Transformation = 'Hcurl_Trans';
Elem.Degree = 1;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(6).Data = []; % init
Elem.Nodal_Var(1).Data = {[1/2, 1/2, 0, 0], '[1; 0; 0]', 'int_edge', 1};
Elem.Nodal_Var(2).Data = {[1/2, 0, 1/2, 0], '[0; 1; 0]', 'int_edge', 2};
Elem.Nodal_Var(3).Data = {[1/2, 0, 0, 1/2], '[0; 0; 1]', 'int_edge', 3};
Elem.Nodal_Var(4).Data = {[0, 1/2, 1/2, 0], '[2^(1/2)/2; -2^(1/2)/2; 0]', 'int_edge', 4};
Elem.Nodal_Var(5).Data = {[0, 0, 1/2, 1/2], '[0; -2^(1/2)/2; 2^(1/2)/2]', 'int_edge', 5};
Elem.Nodal_Var(6).Data = {[0, 1/2, 0, 1/2], '[-2^(1/2)/2; 0; 2^(1/2)/2]', 'int_edge', 6};

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
                    3;
                    4;
                    5;
                    6]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {[]};

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end