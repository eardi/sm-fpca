function Domains = Get_Distinct_Domains(obj)
%Get_Distinct_Domains
%
%   This returns the distinct domains (as a cell array) on which
%   interpolation is performed.

% Copyright (c) 01-29-2013,  Shawn W. Walker

Name_MAP = containers.Map; % init

Interp_Names = obj.keys;
for ind = 1:length(Interp_Names)
    Domain = obj.Interp(Interp_Names{ind}).Domain;
    Name_MAP(Domain.Name) = Domain;
end

Domains = Name_MAP.values;

end