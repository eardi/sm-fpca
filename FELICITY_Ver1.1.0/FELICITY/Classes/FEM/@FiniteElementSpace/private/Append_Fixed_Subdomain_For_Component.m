function obj = Append_Fixed_Subdomain_For_Component(obj,Mesh,Fixed_Subdomain_Name,Comp)
%Append_Fixed_Subdomain_For_Component
%
%   This appends a subdomain name to the cell array of fixed DoF subdomains,
%   i.e. this records a mesh subdomain where the DoFs on that subdomain are
%   considered *fixed* (Dirichlet condition) for a particular component.
%
%   obj = obj.Append_Fixed_Subdomain_For_Component(Mesh,Fixed_Subdomain_Name,Comp);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%   Fixed_Subdomain_Name = (string) name of the mesh subdomain to record.
%   Comp = component of tensor-valued space to fix.
%
%   Output is an updated object.

% Copyright (c) 09-07-2012,  Shawn W. Walker

if (Comp > obj.RefElem.Num_Comp)
    error('Component index is too large!');
end

Num_Fixed_Domain = length(obj.Fixed(Comp).Domain);

obj.Fixed(Comp).Domain{Num_Fixed_Domain + 1} = Fixed_Subdomain_Name;

% sort the names
obj.Fixed(Comp).Domain = sort(obj.Fixed(Comp).Domain);

obj.Verify_Mesh(Mesh);

end