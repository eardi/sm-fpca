function Indices = Find_Valid_GeomFunc_Indices(obj,GeomFunc,Space_Domain_Name)
%Find_Valid_GeomFunc_Indices
%
%   This determines which of the GeomFunc(s) are actually valid for this
%   FiniteElementBasisFunction.

% Copyright (c) 04-07-2010,  Shawn W. Walker

Indices = [];
for gi = 1:length(GeomFunc)
    
    if strcmp(GeomFunc(gi).Map_Type,'intrinsic')
        if strcmp(GeomFunc(gi).Domain.Integration_Set.Name,Space_Domain_Name)
            Indices = [gi; Indices];
        end
    elseif strcmp(GeomFunc(gi).Map_Type,'trace')
        if strcmp(GeomFunc(gi).Domain.Hold_All.Name,Space_Domain_Name)
            Indices = [gi; Indices];
        end
    elseif strcmp(GeomFunc(gi).Map_Type,'')
        if and(strcmp(GeomFunc(gi).Domain.Integration_Set.Name,GeomFunc(gi).Domain.Hold_All.Name),...
               strcmp(GeomFunc(gi).Domain.Integration_Set.Name,Space_Domain_Name))
            Indices = [gi; Indices];
        end
    end
    
end

end