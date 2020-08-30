function [FV, FX] = freeBoundary(obj)
%freeBoundary
%
%   This mimics the analogous MATLAB:TriRep method.
%
%   FV = obj.freeBoundary;
%
%   FV = Mx1 matrix of free boundary vertices that index into the vertex
%        coordinates obj.Points.
%
%   [FV, FX] = obj.freeBoundary;
%
%   FV = Mx1 matrix of free boundary vertices that index into the compact array
%        of vertex coordinates FX.
%   FX = MxD matrix of vertex coordinates, D = geometric dimension.

% Copyright (c) 04-13-2011,  Shawn W. Walker

ALL_VTX_INDICES = unique(obj.ConnectivityList(:));

[N, BIN] = histc(obj.ConnectivityList(:),ALL_VTX_INDICES);

Mask1 = (N==1);

FV = ALL_VTX_INDICES(Mask1,1);

if nargout < 2
    FX = [];
else
    FX = obj.Points(FV,:);
    % now renumber the list so it is compact!
    FV = (1:1:size(FX,1))';
end

end