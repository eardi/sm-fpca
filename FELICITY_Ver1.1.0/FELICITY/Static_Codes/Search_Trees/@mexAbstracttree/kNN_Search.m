function [Indices, Dist] = kNN_Search(obj,pts,num_neighbor)
%kNN_Search
%
%   For each point in pts, this finds the closest point in the tree to it.
%
%   [Indices, Dist] = obj.kNN_Search(pts,num_neighbor);
%
%   pts          = Qxd matrix of query point coordinates (d = space dimension).
%   num_neighbor = number of neighbors to return = K.
%
%   Indices = QxK matrix, where each row contains integer indices that index into the
%             rows of obj.Points, i.e. row i contains the K nearest neighbors of the ith
%             point in obj.Points.
%   Dist    = QxK matrix, similar to Indices except contains the corresponding distances.

% Copyright (c) 01-14-2014,  Shawn W. Walker

nc = size(pts,2);
if (nc~=obj.dim)
    DIM_STR = num2str(obj.dim);
    ERR_STR = ['The given query points must be in ', DIM_STR, '-D (i.e. have ', DIM_STR, ' columns).'];
    error(ERR_STR);
end
if (nargin < 3)
    num_neighbor = 1; % default
end

if (nargout <= 1)
    Indices = obj.cppMEX('knn_search', obj.cppHandle, pts, num_neighbor);
    Dist = [];
else
    [Indices, Dist] = obj.cppMEX('knn_search', obj.cppHandle, pts, num_neighbor);
end

end