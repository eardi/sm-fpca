function Elem = hellan_herrmann_johnson_deg2_dim2(Type_STR)
%hellan_herrmann_johnson_deg2_dim2
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Hellan-Herrmann-Johnson H(div div) Finite Element of degree = 2, in dimension = 2.
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

% Copyright (c) 18-Feb-2019,  Shawn W. Walker

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
Elem.Basis(18).Func = []; % init
Elem.Basis(1).Func = {'0', '15*x^2 - 12*x + 3/2'; '15*x^2 - 12*x + 3/2', '0'};
Elem.Basis(2).Func = {'0', '15*y^2 - 12*y + 3/2'; '15*y^2 - 12*y + 3/2', '0'};
Elem.Basis(3).Func = {'0', '15*x*y - 6*y - 6*x + (15*x^2)/4 + (15*y^2)/4 + 3/2'; '15*x*y - 6*y - 6*x + (15*x^2)/4 + (15*y^2)/4 + 3/2', '0'};
Elem.Basis(4).Func = {'30*y^2 - 24*y + 3', '12*y - 15*y^2 - 3/2'; '12*y - 15*y^2 - 3/2', '0'};
Elem.Basis(5).Func = {'60*x*y - 36*y - 36*x + 30*x^2 + 30*y^2 + 9', '18*x + 18*y - 30*x*y - 15*x^2 - 15*y^2 - 9/2'; '18*x + 18*y - 30*x*y - 15*x^2 - 15*y^2 - 9/2', '0'};
Elem.Basis(6).Func = {'15*y - 3*x - 15*x*y + (15*x^2)/2 - 15*y^2 - 3/2', '(3*x)/2 - (15*y)/2 + (15*x*y)/2 - (15*x^2)/4 + (15*y^2)/2 + 3/4'; '(3*x)/2 - (15*y)/2 + (15*x*y)/2 - (15*x^2)/4 + (15*y^2)/2 + 3/4', '0'};
Elem.Basis(7).Func = {'0', '18*x + 18*y - 30*x*y - 15*x^2 - 15*y^2 - 9/2'; '18*x + 18*y - 30*x*y - 15*x^2 - 15*y^2 - 9/2', '60*x*y - 36*y - 36*x + 30*x^2 + 30*y^2 + 9'};
Elem.Basis(8).Func = {'0', '12*x - 15*x^2 - 3/2'; '12*x - 15*x^2 - 3/2', '30*x^2 - 24*x + 3'};
Elem.Basis(9).Func = {'0', '(3*y)/2 - (15*x)/2 + (15*x*y)/2 + (15*x^2)/2 - (15*y^2)/4 + 3/4'; '(3*y)/2 - (15*x)/2 + (15*x*y)/2 + (15*x^2)/2 - (15*y^2)/4 + 3/4', '15*x - 3*y - 15*x*y - 15*x^2 + (15*y^2)/2 - 3/2'};
Elem.Basis(10).Func = {'-24*x*(5*x + 5*y - 4)', '120*x*y - 48*y - 96*x + 90*x^2 + 30*y^2 + 18'; '120*x*y - 48*y - 96*x + 90*x^2 + 30*y^2 + 18', '0'};
Elem.Basis(11).Func = {'12*x*(5*x - 2)', '84*x + 12*y - 60*x*y - 90*x^2 - 12'; '84*x + 12*y - 60*x*y - 90*x^2 - 12', '0'};
Elem.Basis(12).Func = {'24*x*(5*y - 1)', '-12*(5*y - 1)*(2*x + y - 1)'; '-12*(5*y - 1)*(2*x + y - 1)', '0'};
Elem.Basis(13).Func = {'0', '120*x*y - 96*y - 48*x + 30*x^2 + 90*y^2 + 18'; '120*x*y - 96*y - 48*x + 30*x^2 + 90*y^2 + 18', '-24*y*(5*x + 5*y - 4)'};
Elem.Basis(14).Func = {'0', '-12*(5*x - 1)*(x + 2*y - 1)'; '-12*(5*x - 1)*(x + 2*y - 1)', '24*y*(5*x - 1)'};
Elem.Basis(15).Func = {'0', '12*x + 84*y - 60*x*y - 90*y^2 - 12'; '12*x + 84*y - 60*x*y - 90*y^2 - 12', '12*y*(5*y - 2)'};
Elem.Basis(16).Func = {'0', '120*x*y - 96*y - 96*x + 60*x^2 + 60*y^2 + 36'; '120*x*y - 96*y - 96*x + 60*x^2 + 60*y^2 + 36', '0'};
Elem.Basis(17).Func = {'0', '-24*(5*x - 1)*(x + y - 1)'; '-24*(5*x - 1)*(x + y - 1)', '0'};
Elem.Basis(18).Func = {'0', '-24*(5*y - 1)*(x + y - 1)'; '-24*(5*y - 1)*(x + y - 1)', '0'};
% local mapping transformation to use
Elem.Transformation = 'Hdivdiv_Trans';
Elem.Degree = 2;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(18).Data = []; % init
Elem.Nodal_Var(1).Data = {[0, 1, 0], '[2*y^2 - 3*y + 1]', 'int_facet', 1};
Elem.Nodal_Var(2).Data = {[0, 0, 1], '[y*(2*y - 1)]', 'int_facet', 1};
Elem.Nodal_Var(3).Data = {[0, 1/2, 1/2], '[-4*y*(y - 1)]', 'int_facet', 1};
Elem.Nodal_Var(4).Data = {[0, 0, 1], '[3*y + 2*(y - 1)^2 - 2]', 'int_facet', 2};
Elem.Nodal_Var(5).Data = {[1, 0, 0], '[(2*y - 1)*(y - 1)]', 'int_facet', 2};
Elem.Nodal_Var(6).Data = {[1/2, 0, 1/2], '[-4*y*(y - 1)]', 'int_facet', 2};
Elem.Nodal_Var(7).Data = {[1, 0, 0], '[2*x^2 - 3*x + 1]', 'int_facet', 3};
Elem.Nodal_Var(8).Data = {[0, 1, 0], '[x*(2*x - 1)]', 'int_facet', 3};
Elem.Nodal_Var(9).Data = {[1/2, 1/2, 0], '[-4*x*(x - 1)]', 'int_facet', 3};
Elem.Nodal_Var(10).Data = {[1, 0, 0], '[1 - y - x, 0; 0, 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(11).Data = {[0, 1, 0], '[x, 0; 0, 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(12).Data = {[0, 0, 1], '[y, 0; 0, 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(13).Data = {[1, 0, 0], '[0, 0; 0, 1 - y - x]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(14).Data = {[0, 1, 0], '[0, 0; 0, x]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(15).Data = {[0, 0, 1], '[0, 0; 0, y]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(16).Data = {[1, 0, 0], '[0, 1/2 - y/2 - x/2; 1/2 - y/2 - x/2, 0]', 'int_cell', 1, 'dof_set', 3};
Elem.Nodal_Var(17).Data = {[0, 1, 0], '[0, x/2; x/2, 0]', 'int_cell', 1, 'dof_set', 3};
Elem.Nodal_Var(18).Data = {[0, 0, 1], '[0, y/2; y/2, 0]', 'int_cell', 1, 'dof_set', 3};

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
                   [13, 14, 15],...
                   [16, 17, 18]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end