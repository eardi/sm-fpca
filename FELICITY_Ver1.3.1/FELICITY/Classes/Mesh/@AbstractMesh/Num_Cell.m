function NC = Num_Cell(obj)
%Num_Cell
%
%   Returns the total number of elements in the mesh.
%
%   NC = obj.Num_Cell;

% Copyright (c) 04-19-2011,  Shawn W. Walker

NC = size(obj.ConnectivityList,1);

end