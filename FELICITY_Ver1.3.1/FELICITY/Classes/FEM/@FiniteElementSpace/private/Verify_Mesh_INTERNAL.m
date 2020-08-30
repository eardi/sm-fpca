function status = Verify_Mesh_INTERNAL(obj,Mesh)
%Verify_Mesh_INTERNAL
%
%   This verifies that the given mesh is linked to this Finite Element Space,
%   i.e. it verifies that 'Mesh' matches what was set by 'Get_Mesh_Info'.

% Copyright (c) 03-24-2018,  Shawn W. Walker

status = 0;

% make sure mesh names match
if ~strcmp(obj.Mesh_Info.Name,Mesh.Name)
    error('Mesh name does not match!');
end
if ~isempty(obj.Mesh_Info.SubName)
    if ~strcmp(obj.Mesh_Info.SubName,Mesh.Subdomain(obj.Mesh_Info.SubIndex).Name)
        error('Subdomain name does not match!');
    end
end

% now check to make sure that the reference finite element makes sense for the
% given subdomain
if ~isempty(obj.Mesh_Info.SubName)
    Sub_Top_Dim = Mesh.Subdomain(obj.Mesh_Info.SubIndex).Dim;
%     Subdomain_Simplex_Type = '';
else
    Sub_Top_Dim = Mesh.Top_Dim;
end
% if isa(Mesh,'MeshInterval')
%     
% elseif isa(Mesh,'MeshTriangle')
% elseif isa(Mesh,'MeshTetrahedron')
% else
%     error('Not implemented!');
% end

% should probably store some extra signature data...

if (obj.RefElem.Top_Dim~=Sub_Top_Dim)
    error('Reference Finite Element must have the same topological dimension as the given mesh (subdomain).');
end

% make sure the DoFmap has the same number of rows as the number of mesh cells
if ~isempty(obj.Mesh_Info.SubName)
    Num_Cells = size(Mesh.Subdomain(obj.Mesh_Info.SubIndex).Data,1);
else
    Num_Cells = Mesh.Num_Cell;
end
if ~isempty(obj.DoFmap)
    if (size(obj.DoFmap,1)~=Num_Cells)
        err = FELerror;
        err = err.Add_Comment(['The number of cells in the domain of the finite element space is ', num2str(Num_Cells), '.']);
        err = err.Add_Comment(['The number of rows in the DoFmap is ', num2str(size(obj.DoFmap,1)), '.']);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['These two numbers must be the *same*, because each row of the DoFmap']);
        err = err.Add_Comment(['   corresponds to a distinct cell in the domain.']);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['Therefore, please fix your Mesh or DoFmap!']);
        err.Error;
        error('stop!');
    end
end
% check that the number of columns in the DoFmap is correct
if ~isempty(obj.DoFmap)
    NC = size(obj.DoFmap,2);
    Num_Basis = obj.RefElem.Num_Basis;
    if (NC~=Num_Basis)
        err = FELerror;
        err = err.Add_Comment(['The number of *local* basis functions on the reference element']);
        err = err.Add_Comment(['   of the finite element space is ', num2str(Num_Basis), '.']);
        err = err.Add_Comment(['The number of columns in the DoFmap is ', num2str(NC), '.']);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['These two numbers must be the *same*, because each column of the DoFmap']);
        err = err.Add_Comment(['   corresponds to a distinct local basis function of the reference element.']);
        err = err.Add_Comment(' ');
        err = err.Add_Comment(['Therefore, please fix your DoFmap!']);
        err.Error;
        error('stop!');
    end
end

% make sure any fixed subdomains are actually defined in the Mesh!
if ~isempty(obj.Num_Comp)
    for ci_1 = 1:obj.Num_Comp(1)
        for ci_2 = 1:obj.Num_Comp(2)
            Num_Fixed_Domain = length(obj.Fixed(ci_1,ci_2).Domain);
            for di = 1:Num_Fixed_Domain
                Fixed_SubName = obj.Fixed(ci_1,ci_2).Domain{di};
                Sub_Index = Mesh.Get_Subdomain_Index(Fixed_SubName);
                if (Sub_Index==0)
                    err = FELerror;
                    err = err.Add_Comment(['This fixed sub-domain: ', Fixed_SubName]);
                    err = err.Add_Comment(['    was not found in the given Mesh.']);
                    err = err.Add_Comment(' ');
                    err = err.Add_Comment('Make sure your Mesh and/or your FiniteElementSpace is properly defined!');
                    err.Error;
                    error('stop!');
                end
            end
        end
    end
end

end