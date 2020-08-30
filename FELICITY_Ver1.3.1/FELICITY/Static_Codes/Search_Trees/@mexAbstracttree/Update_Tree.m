function obj = Update_Tree(obj,new_pts)
%Update_Tree
%
%   This accepts a new set of points and updates the tree to accommodate the new point
%   coordinates.
%
%   obj = obj.Update_Tree(new_pts);
%
%   new_pts = Mxd matrix of point coordinates (d = space dimension).
%
%   Note: M must equal the number of rows of obj.Points, because this method replaces
%         obj.Points with new_pts.

% Copyright (c) 01-14-2014,  Shawn W. Walker

[nr, nc] = size(new_pts);
if (nr~=size(obj.Points,1))
    error('The number of points must be the same as the original set of points.');
end
if (nc~=obj.dim)
    DIM_STR = num2str(obj.dim);
    ERR_STR = ['The given points must be in ', DIM_STR, '-D (i.e. have ', DIM_STR, ' columns).'];
    error(ERR_STR);
end
if (nargout~=1)
    error('You must return the updated MATLAB object!');
end

obj.Points = new_pts; % overwrite points
obj.cppMEX('update_tree', obj.cppHandle, obj.Points);

end