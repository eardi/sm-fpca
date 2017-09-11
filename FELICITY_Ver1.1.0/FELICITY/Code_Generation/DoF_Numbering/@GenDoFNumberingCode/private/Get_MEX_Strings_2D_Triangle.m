function mex_strings = Get_MEX_Strings_2D_Triangle(SPACE_LEN,Num_Elem)
%Get_MEX_Strings_2D_Triangle
%
%   This just generates the useful strings for creating the main mex file.

% Copyright (c) 04-07-2010,  Shawn W. Walker

% inputs
mex_strings.PRHS(1).str     = 'PRHS_Tri_List';
%mex_strings.PRHS(2).str     = 'PRHS_Edge_List';

% % outputs
% mex_strings.PLHS(1).str     = 'PLHS_Pos_Edge_to_Tri';
% mex_strings.PLHS(2).str     = 'PLHS_Neg_Edge_to_Tri';

% include statements
mex_strings.INCLUDE(1).str  = '#include "Triangle_Edge_Search.cc"';

for ind=1:length(mex_strings.PRHS)
    mex_strings.PRHS(ind).aligned = [Pad_With_Whitespace(mex_strings.PRHS(ind).str, SPACE_LEN), num2str(ind-1)];
end
% for ind=1:length(mex_strings.PLHS)
%     mex_strings.PLHS(ind).aligned = [Pad_With_Whitespace(mex_strings.PLHS(ind).str, SPACE_LEN), num2str(ind-1 + Num_Elem)];
% end

end