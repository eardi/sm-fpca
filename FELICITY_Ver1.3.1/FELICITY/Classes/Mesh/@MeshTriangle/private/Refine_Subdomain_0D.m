function New_Subdomain = Refine_Subdomain_0D(Subdomain,Num_Old_Tri)
%Refine_Subdomain_0D
%
%   This refines the given subdomain.  note: this is called by
%   'Refine_Tri_Mesh_1to4', so see it for more info.

% Copyright (c) 04-15-2011,  Shawn W. Walker

% NOTE:
% the first column of Subdomain.Data is the index of the cell that contains the
% subdomain (here just a vertex).
% the second column contains the local vertex index that is part
% of the subdomain.

% NOTE:
% also remember that all of the old vertex indices are still intact!  New
% vertices are added to the end.  This means that we just need to update which
% cell the subdomain vertex belongs to.

% NOTE: this routine assumes that the refinement is uniform 1-to-4.

% get a mask for each of the three local vertex possibilities
%Mask_V1 = (Subdomain.Data(:,2) == 1); % no need for this
Mask_V2 = (Subdomain.Data(:,2) == 2);
Mask_V3 = (Subdomain.Data(:,2) == 3);

% b/c of the way the new triangle list is ordered (see 'Refine_Tri_Mesh_1to4'),
% it is simple to update the cell that a vertex belongs to.

% create the new subdomain
New_Subdomain = Subdomain;
%New_Subdomain.Data(Mask_V1,1) = Subdomain.Data(Mask_V1,1); % no need to actually update
New_Subdomain.Data(Mask_V2,1) = Subdomain.Data(Mask_V2,1) + Num_Old_Tri;
New_Subdomain.Data(Mask_V3,1) = Subdomain.Data(Mask_V3,1) + 2*Num_Old_Tri;

% moreover, the local vertex index is ALWAYS 1, b/c of the way the new triangles
% are generated
New_Subdomain.Data(:,2) = 1;

% NOTE: the new subdomain contains the same vertices it did before; just the
% enclosing cell that the vertex belongs to may be different.

% good to sort the data
New_Subdomain.Data = sortrows(New_Subdomain.Data,1);

end