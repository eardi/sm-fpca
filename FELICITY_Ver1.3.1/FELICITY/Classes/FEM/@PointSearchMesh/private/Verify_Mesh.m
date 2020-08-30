function status = Verify_Mesh(obj,Mesh)
%Verify_Mesh
%
%   This verifies that the given mesh is linked to point searching on the
%   given mesh, i.e. it verifies that 'Mesh' matches what was set by
%   'Get_Mesh_Info', and that it matches obj.Pt_Search_Struct.

% Copyright (c) 08-31-2016,  Shawn W. Walker

status = 0;

% make sure mesh names match
if ~strcmp(obj.Mesh_Info.Name,Mesh.Name)
    error('Mesh name does not match!');
end

% make sure number of cells is the same
if (obj.Mesh_Info.Num_Cell~=Mesh.Num_Cell())
    error('Mesh cells do not match!');
end

% make sure sub-domain names match
Num_Subdomains = length(Mesh.Subdomain);
Num_Subdomains_CHK = length(obj.Mesh_Info.Sub);
if (Num_Subdomains_CHK==1)
    % make sure is not empty
    if isempty(obj.Mesh_Info.Sub.Name)
        Num_Subdomains_CHK = 0;
    end
end
if (Num_Subdomains~=Num_Subdomains_CHK)
    error('Mesh does not have the same number of sub-domains!');
end
if (Num_Subdomains==0)
    % do nothing
else
    for ind = 1:Num_Subdomains
        if ~strcmp(obj.Mesh_Info.Sub(ind).Name,Mesh.Subdomain(ind).Name)
            error('Mesh sub-domain names do not match!  Or out of order!');
        end
    end
end

% this is too annoying to check!!!
% % make sure search domain is in the Mesh
% Is_Global_Domain  = strcmp(obj.Pt_Search_Struct.Search_Domain.Name,Mesh.Name);
% Is_Mesh_Subdomain = Mesh.Is_Subdomain(obj.Pt_Search_Struct.Search_Domain.Name);
% if ~or(Is_Global_Domain,Is_Mesh_Subdomain)
%     obj.Pt_Search_Struct.Search_Domain.Name
%     Mesh.Name
%     error('Search domain is not in the mesh!');
% end

% check geometric dimension
GD = obj.Pt_Search_Struct.Search_Domain.GeoDim;
if (GD~=Mesh.Geo_Dim)
    error('Geometric dimension of mesh does not match Point Search dimension!');
end

end