function Elem = lagrange_deg5_dim3(Type_STR)
%lagrange_deg5_dim3
%
%    This defines a reference finite element to be used by FELICITY.
%    INPUT: string = 'CG'/'DG' (continuous/DIScontinuous galerkin).
%
%    Lagrange H^1 Finite Element of degree = 5, in dimension = 3.
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

% Copyright (c) 15-Aug-2019,  Shawn W. Walker

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
Elem.Basis(56).Func = []; % init
Elem.Basis(1).Func = {'(1875*x^2*y^2)/4 - (137*y)/12 - (137*z)/12 - (137*x)/12 - (3125*x^2*y^3)/12 - (3125*x^3*y^2)/12 + (1875*x^2*z^2)/4 - (3125*x^2*z^3)/12 - (3125*x^3*z^2)/12 + (1875*y^2*z^2)/4 - (3125*y^2*z^3)/12 - (3125*y^3*z^2)/12 + (375*x*y)/4 + (375*x*z)/4 + (375*y*z)/4 - (2125*x*y^2)/8 - (2125*x^2*y)/8 + (625*x*y^3)/2 + (625*x^3*y)/2 - (3125*x*y^4)/24 - (3125*x^4*y)/24 - (2125*x*z^2)/8 - (2125*x^2*z)/8 + (625*x*z^3)/2 + (625*x^3*z)/2 - (3125*x*z^4)/24 - (3125*x^4*z)/24 - (2125*y*z^2)/8 - (2125*y^2*z)/8 + (625*y*z^3)/2 + (625*y^3*z)/2 - (3125*y*z^4)/24 - (3125*y^4*z)/24 + (375*x^2)/8 - (2125*x^3)/24 + (625*x^4)/8 - (625*x^5)/24 + (375*y^2)/8 - (2125*y^3)/24 + (625*y^4)/8 - (625*y^5)/24 + (375*z^2)/8 - (2125*z^3)/24 + (625*z^4)/8 - (625*z^5)/24 + (1875*x*y*z^2)/2 + (1875*x*y^2*z)/2 + (1875*x^2*y*z)/2 - (3125*x*y*z^3)/6 - (3125*x*y^3*z)/6 - (3125*x^3*y*z)/6 - (3125*x*y^2*z^2)/4 - (3125*x^2*y*z^2)/4 - (3125*x^2*y^2*z)/4 - (2125*x*y*z)/4 + 1'};
Elem.Basis(2).Func = {'(x*(875*x^2 - 250*x - 1250*x^3 + 625*x^4 + 24))/24'};
Elem.Basis(3).Func = {'(y*(875*y^2 - 250*y - 1250*y^3 + 625*y^4 + 24))/24'};
Elem.Basis(4).Func = {'(z*(875*z^2 - 250*z - 1250*z^3 + 625*z^4 + 24))/24'};
Elem.Basis(5).Func = {'(25*x*(750*x^2*y^2 - 154*y - 154*z - 154*x + 750*x^2*z^2 + 750*y^2*z^2 + 710*x*y + 710*x*z + 710*y*z - 1050*x*y^2 - 1050*x^2*y + 500*x*y^3 + 500*x^3*y - 1050*x*z^2 - 1050*x^2*z + 500*x*z^3 + 500*x^3*z - 1050*y*z^2 - 1050*y^2*z + 500*y*z^3 + 500*y^3*z + 355*x^2 - 350*x^3 + 125*x^4 + 355*y^2 - 350*y^3 + 125*y^4 + 355*z^2 - 350*z^3 + 125*z^4 + 1500*x*y*z^2 + 1500*x*y^2*z + 1500*x^2*y*z - 2100*x*y*z + 24))/24'};
Elem.Basis(6).Func = {'-(25*x*(5*x - 1)*(47*x + 47*y + 47*z - 120*x*y - 120*x*z - 120*y*z + 75*x*y^2 + 75*x^2*y + 75*x*z^2 + 75*x^2*z + 75*y*z^2 + 75*y^2*z - 60*x^2 + 25*x^3 - 60*y^2 + 25*y^3 - 60*z^2 + 25*z^3 + 150*x*y*z - 12))/12'};
Elem.Basis(7).Func = {'(25*x*(25*x^2 - 15*x + 2)*(10*x*y - 9*y - 9*z - 9*x + 10*x*z + 10*y*z + 5*x^2 + 5*y^2 + 5*z^2 + 4))/12'};
Elem.Basis(8).Func = {'-(25*x*(55*x - 150*x^2 + 125*x^3 - 6)*(x + y + z - 1))/24'};
Elem.Basis(9).Func = {'(25*y*(750*x^2*y^2 - 154*y - 154*z - 154*x + 750*x^2*z^2 + 750*y^2*z^2 + 710*x*y + 710*x*z + 710*y*z - 1050*x*y^2 - 1050*x^2*y + 500*x*y^3 + 500*x^3*y - 1050*x*z^2 - 1050*x^2*z + 500*x*z^3 + 500*x^3*z - 1050*y*z^2 - 1050*y^2*z + 500*y*z^3 + 500*y^3*z + 355*x^2 - 350*x^3 + 125*x^4 + 355*y^2 - 350*y^3 + 125*y^4 + 355*z^2 - 350*z^3 + 125*z^4 + 1500*x*y*z^2 + 1500*x*y^2*z + 1500*x^2*y*z - 2100*x*y*z + 24))/24'};
Elem.Basis(10).Func = {'-(25*y*(5*y - 1)*(47*x + 47*y + 47*z - 120*x*y - 120*x*z - 120*y*z + 75*x*y^2 + 75*x^2*y + 75*x*z^2 + 75*x^2*z + 75*y*z^2 + 75*y^2*z - 60*x^2 + 25*x^3 - 60*y^2 + 25*y^3 - 60*z^2 + 25*z^3 + 150*x*y*z - 12))/12'};
Elem.Basis(11).Func = {'(25*y*(25*y^2 - 15*y + 2)*(10*x*y - 9*y - 9*z - 9*x + 10*x*z + 10*y*z + 5*x^2 + 5*y^2 + 5*z^2 + 4))/12'};
Elem.Basis(12).Func = {'-(25*y*(55*y - 150*y^2 + 125*y^3 - 6)*(x + y + z - 1))/24'};
Elem.Basis(13).Func = {'(25*z*(750*x^2*y^2 - 154*y - 154*z - 154*x + 750*x^2*z^2 + 750*y^2*z^2 + 710*x*y + 710*x*z + 710*y*z - 1050*x*y^2 - 1050*x^2*y + 500*x*y^3 + 500*x^3*y - 1050*x*z^2 - 1050*x^2*z + 500*x*z^3 + 500*x^3*z - 1050*y*z^2 - 1050*y^2*z + 500*y*z^3 + 500*y^3*z + 355*x^2 - 350*x^3 + 125*x^4 + 355*y^2 - 350*y^3 + 125*y^4 + 355*z^2 - 350*z^3 + 125*z^4 + 1500*x*y*z^2 + 1500*x*y^2*z + 1500*x^2*y*z - 2100*x*y*z + 24))/24'};
Elem.Basis(14).Func = {'-(25*z*(5*z - 1)*(47*x + 47*y + 47*z - 120*x*y - 120*x*z - 120*y*z + 75*x*y^2 + 75*x^2*y + 75*x*z^2 + 75*x^2*z + 75*y*z^2 + 75*y^2*z - 60*x^2 + 25*x^3 - 60*y^2 + 25*y^3 - 60*z^2 + 25*z^3 + 150*x*y*z - 12))/12'};
Elem.Basis(15).Func = {'(25*z*(25*z^2 - 15*z + 2)*(10*x*y - 9*y - 9*z - 9*x + 10*x*z + 10*y*z + 5*x^2 + 5*y^2 + 5*z^2 + 4))/12'};
Elem.Basis(16).Func = {'-(25*z*(55*z - 150*z^2 + 125*z^3 - 6)*(x + y + z - 1))/24'};
Elem.Basis(17).Func = {'(25*x*y*(55*x - 150*x^2 + 125*x^3 - 6))/24'};
Elem.Basis(18).Func = {'(25*x*y*(5*y - 1)*(25*x^2 - 15*x + 2))/12'};
Elem.Basis(19).Func = {'(25*x*y*(5*x - 1)*(25*y^2 - 15*y + 2))/12'};
Elem.Basis(20).Func = {'(25*x*y*(55*y - 150*y^2 + 125*y^3 - 6))/24'};
Elem.Basis(21).Func = {'(25*y*z*(55*y - 150*y^2 + 125*y^3 - 6))/24'};
Elem.Basis(22).Func = {'(25*y*z*(5*z - 1)*(25*y^2 - 15*y + 2))/12'};
Elem.Basis(23).Func = {'(25*y*z*(5*y - 1)*(25*z^2 - 15*z + 2))/12'};
Elem.Basis(24).Func = {'(25*y*z*(55*z - 150*z^2 + 125*z^3 - 6))/24'};
Elem.Basis(25).Func = {'(25*x*z*(55*z - 150*z^2 + 125*z^3 - 6))/24'};
Elem.Basis(26).Func = {'(25*x*z*(5*x - 1)*(25*z^2 - 15*z + 2))/12'};
Elem.Basis(27).Func = {'(25*x*z*(5*z - 1)*(25*x^2 - 15*x + 2))/12'};
Elem.Basis(28).Func = {'(25*x*z*(55*x - 150*x^2 + 125*x^3 - 6))/24'};
Elem.Basis(29).Func = {'(125*x*y*z*(5*y - 1)*(5*z - 1))/4'};
Elem.Basis(30).Func = {'(125*x*y*z*(25*x^2 - 15*x + 2))/6'};
Elem.Basis(31).Func = {'(125*x*y*z*(5*x - 1)*(5*z - 1))/4'};
Elem.Basis(32).Func = {'(125*x*y*z*(25*y^2 - 15*y + 2))/6'};
Elem.Basis(33).Func = {'(125*x*y*z*(5*x - 1)*(5*y - 1))/4'};
Elem.Basis(34).Func = {'(125*x*y*z*(25*z^2 - 15*z + 2))/6'};
Elem.Basis(35).Func = {'-(125*y*z*(5*y - 1)*(5*z - 1)*(x + y + z - 1))/4'};
Elem.Basis(36).Func = {'-(125*y*z*(47*x + 47*y + 47*z - 120*x*y - 120*x*z - 120*y*z + 75*x*y^2 + 75*x^2*y + 75*x*z^2 + 75*x^2*z + 75*y*z^2 + 75*y^2*z - 60*x^2 + 25*x^3 - 60*y^2 + 25*y^3 - 60*z^2 + 25*z^3 + 150*x*y*z - 12))/6'};
Elem.Basis(37).Func = {'(125*y*z*(5*y - 1)*(10*x*y - 9*y - 9*z - 9*x + 10*x*z + 10*y*z + 5*x^2 + 5*y^2 + 5*z^2 + 4))/4'};
Elem.Basis(38).Func = {'-(125*y*z*(25*z^2 - 15*z + 2)*(x + y + z - 1))/6'};
Elem.Basis(39).Func = {'(125*y*z*(5*z - 1)*(10*x*y - 9*y - 9*z - 9*x + 10*x*z + 10*y*z + 5*x^2 + 5*y^2 + 5*z^2 + 4))/4'};
Elem.Basis(40).Func = {'-(125*y*z*(25*y^2 - 15*y + 2)*(x + y + z - 1))/6'};
Elem.Basis(41).Func = {'-(125*x*z*(5*x - 1)*(5*z - 1)*(x + y + z - 1))/4'};
Elem.Basis(42).Func = {'-(125*x*z*(47*x + 47*y + 47*z - 120*x*y - 120*x*z - 120*y*z + 75*x*y^2 + 75*x^2*y + 75*x*z^2 + 75*x^2*z + 75*y*z^2 + 75*y^2*z - 60*x^2 + 25*x^3 - 60*y^2 + 25*y^3 - 60*z^2 + 25*z^3 + 150*x*y*z - 12))/6'};
Elem.Basis(43).Func = {'(125*x*z*(5*z - 1)*(10*x*y - 9*y - 9*z - 9*x + 10*x*z + 10*y*z + 5*x^2 + 5*y^2 + 5*z^2 + 4))/4'};
Elem.Basis(44).Func = {'-(125*x*z*(25*x^2 - 15*x + 2)*(x + y + z - 1))/6'};
Elem.Basis(45).Func = {'(125*x*z*(5*x - 1)*(10*x*y - 9*y - 9*z - 9*x + 10*x*z + 10*y*z + 5*x^2 + 5*y^2 + 5*z^2 + 4))/4'};
Elem.Basis(46).Func = {'-(125*x*z*(25*z^2 - 15*z + 2)*(x + y + z - 1))/6'};
Elem.Basis(47).Func = {'-(125*x*y*(5*x - 1)*(5*y - 1)*(x + y + z - 1))/4'};
Elem.Basis(48).Func = {'-(125*x*y*(47*x + 47*y + 47*z - 120*x*y - 120*x*z - 120*y*z + 75*x*y^2 + 75*x^2*y + 75*x*z^2 + 75*x^2*z + 75*y*z^2 + 75*y^2*z - 60*x^2 + 25*x^3 - 60*y^2 + 25*y^3 - 60*z^2 + 25*z^3 + 150*x*y*z - 12))/6'};
Elem.Basis(49).Func = {'(125*x*y*(5*x - 1)*(10*x*y - 9*y - 9*z - 9*x + 10*x*z + 10*y*z + 5*x^2 + 5*y^2 + 5*z^2 + 4))/4'};
Elem.Basis(50).Func = {'-(125*x*y*(25*y^2 - 15*y + 2)*(x + y + z - 1))/6'};
Elem.Basis(51).Func = {'(125*x*y*(5*y - 1)*(10*x*y - 9*y - 9*z - 9*x + 10*x*z + 10*y*z + 5*x^2 + 5*y^2 + 5*z^2 + 4))/4'};
Elem.Basis(52).Func = {'-(125*x*y*(25*x^2 - 15*x + 2)*(x + y + z - 1))/6'};
Elem.Basis(53).Func = {'(625*x*y*z*(10*x*y - 9*y - 9*z - 9*x + 10*x*z + 10*y*z + 5*x^2 + 5*y^2 + 5*z^2 + 4))/2'};
Elem.Basis(54).Func = {'-(625*x*y*z*(5*x - 1)*(x + y + z - 1))/2'};
Elem.Basis(55).Func = {'-(625*x*y*z*(5*y - 1)*(x + y + z - 1))/2'};
Elem.Basis(56).Func = {'-(625*x*y*z*(5*z - 1)*(x + y + z - 1))/2'};
% local mapping transformation to use
Elem.Transformation = 'H1_Trans';
Elem.Degree = 5;

% nodal variable data (in the order of their local Degree-of-Freedom index)
% (the nodal point is given in barycentric coordinates)
Elem.Nodal_Var(56).Data = []; % init
Elem.Nodal_Var(1).Data = {[1, 0, 0, 0], 'eval_vertex', 1};
Elem.Nodal_Var(2).Data = {[0, 1, 0, 0], 'eval_vertex', 2};
Elem.Nodal_Var(3).Data = {[0, 0, 1, 0], 'eval_vertex', 3};
Elem.Nodal_Var(4).Data = {[0, 0, 0, 1], 'eval_vertex', 4};
Elem.Nodal_Var(5).Data = {[4/5, 1/5, 0, 0], 'eval_edge', 1};
Elem.Nodal_Var(6).Data = {[3/5, 2/5, 0, 0], 'eval_edge', 1};
Elem.Nodal_Var(7).Data = {[2/5, 3/5, 0, 0], 'eval_edge', 1};
Elem.Nodal_Var(8).Data = {[1/5, 4/5, 0, 0], 'eval_edge', 1};
Elem.Nodal_Var(9).Data = {[4/5, 0, 1/5, 0], 'eval_edge', 2};
Elem.Nodal_Var(10).Data = {[3/5, 0, 2/5, 0], 'eval_edge', 2};
Elem.Nodal_Var(11).Data = {[2/5, 0, 3/5, 0], 'eval_edge', 2};
Elem.Nodal_Var(12).Data = {[1/5, 0, 4/5, 0], 'eval_edge', 2};
Elem.Nodal_Var(13).Data = {[4/5, 0, 0, 1/5], 'eval_edge', 3};
Elem.Nodal_Var(14).Data = {[3/5, 0, 0, 2/5], 'eval_edge', 3};
Elem.Nodal_Var(15).Data = {[2/5, 0, 0, 3/5], 'eval_edge', 3};
Elem.Nodal_Var(16).Data = {[1/5, 0, 0, 4/5], 'eval_edge', 3};
Elem.Nodal_Var(17).Data = {[0, 4/5, 1/5, 0], 'eval_edge', 4};
Elem.Nodal_Var(18).Data = {[0, 3/5, 2/5, 0], 'eval_edge', 4};
Elem.Nodal_Var(19).Data = {[0, 2/5, 3/5, 0], 'eval_edge', 4};
Elem.Nodal_Var(20).Data = {[0, 1/5, 4/5, 0], 'eval_edge', 4};
Elem.Nodal_Var(21).Data = {[0, 0, 4/5, 1/5], 'eval_edge', 5};
Elem.Nodal_Var(22).Data = {[0, 0, 3/5, 2/5], 'eval_edge', 5};
Elem.Nodal_Var(23).Data = {[0, 0, 2/5, 3/5], 'eval_edge', 5};
Elem.Nodal_Var(24).Data = {[0, 0, 1/5, 4/5], 'eval_edge', 5};
Elem.Nodal_Var(25).Data = {[0, 1/5, 0, 4/5], 'eval_edge', 6};
Elem.Nodal_Var(26).Data = {[0, 2/5, 0, 3/5], 'eval_edge', 6};
Elem.Nodal_Var(27).Data = {[0, 3/5, 0, 2/5], 'eval_edge', 6};
Elem.Nodal_Var(28).Data = {[0, 4/5, 0, 1/5], 'eval_edge', 6};
Elem.Nodal_Var(29).Data = {[0, 1/5, 2/5, 2/5], 'eval_facet', 1};
Elem.Nodal_Var(30).Data = {[0, 3/5, 1/5, 1/5], 'eval_facet', 1};
Elem.Nodal_Var(31).Data = {[0, 2/5, 1/5, 2/5], 'eval_facet', 1};
Elem.Nodal_Var(32).Data = {[0, 1/5, 3/5, 1/5], 'eval_facet', 1};
Elem.Nodal_Var(33).Data = {[0, 2/5, 2/5, 1/5], 'eval_facet', 1};
Elem.Nodal_Var(34).Data = {[0, 1/5, 1/5, 3/5], 'eval_facet', 1};
Elem.Nodal_Var(35).Data = {[1/5, 0, 2/5, 2/5], 'eval_facet', 2};
Elem.Nodal_Var(36).Data = {[3/5, 0, 1/5, 1/5], 'eval_facet', 2};
Elem.Nodal_Var(37).Data = {[2/5, 0, 2/5, 1/5], 'eval_facet', 2};
Elem.Nodal_Var(38).Data = {[1/5, 0, 1/5, 3/5], 'eval_facet', 2};
Elem.Nodal_Var(39).Data = {[2/5, 0, 1/5, 2/5], 'eval_facet', 2};
Elem.Nodal_Var(40).Data = {[1/5, 0, 3/5, 1/5], 'eval_facet', 2};
Elem.Nodal_Var(41).Data = {[1/5, 2/5, 0, 2/5], 'eval_facet', 3};
Elem.Nodal_Var(42).Data = {[3/5, 1/5, 0, 1/5], 'eval_facet', 3};
Elem.Nodal_Var(43).Data = {[2/5, 1/5, 0, 2/5], 'eval_facet', 3};
Elem.Nodal_Var(44).Data = {[1/5, 3/5, 0, 1/5], 'eval_facet', 3};
Elem.Nodal_Var(45).Data = {[2/5, 2/5, 0, 1/5], 'eval_facet', 3};
Elem.Nodal_Var(46).Data = {[1/5, 1/5, 0, 3/5], 'eval_facet', 3};
Elem.Nodal_Var(47).Data = {[1/5, 2/5, 2/5, 0], 'eval_facet', 4};
Elem.Nodal_Var(48).Data = {[3/5, 1/5, 1/5, 0], 'eval_facet', 4};
Elem.Nodal_Var(49).Data = {[2/5, 2/5, 1/5, 0], 'eval_facet', 4};
Elem.Nodal_Var(50).Data = {[1/5, 1/5, 3/5, 0], 'eval_facet', 4};
Elem.Nodal_Var(51).Data = {[2/5, 1/5, 2/5, 0], 'eval_facet', 4};
Elem.Nodal_Var(52).Data = {[1/5, 3/5, 1/5, 0], 'eval_facet', 4};
Elem.Nodal_Var(53).Data = {[2/5, 1/5, 1/5, 1/5], 'eval_cell', 1};
Elem.Nodal_Var(54).Data = {[1/5, 2/5, 1/5, 1/5], 'eval_cell', 1};
Elem.Nodal_Var(55).Data = {[1/5, 1/5, 2/5, 1/5], 'eval_cell', 1};
Elem.Nodal_Var(56).Data = {[1/5, 1/5, 1/5, 2/5], 'eval_cell', 1};

%%%%% topological arrangement of nodal points %%%%%
% note: multiple sets of nodal variables can be associated with each topological entity.
%       This is done by defining multiple matrix arrays within each matlab cell.
%       See the FELICITY manual for more info.

% nodes attached to vertices
Elem.Nodal_Top.V = {...
                   [1;
                    2;
                    3;
                    4]...
                   };
%

% nodes attached to edges
Elem.Nodal_Top.E = {...
                   [5, 6, 7, 8;
                    9, 10, 11, 12;
                    13, 14, 15, 16;
                    17, 18, 19, 20;
                    21, 22, 23, 24;
                    25, 26, 27, 28]...
                   };
%

% nodes attached to triangles (faces)
Elem.Nodal_Top.F = {...
                   [29, 30, 31, 32, 33, 34;
                    35, 36, 37, 38, 39, 40;
                    41, 42, 43, 44, 45, 46;
                    47, 48, 49, 50, 51, 52]...
                   };
%

% nodes attached to tetrahedra (cells)
Elem.Nodal_Top.T = {...
                   [53, 54, 55, 56]...
                   };
%

end