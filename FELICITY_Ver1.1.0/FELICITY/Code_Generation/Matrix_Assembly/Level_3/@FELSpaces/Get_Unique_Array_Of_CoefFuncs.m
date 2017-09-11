function CoefFunc = Get_Unique_Array_Of_CoefFuncs(obj)
%Get_Unique_Array_Of_CoefFuncs
%
%   This returns a cell array containing a unique list of CoefFunc(s).

% Copyright (c) 06-04-2012,  Shawn W. Walker

Map_Names = containers.Map;

Num_Integration = length(obj.Integration);
for ind = 1:Num_Integration
    CF = obj.Integration(ind).CoefFunc;
    CF_keys = CF.keys;
    Num_CF = length(CF_keys);
    for ci = 1:Num_CF
        CF_specific = CF(CF_keys{ci});
        CF_specific_Name = CF_specific.CPP_Var;
        Map_Names(CF_specific_Name) = CF_specific;
    end
end

CoefFunc = Map_Names.values;

end