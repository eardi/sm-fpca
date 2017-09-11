function obj = Create_Transformer(obj)
%Create_Transformer
%
%   This creates a Geometric_Trans object for the integration domain, i.e. this
%   is an intrinsic map.  It is built from the Subdomain and Integration_Domain.
%   The Global domain is used for "computing" the intrinsic map from Global to
%   Subdomain.

% Copyright (c) 05-31-2012,  Shawn W. Walker

Subdomain_Subset_Of_is_NULL = or(isempty(obj.Domain.Subdomain.Subset_Of),strcmp(obj.Domain.Subdomain.Subset_Of,''));
Subdomain_equal_Global = isequal(obj.Domain.Subdomain,obj.Domain.Global);
if and(Subdomain_Subset_Of_is_NULL,~Subdomain_equal_Global)
    error('Subdomain must be a subset of something!');
end

if Subdomain_Subset_Of_is_NULL
    Embed_Name = obj.Domain.Global.Name; % Global domain *must* be the embedding domain
else
    Embed_Name = obj.Domain.Subdomain.Subset_Of;
end

G_NAME = [obj.Func_Name, '_', obj.Domain.Subdomain.Name,...
          '_embedded_in_', Embed_Name, '_restricted_to_', obj.Domain.Integration_Domain.Name];

% the geometric dimension is based on the ambient embedding that the
% Subdomain is embedded in
GeoDim = obj.Domain.Subdomain.GeoDim;
% the topological dimension is also based on the Subdomain!  We need to know how
% to compute the intrinsic map that defines the *Subdomain*.  The
% Integration_Domain is just where you EVALUATE it!!!!!
TopDim = obj.Domain.Subdomain.Top_Dim;

Lin_PHI_TF = ~obj.Domain.IS_CURVED; % if it ain't curved, then it is a linear map!
obj.GeoTrans = Geometric_Trans(G_NAME,GeoDim,TopDim,Lin_PHI_TF);

end