function Func = Find_Basis_Function_On_Domain(obj,Space_Name,Given_Integration_Domain)
%Find_Basis_Function_On_Domain
%
%   This returns a FiniteElementBasisFunction.

% Copyright (c) 06-18-2012,  Shawn W. Walker

Func = []; % init

if nargin==2
    for index = 1:length(obj.Integration)
        BF_Set = obj.Integration(index).BasisFunc;
        BF_Set_Names = BF_Set.keys;
        if ismember(Space_Name,BF_Set_Names)
            Func = BF_Set(Space_Name);
            break;
        end
    end
else
    Int_Index = obj.Get_Integration_Index(Given_Integration_Domain);
    BF_Set = obj.Integration(Int_Index).BasisFunc;
    BF_Set_Names = BF_Set.keys;
    if ismember(Space_Name,BF_Set_Names)
        Func = BF_Set(Space_Name);
    end
end

% if isempty(Func)
%     disp('Warning: Basis Function not found!');
% end

end