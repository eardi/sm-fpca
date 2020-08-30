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

% Copyright (c) 06-20-2012,  Shawn W. Walker

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