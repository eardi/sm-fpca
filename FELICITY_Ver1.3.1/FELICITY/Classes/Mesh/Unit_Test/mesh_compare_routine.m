function status = mesh_compare_routine(Mesh,Mesh_REF)
%mesh_compare_routine
%
%   Routine to compare two FELICITY meshes.

% Copyright (c) 01-01-2011,  Shawn W. Walker

status = 0; % default

if ~isequal(Mesh,Mesh_REF)
    
    % ensure meshes match
    X_Err = max(abs(Mesh.Points(:) - Mesh_REF.Points(:)));
    T_Err = max(abs(Mesh.ConnectivityList(:) - Mesh_REF.ConnectivityList(:)));
    if or(X_Err > 1e-15,T_Err > 0)
        disp('Test Failed for Mesh structure comparison.');
        status = 1;
    end
    if ~strcmp(Mesh.Name,Mesh_REF.Name)
        disp('Test Failed for Mesh Name comparison.');
        status = 1;
    end
    
    % ensure subdomains match
    Num_Sub = length(Mesh.Subdomain);
    for ind = 1:Num_Sub
        Name_Match = strcmp(Mesh.Subdomain(ind).Name,Mesh_REF.Subdomain(ind).Name);
        if ~Name_Match
            disp('Test Failed for Subdomain Name comparison.');
            status = 1;
        end
        D_Err = max(abs(Mesh.Subdomain(ind).Data(:) - Mesh_REF.Subdomain(ind).Data(:)));
        if D_Err > 0
            disp('Test Failed for Subdomain Data comparison.');
            status = 1;
        end
        if (Mesh.Subdomain(ind).Dim~=Mesh_REF.Subdomain(ind).Dim)
            disp('Test Failed for Subdomain Dimension comparison.');
            status = 1;
        end
    end
end

end