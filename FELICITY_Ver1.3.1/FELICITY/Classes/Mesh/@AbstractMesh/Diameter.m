function [Diam, PH] = Diameter(obj,ARG1,ARG2)
%Diameter
%
%   This computes the diameter of each element of the mesh.  Note: in 2-D
%   and 3-D, the diameter is *defined* to be the length of the longest
%   edge.  In 1-D, it is simply the length of the interval.
%
%   [Diam, PH] = obj.Diameter(Num_Bins);
%
%   Num_Bins = number of bins to use in histogram (optional argument).
%
%   Diam: Mx1 column vector, where each row contains the diameter of a
%         single element in the mesh.
%
%   PH = plot handle for the histogram (valid if Num_Bins > 0).
%
%   [Diam, PH] = obj.Diameter(Pts,Num_Bins);
%
%   Similar to above, except it uses "Pts" instead of the mesh vertices
%   (obviously, Pts should be compatible with the mesh).  Num_Bins is an
%   optional argument.

% Copyright (c) 04-12-2018,  Shawn W. Walker

if (nargin==1)
    Num_Bins = 0;
    Mesh_Points = obj.Points;
elseif (nargin==2)
    if and(size(ARG1,1)==1,size(ARG1,2)==1)
        % just want bins
        Num_Bins = ARG1;
        Mesh_Points = obj.Points;
    else
        % alternate points
        Num_Bins = 0;
        Mesh_Points = ARG1;
    end
else
    % alternate points and bins
    Mesh_Points = ARG1;
    Num_Bins = ARG2;
end

if (obj.Num_Vtx ~= size(Mesh_Points,1))
    error('Number of points does not match present mesh structure.');
end
if (obj.Geo_Dim ~= size(Mesh_Points,2))
    error('Dimension of points does not match present mesh structure.');
end

Diam = Compute_Simplex_Diameters(Mesh_Points,obj.ConnectivityList);

if Num_Bins > 0
    PH = obj.Plot_Simplex_Diameters(Diam,Num_Bins);
else
    PH = [];
end

end