function GEOM = Get_Local_Geom_Functions(obj,Spaces,Integration_Index)
%Get_Local_Geom_Functions
%
%   This returns a struct containing info about the local geometric functions needed for
%   the current domain of expression.
%   note: geometric functions are ``fresh'' everytime (all options off)

% Copyright (c) 06-12-2014,  Shawn W. Walker

% the Domain of Expression (DoE) geometric information
% SWW: bad notation here!
GEOM.DoI_Geom = Spaces.Integration(Integration_Index).DoI_Geom;

% get other geometric functions
GeomFuncs   = Spaces.Integration(Integration_Index).GeomFunc;
Num_Funcs   = length(GeomFuncs);
Geom_Names  = GeomFuncs.keys;

if (Num_Funcs > 0)
    % geometric function
    GEOM.GF = output_struct(Integration_Index,GeomFuncs(Geom_Names{1}));
    
    for ind = 2:Num_Funcs
        GEOM.GF(ind) = output_struct(Integration_Index,GeomFuncs(Geom_Names{ind}));
    end
else
    GEOM.GF = [];
end

end

function GF = output_struct(Integration_Index,GeomFunc)

% geometric function
GF.func = GeomFunc;
GF.Integration_Index = Integration_Index;

GF.func = GF.func.Reset_Options;

end