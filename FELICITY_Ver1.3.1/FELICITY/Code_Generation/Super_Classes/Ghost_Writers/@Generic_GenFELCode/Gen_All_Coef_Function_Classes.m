function Gen_All_Coef_Function_Classes(obj,FS,For_INTERP)
%Gen_All_Coef_Function_Classes
%
%   This generates a class file for accessing coef function info.

% Copyright (c) 06-13-2014,  Shawn W. Walker

OUT_Dir = fullfile(obj.Output_Dir, obj.Sub_Dir.Coef_Classes);

Num_Int = length(FS.Integration);
for ind = 1:Num_Int
    CF_Set = FS.Integration(ind).CoefFunc;
    CF_Names = CF_Set.keys;
    for k = 1:length(CF_Names)
        CF = CF_Set(CF_Names{k});
        % get basis function that is associated with this coef function
        BasisFunc = FS.Integration(ind).BasisFunc(CF.Space_Name);
        CF.INTERPOLATION = For_INTERP; % indicate if this is for interpolation
        
        CF_Space = FS.Space(CF.Space_Name); % get space information
        CF.Gen_Coef_Function_Class_cc(OUT_Dir,BasisFunc,CF_Space.Num_Comp);
    end
end

end