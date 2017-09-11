function DOM = FEL_Pt_Search_triangle_in_3D()
%FEL_Pt_Search_triangle_in_3D

% Copyright (c) 07-18-2014,  Shawn W. Walker

% define domain (embedded in 3-D)
Gamma = Domain('triangle',3);

% define geometry representation of global domain: Domain, reference element
G1 = GeoElement(Gamma);

% define a set of domains to point search in
DOM = PointSearches(G1);

% collect together all of the domains to be searched
DOM = DOM.Append_Domain(Gamma);

end