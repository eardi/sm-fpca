function DOM = FEL_PtSearch_Mesh_T2_G3()
%FEL_PtSearch_Mesh_T2_G3

% Copyright (c) 08-31-2016,  Shawn W. Walker

% define domain (surface)
Gamma = Domain('triangle',3);

% define geometry representation of global domain: Domain, reference element
G1 = GeoElement(Gamma);

% define a set of domains to point search in
DOM = PointSearches(G1);

% collect together all of the domains to be searched
DOM = DOM.Append_Domain(Gamma);

end