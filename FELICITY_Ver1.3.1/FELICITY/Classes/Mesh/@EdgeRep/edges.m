function EDGE = edges(obj)
%edges
%
%   This mimics the analogous MATLAB:TriRep method.
%
%   EDGE = obj.edges;
%
%   EDGE = mesh edges (i.e. the 1-D triangulation).

% Copyright (c) 02-23-2015,  Shawn W. Walker

EDGE = obj.ConnectivityList;

end