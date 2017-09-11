function INDEX = Get_Integration_Set_Index(obj,Domain_Name)
%Get_Integration_Set_Index
%
%   This finds the index of the domain from the given name.

% Copyright (c) 04-10-2010,  Shawn W. Walker

INDEX = 0;
for ind = 1:length(obj.Integration_Set)
    if strcmp(obj.Integration_Set(ind).Name,Domain_Name)
        INDEX = ind;
        break;
    end
end

end