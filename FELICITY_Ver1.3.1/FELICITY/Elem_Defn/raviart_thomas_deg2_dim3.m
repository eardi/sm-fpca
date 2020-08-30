function Elem = raviart_thomas_deg2_dim3(Type_STR)
%raviart_thomas_deg2_dim3
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Raviart-Thomas H(div) Finite Element of degree = 2, in dimension = 3.
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
Elem.Basis(36).Func = []; % init
Elem.Basis(1).Func = {'36*x*(7*x^2 - 6*x + 1)'; '12*y*(21*x^2 - 12*x + 1)'; '12*z*(21*x^2 - 12*x + 1)'};
Elem.Basis(2).Func = {'12*x*(21*y^2 - 12*y + 1)'; '36*y*(7*y^2 - 6*y + 1)'; '12*z*(21*y^2 - 12*y + 1)'};
Elem.Basis(3).Func = {'12*x*(21*z^2 - 12*z + 1)'; '12*y*(21*z^2 - 12*z + 1)'; '36*z*(7*z^2 - 6*z + 1)'};
Elem.Basis(4).Func = {'3*x*(84*y*z - 24*z - 24*y + 21*y^2 + 21*z^2 + 4)'; '3*y*(84*y*z - 36*z - 30*y + 21*y^2 + 21*z^2 + 8)'; '3*z*(84*y*z - 30*z - 36*y + 21*y^2 + 21*z^2 + 8)'};
Elem.Basis(5).Func = {'3*x*(84*x*z - 36*z - 30*x + 21*x^2 + 21*z^2 + 8)'; '3*y*(84*x*z - 24*z - 24*x + 21*x^2 + 21*z^2 + 4)'; '3*z*(84*x*z - 30*z - 36*x + 21*x^2 + 21*z^2 + 8)'};
Elem.Basis(6).Func = {'3*x*(84*x*y - 36*y - 30*x + 21*x^2 + 21*y^2 + 8)'; '3*y*(84*x*y - 30*y - 36*x + 21*x^2 + 21*y^2 + 8)'; '3*z*(84*x*y - 24*y - 24*x + 21*x^2 + 21*y^2 + 4)'};
Elem.Basis(7).Func = {'360*x + 240*y + 240*z - 720*x*y - 720*x*z - 360*y*z + 252*x*y^2 + 504*x^2*y + 252*x*z^2 + 504*x^2*z - 540*x^2 + 252*x^3 - 180*y^2 - 180*z^2 + 504*x*y*z - 72'; '12*y*(42*x*y - 30*y - 30*z - 30*x + 42*x*z + 42*y*z + 21*x^2 + 21*y^2 + 21*z^2 + 10)'; '12*z*(42*x*y - 30*y - 30*z - 30*x + 42*x*z + 42*y*z + 21*x^2 + 21*y^2 + 21*z^2 + 10)'};
Elem.Basis(8).Func = {'12*x + 120*z - 144*x*z + 252*x*z^2 - 180*z^2 - 12'; '12*y*(21*z^2 - 12*z + 1)'; '36*z*(7*z^2 - 6*z + 1)'};
Elem.Basis(9).Func = {'12*x + 120*y - 144*x*y + 252*x*y^2 - 180*y^2 - 12'; '36*y*(7*y^2 - 6*y + 1)'; '12*z*(21*y^2 - 12*y + 1)'};
Elem.Basis(10).Func = {'12*x + 60*y + 60*z - 72*x*y - 72*x*z - 180*y*z + 63*x*y^2 + 63*x*z^2 - 45*y^2 - 45*z^2 + 252*x*y*z - 12'; '3*y*(84*y*z - 36*z - 30*y + 21*y^2 + 21*z^2 + 8)'; '3*z*(84*y*z - 30*z - 36*y + 21*y^2 + 21*z^2 + 8)'};
Elem.Basis(11).Func = {'33*x - 90*y + 30*z + 216*x*y - 144*x*z + 90*y*z - 126*x*y^2 - 126*x^2*y + 63*x*z^2 + 126*x^2*z - 99*x^2 + 63*x^3 + 90*y^2 - 45*z^2 - 126*x*y*z + 3'; '-3*y*(6*x - 48*y + 6*z + 42*x*y - 42*x*z + 42*y*z - 21*x^2 + 42*y^2 - 21*z^2 + 7)'; '-3*z*(18*x - 42*y + 18*z + 42*x*y - 42*x*z + 42*y*z - 21*x^2 + 42*y^2 - 21*z^2 - 1)'};
Elem.Basis(12).Func = {'33*x + 30*y - 90*z - 144*x*y + 216*x*z + 90*y*z + 63*x*y^2 + 126*x^2*y - 126*x*z^2 - 126*x^2*z - 99*x^2 + 63*x^3 - 45*y^2 + 90*z^2 - 126*x*y*z + 3'; '-3*y*(18*x + 18*y - 42*z - 42*x*y + 42*x*z + 42*y*z - 21*x^2 - 21*y^2 + 42*z^2 - 1)'; '-3*z*(6*x + 6*y - 48*z - 42*x*y + 42*x*z + 42*y*z - 21*x^2 - 21*y^2 + 42*z^2 + 7)'};
Elem.Basis(13).Func = {'12*x*(42*x*y - 30*y - 30*z - 30*x + 42*x*z + 42*y*z + 21*x^2 + 21*y^2 + 21*z^2 + 10)'; '240*x + 360*y + 240*z - 720*x*y - 360*x*z - 720*y*z + 504*x*y^2 + 252*x^2*y + 252*y*z^2 + 504*y^2*z - 180*x^2 - 540*y^2 + 252*y^3 - 180*z^2 + 504*x*y*z - 72'; '12*z*(42*x*y - 30*y - 30*z - 30*x + 42*x*z + 42*y*z + 21*x^2 + 21*y^2 + 21*z^2 + 10)'};
Elem.Basis(14).Func = {'36*x*(7*x^2 - 6*x + 1)'; '120*x + 12*y - 144*x*y + 252*x^2*y - 180*x^2 - 12'; '12*z*(21*x^2 - 12*x + 1)'};
Elem.Basis(15).Func = {'12*x*(21*z^2 - 12*z + 1)'; '12*y + 120*z - 144*y*z + 252*y*z^2 - 180*z^2 - 12'; '36*z*(7*z^2 - 6*z + 1)'};
Elem.Basis(16).Func = {'3*x*(84*x*z - 36*z - 30*x + 21*x^2 + 21*z^2 + 8)'; '60*x + 12*y + 60*z - 72*x*y - 180*x*z - 72*y*z + 63*x^2*y + 63*y*z^2 - 45*x^2 - 45*z^2 + 252*x*y*z - 12'; '3*z*(84*x*z - 30*z - 36*x + 21*x^2 + 21*z^2 + 8)'};
Elem.Basis(17).Func = {'-3*x*(18*x + 18*y - 42*z - 42*x*y + 42*x*z + 42*y*z - 21*x^2 - 21*y^2 + 42*z^2 - 1)'; '30*x + 33*y - 90*z - 144*x*y + 90*x*z + 216*y*z + 126*x*y^2 + 63*x^2*y - 126*y*z^2 - 126*y^2*z - 45*x^2 - 99*y^2 + 63*y^3 + 90*z^2 - 126*x*y*z + 3'; '-3*z*(6*x + 6*y - 48*z - 42*x*y + 42*x*z + 42*y*z - 21*x^2 - 21*y^2 + 42*z^2 + 7)'};
Elem.Basis(18).Func = {'-3*x*(6*y - 48*x + 6*z + 42*x*y + 42*x*z - 42*y*z + 42*x^2 - 21*y^2 - 21*z^2 + 7)'; '33*y - 90*x + 30*z + 216*x*y + 90*x*z - 144*y*z - 126*x*y^2 - 126*x^2*y + 63*y*z^2 + 126*y^2*z + 90*x^2 - 99*y^2 + 63*y^3 - 45*z^2 - 126*x*y*z + 3'; '3*z*(42*x - 18*y - 18*z - 42*x*y - 42*x*z + 42*y*z - 42*x^2 + 21*y^2 + 21*z^2 + 1)'};
Elem.Basis(19).Func = {'12*x*(42*x*y - 30*y - 30*z - 30*x + 42*x*z + 42*y*z + 21*x^2 + 21*y^2 + 21*z^2 + 10)'; '12*y*(42*x*y - 30*y - 30*z - 30*x + 42*x*z + 42*y*z + 21*x^2 + 21*y^2 + 21*z^2 + 10)'; '240*x + 240*y + 360*z - 360*x*y - 720*x*z - 720*y*z + 504*x*z^2 + 252*x^2*z + 504*y*z^2 + 252*y^2*z - 180*x^2 - 180*y^2 - 540*z^2 + 252*z^3 + 504*x*y*z - 72'};
Elem.Basis(20).Func = {'12*x*(21*y^2 - 12*y + 1)'; '36*y*(7*y^2 - 6*y + 1)'; '120*y + 12*z - 144*y*z + 252*y^2*z - 180*y^2 - 12'};
Elem.Basis(21).Func = {'36*x*(7*x^2 - 6*x + 1)'; '12*y*(21*x^2 - 12*x + 1)'; '120*x + 12*z - 144*x*z + 252*x^2*z - 180*x^2 - 12'};
Elem.Basis(22).Func = {'3*x*(84*x*y - 36*y - 30*x + 21*x^2 + 21*y^2 + 8)'; '3*y*(84*x*y - 30*y - 36*x + 21*x^2 + 21*y^2 + 8)'; '60*x + 60*y + 12*z - 180*x*y - 72*x*z - 72*y*z + 63*x^2*z + 63*y^2*z - 45*x^2 - 45*y^2 + 252*x*y*z - 12'};
Elem.Basis(23).Func = {'-3*x*(6*y - 48*x + 6*z + 42*x*y + 42*x*z - 42*y*z + 42*x^2 - 21*y^2 - 21*z^2 + 7)'; '3*y*(42*x - 18*y - 18*z - 42*x*y - 42*x*z + 42*y*z - 42*x^2 + 21*y^2 + 21*z^2 + 1)'; '30*y - 90*x + 33*z + 90*x*y + 216*x*z - 144*y*z - 126*x*z^2 - 126*x^2*z + 126*y*z^2 + 63*y^2*z + 90*x^2 - 45*y^2 - 99*z^2 + 63*z^3 - 126*x*y*z + 3'};
Elem.Basis(24).Func = {'-3*x*(18*x - 42*y + 18*z + 42*x*y - 42*x*z + 42*y*z - 21*x^2 + 42*y^2 - 21*z^2 - 1)'; '-3*y*(6*x - 48*y + 6*z + 42*x*y - 42*x*z + 42*y*z - 21*x^2 + 42*y^2 - 21*z^2 + 7)'; '30*x - 90*y + 33*z + 90*x*y - 144*x*z + 216*y*z + 126*x*z^2 + 63*x^2*z - 126*y*z^2 - 126*y^2*z - 45*x^2 + 90*y^2 - 99*z^2 + 63*z^3 - 126*x*y*z + 3'};
Elem.Basis(25).Func = {'72*x*(28*x*y - 24*y - 24*z - 36*x + 28*x*z + 14*y*z + 21*x^2 + 7*y^2 + 7*z^2 + 15)'; '72*y*(28*x*y - 12*y - 12*z - 24*x + 28*x*z + 14*y*z + 21*x^2 + 7*y^2 + 7*z^2 + 5)'; '72*z*(28*x*y - 12*y - 12*z - 24*x + 28*x*z + 14*y*z + 21*x^2 + 7*y^2 + 7*z^2 + 5)'};
Elem.Basis(26).Func = {'-72*x*(7*x - 2)*(3*x + 2*y + 2*z - 3)'; '-72*y*(14*x*y - 2*y - 2*z - 18*x + 14*x*z + 21*x^2 + 2)'; '-72*z*(14*x*y - 2*y - 2*z - 18*x + 14*x*z + 21*x^2 + 2)'};
Elem.Basis(27).Func = {'-144*x*(14*x*y - 14*y - z - 2*x + 7*y*z + 7*y^2 + 2)'; '-144*y*(7*y - 2)*(2*x + y + z - 1)'; '-144*z*(7*y - 1)*(2*x + y + z - 1)'};
Elem.Basis(28).Func = {'-144*x*(14*x*z - y - 14*z - 2*x + 7*y*z + 7*z^2 + 2)'; '-144*y*(7*z - 1)*(2*x + y + z - 1)'; '-144*z*(7*z - 2)*(2*x + y + z - 1)'};
Elem.Basis(29).Func = {'72*x*(28*x*y - 24*y - 12*z - 12*x + 14*x*z + 28*y*z + 7*x^2 + 21*y^2 + 7*z^2 + 5)'; '72*y*(28*x*y - 36*y - 24*z - 24*x + 14*x*z + 28*y*z + 7*x^2 + 21*y^2 + 7*z^2 + 15)'; '72*z*(28*x*y - 24*y - 12*z - 12*x + 14*x*z + 28*y*z + 7*x^2 + 21*y^2 + 7*z^2 + 5)'};
Elem.Basis(30).Func = {'-144*x*(7*x - 2)*(x + 2*y + z - 1)'; '-144*y*(14*x*y - 2*y - z - 14*x + 7*x*z + 7*x^2 + 2)'; '-144*z*(7*x - 1)*(x + 2*y + z - 1)'};
Elem.Basis(31).Func = {'-72*x*(14*x*y - 18*y - 2*z - 2*x + 14*y*z + 21*y^2 + 2)'; '-72*y*(7*y - 2)*(2*x + 3*y + 2*z - 3)'; '-72*z*(14*x*y - 18*y - 2*z - 2*x + 14*y*z + 21*y^2 + 2)'};
Elem.Basis(32).Func = {'-144*x*(7*z - 1)*(x + 2*y + z - 1)'; '-144*y*(7*x*z - 2*y - 14*z - x + 14*y*z + 7*z^2 + 2)'; '-144*z*(7*z - 2)*(x + 2*y + z - 1)'};
Elem.Basis(33).Func = {'72*x*(14*x*y - 12*y - 24*z - 12*x + 28*x*z + 28*y*z + 7*x^2 + 7*y^2 + 21*z^2 + 5)'; '72*y*(14*x*y - 12*y - 24*z - 12*x + 28*x*z + 28*y*z + 7*x^2 + 7*y^2 + 21*z^2 + 5)'; '72*z*(14*x*y - 24*y - 36*z - 24*x + 28*x*z + 28*y*z + 7*x^2 + 7*y^2 + 21*z^2 + 15)'};
Elem.Basis(34).Func = {'-144*x*(7*x - 2)*(x + y + 2*z - 1)'; '-144*y*(7*x - 1)*(x + y + 2*z - 1)'; '-144*z*(7*x*y - y - 2*z - 14*x + 14*x*z + 7*x^2 + 2)'};
Elem.Basis(35).Func = {'-144*x*(7*y - 1)*(x + y + 2*z - 1)'; '-144*y*(7*y - 2)*(x + y + 2*z - 1)'; '-144*z*(7*x*y - 14*y - 2*z - x + 14*y*z + 7*y^2 + 2)'};
Elem.Basis(36).Func = {'-72*x*(14*x*z - 2*y - 18*z - 2*x + 14*y*z + 21*z^2 + 2)'; '-72*y*(14*x*z - 2*y - 18*z - 2*x + 14*y*z + 21*z^2 + 2)'; '-72*z*(7*z - 2)*(2*x + 2*y + 3*z - 3)'};
% local mapping transformation to use
Elem.Transformation = 'Hdiv_Trans';
Elem.Degree = 2;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(36).Data = []; % init
Elem.Nodal_Var(1).Data = {[0, 1, 0, 0], '[4*y*z - 3*z - 3*y + 2*y^2 + 2*z^2 + 1]', 'int_facet', 1};
Elem.Nodal_Var(2).Data = {[0, 0, 1, 0], '[y*(2*y - 1)]', 'int_facet', 1};
Elem.Nodal_Var(3).Data = {[0, 0, 0, 1], '[z*(2*z - 1)]', 'int_facet', 1};
Elem.Nodal_Var(4).Data = {[0, 0, 1/2, 1/2], '[4*y*z]', 'int_facet', 1};
Elem.Nodal_Var(5).Data = {[0, 1/2, 0, 1/2], '[-4*z*(y + z - 1)]', 'int_facet', 1};
Elem.Nodal_Var(6).Data = {[0, 1/2, 1/2, 0], '[-4*y*(y + z - 1)]', 'int_facet', 1};
Elem.Nodal_Var(7).Data = {[1, 0, 0, 0], '[4*y*z - 3*z - 3*y + 2*y^2 + 2*z^2 + 1]', 'int_facet', 2};
Elem.Nodal_Var(8).Data = {[0, 0, 0, 1], '[z*(2*z - 1)]', 'int_facet', 2};
Elem.Nodal_Var(9).Data = {[0, 0, 1, 0], '[y*(2*y - 1)]', 'int_facet', 2};
Elem.Nodal_Var(10).Data = {[0, 0, 1/2, 1/2], '[4*y*z]', 'int_facet', 2};
Elem.Nodal_Var(11).Data = {[1/2, 0, 1/2, 0], '[-4*y*(y + z - 1)]', 'int_facet', 2};
Elem.Nodal_Var(12).Data = {[1/2, 0, 0, 1/2], '[-4*z*(y + z - 1)]', 'int_facet', 2};
Elem.Nodal_Var(13).Data = {[1, 0, 0, 0], '[4*x*z - 3*z - 3*x + 2*x^2 + 2*z^2 + 1]', 'int_facet', 3};
Elem.Nodal_Var(14).Data = {[0, 1, 0, 0], '[x*(2*x - 1)]', 'int_facet', 3};
Elem.Nodal_Var(15).Data = {[0, 0, 0, 1], '[z*(2*z - 1)]', 'int_facet', 3};
Elem.Nodal_Var(16).Data = {[0, 1/2, 0, 1/2], '[4*x*z]', 'int_facet', 3};
Elem.Nodal_Var(17).Data = {[1/2, 0, 0, 1/2], '[-4*z*(x + z - 1)]', 'int_facet', 3};
Elem.Nodal_Var(18).Data = {[1/2, 1/2, 0, 0], '[-4*x*(x + z - 1)]', 'int_facet', 3};
Elem.Nodal_Var(19).Data = {[1, 0, 0, 0], '[4*x*y - 3*y - 3*x + 2*x^2 + 2*y^2 + 1]', 'int_facet', 4};
Elem.Nodal_Var(20).Data = {[0, 0, 1, 0], '[y*(2*y - 1)]', 'int_facet', 4};
Elem.Nodal_Var(21).Data = {[0, 1, 0, 0], '[x*(2*x - 1)]', 'int_facet', 4};
Elem.Nodal_Var(22).Data = {[0, 1/2, 1/2, 0], '[4*x*y]', 'int_facet', 4};
Elem.Nodal_Var(23).Data = {[1/2, 1/2, 0, 0], '[-4*x*(x + y - 1)]', 'int_facet', 4};
Elem.Nodal_Var(24).Data = {[1/2, 0, 1/2, 0], '[-4*y*(x + y - 1)]', 'int_facet', 4};
Elem.Nodal_Var(25).Data = {[1, 0, 0, 0], '[1 - y - z - x; 0; 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(26).Data = {[0, 1, 0, 0], '[x; 0; 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(27).Data = {[0, 0, 1, 0], '[y; 0; 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(28).Data = {[0, 0, 0, 1], '[z; 0; 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(29).Data = {[1, 0, 0, 0], '[0; 1 - y - z - x; 0]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(30).Data = {[0, 1, 0, 0], '[0; x; 0]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(31).Data = {[0, 0, 1, 0], '[0; y; 0]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(32).Data = {[0, 0, 0, 1], '[0; z; 0]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(33).Data = {[1, 0, 0, 0], '[0; 0; 1 - y - z - x]', 'int_cell', 1, 'dof_set', 3};
Elem.Nodal_Var(34).Data = {[0, 1, 0, 0], '[0; 0; x]', 'int_cell', 1, 'dof_set', 3};
Elem.Nodal_Var(35).Data = {[0, 0, 1, 0], '[0; 0; y]', 'int_cell', 1, 'dof_set', 3};
Elem.Nodal_Var(36).Data = {[0, 0, 0, 1], '[0; 0; z]', 'int_cell', 1, 'dof_set', 3};

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
                   [1, 2, 3, 4, 5, 6;
                    7, 8, 9, 10, 11, 12;
                    13, 14, 15, 16, 17, 18;
                    19, 20, 21, 22, 23, 24]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {...
                   [25, 26, 27, 28],...
                   [29, 30, 31, 32],...
                   [33, 34, 35, 36]...
                   };
%

end