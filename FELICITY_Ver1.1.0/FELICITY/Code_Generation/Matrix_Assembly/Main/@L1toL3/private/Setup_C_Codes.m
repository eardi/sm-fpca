function Extra_C_Code = Setup_C_Codes(obj,Main_Dir)
%Setup_C_Codes
%
%   This just massages the C_Codes struct to fit into the Level 3 object syntax.

% Copyright (c) 08-01-2011,  Shawn W. Walker

% init
Extra_C_Code.FileName = [];

Num_C_Codes = length(obj.MATS.C_Codes);
for ind = 1:Num_C_Codes
    CC = obj.MATS.C_Codes(ind);
    
    % if Path = [], then use the directory (Main_Dir) that contains the m-script
    if isempty(CC.Path)
        ECC.FileName = fullfile(Main_Dir, [CC.File, CC.Ext]);
    else
        ECC.FileName = fullfile(CC.Path, [CC.File, CC.Ext]);
    end
    Extra_C_Code(ind) = ECC;
end

end