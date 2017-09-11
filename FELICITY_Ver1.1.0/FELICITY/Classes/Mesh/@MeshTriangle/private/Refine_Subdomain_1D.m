function New_Subdomain = Refine_Subdomain_1D(Subdomain,Num_Old_Tri)
%Refine_Subdomain_1D
%
%   This refines the given subdomain.  note: this is called by
%   'Refine_Tri_Mesh_1to4', so see it for more info.

% Copyright (c) 04-15-2011,  Shawn W. Walker

% NOTE:
% the first column of Subdomain.Data is the index of the cell that contains the
% subdomain (here just an edge).
% the second column contains the local edge index (with sign) that is part
% of the subdomain.

% NOTE: this routine assumes that the refinement is uniform 1-to-4.

% get a mask for each of the three local edge possibilities
Mask_E1 = (abs(Subdomain.Data(:,2)) == 1);
Mask_E2 = (abs(Subdomain.Data(:,2)) == 2);
Mask_E3 = (abs(Subdomain.Data(:,2)) == 3);
SIGN    = sign(Subdomain.Data(:,2));

% b/c of the way the new triangle list is ordered (see 'Refine_Tri_Mesh_1to4'),
% it is straightforward to update the cell that a edge belongs to

% create the new subdomain DATA (init)
TEMP1_Data = Subdomain.Data;
TEMP2_Data = Subdomain.Data;

% that edge belongs to Tri2 (edge 3) and Tri3 (edge 2)
TEMP1_Data(Mask_E1,1) = Subdomain.Data(Mask_E1,1) + 1*Num_Old_Tri;
TEMP1_Data(Mask_E1,2) = 3*SIGN(Mask_E1,1);
TEMP2_Data(Mask_E1,1) = Subdomain.Data(Mask_E1,1) + 2*Num_Old_Tri;
TEMP2_Data(Mask_E1,2) = 2*SIGN(Mask_E1,1);

% that edge belongs to Tri3 (edge 3) and Tri1 (edge 2)
TEMP1_Data(Mask_E2,1) = Subdomain.Data(Mask_E2,1) + 2*Num_Old_Tri;
TEMP1_Data(Mask_E2,2) = 3*SIGN(Mask_E2,1);
%TEMP2_Data(Mask_E2,1) = Subdomain.Data(Mask_E2,1) + 0*Num_Old_Tri; % no need to update
TEMP2_Data(Mask_E2,2) = 2*SIGN(Mask_E2,1);

% that edge belongs to Tri1 (edge 3) and Tri2 (edge 2)
%TEMP1_Data(Mask_E3,1) = Subdomain.Data(Mask_E3,1) + 0*Num_Old_Tri; % no need to update
TEMP1_Data(Mask_E3,2) = 3*SIGN(Mask_E3,1);
TEMP2_Data(Mask_E3,1) = Subdomain.Data(Mask_E3,1) + 1*Num_Old_Tri;
TEMP2_Data(Mask_E3,2) = 2*SIGN(Mask_E3,1);

% output the new subdomain labeling
New_Subdomain = Subdomain;
New_Subdomain.Data = [TEMP1_Data; TEMP2_Data];

% good to sort the data
New_Subdomain.Data = sortrows(New_Subdomain.Data,1);

end