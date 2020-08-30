function Domains = Get_Distinct_Domains(obj)
%Get_Distinct_Domains
%
%   This returns the distinct domains (as a cell array) on which point searching
%   is performed.

% Copyright (c) 06-15-2014,  Shawn W. Walker

Name_MAP = containers.Map; % init

Domain_Names = obj.keys;
for ind = 1:length(Domain_Names)
    Domain = obj.GeomFuncs(Domain_Names{ind}).Domain.Subdomain; % get the sub-domain
    Name_MAP(Domain.Name) = Domain;
end

Domains = Name_MAP.values;

end