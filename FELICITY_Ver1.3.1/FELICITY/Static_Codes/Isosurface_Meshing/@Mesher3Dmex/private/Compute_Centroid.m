function CT = Compute_Centroid(p,t)
%Compute_Centroid
%
%   Compute centroid of tets.

% Copyright (c) 10-13-2011,  Shawn W. Walker

CT = (1/4) * ( p(t(:,1),:) + p(t(:,2),:) + p(t(:,3),:) + p(t(:,4),:) );

end