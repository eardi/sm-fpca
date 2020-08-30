function obj = Get_Mesh_Info(obj,Mesh,SubName)
%Get_Mesh_Info
%
%   This sets (records) mesh info data so that the Finite Element Space knows
%   what mesh it is attached to.
%
%   obj = obj.Get_Mesh_Info(Mesh,SubName);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%   SubName = (string) name of the specific subdomain that obj.DoFmap is
%             defined on. If SubName = [], the obj.DoFmap is defined on the
%             global mesh.

% Copyright (c) 08-16-2014,  Shawn W. Walker

% if the sub-domain is the global mesh
if strcmp(SubName,Mesh.Name)
    SubName = []; % then assume default
end

obj.Mesh_Info.Name     = Mesh.Name;
obj.Mesh_Info.SubName  = SubName;
if ~isempty(SubName)
    obj.Mesh_Info.SubIndex = Mesh.Get_Subdomain_Index(SubName);
    if (obj.Mesh_Info.SubIndex < 1)
        err = FELerror;
        err = err.Add_Comment(['The sub-domain ', SubName, ' is *not* contained in the global mesh.']);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['The global mesh is called ', Mesh.Name, '.']);
        Num_Subdomain = length(Mesh.Subdomain);
        if (Num_Subdomain > 0)
            err = err.Add_Comment('The global mesh contains the following sub-domains:');
            for ind = 1:Num_Subdomain
                err = err.Add_Comment(['', Mesh.Subdomain(ind).Name, '']);
            end
        else
            err = err.Add_Comment('The global mesh contains *no* sub-domains.');
        end
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['Either the name of the global mesh should be "', SubName, '",']);
        err = err.Add_Comment(['    or the mesh should contain a sub-domain named "', SubName, '".']);
        err.Error;
        error('stop!');
    end
else % finite element space is defined on the global mesh
    obj.Mesh_Info.SubIndex = [];
end

status = obj.Verify_Mesh(Mesh);

end