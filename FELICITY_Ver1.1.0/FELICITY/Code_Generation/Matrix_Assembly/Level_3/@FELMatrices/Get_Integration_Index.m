function Int_Index = Get_Integration_Index(obj,Given_Integration_Domain)
%Get_Integration_Index
%
%   This returns the index of the integration struct with matching domain of
%   integration.
%   Note: Given_Integration_Domain = is a Level 1 Domain.

% Copyright (c) 06-03-2012,  Shawn W. Walker

% compare to the Domain of Integration (DoI)
Int_Index = 0;
for ind = 1:length(obj.Integration)
    DoI = obj.Integration(ind).Domain.Integration_Domain;
    if isequal(DoI,Given_Integration_Domain)
        Int_Index = ind;
        break;
    end
end

if (Int_Index==0)
    error('Given_Integration_Domain not found in obj.Integration(:).Domain.Integration_Domain!');
end

end