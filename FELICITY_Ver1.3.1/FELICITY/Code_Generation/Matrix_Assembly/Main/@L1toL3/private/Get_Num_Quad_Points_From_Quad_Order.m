function [Num_Quad, Top_Dim] = Get_Num_Quad_Points_From_Quad_Order(Quad_Order,Domain_Type)
%Get_Num_Quad_Points_From_Quad_Order
%
%   This converts the quadrature order into the actual number of points
%   to use (which, of course, depends on the dimension and quad rule).

% Copyright (c) 05-27-2010,  Shawn W. Walker

DIM_1 = false;
DIM_2 = false;
DIM_3 = false;
if strcmp(Domain_Type,'interval')
    DIM_1 = true;
    Top_Dim = 1;
elseif strcmp(Domain_Type,'triangle')
    DIM_2 = true;
    Top_Dim = 2;
elseif strcmp(Domain_Type,'tetrahedron')
    DIM_3 = true;
    Top_Dim = 3;
else
    error('Domain_Type not recognized!');
end

% determine number of quad points accordingly
if DIM_1
    Num_Quad = ceil(Quad_Order/2);
elseif DIM_2
    Implemented_Num_Points = [1,3,4,6,7,9,12,13,19,28,37];
    DO = Implemented_Num_Points - Quad_Order;
    Mask_Pos = DO > -1e-12;
    Pos_Points = Implemented_Num_Points(Mask_Pos);
    if isempty(Pos_Points)
        error('Quadrature order must be <= 37.');
    else
        Num_Quad = min(Pos_Points);
    end
elseif DIM_3
    Implemented_Num_Points = [1,4,5,10,11,14,15,24,31,45];
    DO = Implemented_Num_Points - Quad_Order;
    Mask_Pos = DO > -1e-12;
    Pos_Points = Implemented_Num_Points(Mask_Pos);
    if isempty(Pos_Points)
        error('Quadrature order must be <= 45.');
    else
        Num_Quad = min(Pos_Points);
    end
else
    error('You should not be here!!!  The Dimension is too high.');
end

% minor error check
if Num_Quad < 1
    error('There should be at least one quadrature point!');
end

end