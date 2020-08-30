function Geo_Dim = Geo_Dim(obj)
%Geo_Dim
%
%   Returns the (ambient) geometric dimension of the mesh.
%
%   Geo_Dim = obj.Geo_Dim;

% Copyright (c) 04-19-2011,  Shawn W. Walker

Geo_Dim = size(obj.Points,2);

end