function obj = Update_All_GeomFunc_Options(obj,Integration_Index,GEOM)
%Update_All_GeomFunc_Options
%
%   This updates what needs to be computed in the C++ code for the geometric
%   functions in order to compute all basis function transformations and integrands.

% Copyright (c) 01-24-2014,  Shawn W. Walker

% update the DoI geometric function options (this comes before the basis function update!)
obj.Integration(Integration_Index).DoI_Geom = obj.Integration(Integration_Index).DoI_Geom.OR_Options(GEOM.DoI_Geom);
% get name of DoI
DoI_Name = obj.Integration(Integration_Index).DoI_Geom.Domain.Integration_Domain.Name;

% now update the extra geometric functions
for gi = 1:length(GEOM.GF)
    Local_GF = GEOM.GF(gi).func;
    % get geometry domain name (see 'Setup_FELGeoms' in '@L1toL3\private' to compare)
    Geom_Domain_Name = Local_GF.Domain.Subdomain.Name;
    % make a simple error check
    if strcmp(Geom_Domain_Name,DoI_Name)
        disp('An "extra" geometric function is the same as the Domain of Integration geometric function!');
        disp('This should NOT happen!');
        error('stop');
    end
    obj.Integration(Integration_Index).GeomFunc(Geom_Domain_Name) = ...
    obj.Integration(Integration_Index).GeomFunc(Geom_Domain_Name).OR_Options(Local_GF);
end

% now update *all* geometric function options based on what the basis functions require
obj = obj.Update_GeomFunc_Options_From_Basis_Functions(Integration_Index);

% test_GFs = obj.Integration(Integration_Index).GeomFunc.values;
% for kk = 1:length(test_GFs)
%     test_GFs{kk}
% end

end