function mex_strings = Get_MEX_Strings_1D_Interval(SPACE_LEN,Num_Elem)
%Get_MEX_Strings_1D_Interval
%
%   This just generates the useful strings for creating the main mex file.

% Copyright (c) 04-07-2010,  Shawn W. Walker

% inputs
mex_strings.PRHS(1).str     = 'PRHS_Edge_List';

% % outputs
% mex_strings.PLHS(1).str     = 'PLHS_Tail_Point_to_Edge';
% mex_strings.PLHS(2).str     = 'PLHS_Head_Point_to_Edge';

% include statements
mex_strings.INCLUDE(1).str  = '#include "Edge_Point_Search.cc"';

for ind=1:length(mex_strings.PRHS)
    mex_strings.PRHS(ind).aligned = [Pad_With_Whitespace(mex_strings.PRHS(ind).str, SPACE_LEN), num2str(ind-1)];
end
% for ind=1:length(mex_strings.PLHS)
%     mex_strings.PLHS(ind).aligned = [Pad_With_Whitespace(mex_strings.PLHS(ind).str, SPACE_LEN), num2str(ind-1 + Num_Elem)];
% end

end