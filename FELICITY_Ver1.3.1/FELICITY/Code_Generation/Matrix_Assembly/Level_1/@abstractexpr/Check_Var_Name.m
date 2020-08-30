function VALID = Check_Var_Name(obj,var_name)
%Check_Var_Name
%
%   This verifies that the given var_name is either a test, trial, coef, or geometric
%   function (for this object).
%
%   VALID = obj.Check_Var_Name(var_name);
%
%   var_name = (string) variable name to check.
%
%   VALID = true if it satisfies the above criteria; false otherwise.

% Copyright (c) 08-01-2011,  Shawn W. Walker

VALID = false;

if ~isempty(obj.TestF)
    if strncmp(var_name,obj.TestF.Name,length(obj.TestF.Name))
        VALID = true;
    end
end
if ~isempty(obj.TrialF)
    if strncmp(var_name,obj.TrialF.Name,length(obj.TrialF.Name))
        VALID = true;
    end
end

for ind = 1:length(obj.CoefF)
    if strncmp(var_name,obj.CoefF(ind).Name,length(obj.CoefF(ind).Name))
        VALID = true;
        break;
    end
end

% check if the variable name corresponds to the geometry function for this abstract
% expression's domain
g_string1 = ['geom', obj.Domain.Name];
if strncmp(var_name,g_string1,length(g_string1))
    VALID = true;
end
% check if the variable name corresponds to any other geometry function (GeoFunc)
for ind = 1:length(obj.GeoF)
    if strncmp(var_name,obj.GeoF(ind).Name,length(obj.GeoF(ind).Name))
        VALID = true;
        break;
    end
end

end