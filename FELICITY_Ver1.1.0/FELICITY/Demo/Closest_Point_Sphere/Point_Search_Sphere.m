function DOM = Point_Search_Sphere()
%Point_Search_Sphere

% Copyright (c) 07-24-2014,  Shawn W. Walker

% define domain (sphere embedded in 3-D)
Sphere = Domain('triangle',3);

% define geometry representation of global domain:  Domain, reference element
% Here we assume the default reference element:
% Lagrange piecewise linear continuous,
% in other words, the domain is a triangulation of a surface (sphere), where each triangle
% is flat (not curved).
G1 = GeoElement(Sphere);

% define a set of domains to point search in
DOM = PointSearches(G1);

% collect together all of the domains to be searched
DOM = DOM.Append_Domain(Sphere);

end