function TF = Need_Subdomain_Embedding(obj,FS)
%Need_Subdomain_Embedding
%
%   This indicates if mesh subdomain embedding data is needed.

% Copyright (c) 06-25-2012,  Shawn W. Walker

TF = false;

for ind = 1:length(FS.Integration)
    GF = FS.Integration(ind).DoI_Geom;
    Embed = GF.Domain.Get_Sub_DoI_Embedding_Data;
    % if there are subdomains present, then we need the embedding data
    if ~and(Embed.Global_Equal_Subdomain,Embed.Subdomain_Equal_DoI)
        TF = true;
        break;
    end
end

end