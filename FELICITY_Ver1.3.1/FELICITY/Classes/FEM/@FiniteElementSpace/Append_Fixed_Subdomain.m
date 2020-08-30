function obj = Append_Fixed_Subdomain(obj,Mesh,Fixed_Subdomain_Name,ARG)
%Append_Fixed_Subdomain
%
%   This appends a subdomain name to the cell array of fixed DoF subdomains,
%   i.e. this records a mesh subdomain where the DoFs on that subdomain are
%   considered *fixed* (Dirichlet condition).
%
%   obj = obj.Append_Fixed_Subdomain(Mesh,Fixed_Subdomain_Name);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%   Fixed_Subdomain_Name = (string) name of the mesh subdomain.
%
%   Output is an updated object.  If the space is tuple-valued (more than one
%   component), then it is assumed that *all* components are fixed on that
%   subdomain.
%
%   obj = obj.Append_Fixed_Subdomain(Mesh,Fixed_Subdomain_Name,Comp);
%
%   Similar to above case, except 'Comp' specifies which component (in the
%   case of a tuple-valued space) to fix.

% Copyright (c) 03-24-2018,  Shawn W. Walker

if (nargin==3)
    ARG = [];
end
if isempty(ARG)
    ARG = 'all'; % default to all components
end

if strcmpi(ARG,'all')
    % set the same subdomain name for all tuple components
    for ci_1 = 1:obj.Num_Comp(1)
        for ci_2 = 1:obj.Num_Comp(2)
            obj = obj.Append_Fixed_Subdomain_For_Component(Mesh,Fixed_Subdomain_Name,[ci_1, ci_2]);
        end
    end
else
    % just set it for one component
    Comp = obj.Process_Tuple_Component(ARG);
    obj = obj.Append_Fixed_Subdomain_For_Component(Mesh,Fixed_Subdomain_Name,Comp);
end

end