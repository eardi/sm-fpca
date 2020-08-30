function Embed = Create_Embedding_Data(obj,Sub,DoI)
%Create_Embedding_Data
%
%   This fills in a struct containing the embedding information for the given
%   individual embeddings Sub and DoI.
%
%   Embed = obj.Create_Embedding_Data(Sub,DoI);
%
%   Sub = struct of the form:
%         Sub.Name
%         Sub.Dim
%         Sub.Data,
%         which is the subdomain data referenced to the global mesh. Sub
%         corresponds to a "Subdomain" (see 'Generate_Subdomain_Embedding_Data'
%         in 'AbstractMesh').
%   DoI = struct of the same form as Sub, except it corresponds to a "Domain of
%         Integration" (or "Domain of Expression").
%
%   Embed = struct of the form:
%         Embed.Global_Name             = Name of the Global Mesh;
%         Embed.Subdomain_Name          = Name of the Subdomain;
%         Embed.Integration_Domain_Name = Name of the DoI;
%         Embed.Global_Cell_Index       = column vector containing Global Mesh
%                                         cell indices;
%         Embed.Subdomain_Cell_Index    = ... Subdomain cell indices;
%         Embed.Subdomain_Entity_Index  = ... Subdomain *entity* indices;
%         Embed.Integration_Domain_Entity_Index = ... DoI *entity* indices;
%
%   Note: this struct is for interfacing with the auto generated matrix assembly
%   routine.  Also see: FELDomain::Write_Sub_DoI_Embedding_Info_in_Setup_Data.

% Copyright (c) 06-27-2012,  Shawn W. Walker

Embed = get_embed_struct();

% store the names
Embed.Global_Name             = obj.Name;
Embed.Subdomain_Name          = Sub.Name;
Embed.Integration_Domain_Name = DoI.Name;

% topological dimensions
Global_TD = obj.Top_Dim;
Sub_TD    = Sub.Dim;
DoI_TD    = DoI.Dim;

% temporarily turn this off
warning('off', 'MATLAB:TriRep:PtsNotInTriWarnId');

if and(Global_TD==Sub_TD, Sub_TD==DoI_TD)
    % only need the Cell Indices
    
    % if the domain names are all different
    if and(~strcmp(Embed.Global_Name,Embed.Subdomain_Name),~strcmp(Embed.Subdomain_Name,Embed.Integration_Domain_Name))
        % then we need the Global and Subdomain cells
        Embed.Global_Cell_Index    = DoI.Data(:,1);
        [TF, LOC] = ismember(DoI.Data(:,1),Sub.Data(:,1));
        Embed.Subdomain_Cell_Index = int32(LOC(TF,1));
        if (length(Embed.Global_Cell_Index)~=length(Embed.Subdomain_Cell_Index))
            % then  DoI  cannot be a subset of  Subdomain
            Embed = [];
        end
    else
        % else we don't need the Subdomain cells
        if and(strcmp(Embed.Global_Name,Embed.Subdomain_Name),strcmp(Embed.Subdomain_Name,Embed.Integration_Domain_Name))
            % then we don't need the global cells either
        else
            Embed.Global_Cell_Index = DoI.Data(:,1);
        end
    end
    
elseif and(Global_TD==Sub_TD, Sub_TD > DoI_TD)
    
    if ~strcmp(Embed.Global_Name,Embed.Subdomain_Name)
        % then we need the Global and Subdomain cells, and DoI Entity Index
        % get DoI embedding w.r.t. Subdomain
        Global_Sub = obj.Get_Global_Subdomain(Sub.Name);
        Sub_Mesh = MeshTetrahedron(Global_Sub,obj.Points,'Sub_Mesh');
        Global_DoI = obj.Get_Global_Subdomain(DoI.Name);
        if (DoI_TD==2)
            New_DoI_Data = int32(Sub_Mesh.Get_Subdomain_2D(Global_DoI,true)); % STRICT subdomain
        elseif (DoI_TD==1)
            New_DoI_Data = int32(Sub_Mesh.Get_Subdomain_1D(Global_DoI,true)); % STRICT subdomain
        else
            error('Invalid!');
        end
        
        if isempty(New_DoI_Data)
            % then  DoI  cannot be a subset of  Subdomain
            Embed = [];
        else
            Embed.Subdomain_Cell_Index            = New_DoI_Data(:,1);
            Embed.Integration_Domain_Entity_Index = New_DoI_Data(:,2);
            % find the Global Cells that correspond to the Subdomain Cells
            Embed.Global_Cell_Index = Sub.Data(Embed.Subdomain_Cell_Index,1);
        end
    else
        % just need Global cells and DoI Entity Index
        Embed.Global_Cell_Index               = DoI.Data(:,1);
        Embed.Integration_Domain_Entity_Index = DoI.Data(:,2);
    end
    
elseif and(Global_TD > Sub_TD, Sub_TD==DoI_TD)
    % need Cell Indices and Subdomain Entity Index
    Embed.Global_Cell_Index        = DoI.Data(:,1);
    Embed.Subdomain_Entity_Index   = DoI.Data(:,2);
    
    if ~strcmp(Embed.Subdomain_Name,Embed.Integration_Domain_Name)
        % then we need the Subdomain cells
        Global_DoI = obj.Get_Global_Subdomain(DoI.Name);
        Global_Sub = obj.Get_Global_Subdomain(Sub.Name);
        [TF, LOC] = ismember(sort(Global_DoI,2),sort(Global_Sub,2),'rows'); % this sorting should not cause a problem
        Embed.Subdomain_Cell_Index = int32(LOC(TF,1));
        if (length(Embed.Global_Cell_Index)~=length(Embed.Subdomain_Cell_Index))
            % then  DoI  cannot be a subset of  Subdomain
            Embed = [];
        end
    end
    
elseif and(Global_TD > Sub_TD, Sub_TD > DoI_TD)
    % need both Cell Indices, Subdomain Entity Index, and DoI Entity Index
    
    % global data
    Global_Sub = obj.Get_Global_Subdomain(Sub.Name); % global set of triangles
    Global_DoI = obj.Get_Global_Subdomain(DoI.Name); % global set of edges
    
    % get edge embedding in the surface mesh
    Sub_Mesh = MeshTriangle(Global_Sub,obj.Points,'Sub_Mesh'); % surface mesh
    Sub_Mesh = Sub_Mesh.Append_Subdomain('1D','Global_DoI',Global_DoI);
    New_DoI_Data = Sub_Mesh.Subdomain(1).Data;
    if (size(New_DoI_Data,1)~=size(Global_DoI,1))
        % then  DoI  cannot be a subset of  Subdomain
        Embed = [];
    else
        Embed.Subdomain_Cell_Index            = New_DoI_Data(:,1);
        Embed.Integration_Domain_Entity_Index = New_DoI_Data(:,2);
        % triangle embedding in global mesh:  Sub.Data
        Embed.Global_Cell_Index        = Sub.Data(Embed.Subdomain_Cell_Index,1);
        Embed.Subdomain_Entity_Index   = Sub.Data(Embed.Subdomain_Cell_Index,2);
    end
    
else
    % it must not be a valid choice for DoI and Subdomain, i.e.
    %    DoI  cannot be a subset of  Subdomain
    Embed = [];
end

% turn it back on
warning('on', 'MATLAB:TriRep:PtsNotInTriWarnId');

end

function SS = get_embed_struct()

SS.Global_Name             = [];
SS.Subdomain_Name          = [];
SS.Integration_Domain_Name = [];

SS.Global_Cell_Index               = [];
SS.Subdomain_Cell_Index            = [];
SS.Subdomain_Entity_Index          = [];
SS.Integration_Domain_Entity_Index = [];

end