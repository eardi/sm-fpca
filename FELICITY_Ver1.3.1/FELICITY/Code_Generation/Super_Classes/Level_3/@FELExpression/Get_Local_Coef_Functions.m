function CF = Get_Local_Coef_Functions(obj,Spaces,Integration_Index)
%Get_Local_Coef_Functions
%
%   This returns a struct containing info about the local coefficient functions.
%   note: coef functions are ``fresh'' everytime (all options off)

% Copyright (c) 03-24-2017,  Shawn W. Walker

Coefs = Spaces.Integration(Integration_Index).CoefFunc;
Num_Funcs = length(Coefs);
Coef_Names = Coefs.keys;

if (Num_Funcs > 0)
    % coefficient function
    CF = output_struct(Spaces,Integration_Index,Coefs(Coef_Names{1}));
    
    for ind = 2:Num_Funcs
        CF(ind) = output_struct(Spaces,Integration_Index,Coefs(Coef_Names{ind}));
    end
else
    CF = [];
end

end

function CF = output_struct(Spaces,Integration_Index,CoefFunc)

% coefficient function
CF.str  = CoefFunc.Func_Name;
CF.func = CoefFunc;
CF.Integration_Index = Integration_Index;

% store the vector dimension of FE space
f_Space = Spaces.Space(CF.func.Space_Name);
CF.Space_Num_Comp = f_Space.Num_Comp;

CF.func = CF.func.Reset_Options;

end