function Elem = nedelec_1stkind_deg3_dim3_mirror_image(Type_STR)
%nedelec_1stkind_deg3_dim3_mirror_image
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Nedelec (1st-kind) H(curl) Finite Element of degree = 3, in dimension = 3.
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
Elem.Basis(45).Func = []; % init
Elem.Basis(1).Func = {'120*x*y - 54*y - 54*z - 36*x + 120*x*z + 180*y*z - 90*x*y^2 - 45*x^2*y - 90*x*z^2 - 45*x^2*z - 135*y*z^2 - 135*y^2*z + 30*x^2 + 90*y^2 - 45*y^3 + 90*z^2 - 45*z^3 - 180*x*y*z + 9'; '3*x*(30*x*y - 20*y - 20*z - 20*x + 30*x*z + 30*y*z + 15*x^2 + 15*y^2 + 15*z^2 + 6)'; '3*x*(30*x*y - 20*y - 20*z - 20*x + 30*x*z + 30*y*z + 15*x^2 + 15*y^2 + 15*z^2 + 6)'};
Elem.Basis(2).Func = {'30*x*y - 3*y - 3*z - 24*x + 30*x*z - 45*x^2*y - 45*x^2*z + 30*x^2 + 3'; '9*x*(5*x^2 - 5*x + 1)'; '9*x*(5*x^2 - 5*x + 1)'};
Elem.Basis(3).Func = {'15*x - (9*y)/4 - (9*z)/4 - (75*x*y)/2 - (75*x*z)/2 + 30*y*z + (45*x*y^2)/2 + (45*x^2*y)/2 + (45*x*z^2)/2 + (45*x^2*z)/2 - (135*y*z^2)/4 - (135*y^2*z)/4 - 15*x^2 + 15*y^2 - (45*y^3)/4 + 15*z^2 - (45*z^3)/4 + 45*x*y*z - 3/2'; '(3*x*(35*x - 30*x*y - 30*x*z + 30*y*z - 30*x^2 + 15*y^2 + 15*z^2 - 7))/4'; '(3*x*(35*x - 30*x*y - 30*x*z + 30*y*z - 30*x^2 + 15*y^2 + 15*z^2 - 7))/4'};
Elem.Basis(4).Func = {'3*y*(30*x*y - 20*y - 20*z - 20*x + 30*x*z + 30*y*z + 15*x^2 + 15*y^2 + 15*z^2 + 6)'; '120*x*y - 36*y - 54*z - 54*x + 180*x*z + 120*y*z - 45*x*y^2 - 90*x^2*y - 135*x*z^2 - 135*x^2*z - 90*y*z^2 - 45*y^2*z + 90*x^2 - 45*x^3 + 30*y^2 + 90*z^2 - 45*z^3 - 180*x*y*z + 9'; '3*y*(30*x*y - 20*y - 20*z - 20*x + 30*x*z + 30*y*z + 15*x^2 + 15*y^2 + 15*z^2 + 6)'};
Elem.Basis(5).Func = {'9*y*(5*y^2 - 5*y + 1)'; '30*x*y - 24*y - 3*z - 3*x + 30*y*z - 45*x*y^2 - 45*y^2*z + 30*y^2 + 3'; '9*y*(5*y^2 - 5*y + 1)'};
Elem.Basis(6).Func = {'(3*y*(35*y - 30*x*y + 30*x*z - 30*y*z + 15*x^2 - 30*y^2 + 15*z^2 - 7))/4'; '15*y - (9*x)/4 - (9*z)/4 - (75*x*y)/2 + 30*x*z - (75*y*z)/2 + (45*x*y^2)/2 + (45*x^2*y)/2 - (135*x*z^2)/4 - (135*x^2*z)/4 + (45*y*z^2)/2 + (45*y^2*z)/2 + 15*x^2 - (45*x^3)/4 - 15*y^2 + 15*z^2 - (45*z^3)/4 + 45*x*y*z - 3/2'; '(3*y*(35*y - 30*x*y + 30*x*z - 30*y*z + 15*x^2 - 30*y^2 + 15*z^2 - 7))/4'};
Elem.Basis(7).Func = {'3*z*(30*x*y - 20*y - 20*z - 20*x + 30*x*z + 30*y*z + 15*x^2 + 15*y^2 + 15*z^2 + 6)'; '3*z*(30*x*y - 20*y - 20*z - 20*x + 30*x*z + 30*y*z + 15*x^2 + 15*y^2 + 15*z^2 + 6)'; '180*x*y - 54*y - 36*z - 54*x + 120*x*z + 120*y*z - 135*x*y^2 - 135*x^2*y - 45*x*z^2 - 90*x^2*z - 45*y*z^2 - 90*y^2*z + 90*x^2 - 45*x^3 + 90*y^2 - 45*y^3 + 30*z^2 - 180*x*y*z + 9'};
Elem.Basis(8).Func = {'9*z*(5*z^2 - 5*z + 1)'; '9*z*(5*z^2 - 5*z + 1)'; '30*x*z - 3*y - 24*z - 3*x + 30*y*z - 45*x*z^2 - 45*y*z^2 + 30*z^2 + 3'};
Elem.Basis(9).Func = {'(3*z*(35*z + 30*x*y - 30*x*z - 30*y*z + 15*x^2 + 15*y^2 - 30*z^2 - 7))/4'; '(3*z*(35*z + 30*x*y - 30*x*z - 30*y*z + 15*x^2 + 15*y^2 - 30*z^2 - 7))/4'; '15*z - (9*y)/4 - (9*x)/4 + 30*x*y - (75*x*z)/2 - (75*y*z)/2 - (135*x*y^2)/4 - (135*x^2*y)/4 + (45*x*z^2)/2 + (45*x^2*z)/2 + (45*y*z^2)/2 + (45*y^2*z)/2 + 15*x^2 - (45*x^3)/4 + 15*y^2 - (45*y^3)/4 - 15*z^2 + 45*x*y*z - 3/2'};
Elem.Basis(10).Func = {'3*y*(15*x^2 - 10*x + 1)'; '-9*x*(5*x^2 - 5*x + 1)'; '0'};
Elem.Basis(11).Func = {'9*y*(5*y^2 - 5*y + 1)'; '-3*x*(15*y^2 - 10*y + 1)'; '0'};
Elem.Basis(12).Func = {'(3*y*(60*x*y - 25*y - 30*x + 15*x^2 + 15*y^2 + 8))/4'; '-(3*x*(60*x*y - 30*y - 25*x + 15*x^2 + 15*y^2 + 8))/4'; '0'};
Elem.Basis(13).Func = {'0'; '-3*z*(15*y^2 - 10*y + 1)'; '9*y*(5*y^2 - 5*y + 1)'};
Elem.Basis(14).Func = {'0'; '-9*z*(5*z^2 - 5*z + 1)'; '3*y*(15*z^2 - 10*z + 1)'};
Elem.Basis(15).Func = {'0'; '-(3*z*(60*y*z - 25*z - 30*y + 15*y^2 + 15*z^2 + 8))/4'; '(3*y*(60*y*z - 30*z - 25*y + 15*y^2 + 15*z^2 + 8))/4'};
Elem.Basis(16).Func = {'-9*z*(5*z^2 - 5*z + 1)'; '0'; '3*x*(15*z^2 - 10*z + 1)'};
Elem.Basis(17).Func = {'-3*z*(15*x^2 - 10*x + 1)'; '0'; '9*x*(5*x^2 - 5*x + 1)'};
Elem.Basis(18).Func = {'-(3*z*(60*x*z - 25*z - 30*x + 15*x^2 + 15*z^2 + 8))/4'; '0'; '(3*x*(60*x*z - 30*z - 25*x + 15*x^2 + 15*z^2 + 8))/4'};
Elem.Basis(19).Func = {'30*y*z*(6*x - 1)'; '-30*x*z*(3*x - 1)'; '-30*x*y*(3*x - 1)'};
Elem.Basis(20).Func = {'45*y*z*(3*y - 1)'; '-15*x*z*(6*y - 1)'; '-15*x*y*(3*y - 1)'};
Elem.Basis(21).Func = {'45*y*z*(3*z - 1)'; '-15*x*z*(3*z - 1)'; '-15*x*y*(6*z - 1)'};
Elem.Basis(22).Func = {'-15*y*z*(6*x + 6*y + 6*z - 5)'; '15*z*(12*x*y - 10*y - 15*z - 15*x + 18*x*z + 12*y*z + 9*x^2 + 3*y^2 + 9*z^2 + 6)'; '-15*y*(6*x*y - 5*y - 10*z - 5*x + 12*x*z + 12*y*z + 3*x^2 + 3*y^2 + 9*z^2 + 2)'};
Elem.Basis(23).Func = {'15*y*z*(3*z - 1)'; '-15*z*(3*z - 1)*(3*x + 2*y + 3*z - 3)'; '15*y*(6*x*z - y - 8*z - x + 6*y*z + 9*z^2 + 1)'};
Elem.Basis(24).Func = {'30*y*z*(3*y - 1)'; '-30*z*(6*x*y - 6*y - z - x + 6*y*z + 3*y^2 + 1)'; '30*y*(3*y - 1)*(x + y + 2*z - 1)'};
Elem.Basis(25).Func = {'15*z*(12*x*y - 15*y - 15*z - 10*x + 12*x*z + 18*y*z + 3*x^2 + 9*y^2 + 9*z^2 + 6)'; '-15*x*z*(6*x + 6*y + 6*z - 5)'; '-15*x*(6*x*y - 5*y - 10*z - 5*x + 12*x*z + 12*y*z + 3*x^2 + 3*y^2 + 9*z^2 + 2)'};
Elem.Basis(26).Func = {'-30*z*(6*x*y - y - z - 6*x + 6*x*z + 3*x^2 + 1)'; '30*x*z*(3*x - 1)'; '30*x*(3*x - 1)*(x + y + 2*z - 1)'};
Elem.Basis(27).Func = {'-15*z*(3*z - 1)*(2*x + 3*y + 3*z - 3)'; '15*x*z*(3*z - 1)'; '15*x*(6*x*z - y - 8*z - x + 6*y*z + 9*z^2 + 1)'};
Elem.Basis(28).Func = {'-15*y*(12*x*y - 5*y - 5*z - 10*x + 12*x*z + 6*y*z + 9*x^2 + 3*y^2 + 3*z^2 + 2)'; '15*x*(12*x*y - 10*y - 15*z - 15*x + 18*x*z + 12*y*z + 9*x^2 + 3*y^2 + 9*z^2 + 6)'; '-15*x*y*(6*x + 6*y + 6*z - 5)'};
Elem.Basis(29).Func = {'30*y*(3*y - 1)*(2*x + y + z - 1)'; '-30*x*(6*x*y - 6*y - z - x + 6*y*z + 3*y^2 + 1)'; '30*x*y*(3*y - 1)'};
Elem.Basis(30).Func = {'15*y*(6*x*y - y - z - 8*x + 6*x*z + 9*x^2 + 1)'; '-15*x*(3*x - 1)*(3*x + 2*y + 3*z - 3)'; '15*x*y*(3*x - 1)'};
Elem.Basis(31).Func = {'-15*y*z*(6*x - 1)'; '-15*x*z*(3*x - 1)'; '45*x*y*(3*x - 1)'};
Elem.Basis(32).Func = {'-15*y*z*(3*y - 1)'; '-15*x*z*(6*y - 1)'; '45*x*y*(3*y - 1)'};
Elem.Basis(33).Func = {'-30*y*z*(3*z - 1)'; '-30*x*z*(3*z - 1)'; '30*x*y*(6*z - 1)'};
Elem.Basis(34).Func = {'-15*y*z*(6*x + 6*y + 6*z - 5)'; '-15*z*(12*x*y - 10*y - 5*z - 5*x + 6*x*z + 12*y*z + 3*x^2 + 9*y^2 + 3*z^2 + 2)'; '15*y*(18*x*y - 15*y - 10*z - 15*x + 12*x*z + 12*y*z + 9*x^2 + 9*y^2 + 3*z^2 + 6)'};
Elem.Basis(35).Func = {'30*y*z*(3*z - 1)'; '30*z*(3*z - 1)*(x + 2*y + z - 1)'; '-30*y*(6*x*z - y - 6*z - x + 6*y*z + 3*z^2 + 1)'};
Elem.Basis(36).Func = {'15*y*z*(3*y - 1)'; '15*z*(6*x*y - 8*y - z - x + 6*y*z + 9*y^2 + 1)'; '-15*y*(3*y - 1)*(3*x + 3*y + 2*z - 3)'};
Elem.Basis(37).Func = {'-15*z*(12*x*y - 5*y - 5*z - 10*x + 12*x*z + 6*y*z + 9*x^2 + 3*y^2 + 3*z^2 + 2)'; '-15*x*z*(6*x + 6*y + 6*z - 5)'; '15*x*(18*x*y - 15*y - 10*z - 15*x + 12*x*z + 12*y*z + 9*x^2 + 9*y^2 + 3*z^2 + 6)'};
Elem.Basis(38).Func = {'15*z*(6*x*y - y - z - 8*x + 6*x*z + 9*x^2 + 1)'; '15*x*z*(3*x - 1)'; '-15*x*(3*x - 1)*(3*x + 3*y + 2*z - 3)'};
Elem.Basis(39).Func = {'30*z*(3*z - 1)*(2*x + y + z - 1)'; '30*x*z*(3*z - 1)'; '-30*x*(6*x*z - y - 6*z - x + 6*y*z + 3*z^2 + 1)'};
Elem.Basis(40).Func = {'15*y*(12*x*y - 15*y - 15*z - 10*x + 12*x*z + 18*y*z + 3*x^2 + 9*y^2 + 9*z^2 + 6)'; '-15*x*(12*x*y - 10*y - 5*z - 5*x + 6*x*z + 12*y*z + 3*x^2 + 9*y^2 + 3*z^2 + 2)'; '-15*x*y*(6*x + 6*y + 6*z - 5)'};
Elem.Basis(41).Func = {'-15*y*(3*y - 1)*(2*x + 3*y + 3*z - 3)'; '15*x*(6*x*y - 8*y - z - x + 6*y*z + 9*y^2 + 1)'; '15*x*y*(3*y - 1)'};
Elem.Basis(42).Func = {'-30*y*(6*x*y - y - z - 6*x + 6*x*z + 3*x^2 + 1)'; '30*x*(3*x - 1)*(x + 2*y + z - 1)'; '30*x*y*(3*x - 1)'};
Elem.Basis(43).Func = {'-180*y*z*(2*x + 3*y + 3*z - 3)'; '180*x*z*(x + 2*y + z - 1)'; '180*x*y*(x + y + 2*z - 1)'};
Elem.Basis(44).Func = {'180*y*z*(2*x + y + z - 1)'; '-180*x*z*(3*x + 2*y + 3*z - 3)'; '180*x*y*(x + y + 2*z - 1)'};
Elem.Basis(45).Func = {'180*y*z*(2*x + y + z - 1)'; '180*x*z*(x + 2*y + z - 1)'; '-180*x*y*(3*x + 3*y + 2*z - 3)'};
% local mapping transformation to use
Elem.Transformation = 'Hcurl_Trans';
Elem.Degree = 3;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(45).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0, 0, 0], '[2*x^2 - 3*x + 1; 0; 0]', 'int_edge', 1};
Elem.Nodal_Var(2).Data = {[0, 1, 0, 0], '[x*(2*x - 1); 0; 0]', 'int_edge', 1};
Elem.Nodal_Var(3).Data = {[1/2, 1/2, 0, 0], '[-4*x*(x - 1); 0; 0]', 'int_edge', 1};
Elem.Nodal_Var(4).Data = {[1, 0, 0, 0], '[0; 2*y^2 - 3*y + 1; 0]', 'int_edge', 2};
Elem.Nodal_Var(5).Data = {[0, 0, 1, 0], '[0; y*(2*y - 1); 0]', 'int_edge', 2};
Elem.Nodal_Var(6).Data = {[1/2, 0, 1/2, 0], '[0; -4*y*(y - 1); 0]', 'int_edge', 2};
Elem.Nodal_Var(7).Data = {[1, 0, 0, 0], '[0; 0; 2*z^2 - 3*z + 1]', 'int_edge', 3};
Elem.Nodal_Var(8).Data = {[0, 0, 0, 1], '[0; 0; z*(2*z - 1)]', 'int_edge', 3};
Elem.Nodal_Var(9).Data = {[1/2, 0, 0, 1/2], '[0; 0; -4*z*(z - 1)]', 'int_edge', 3};
Elem.Nodal_Var(10).Data = {[0, 1, 0, 0], '[(2^(1/2)*(2*y^2 - 3*y + 1))/2; -(2^(1/2)*(2*y^2 - 3*y + 1))/2; 0]', 'int_edge', 4};
Elem.Nodal_Var(11).Data = {[0, 0, 1, 0], '[(2^(1/2)*y*(2*y - 1))/2; -(2^(1/2)*y*(2*y - 1))/2; 0]', 'int_edge', 4};
Elem.Nodal_Var(12).Data = {[0, 1/2, 1/2, 0], '[-2*2^(1/2)*y*(y - 1); 2*2^(1/2)*y*(y - 1); 0]', 'int_edge', 4};
Elem.Nodal_Var(13).Data = {[0, 0, 1, 0], '[0; -(2^(1/2)*(2*z^2 - 3*z + 1))/2; (2^(1/2)*(2*z^2 - 3*z + 1))/2]', 'int_edge', 5};
Elem.Nodal_Var(14).Data = {[0, 0, 0, 1], '[0; -(2^(1/2)*z*(2*z - 1))/2; (2^(1/2)*z*(2*z - 1))/2]', 'int_edge', 5};
Elem.Nodal_Var(15).Data = {[0, 0, 1/2, 1/2], '[0; 2*2^(1/2)*z*(z - 1); -2*2^(1/2)*z*(z - 1)]', 'int_edge', 5};
Elem.Nodal_Var(16).Data = {[0, 0, 0, 1], '[-(2^(1/2)*(2*x^2 - 3*x + 1))/2; 0; (2^(1/2)*(2*x^2 - 3*x + 1))/2]', 'int_edge', 6};
Elem.Nodal_Var(17).Data = {[0, 1, 0, 0], '[-(2^(1/2)*x*(2*x - 1))/2; 0; (2^(1/2)*x*(2*x - 1))/2]', 'int_edge', 6};
Elem.Nodal_Var(18).Data = {[0, 1/2, 0, 1/2], '[2*2^(1/2)*x*(x - 1); 0; -2*2^(1/2)*x*(x - 1)]', 'int_edge', 6};
Elem.Nodal_Var(19).Data = {[0, 1, 0, 0], '[1 - z - y; y + z - 1; 0]', 'int_facet', 1, 'dof_set', 1};
Elem.Nodal_Var(20).Data = {[0, 0, 1, 0], '[y; -y; 0]', 'int_facet', 1, 'dof_set', 1};
Elem.Nodal_Var(21).Data = {[0, 0, 0, 1], '[z; -z; 0]', 'int_facet', 1, 'dof_set', 1};
Elem.Nodal_Var(22).Data = {[1, 0, 0, 0], '[0; 1 - z - y; 0]', 'int_facet', 2, 'dof_set', 1};
Elem.Nodal_Var(23).Data = {[0, 0, 0, 1], '[0; z; 0]', 'int_facet', 2, 'dof_set', 1};
Elem.Nodal_Var(24).Data = {[0, 0, 1, 0], '[0; y; 0]', 'int_facet', 2, 'dof_set', 1};
Elem.Nodal_Var(25).Data = {[1, 0, 0, 0], '[1 - z - x; 0; 0]', 'int_facet', 3, 'dof_set', 1};
Elem.Nodal_Var(26).Data = {[0, 1, 0, 0], '[x; 0; 0]', 'int_facet', 3, 'dof_set', 1};
Elem.Nodal_Var(27).Data = {[0, 0, 0, 1], '[z; 0; 0]', 'int_facet', 3, 'dof_set', 1};
Elem.Nodal_Var(28).Data = {[1, 0, 0, 0], '[0; 1 - y - x; 0]', 'int_facet', 4, 'dof_set', 1};
Elem.Nodal_Var(29).Data = {[0, 0, 1, 0], '[0; y; 0]', 'int_facet', 4, 'dof_set', 1};
Elem.Nodal_Var(30).Data = {[0, 1, 0, 0], '[0; x; 0]', 'int_facet', 4, 'dof_set', 1};
Elem.Nodal_Var(31).Data = {[0, 1, 0, 0], '[0; y + z - 1; 1 - z - y]', 'int_facet', 1, 'dof_set', 2};
Elem.Nodal_Var(32).Data = {[0, 0, 1, 0], '[0; -y; y]', 'int_facet', 1, 'dof_set', 2};
Elem.Nodal_Var(33).Data = {[0, 0, 0, 1], '[0; -z; z]', 'int_facet', 1, 'dof_set', 2};
Elem.Nodal_Var(34).Data = {[1, 0, 0, 0], '[0; 0; 1 - z - y]', 'int_facet', 2, 'dof_set', 2};
Elem.Nodal_Var(35).Data = {[0, 0, 0, 1], '[0; 0; z]', 'int_facet', 2, 'dof_set', 2};
Elem.Nodal_Var(36).Data = {[0, 0, 1, 0], '[0; 0; y]', 'int_facet', 2, 'dof_set', 2};
Elem.Nodal_Var(37).Data = {[1, 0, 0, 0], '[0; 0; 1 - z - x]', 'int_facet', 3, 'dof_set', 2};
Elem.Nodal_Var(38).Data = {[0, 1, 0, 0], '[0; 0; x]', 'int_facet', 3, 'dof_set', 2};
Elem.Nodal_Var(39).Data = {[0, 0, 0, 1], '[0; 0; z]', 'int_facet', 3, 'dof_set', 2};
Elem.Nodal_Var(40).Data = {[1, 0, 0, 0], '[1 - y - x; 0; 0]', 'int_facet', 4, 'dof_set', 2};
Elem.Nodal_Var(41).Data = {[0, 0, 1, 0], '[y; 0; 0]', 'int_facet', 4, 'dof_set', 2};
Elem.Nodal_Var(42).Data = {[0, 1, 0, 0], '[x; 0; 0]', 'int_facet', 4, 'dof_set', 2};
Elem.Nodal_Var(43).Data = {[1/4, 1/4, 1/4, 1/4], '[1; 0; 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(44).Data = {[1/4, 1/4, 1/4, 1/4], '[0; 1; 0]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(45).Data = {[1/4, 1/4, 1/4, 1/4], '[0; 0; 1]', 'int_cell', 1, 'dof_set', 3};

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
                    7, 8, 9;
                    10, 11, 12;
                    13, 14, 15;
                    16, 17, 18]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [19, 20, 21;
                    22, 23, 24;
                    25, 26, 27;
                    28, 29, 30],...
                   [31, 32, 33;
                    34, 35, 36;
                    37, 38, 39;
                    40, 41, 42]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {...
                   [43],...
                   [44],...
                   [45]...
                   };
%

end