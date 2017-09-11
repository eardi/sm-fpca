function DOM = FEL_Pt_Search_triangle()
%FEL_Pt_Search_triangle

% Copyright (c) 06-13-2014,  Shawn W. Walker

% define domain (flat)
Omega = Domain('triangle');

% define geometry representation of global domain: Domain, reference element
G1 = GeoElement(Omega);

% define a set of domains to point search in
DOM = PointSearches(G1);

% collect together all of the domains to be searched
DOM = DOM.Append_Domain(Omega);

end