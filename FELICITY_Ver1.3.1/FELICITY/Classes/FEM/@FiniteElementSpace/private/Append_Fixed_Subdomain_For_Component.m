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
%   Comp = component of tuple-valued space to fix (row vector of length 1 or 2).
%
%   Output is an updated object.

% Copyright (c) 03-26-2018,  Shawn W. Walker

Comp = obj.Process_Tuple_Component(Comp);

Num_Fixed_Domain = length(obj.Fixed(Comp(1),Comp(2)).Domain);

obj.Fixed(Comp(1),Comp(2)).Domain{Num_Fixed_Domain + 1} = Fixed_Subdomain_Name;

% sort the names
obj.Fixed(Comp(1),Comp(2)).Domain = sort(obj.Fixed(Comp(1),Comp(2)).Domain);

obj.Verify_Mesh(Mesh);

end