function DOM = FEL_Pt_Search_Bending_Plate_2D(deg_geo)
%FEL_Pt_Search_Bending_Plate_2D

% Copyright (c) 03-29-2018,  Shawn W. Walker

% define domain (flat)
Omega = Domain('triangle');

% define geometry representation - Domain, reference element
deg_surf_str = num2str(deg_geo);
Pk_Omega = eval(['lagrange_deg', deg_surf_str, '_dim2();']);
G_Space = GeoElement(Omega,Pk_Omega);

% define a set of domains to point search in
DOM = PointSearches(G_Space);

% collect together all of the domains to be searched
DOM = DOM.Append_Domain(Omega);

end