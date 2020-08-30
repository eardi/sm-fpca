function [Angles, PH] = Angles(obj,ARG1,ARG2)
%Angles
%
%   This computes the interior angles of each element of the mesh.  Note: only
%   makes sense for 2-D and 3-D meshes.
%
%   [Angles, PH] = obj.Angles(Num_Bins);
%
%   Num_Bins = number of bins to use in histogram (optional argument).
%
%   Angles (in radians):
%       1-D Mesh: [] (case not valid).
%       2-D Mesh: Tx3 matrix, where each row contains the 3 interior angles
%                 of a single triangle in the mesh.  The angles are ordered
%                 with respect to the (local) opposite edge index.
%       3-D Mesh: Tx6 matrix, where each row contains the 6 interior dihedral
%                 angles of a single tetrahedron in the mesh.  The angles are
%                 ordered with respect to the (local) edge index.
%
%   PH = plot handle for the histogram (valid if Num_Bins > 0).
%
%   [Angles, PH] = obj.Angles(Pts,Num_Bins);
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

Angles = Compute_Simplex_Angles(Mesh_Points,obj.ConnectivityList);

if Num_Bins > 0
    PH = obj.Plot_Simplex_Angles(Angles,Num_Bins);
else
    PH = [];
end

end