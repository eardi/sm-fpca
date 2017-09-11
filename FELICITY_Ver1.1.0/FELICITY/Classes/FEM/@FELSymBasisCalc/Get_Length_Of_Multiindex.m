function Multiindex_Length = Get_Length_Of_Multiindex(obj)
%Get_Length_Of_Multiindex
%
%   This returns the length of the alpha multi-index for the basis functions
%   stored in this object, i.e. an alpha index is used to retrieve derivative
%   information for the basis function.
%   
%   Multiindex_Length = obj.Get_Length_Of_Multiindex;

% Copyright (c) 03-01-2013,  Shawn W. Walker

if isempty(obj.Orig_Vars)
    Multiindex_Length = obj.Base_Func.input_dim;
else
    Multiindex_Length = length(obj.Orig_Vars);
end

end