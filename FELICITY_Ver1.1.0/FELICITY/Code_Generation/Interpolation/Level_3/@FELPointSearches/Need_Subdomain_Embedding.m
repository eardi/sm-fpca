function TF = Need_Subdomain_Embedding(obj)
%Need_Subdomain_Embedding
%
%   This indicates if mesh subdomain embedding data is needed.

% Copyright (c) 06-26-2014,  Shawn W. Walker

GeomFunc = obj.GeomFuncs.values;

% if there are any *sub-domains* that differ from the global domain, then
% we need sub-domain embedding info
TF = false; % init
for ind = 1:length(GeomFunc)
    GF = GeomFunc{ind};
    Embed = GF.Domain.Get_Sub_DoI_Embedding_Data;
    % if there are subdomains present, then we need the embedding data
    if ~and(Embed.Global_Equal_Subdomain,Embed.Subdomain_Equal_DoI)
        TF = true;
        break;
    end
end

end