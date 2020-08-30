function Deriv_str = Append_Multiindex_Derivative_String(obj,Deriv_Multiindex)
%Append_Multiindex_Derivative_String
%
%   This returns a string representing a multiindex derivative.
%
%   Note: Deriv_Multiindex is 1x3 vector, where Deriv_Multiindex(j)
%   indicates the number of derivatives to take with respect to x_j
%   (i.e. the jth coordinate).
%
%   Output looks like:   '1_2_3',  if  Deriv_Multiindex = [1 2 3];

% Copyright (c) 09-13-2016,  Shawn W. Walker

Deriv_str = [num2str(Deriv_Multiindex(1)), '_',...
             num2str(Deriv_Multiindex(2)), '_',...
             num2str(Deriv_Multiindex(3))];
%

end