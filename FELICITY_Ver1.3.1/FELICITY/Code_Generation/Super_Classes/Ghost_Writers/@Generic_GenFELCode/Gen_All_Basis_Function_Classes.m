function Gen_All_Basis_Function_Classes(obj,FS,For_INTERP)
%Gen_All_Basis_Function_Classes
%
%   This generates a class file for accessing basis function info.

% Copyright (c) 06-13-2014,  Shawn W. Walker

OUT_Dir = fullfile(obj.Output_Dir, obj.Sub_Dir.Basis_Classes);

Num_Int = length(FS.Integration);
for ind = 1:Num_Int
    BF_Set = FS.Integration(ind).BasisFunc;
    BF_Names = BF_Set.keys;
    for k = 1:length(BF_Names)
        BF = BF_Set(BF_Names{k});
        Data_Type = BF.CPP_Data_Type;
        BF.INTERPOLATION = For_INTERP; % indicate if this is for interpolation
        
        BF_Space = FS.Space(BF.Space_Name); % get space information
        BF.Gen_Basis_Function_Class_cc(OUT_Dir,Data_Type,BF_Space.Num_Comp);
    end
end

end