function BC = Get_Cell_Centers(obj,SubName)
%Get_Cell_Centers
%
%   This routine outputs the barycenter of the cells in the mesh. An optional argument can
%   be given to output barycenters for a sub-domain.
%
%   BC = obj.Get_Cell_Centers();
%
%   BC = MxD matrix of coordinates, where M is the number of cells in the global mesh and
%        D is the geometric dimension.  Row i corresponds to the ith cell in the mesh
%        (i.e. the ith row of obj.Triangulation).
%
%   BC = obj.Get_Cell_Centers(SubName);
%
%   SubName = (string) name of a mesh subdomain.
%
%   BC = similar to before, except M is the number of cells in the *sub-domain*.
%        Row i corresponds to the ith cell in the sub-domain.

% Copyright (c) 09-16-2014,  Shawn W. Walker

if (nargin==1)
    SubName = [];
end

% compute barycenters of global mesh
if isempty(SubName)
    SI = (1:1:obj.Num_Cell)';
    TD = obj.Top_Dim;
    BB = (1/(TD+1)) * ones(obj.Num_Cell,TD+1);
    BC = obj.baryToCart(SI, BB);
else
    % compute barycenters of a sub-domain
    Sub_Index = obj.Get_Subdomain_Index(SubName);
    TD = obj.Subdomain(Sub_Index).Dim;
    Global_Sub = obj.Get_Global_Subdomain(SubName);
    
    BC = obj.X(Global_Sub(:,1),:); % init
    for ind = 2:TD+1
        BC = BC + obj.X(Global_Sub(:,ind),:);
    end
    BC = (1/(TD+1)) * BC;
end

end