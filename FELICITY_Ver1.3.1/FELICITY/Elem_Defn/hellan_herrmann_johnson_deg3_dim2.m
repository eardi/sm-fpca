function Elem = hellan_herrmann_johnson_deg3_dim2(Type_STR)
%hellan_herrmann_johnson_deg3_dim2
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Hellan-Herrmann-Johnson H(div div) Finite Element of degree = 3, in dimension = 2.
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
Elem.Basis(30).Func = []; % init
Elem.Basis(1).Func = {'0', '30*x - 90*x^2 + 70*x^3 - 2'; '30*x - 90*x^2 + 70*x^3 - 2', '0'};
Elem.Basis(2).Func = {'0', '30*y - 90*y^2 + 70*y^3 - 2'; '30*y - 90*y^2 + 70*y^3 - 2', '0'};
Elem.Basis(3).Func = {'0', '20*x + 10*y - 80*x*y + (140*x*y^2)/3 + (280*x^2*y)/3 - 40*x^2 + (560*x^3)/27 - 10*y^2 + (70*y^3)/27 - 2'; '20*x + 10*y - 80*x*y + (140*x*y^2)/3 + (280*x^2*y)/3 - 40*x^2 + (560*x^3)/27 - 10*y^2 + (70*y^3)/27 - 2', '0'};
Elem.Basis(4).Func = {'0', '10*x + 20*y - 80*x*y + (280*x*y^2)/3 + (140*x^2*y)/3 - 10*x^2 + (70*x^3)/27 - 40*y^2 + (560*y^3)/27 - 2'; '10*x + 20*y - 80*x*y + (280*x*y^2)/3 + (140*x^2*y)/3 - 10*x^2 + (70*x^3)/27 - 40*y^2 + (560*y^3)/27 - 2', '0'};
Elem.Basis(5).Func = {'60*y - 180*y^2 + 140*y^3 - 4', '90*y^2 - 30*y - 70*y^3 + 2'; '90*y^2 - 30*y - 70*y^3 + 2', '0'};
Elem.Basis(6).Func = {'480*x*y - 120*y - 120*x - 420*x*y^2 - 420*x^2*y + 240*x^2 - 140*x^3 + 240*y^2 - 140*y^3 + 16', '60*x + 60*y - 240*x*y + 210*x*y^2 + 210*x^2*y - 120*x^2 + 70*x^3 - 120*y^2 + 70*y^3 - 8'; '60*x + 60*y - 240*x*y + 210*x*y^2 + 210*x^2*y - 120*x^2 + 70*x^3 - 120*y^2 + 70*y^3 - 8', '0'};
Elem.Basis(7).Func = {'(40*x)/9 - (200*y)/9 - (320*x*y)/9 - (140*x*y^2)/9 + (700*x^2*y)/9 - (40*x^2)/9 - (140*x^3)/27 + (680*y^2)/9 - (1540*y^3)/27 + 32/27', '(100*y)/9 - (20*x)/9 + (160*x*y)/9 + (70*x*y^2)/9 - (350*x^2*y)/9 + (20*x^2)/9 + (70*x^3)/27 - (340*y^2)/9 + (770*y^3)/27 - 16/27'; '(100*y)/9 - (20*x)/9 + (160*x*y)/9 + (70*x*y^2)/9 - (350*x^2*y)/9 + (20*x^2)/9 + (70*x^3)/27 - (340*y^2)/9 + (770*y^3)/27 - 16/27', '0'};
Elem.Basis(8).Func = {'(380*y)/9 - (40*x)/9 - (1120*x*y)/9 + (1400*x*y^2)/9 + (560*x^2*y)/9 + (400*x^2)/9 - (1120*x^3)/27 - (860*y^2)/9 + (1540*y^3)/27 - 68/27', '(20*x)/9 - (190*y)/9 + (560*x*y)/9 - (700*x*y^2)/9 - (280*x^2*y)/9 - (200*x^2)/9 + (560*x^3)/27 + (430*y^2)/9 - (770*y^3)/27 + 34/27'; '(20*x)/9 - (190*y)/9 + (560*x*y)/9 - (700*x*y^2)/9 - (280*x^2*y)/9 - (200*x^2)/9 + (560*x^3)/27 + (430*y^2)/9 - (770*y^3)/27 + 34/27', '0'};
Elem.Basis(9).Func = {'0', '60*x + 60*y - 240*x*y + 210*x*y^2 + 210*x^2*y - 120*x^2 + 70*x^3 - 120*y^2 + 70*y^3 - 8'; '60*x + 60*y - 240*x*y + 210*x*y^2 + 210*x^2*y - 120*x^2 + 70*x^3 - 120*y^2 + 70*y^3 - 8', '480*x*y - 120*y - 120*x - 420*x*y^2 - 420*x^2*y + 240*x^2 - 140*x^3 + 240*y^2 - 140*y^3 + 16'};
Elem.Basis(10).Func = {'0', '90*x^2 - 30*x - 70*x^3 + 2'; '90*x^2 - 30*x - 70*x^3 + 2', '60*x - 180*x^2 + 140*x^3 - 4'};
Elem.Basis(11).Func = {'0', '(20*y)/9 - (190*x)/9 + (560*x*y)/9 - (280*x*y^2)/9 - (700*x^2*y)/9 + (430*x^2)/9 - (770*x^3)/27 - (200*y^2)/9 + (560*y^3)/27 + 34/27'; '(20*y)/9 - (190*x)/9 + (560*x*y)/9 - (280*x*y^2)/9 - (700*x^2*y)/9 + (430*x^2)/9 - (770*x^3)/27 - (200*y^2)/9 + (560*y^3)/27 + 34/27', '(380*x)/9 - (40*y)/9 - (1120*x*y)/9 + (560*x*y^2)/9 + (1400*x^2*y)/9 - (860*x^2)/9 + (1540*x^3)/27 + (400*y^2)/9 - (1120*y^3)/27 - 68/27'};
Elem.Basis(12).Func = {'0', '(100*x)/9 - (20*y)/9 + (160*x*y)/9 - (350*x*y^2)/9 + (70*x^2*y)/9 - (340*x^2)/9 + (770*x^3)/27 + (20*y^2)/9 + (70*y^3)/27 - 16/27'; '(100*x)/9 - (20*y)/9 + (160*x*y)/9 - (350*x*y^2)/9 + (70*x^2*y)/9 - (340*x^2)/9 + (770*x^3)/27 + (20*y^2)/9 + (70*y^3)/27 - 16/27', '(40*y)/9 - (200*x)/9 - (320*x*y)/9 + (700*x*y^2)/9 - (140*x^2*y)/9 + (680*x^2)/9 - (1540*x^3)/27 - (40*y^2)/9 - (140*y^3)/27 + 32/27'};
Elem.Basis(13).Func = {'60*x*(42*x*y - 30*y - 30*x + 21*x^2 + 21*y^2 + 10)', '1800*x*y - 300*y - 600*x - 1260*x*y^2 - 1890*x^2*y + 1350*x^2 - 840*x^3 + 450*y^2 - 210*y^3 + 60'; '1800*x*y - 300*y - 600*x - 1260*x*y^2 - 1890*x^2*y + 1350*x^2 - 840*x^3 + 450*y^2 - 210*y^3 + 60', '0'};
Elem.Basis(14).Func = {'60*x*(7*x^2 - 6*x + 1)', '360*x*y - 30*y - 420*x - 630*x^2*y + 1170*x^2 - 840*x^3 + 30'; '360*x*y - 30*y - 420*x - 630*x^2*y + 1170*x^2 - 840*x^3 + 30', '0'};
Elem.Basis(15).Func = {'60*x*(21*y^2 - 12*y + 1)', '-30*(21*y^2 - 12*y + 1)*(2*x + y - 1)'; '-30*(21*y^2 - 12*y + 1)*(2*x + y - 1)', '0'};
Elem.Basis(16).Func = {'15*x*(42*x*y - 24*y - 12*x + 7*x^2 + 21*y^2 + 4)', '1170*x*y - 210*y - 240*x - 945*x*y^2 - (2205*x^2*y)/2 + (855*x^2)/2 - 210*x^3 + (675*y^2)/2 - (315*y^3)/2 + 30'; '1170*x*y - 210*y - 240*x - 945*x*y^2 - (2205*x^2*y)/2 + (855*x^2)/2 - 210*x^3 + (675*y^2)/2 - (315*y^3)/2 + 30', '0'};
Elem.Basis(17).Func = {'-15*x*(18*x - 42*y + 42*x*y - 21*x^2 + 42*y^2 - 1)', '(255*y)/2 - 15*x - 630*x*y + 630*x*y^2 + (945*x^2*y)/2 + (405*x^2)/2 - 210*x^3 - 225*y^2 + 105*y^3 - 15/2'; '(255*y)/2 - 15*x - 630*x*y + 630*x*y^2 + (945*x^2*y)/2 + (405*x^2)/2 - 210*x^3 - 225*y^2 + 105*y^3 - 15/2', '0'};
Elem.Basis(18).Func = {'15*x*(12*x - 18*y - 14*x^2 + 21*y^2 + 1)', '120*x - (15*y)/2 - 180*x*y + 315*x^2*y - 315*x^2 + 210*x^3 + (135*y^2)/2 - (105*y^3)/2 - 15/2'; '120*x - (15*y)/2 - 180*x*y + 315*x^2*y - 315*x^2 + 210*x^3 + (135*y^2)/2 - (105*y^3)/2 - 15/2', '0'};
Elem.Basis(19).Func = {'0', '1800*x*y - 600*y - 300*x - 1890*x*y^2 - 1260*x^2*y + 450*x^2 - 210*x^3 + 1350*y^2 - 840*y^3 + 60'; '1800*x*y - 600*y - 300*x - 1890*x*y^2 - 1260*x^2*y + 450*x^2 - 210*x^3 + 1350*y^2 - 840*y^3 + 60', '60*y*(42*x*y - 30*y - 30*x + 21*x^2 + 21*y^2 + 10)'};
Elem.Basis(20).Func = {'0', '-30*(21*x^2 - 12*x + 1)*(x + 2*y - 1)'; '-30*(21*x^2 - 12*x + 1)*(x + 2*y - 1)', '60*y*(21*x^2 - 12*x + 1)'};
Elem.Basis(21).Func = {'0', '360*x*y - 420*y - 30*x - 630*x*y^2 + 1170*y^2 - 840*y^3 + 30'; '360*x*y - 420*y - 30*x - 630*x*y^2 + 1170*y^2 - 840*y^3 + 30', '60*y*(7*y^2 - 6*y + 1)'};
Elem.Basis(22).Func = {'0', '1170*x*y - 240*y - 210*x - (2205*x*y^2)/2 - 945*x^2*y + (675*x^2)/2 - (315*x^3)/2 + (855*y^2)/2 - 210*y^3 + 30'; '1170*x*y - 240*y - 210*x - (2205*x*y^2)/2 - 945*x^2*y + (675*x^2)/2 - (315*x^3)/2 + (855*y^2)/2 - 210*y^3 + 30', '15*y*(42*x*y - 12*y - 24*x + 21*x^2 + 7*y^2 + 4)'};
Elem.Basis(23).Func = {'0', '120*y - (15*x)/2 - 180*x*y + 315*x*y^2 + (135*x^2)/2 - (105*x^3)/2 - 315*y^2 + 210*y^3 - 15/2'; '120*y - (15*x)/2 - 180*x*y + 315*x*y^2 + (135*x^2)/2 - (105*x^3)/2 - 315*y^2 + 210*y^3 - 15/2', '15*y*(12*y - 18*x + 21*x^2 - 14*y^2 + 1)'};
Elem.Basis(24).Func = {'0', '(255*x)/2 - 15*y - 630*x*y + (945*x*y^2)/2 + 630*x^2*y - 225*x^2 + 105*x^3 + (405*y^2)/2 - 210*y^3 - 15/2'; '(255*x)/2 - 15*y - 630*x*y + (945*x*y^2)/2 + 630*x^2*y - 225*x^2 + 105*x^3 + (405*y^2)/2 - 210*y^3 - 15/2', '15*y*(42*x - 18*y - 42*x*y - 42*x^2 + 21*y^2 + 1)'};
Elem.Basis(25).Func = {'0', '1800*x*y - 600*y - 600*x - 1260*x*y^2 - 1260*x^2*y + 900*x^2 - 420*x^3 + 900*y^2 - 420*y^3 + 120'; '1800*x*y - 600*y - 600*x - 1260*x*y^2 - 1260*x^2*y + 900*x^2 - 420*x^3 + 900*y^2 - 420*y^3 + 120', '0'};
Elem.Basis(26).Func = {'0', '-60*(x + y - 1)*(21*x^2 - 12*x + 1)'; '-60*(x + y - 1)*(21*x^2 - 12*x + 1)', '0'};
Elem.Basis(27).Func = {'0', '-60*(x + y - 1)*(21*y^2 - 12*y + 1)'; '-60*(x + y - 1)*(21*y^2 - 12*y + 1)', '0'};
Elem.Basis(28).Func = {'0', '1980*x*y - 420*y - 420*x - 1575*x*y^2 - 1575*x^2*y + 675*x^2 - 315*x^3 + 675*y^2 - 315*y^3 + 60'; '1980*x*y - 420*y - 420*x - 1575*x*y^2 - 1575*x^2*y + 675*x^2 - 315*x^3 + 675*y^2 - 315*y^3 + 60', '0'};
Elem.Basis(29).Func = {'0', '255*y - 15*x - 630*x*y + 630*x*y^2 + 315*x^2*y + 135*x^2 - 105*x^3 - 450*y^2 + 210*y^3 - 15'; '255*y - 15*x - 630*x*y + 630*x*y^2 + 315*x^2*y + 135*x^2 - 105*x^3 - 450*y^2 + 210*y^3 - 15', '0'};
Elem.Basis(30).Func = {'0', '255*x - 15*y - 630*x*y + 315*x*y^2 + 630*x^2*y - 450*x^2 + 210*x^3 + 135*y^2 - 105*y^3 - 15'; '255*x - 15*y - 630*x*y + 315*x*y^2 + 630*x^2*y - 450*x^2 + 210*x^3 + 135*y^2 - 105*y^3 - 15', '0'};
% local mapping transformation to use
Elem.Transformation = 'Hdivdiv_Trans';
Elem.Degree = 3;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(30).Data = []; % init
Elem.Nodal_Var(1).Data = {[0, 1, 0], '[9*y^2 - (11*y)/2 - (9*y^3)/2 + 1]', 'int_facet', 1};
Elem.Nodal_Var(2).Data = {[0, 0, 1], '[(y*(9*y^2 - 9*y + 2))/2]', 'int_facet', 1};
Elem.Nodal_Var(3).Data = {[0, 2/3, 1/3], '[(9*y*(3*y^2 - 5*y + 2))/2]', 'int_facet', 1};
Elem.Nodal_Var(4).Data = {[0, 1/3, 2/3], '[-(9*y*(3*y^2 - 4*y + 1))/2]', 'int_facet', 1};
Elem.Nodal_Var(5).Data = {[0, 0, 1], '[(11*y)/2 + 9*(y - 1)^2 + (9*(y - 1)^3)/2 - 9/2]', 'int_facet', 2};
Elem.Nodal_Var(6).Data = {[1, 0, 0], '[-((y - 1)*(9*y + 9*(y - 1)^2 - 7))/2]', 'int_facet', 2};
Elem.Nodal_Var(7).Data = {[1/3, 0, 2/3], '[-(9*(y - 1)*(5*y + 3*(y - 1)^2 - 3))/2]', 'int_facet', 2};
Elem.Nodal_Var(8).Data = {[2/3, 0, 1/3], '[(9*(y - 1)*(4*y + 3*(y - 1)^2 - 3))/2]', 'int_facet', 2};
Elem.Nodal_Var(9).Data = {[1, 0, 0], '[9*x^2 - (11*x)/2 - (9*x^3)/2 + 1]', 'int_facet', 3};
Elem.Nodal_Var(10).Data = {[0, 1, 0], '[(x*(9*x^2 - 9*x + 2))/2]', 'int_facet', 3};
Elem.Nodal_Var(11).Data = {[2/3, 1/3, 0], '[(9*x*(3*x^2 - 5*x + 2))/2]', 'int_facet', 3};
Elem.Nodal_Var(12).Data = {[1/3, 2/3, 0], '[-(9*x*(3*x^2 - 4*x + 1))/2]', 'int_facet', 3};
Elem.Nodal_Var(13).Data = {[1, 0, 0], '[4*x*y - 3*y - 3*x + 2*x^2 + 2*y^2 + 1, 0; 0, 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(14).Data = {[0, 1, 0], '[x*(2*x - 1), 0; 0, 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(15).Data = {[0, 0, 1], '[y*(2*y - 1), 0; 0, 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(16).Data = {[0, 1/2, 1/2], '[4*x*y, 0; 0, 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(17).Data = {[1/2, 0, 1/2], '[-4*y*(x + y - 1), 0; 0, 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(18).Data = {[1/2, 1/2, 0], '[-4*x*(x + y - 1), 0; 0, 0]', 'int_cell', 1, 'dof_set', 1};
Elem.Nodal_Var(19).Data = {[1, 0, 0], '[0, 0; 0, 4*x*y - 3*y - 3*x + 2*x^2 + 2*y^2 + 1]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(20).Data = {[0, 1, 0], '[0, 0; 0, x*(2*x - 1)]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(21).Data = {[0, 0, 1], '[0, 0; 0, y*(2*y - 1)]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(22).Data = {[0, 1/2, 1/2], '[0, 0; 0, 4*x*y]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(23).Data = {[1/2, 0, 1/2], '[0, 0; 0, -4*y*(x + y - 1)]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(24).Data = {[1/2, 1/2, 0], '[0, 0; 0, -4*x*(x + y - 1)]', 'int_cell', 1, 'dof_set', 2};
Elem.Nodal_Var(25).Data = {[1, 0, 0], '[0, 2*x*y - (3*y)/2 - (3*x)/2 + x^2 + y^2 + 1/2; 2*x*y - (3*y)/2 - (3*x)/2 + x^2 + y^2 + 1/2, 0]', 'int_cell', 1, 'dof_set', 3};
Elem.Nodal_Var(26).Data = {[0, 1, 0], '[0, (x*(2*x - 1))/2; (x*(2*x - 1))/2, 0]', 'int_cell', 1, 'dof_set', 3};
Elem.Nodal_Var(27).Data = {[0, 0, 1], '[0, (y*(2*y - 1))/2; (y*(2*y - 1))/2, 0]', 'int_cell', 1, 'dof_set', 3};
Elem.Nodal_Var(28).Data = {[0, 1/2, 1/2], '[0, 2*x*y; 2*x*y, 0]', 'int_cell', 1, 'dof_set', 3};
Elem.Nodal_Var(29).Data = {[1/2, 0, 1/2], '[0, -2*y*(x + y - 1); -2*y*(x + y - 1), 0]', 'int_cell', 1, 'dof_set', 3};
Elem.Nodal_Var(30).Data = {[1/2, 1/2, 0], '[0, -2*x*(x + y - 1); -2*x*(x + y - 1), 0]', 'int_cell', 1, 'dof_set', 3};

%%%%% topological arrangement of nodal points %%%%%
% note: multiple sets of nodal variables can be associated with each topological entity.
%       This is done by defining multiple matrix arrays within each matlab cell.
%       See the FELICITY manual for more info.

% nodes attached to vertices
Elem.Nodal_Top.V = {[]};

% nodes attached to edges
Elem.Nodal_Top.E = {...
                   [1, 2, 3, 4;
                    5, 6, 7, 8;
                    9, 10, 11, 12]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [13, 14, 15, 16, 17, 18],...
                   [19, 20, 21, 22, 23, 24],...
                   [25, 26, 27, 28, 29, 30]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {[]};

end