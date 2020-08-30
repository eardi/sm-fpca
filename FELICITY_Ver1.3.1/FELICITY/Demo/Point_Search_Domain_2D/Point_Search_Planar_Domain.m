function DOM = Point_Search_Planar_Domain()
%Point_Search_Planar_Domain

% Copyright (c) 08-01-2014,  Shawn W. Walker

% define domain
Omega = Domain('triangle');

% define geometry representation of the global mesh domain
G1 = GeoElement(Omega); % arguments are: Domain, reference element (optional)

% define a set of domains to point search in
DOM = PointSearches(G1);

% input the domain to be searched
DOM = DOM.Append_Domain(Omega);

end