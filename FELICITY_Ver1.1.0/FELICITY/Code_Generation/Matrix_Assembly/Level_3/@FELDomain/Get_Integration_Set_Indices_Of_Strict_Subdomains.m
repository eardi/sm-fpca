function Indices = Get_Integration_Set_Indices_Of_Strict_Subdomains(obj)
%Get_Integration_Set_Indices_Of_Strict_Subdomains
%
%   This returns an array of indices that index into the ``Integration_Set''
%   struct.  If the array returned is empty, then NONE of the integration_sets
%   are strict subdomains, i.e. all of them are EQUAL to the hold-all domain.
%   If it is not empty, then
%         obj.Integration_Set(Indices)
%   gives the integration sets that are strict sub-domains, i.e. sets that are
%   contained in the hold-all domain but are NOT equal to the hold-all domain!

% Copyright (c) 02-28-2012,  Shawn W. Walker

Num_Int_Sets = length(obj.Integration_Set);

TF = false(Num_Int_Sets,1);
for ind = 1:Num_Int_Sets
    % if the names are different
    if ~strcmp(obj.Integration_Set(ind).Name,obj.Hold_All.Name)
        % then it is a STRICT subdomain!
        TF(ind) = true;
        break;
    end
end

All_Indices = (1:1:Num_Int_Sets)';
Indices = All_Indices(TF,1);

end