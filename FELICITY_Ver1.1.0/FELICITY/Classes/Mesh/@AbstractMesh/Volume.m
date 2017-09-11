function [Vol, PH] = Volume(obj,Num_Bins)
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

% Copyright (c) 04-13-2011,  Shawn W. Walker

Vol = Compute_Simplex_Vol(obj.X,obj.Triangulation);

if nargin < 2
    Num_Bins = 0;
end

if Num_Bins > 0
    PH = obj.Plot_Simplex_Volume(Vol,Num_Bins);
else
    PH = [];
end

end