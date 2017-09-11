function [Angles, PH] = Angles(obj,Num_Bins)
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

% Copyright (c) 02-14-2013,  Shawn W. Walker

Angles = Compute_Simplex_Angles(obj.X,obj.Triangulation);

if nargin < 2
    Num_Bins = 0;
end

if Num_Bins > 0
    PH = obj.Plot_Simplex_Angles(Angles,Num_Bins);
else
    PH = [];
end

end