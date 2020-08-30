function CoefFunc_Names = Get_Unique_CoefFunc_Names(obj)
%Get_Unique_CoefFunc_Names
%
%   This returns a cell array containing a unique list of CoefFunc Func_Names.

% Copyright (c) 06-04-2012,  Shawn W. Walker

Map_Names = containers.Map;

Num_Integration = length(obj.Integration);
for ind = 1:Num_Integration
    CF = obj.Integration(ind).CoefFunc;
    CF_keys = CF.keys;
    Num_CF = length(CF_keys);
    for ci = 1:Num_CF
        Func_Name = CF(CF_keys{ci}).Func_Name;
        Map_Names(Func_Name) = ind; % dummy value
    end
end

CoefFunc_Names = Map_Names.keys;

end