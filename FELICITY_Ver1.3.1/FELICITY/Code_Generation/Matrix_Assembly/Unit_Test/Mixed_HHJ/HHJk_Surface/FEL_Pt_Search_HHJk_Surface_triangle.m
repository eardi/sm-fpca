function DOM = FEL_Pt_Search_HHJk_Surface_triangle(deg_geo)
%FEL_Pt_Search_HHJk_Surface_triangle

% Copyright (c) 03-30-2018,  Shawn W. Walker

% define domain (flat)
Gamma = Domain('triangle',3);

% define geometry representation - Domain, reference element
deg_surf_str = num2str(deg_geo);
Pk_Gamma = eval(['lagrange_deg', deg_surf_str, '_dim2();']);
G_Space = GeoElement(Gamma,Pk_Gamma);

% define a set of domains to point search in
DOM = PointSearches(G_Space);

% collect together all of the domains to be searched
DOM = DOM.Append_Domain(Gamma);

end