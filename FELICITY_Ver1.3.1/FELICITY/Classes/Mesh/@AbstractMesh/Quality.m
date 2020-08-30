function [Qual, PH] = Quality(obj,Num_Bins)
%Quality
%
%   This computes the quality metric of all elements in the mesh.  This uses the
%   ratio of the inscribed sphere radius to circumscribed sphere radius.
%
%   [Qual, PH] = obj.Quality(Num_Bins);
%
%   Num_Bins = number of bins to use in histogram (optional argument).
%
%   Qual = column vector of mesh element qualities.
%   PH   = plot handle for the histogram (valid if Num_Bins > 0).

% Copyright (c) 04-13-2011,  Shawn W. Walker

Qual = Compute_Simplex_Quality(obj.Points,obj.ConnectivityList);
%[Qual, Inverted] = Compute_Triangle_Quality_Metric(obj.Vtx(ti).Coord,obj.Top(Top_i).Tri_List(Mask,:));

if nargin < 2
    Num_Bins = 0;
end

if Num_Bins > 0
    PH = obj.Plot_Simplex_Quality(Qual,Num_Bins);
else
    PH = [];
end

end