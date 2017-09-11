function DOM = FEL_Pt_Search_interval()
%FEL_Pt_Search_interval

% Copyright (c) 07-25-2014,  Shawn W. Walker

% define domain (flat)
Omega = Domain('interval');

% define geometry representation of global domain: Domain, reference element
G1 = GeoElement(Omega);

% define a set of domains to point search in
DOM = PointSearches(G1);

% collect together all of the domains to be searched
DOM = DOM.Append_Domain(Omega);

end