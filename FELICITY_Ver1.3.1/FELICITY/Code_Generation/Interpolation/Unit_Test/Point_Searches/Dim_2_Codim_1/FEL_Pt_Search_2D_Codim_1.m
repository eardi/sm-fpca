function DOM = FEL_Pt_Search_2D_Codim_1()
%FEL_Pt_Search_2D_Codim_1

% Copyright (c) 04-12-2018,  Shawn W. Walker

% define domain (flat)
Omega = Domain('triangle');
Gamma = Domain('interval') < Omega;

% define geometry representation of global domain: Domain, reference element
G_Space = GeoElement(Omega);

% define a set of domains to point search in
DOM = PointSearches(G_Space);

% collect together all of the domains to be searched
DOM = DOM.Append_Domain(Gamma);

end