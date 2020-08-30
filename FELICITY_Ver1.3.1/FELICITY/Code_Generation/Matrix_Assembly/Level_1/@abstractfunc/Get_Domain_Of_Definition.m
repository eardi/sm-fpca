function Domain = Get_Domain_Of_Definition(obj)
%Get_Domain_Of_Definition
%
%   This returns the domain that the function is defined/evaluated on.
%   Note: the function could be the *restriction* of some more globally defined
%   function to a subdomain.
%
%   Domain = obj.Get_Domain_Of_Definition;
%
%   Domain = Level 1 Domain object.

% Copyright (c) 05-28-2012,  Shawn W. Walker

if isempty(obj.Domain)
    Domain = obj.Element.Domain; % global function
else
    Domain = obj.Domain; % restricted function
end

end