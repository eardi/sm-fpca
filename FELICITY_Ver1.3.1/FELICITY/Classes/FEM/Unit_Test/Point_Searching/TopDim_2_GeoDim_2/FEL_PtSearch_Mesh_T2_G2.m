function DOM = FEL_PtSearch_Mesh_T2_G2()
%FEL_PtSearch_Mesh_T2_G2

% Copyright (c) 08-31-2016,  Shawn W. Walker

% define domain (flat)
Omega = Domain('triangle');

% define geometry representation of global domain: Domain, reference element
G1 = GeoElement(Omega);

% define a set of domains to point search in
DOM = PointSearches(G1);

% collect together all of the domains to be searched
DOM = DOM.Append_Domain(Omega);

end