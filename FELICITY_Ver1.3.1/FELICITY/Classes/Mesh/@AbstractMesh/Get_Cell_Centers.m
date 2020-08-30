function BC = Get_Cell_Centers(obj,ARG1,ARG2)
%Get_Cell_Centers
%
%   This routine outputs the barycenter of the cells in the mesh. An optional argument can
%   be given to output barycenters for a sub-domain.
%
%   BC = obj.Get_Cell_Centers();
%
%   BC = MxD matrix of coordinates, where M is the number of cells in the global mesh and
%        D is the geometric dimension.  Row i corresponds to the ith cell in the mesh
%        (i.e. the ith row of obj.ConnectivityList).
%
%   BC = obj.Get_Cell_Centers(SubName);
%
%   SubName = (string) name of a mesh subdomain.
%
%   BC = similar to before, except M is the number of cells in the *sub-domain*.
%        Row i corresponds to the ith cell in the sub-domain.
%
%   Alternate call procedure:
%
%   BC = obj.Get_Cell_Centers(Pts,SubName);
%
%   Similar to above, except it uses "Pts" instead of the mesh vertices
%   (obviously, Pts should be compatible with the mesh).  SubName is an
%   optional argument.

% Copyright (c) 09-16-2014,  Shawn W. Walker

if (nargin==1)
    SubName = [];
    Mesh_Points = obj.Points;
elseif (nargin==2)
    if ischar(ARG1)
        % just want sub-domain
        SubName = ARG1;
        Mesh_Points = obj.Points;
    else
        % alternate points
        SubName = [];
        Mesh_Points = ARG1;
    end
else
    % alternate points and sub-domain
    Mesh_Points = ARG1;
    SubName = ARG2;
end

if (obj.Num_Vtx ~= size(Mesh_Points,1))
    error('Number of points does not match present mesh structure.');
end
if (obj.Geo_Dim ~= size(Mesh_Points,2))
    error('Dimension of points does not match present mesh structure.');
end

% compute barycenters of global mesh
if isempty(SubName)
%     SI = (1:1:obj.Num_Cell)';
%     TD = obj.Top_Dim;
%     BB = (1/(TD+1)) * ones(obj.Num_Cell,TD+1);
%     BC = obj.barycentricToCartesian(SI, BB);
    
    % compute barycenters of global mesh
    TD = obj.Top_Dim();
    BC = Mesh_Points(obj.ConnectivityList(:,1),:); % init
    for ind = 2:TD+1
        BC = BC + Mesh_Points(obj.ConnectivityList(:,ind),:);
    end
    BC = (1/(TD+1)) * BC;
else
    % compute barycenters of a sub-domain
    Sub_Index = obj.Get_Subdomain_Index(SubName);
    TD = obj.Subdomain(Sub_Index).Dim;
    Global_Sub = obj.Get_Global_Subdomain(SubName);
    
    BC = Mesh_Points(Global_Sub(:,1),:); % init
    for ind = 2:TD+1
        BC = BC + Mesh_Points(Global_Sub(:,ind),:);
    end
    BC = (1/(TD+1)) * BC;
end

end