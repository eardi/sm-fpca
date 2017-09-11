function Interp = Get_Interpolations_On_Domain(obj,Dom_Name)
%Get_Interpolations_On_Domain
%
%   This returns the interpolations defined on the given Domain.

% Copyright (c) 02-03-2013,  Shawn W. Walker

Interp_MAP = containers.Map; % init

Interp_Names = obj.keys;
for ind = 1:length(Interp_Names)
    Domain = obj.Interp(Interp_Names{ind}).Domain;
    if strcmp(Dom_Name,Domain.Name)
        Interp_MAP(Interp_Names{ind}) = obj.Interp(Interp_Names{ind});
    end
end

Interp = Interp_MAP.values;

end