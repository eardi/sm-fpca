function BasisFunc = Get_Unique_Array_Of_BasisFuncs(obj)
%Get_Unique_Array_Of_BasisFuncs
%
%   This returns a cell array containing a unique list of BasisFunc(s).

% Copyright (c) 06-19-2012,  Shawn W. Walker

Map_Names = containers.Map;

Num_Integration = length(obj.Integration);
for ind = 1:Num_Integration
    BF = obj.Integration(ind).BasisFunc;
    BF_keys = BF.keys;
    Num_BF = length(BF_keys);
    for ci = 1:Num_BF
        BF_specific = BF(BF_keys{ci});
        % the CPP_Var string is unique because it contains the Domain of
        % Integration's (DoI) name 
        BF_specific_Name = BF_specific.CPP_Var;
        Map_Names(BF_specific_Name) = BF_specific;
    end
end

BasisFunc = Map_Names.values;

end