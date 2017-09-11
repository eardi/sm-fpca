function New_Subdomain = Refine_Subdomain_2D(Subdomain,Num_Old_Tri)
%Refine_Subdomain_2D
%
%   This refines the given subdomain.  note: this is called by
%   'Refine_Tri_Mesh_1to4', so see it for more info.

% Copyright (c) 04-15-2011,  Shawn W. Walker

% NOTE:
% the ONLY column of Subdomain.Data is the index of the cell that IS part of the
% subdomain (here just a triangle).

% NOTE: this routine assumes that the refinement is uniform 1-to-4.

% b/c of the way the new triangle list is ordered (see 'Refine_Tri_Mesh_1to4'),
% it is straightforward to update the triangles that belong to the subdomain

% create new subdomain
New_Subdomain = Subdomain;
New_Subdomain.Data = [Subdomain.Data;
                      Subdomain.Data + 1*Num_Old_Tri;
                      Subdomain.Data + 2*Num_Old_Tri;
                      Subdomain.Data + 3*Num_Old_Tri];
%

% good to sort the data
New_Subdomain.Data = sortrows(New_Subdomain.Data,1);

end