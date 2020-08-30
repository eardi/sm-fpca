function Sub_Index = Get_Subdomain_Index(obj,SubName)
%Get_Subdomain_Index
%
%   This routine finds the sub-domain index of the given subdomain.
%   If not found, it returns 0.
%
%   Sub_Index = obj.Get_Subdomain_Index(SubName);
%
%   SubName = (string) name of the mesh subdomain.

% Copyright (c) 04-15-2011,  Shawn W. Walker

Sub_Index = 0; % init
for ind = 1:length(obj.Subdomain)
    if strcmp(obj.Subdomain(ind).Name,SubName)
        Sub_Index = ind;
        break;
    end
end

end