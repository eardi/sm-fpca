function Codim = Get_Codim_For_Basis_Function(obj)
%Get_Codim_For_Basis_Function
%
%   This returns the co-dimension of the subdomain relative to which domain the
%   basis function is defined on.

% Copyright (c) 03-19-2012,  Shawn W. Walker

Subdomain_Dim = obj.Domain.Subdomain.Top_Dim;
DoI_Dim       = obj.Domain.Integration_Domain.Top_Dim;

Codim = Subdomain_Dim - DoI_Dim;

end