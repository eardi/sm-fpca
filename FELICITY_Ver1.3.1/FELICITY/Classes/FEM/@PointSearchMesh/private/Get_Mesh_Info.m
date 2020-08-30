function obj = Get_Mesh_Info(obj,Mesh)
%Get_Mesh_Info
%
%   This sets (records) mesh info data so that the Point Searching code knows
%   what mesh it is attached to.
%
%   obj = obj.Get_Mesh_Info(Mesh);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.

% Copyright (c) 08-31-2016,  Shawn W. Walker

% record for error checking later
obj.Mesh_Info.Name     = Mesh.Name;
obj.Mesh_Info.Num_Cell = Mesh.Num_Cell();

Num_Subdomains = length(Mesh.Subdomain);
if (Num_Subdomains==0)
    % do nothing
else
    for ind = 1:Num_Subdomains
        obj.Mesh_Info.Sub(ind).Name = Mesh.Subdomain(ind).Name;
    end
end

status = obj.Verify_Mesh(Mesh);

end