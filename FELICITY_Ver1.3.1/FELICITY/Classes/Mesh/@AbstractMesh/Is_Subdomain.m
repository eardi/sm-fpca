function TF = Is_Subdomain(obj,SubName)
%Is_Subdomain
%
%   This routine returns whether the given subdomain exists.
%
%   Note: this only checks for strict sub-domains; it does *not* check if
%   the given subdomain name is actually the *global* mesh.
%
%   Sub_Index = obj.Get_Subdomain_Index(SubName);
%
%   SubName = (string) name of the mesh subdomain.

% Copyright (c) 08-31-2016,  Shawn W. Walker

Sub_Index = obj.Get_Subdomain_Index(SubName);
if (Sub_Index > 0)
    TF = true;
else
    TF = false;
end

end