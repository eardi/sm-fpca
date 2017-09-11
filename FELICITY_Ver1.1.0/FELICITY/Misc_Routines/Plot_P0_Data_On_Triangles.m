function PH = Plot_P0_Data_On_Triangles(Vtx,Tri,P0_Value)
%Get_Edge_to_Tri_Data
%
%   This plots piecewise constant data on a triangular grid.
%   Adapted from a MATLAB code   by   John Burkardt.
%
%   PH = Plot_P0_Data_On_Triangles(Vtx,Tri,P0_Value);
%
%   Vtx, Tri = triangle mesh data.
%   P0_Value = column vector (length = number of triangles in mesh) of constant
%              values; row i corresponds to Tri(i,:).
%
%   PH = returns a column vector of handles to PATCH objects (see MATLAB's fill3).

% Copyright (c) 03-27-2012,  Shawn W. Walker

zmax = max(P0_Value);
zmin = min(P0_Value);

% pick the colors that will correspond to the minimum and maximum values of Z
rmax = 0.8;
gmax = 0.2;
bmax = 0.1;

rmin = 0.1;
gmin = 0.3;
bmin = 0.7;

PH = []; % init
hold on;
for ti = 1:size(Tri,1)
    
    % Pick out the nodes of the triangle.
    x1 = Vtx(Tri(ti,1),1);
    y1 = Vtx(Tri(ti,1),2);
    x2 = Vtx(Tri(ti,2),1);
    y2 = Vtx(Tri(ti,2),2);
    x3 = Vtx(Tri(ti,3),1);
    y3 = Vtx(Tri(ti,3),2);

    z = P0_Value(ti);
    
    % Draw the top of the prism, using a color corresponding to the height.
    r = ( ( zmax - z ) * rmin + ( z - zmin ) * rmax ) / ( zmax - zmin );
    g = ( ( zmax - z ) * gmin + ( z - zmin ) * gmax ) / ( zmax - zmin );
    b = ( ( zmax - z ) * bmin + ( z - zmin ) * bmax ) / ( zmax - zmin );
    PH = fill3( [ x1, x2, x3 ], [ y1, y2, y3 ], [ z, z, z ], [ r, g, b ] );
    
%     % Draw the bottom of the prism, using black.
%     fill3( [ x1, x2, x3 ], [ y1, y2, y3 ], [ 0, 0, 0 ], [ rmin, gmin, bmin ] );
% 
%     % Draw the sides of the prism, using a lighter shade of the top color.
%     r = sqrt( r );
%     g = sqrt( g );
%     b = sqrt( b );
%     
%     fill3( [ x1, x2, x2, x1 ], [ y1, y2, y2, y1 ], [ 0, 0, z, z ], [ r, g, b ] );
%     fill3( [ x2, x3, x3, x2 ], [ y2, y3, y3, y2 ], [ 0, 0, z, z ], [ r, g, b ] );
%     fill3( [ x3, x1, x1, x3 ], [ y3, y1, y1, y3 ], [ 0, 0, z, z ], [ r, g, b ] );
end
hold off;

view(3);

end