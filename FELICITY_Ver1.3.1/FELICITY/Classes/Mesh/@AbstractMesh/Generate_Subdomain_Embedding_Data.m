function Embed = Generate_Subdomain_Embedding_Data(obj,Domains_of_Integration)
%Generate_Subdomain_Embedding_Data
%
%   This returns a struct containing the embedding information for all
%   subdomains relative to the given Domains_of_Integration (DoI).
%
%   Embed = obj.Generate_Subdomain_Embedding_Data(Domains_of_Integration);
%
%   Domains_of_Integration = cell array of strings containing the names of
%                            Subdomains in the global mesh.
%
%   Embed = array of structs containing info on how the DoI's are embedded in
%           other subdomains in the mesh; see "Create_Embedding_Data" in the
%           other concrete mesh classes for more info.

% Copyright (c) 06-20-2012,  Shawn W. Walker

Embed = []; % initialize

if isempty(obj.Subdomain)
    return; % nothing to do...
end

Num_Subdomains = length(obj.Subdomain);
if (nargin==1)
    % then do ALL of the subdomains
    Domains_of_Integration = cell(Num_Subdomains,1);
    for si = 1:Num_Subdomains
        Domains_of_Integration{si} = obj.Subdomain(si).Name;
    end
end

for di = 1:length(Domains_of_Integration)
    DoI_Name = Domains_of_Integration{di};
    if strcmp(DoI_Name,obj.Name) % if the DoI *is* the global mesh
        DoI.Name = obj.Name;
        DoI.Dim  = obj.Top_Dim;
        DoI.Data = int32((1:1:obj.Num_Cell)');
        % the subdomain *must* also equal DoI==Global
        Sub = DoI;
        Embed = append_embedding_data(Embed, obj.Create_Embedding_Data(Sub,DoI));
        
    else
        DoI_Index = obj.Get_Subdomain_Index(DoI_Name);
        if DoI_Index > 0
            DoI = obj.Subdomain(DoI_Index);
        else
            disp(['This subdomain does not exist: ', DoI_Name]);
            error('Check your code!');
        end
        
        for si = 1:length(obj.Subdomain)
            Sub = obj.Subdomain(si);
            Embed = append_embedding_data(Embed, obj.Create_Embedding_Data(Sub,DoI));
        end
        
        % declare Subdomain that EQUALS Global mesh
        Sub.Name = obj.Name;
        Sub.Dim  = obj.Top_Dim;
        Sub.Data = int32((1:1:obj.Num_Cell)');
        Embed = append_embedding_data(Embed, obj.Create_Embedding_Data(Sub,DoI));
    end
end

end

function Embed_Array = append_embedding_data(Embed_Array, New_Embed)

Current_Index = length(Embed_Array);

if ~isempty(New_Embed)
    if (Current_Index==0)
        Embed_Array = New_Embed; % the first one!
    else
        Embed_Array(Current_Index+1) = New_Embed; % the next one
    end
end

end