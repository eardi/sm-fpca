function [TF, LOC] = isConnected(obj,arg1,arg2)
%isConnected
%
%   This mimics the analogous MATLAB:TriRep method.  Tests whether a pair of
%   vertices are joined by an edge.
%
%   [TF, LOC] = obj.isConnected(V1,V2);
%
%   V1, V2 = column vectors (of indices) representing pairs of vertices.
%
%   TF  = array of 1/0 (true/false) flags, where each entry TF(i) is true if
%         V1(i), V2(i) is an edge in the mesh.
%   LOC = global edge indices corresponding to given vertex pairs, i.e.
%         obj.ConnectivityList(LOC(TF),:) corresponds directly to [V1, V2], though
%         the column order may be different.
%
%   [TF, LOC] = obj.isConnected(EDGE);
%
%   Same as before, except EDGE = [V1, V2].

% Copyright (c) 04-13-2011,  Shawn W. Walker

% sort along columns so we can compare
if nargin == 3
    EDGE = sort([arg1, arg2],2);
else
    EDGE = sort(arg1,2);
end
[TF, LOC] = ismember(EDGE,sort(obj.ConnectivityList,2),'rows');

end