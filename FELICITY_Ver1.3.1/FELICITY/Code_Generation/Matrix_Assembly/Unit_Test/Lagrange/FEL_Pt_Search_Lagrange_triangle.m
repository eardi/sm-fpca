function DOM = FEL_Pt_Search_Lagrange_triangle(DIM)
%FEL_Pt_Search_Lagrange_triangle

% Copyright (c) 04-04-2018,  Shawn W. Walker

% define domain
if (DIM==1)
    Omega = Domain('interval');
    %Gamma = Domain('point') < Omega;
elseif (DIM==2)
    Omega = Domain('triangle');
    %Gamma = Domain('interval') < Omega;
elseif (DIM==3)
    Omega = Domain('tetrahedron');
    %Gamma = Domain('triangle') < Omega;
else
    error('Invalid!');
end

% define geometry representation - Domain, reference element
G_Space = GeoElement(Omega);

% define a set of domains to point search in
DOM = PointSearches(G_Space);

% collect together all of the domains to be searched
DOM = DOM.Append_Domain(Omega);

end