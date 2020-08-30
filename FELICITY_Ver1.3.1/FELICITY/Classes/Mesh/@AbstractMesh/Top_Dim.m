function TD = Top_Dim(obj)
%Top_Dim
%
%   Returns the topological dimension of the mesh.
%
%   TD = obj.Top_Dim;

% Copyright (c) 04-19-2011,  Shawn W. Walker

TD = size(obj.ConnectivityList,2) - 1;

end