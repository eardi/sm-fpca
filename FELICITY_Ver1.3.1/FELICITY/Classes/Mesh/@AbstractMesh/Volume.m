function [Vol, PH] = Volume(obj,ARG1,ARG2)
%Volume
%
%   This computes the volume of all simplices in the mesh.
%
%   [Vol, PH] = obj.Volume(Num_Bins);
%
%   Num_Bins = number of bins to use in histogram (optional argument).
%
%   Vol = column vector of mesh element volumes.
%   PH  = plot handle for the histogram (valid if Num_Bins > 0).
%
%   [Vol, PH] = obj.Volume(Pts,Num_Bins);
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

Vol = Compute_Simplex_Vol(Mesh_Points,obj.ConnectivityList);

if Num_Bins > 0
    PH = obj.Plot_Simplex_Volume(Vol,Num_Bins);
else
    PH = [];
end

end