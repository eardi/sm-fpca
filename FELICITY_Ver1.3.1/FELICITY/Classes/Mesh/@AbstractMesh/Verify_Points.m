function TF = Verify_Points(obj,Given_Points)
%Verify_Points
%
%   This verifies that the current mesh points can be replaced by the given
%   points and still have a valid mesh (i.e. no elements will be inverted).
%
%   TF = obj.Verify_Points(Given_Points);
%
%   Given_Points = list of candidate point coordinates
%                  (must be the same size as obj.Points).
%
%   TF = true/false indicating if the given points maintain a valid mesh.

% Copyright (c) 04-12-2018,  Shawn W. Walker

if (obj.Num_Vtx ~= size(Given_Points,1))
    error('Number of points does not match present mesh structure.');
end
if (obj.Geo_Dim ~= size(Given_Points,2))
    error('Dimension of points does not match present mesh structure.');
end

Vol = Compute_Simplex_Vol(Given_Points,obj.ConnectivityList);

% true means we have *ALL* elements with positive volume!
TF = min(Vol) > 0;

end