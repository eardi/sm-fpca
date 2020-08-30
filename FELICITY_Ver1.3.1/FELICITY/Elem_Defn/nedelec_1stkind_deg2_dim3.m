function Elem = nedelec_1stkind_deg2_dim3(Type_STR)
%nedelec_1stkind_deg2_dim3
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Nedelec (1st-kind) H(curl) Finite Element of degree = 2, in dimension = 3.
%
%    This assumes the tetrahedral element [V_1, V_2, V_3, V_4] satisfies:
%    V_1 < V_2 < V_3 < V_4  (ascending order)
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
%    V1 < V2 < V3 < V4  (ascending order)
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
Elem.Basis(20).Func = []; % init
Elem.Basis(1).Func = {'8*x*y - 12*y - 12*z - 6*x + 8*x*z + 16*y*z + 8*y^2 + 8*z^2 + 4'; '-2*x*(4*x + 4*y + 4*z - 3)'; '-2*x*(4*x + 4*y + 4*z - 3)'};
Elem.Basis(2).Func = {'6*x + 2*y + 2*z - 8*x*y - 8*x*z - 2'; '4*x*(2*x - 1)'; '4*x*(2*x - 1)'};
Elem.Basis(3).Func = {'-2*y*(4*x + 4*y + 4*z - 3)'; '8*x*y - 6*y - 12*z - 12*x + 16*x*z + 8*y*z + 8*x^2 + 8*z^2 + 4'; '-2*y*(4*x + 4*y + 4*z - 3)'};
Elem.Basis(4).Func = {'4*y*(2*y - 1)'; '2*x + 6*y + 2*z - 8*x*y - 8*y*z - 2'; '4*y*(2*y - 1)'};
Elem.Basis(5).Func = {'-2*z*(4*x + 4*y + 4*z - 3)'; '-2*z*(4*x + 4*y + 4*z - 3)'; '16*x*y - 12*y - 6*z - 12*x + 8*x*z + 8*y*z + 8*x^2 + 8*y^2 + 4'};
Elem.Basis(6).Func = {'4*z*(2*z - 1)'; '4*z*(2*z - 1)'; '2*x + 2*y + 6*z - 8*x*z - 8*y*z - 2'};
Elem.Basis(7).Func = {'-2*y*(4*x - 1)'; '4*x*(2*x - 1)'; '0'};
Elem.Basis(8).Func = {'-4*y*(2*y - 1)'; '2*x*(4*y - 1)'; '0'};
Elem.Basis(9).Func = {'0'; '-2*z*(4*y - 1)'; '4*y*(2*y - 1)'};
Elem.Basis(10).Func = {'0'; '-4*z*(2*z - 1)'; '2*y*(4*z - 1)'};
Elem.Basis(11).Func = {'-4*z*(2*z - 1)'; '0'; '2*x*(4*z - 1)'};
Elem.Basis(12).Func = {'-2*z*(4*x - 1)'; '0'; '4*x*(2*x - 1)'};
Elem.Basis(13).Func = {'-4*y*z'; '8*x*z'; '-4*x*y'};
Elem.Basis(14).Func = {'4*y*z'; '-4*z*(2*x + y + 2*z - 2)'; '4*y*(x + y + 2*z - 1)'};
Elem.Basis(15).Func = {'-4*z*(x + 2*y + 2*z - 2)'; '4*x*z'; '4*x*(x + y + 2*z - 1)'};
Elem.Basis(16).Func = {'-4*y*(x + 2*y + 2*z - 2)'; '4*x*(x + 2*y + z - 1)'; '4*x*y'};
Elem.Basis(17).Func = {'-4*y*z'; '-4*x*z'; '8*x*y'};
Elem.Basis(18).Func = {'4*y*z'; '4*z*(x + 2*y + z - 1)'; '-4*y*(2*x + 2*y + z - 2)'};
Elem.Basis(19).Func = {'4*z*(2*x + y + z - 1)'; '4*x*z'; '-4*x*(2*x + 2*y + z - 2)'};
Elem.Basis(20).Func = {'4*y*(2*x + y + z - 1)'; '-4*x*(2*x + y + 2*z - 2)'; '4*x*y'};
% local mapping transformation to use
Elem.Transformation = 'Hcurl_Trans';
Elem.Degree = 2;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(20).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0, 0, 0], '[1 - x; 0; 0]', 'int_edge', 1};
Elem.Nodal_Var(2).Data = {[0, 1, 0, 0], '[x; 0; 0]', 'int_edge', 1};
Elem.Nodal_Var(3).Data = {[1, 0, 0, 0], '[0; 1 - y; 0]', 'int_edge', 2};
Elem.Nodal_Var(4).Data = {[0, 0, 1, 0], '[0; y; 0]', 'int_edge', 2};
Elem.Nodal_Var(5).Data = {[1, 0, 0, 0], '[0; 0; 1 - z]', 'int_edge', 3};
Elem.Nodal_Var(6).Data = {[0, 0, 0, 1], '[0; 0; z]', 'int_edge', 3};
Elem.Nodal_Var(7).Data = {[0, 1, 0, 0], '[(2^(1/2)*(y - 1))/2; -(2^(1/2)*(y - 1))/2; 0]', 'int_edge', 4};
Elem.Nodal_Var(8).Data = {[0, 0, 1, 0], '[-(2^(1/2)*y)/2; (2^(1/2)*y)/2; 0]', 'int_edge', 4};
Elem.Nodal_Var(9).Data = {[0, 0, 1, 0], '[0; (2^(1/2)*(z - 1))/2; -(2^(1/2)*(z - 1))/2]', 'int_edge', 5};
Elem.Nodal_Var(10).Data = {[0, 0, 0, 1], '[0; -(2^(1/2)*z)/2; (2^(1/2)*z)/2]', 'int_edge', 5};
Elem.Nodal_Var(11).Data = {[0, 0, 0, 1], '[(2^(1/2)*(x - 1))/2; 0; -(2^(1/2)*(x - 1))/2]', 'int_edge', 6};
Elem.Nodal_Var(12).Data = {[0, 1, 0, 0], '[-(2^(1/2)*x)/2; 0; (2^(1/2)*x)/2]', 'int_edge', 6};
Elem.Nodal_Var(13).Data = {[0, 1/3, 1/3, 1/3], '[-1; 1; 0]', 'int_facet', 1, 'dof_set', 1};
Elem.Nodal_Var(14).Data = {[1/3, 0, 1/3, 1/3], '[0; 1; 0]', 'int_facet', 2, 'dof_set', 1};
Elem.Nodal_Var(15).Data = {[1/3, 1/3, 0, 1/3], '[1; 0; 0]', 'int_facet', 3, 'dof_set', 1};
Elem.Nodal_Var(16).Data = {[1/3, 1/3, 1/3, 0], '[1; 0; 0]', 'int_facet', 4, 'dof_set', 1};
Elem.Nodal_Var(17).Data = {[0, 1/3, 1/3, 1/3], '[-1; 0; 1]', 'int_facet', 1, 'dof_set', 2};
Elem.Nodal_Var(18).Data = {[1/3, 0, 1/3, 1/3], '[0; 0; 1]', 'int_facet', 2, 'dof_set', 2};
Elem.Nodal_Var(19).Data = {[1/3, 1/3, 0, 1/3], '[0; 0; 1]', 'int_facet', 3, 'dof_set', 2};
Elem.Nodal_Var(20).Data = {[1/3, 1/3, 1/3, 0], '[0; 1; 0]', 'int_facet', 4, 'dof_set', 2};

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
                    5, 6;
                    7, 8;
                    9, 10;
                    11, 12]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [13;
                    14;
                    15;
                    16],...
                   [17;
                    18;
                    19;
                    20]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end