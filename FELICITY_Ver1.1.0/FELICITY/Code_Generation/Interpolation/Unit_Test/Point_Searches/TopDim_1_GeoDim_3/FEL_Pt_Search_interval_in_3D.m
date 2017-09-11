function DOM = FEL_Pt_Search_interval_in_3D()
%FEL_Pt_Search_interval_in_3D

% Copyright (c) 07-25-2014,  Shawn W. Walker

% define domain (embedded in 3-D)
Sigma = Domain('interval',3);

% define geometry representation of global domain: Domain, reference element
G1 = GeoElement(Sigma);

% define a set of domains to point search in
DOM = PointSearches(G1);

% collect together all of the domains to be searched
DOM = DOM.Append_Domain(Sigma);

end