function BB = Bounding_Box(obj,Pts)
%Bounding_Box
%
%   This returns the cartesian bounding box of the mesh vertices.
%
%   BB = obj.Bounding_Box();
%
%   BB = a row vector containing the bounding box coordinates:
%        1-D: BB = [X_min, X_max]
%        2-D: BB = [X_min, X_max, Y_min, Y_max]
%        3-D: BB = [X_min, X_max, Y_min, Y_max, Z_min, Z_max]
%
%   Note that the dimension refers to the geometric dimension of the mesh.
%
%   BB = obj.Bounding_Box(Pts);
%
%   Returns the bounding box of the given "Pts" instead.  Dimension refers
%   to the dimension of Pts.

% Copyright (c) 04-12-2018,  Shawn W. Walker

if (nargin==2)
    Mesh_Points = Pts;
else
    Mesh_Points = obj.Points;
end

GD = size(Mesh_Points,2);
BB = zeros(1,2*GD);

% loop thru dimensions
for gg=1:3
    if (GD >= gg)
        BB(2*(gg-1)+1) = min(Mesh_Points(:,gg));
        BB(2*gg)       = max(Mesh_Points(:,gg));
    end
end

end