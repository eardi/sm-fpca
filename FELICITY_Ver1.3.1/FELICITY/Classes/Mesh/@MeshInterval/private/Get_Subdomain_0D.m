function Data = Get_Subdomain_0D(obj,Vtx_Indices,STRICT)
%Get_Subdomain_0D
%
%   This sets up a data structure for representing a sub-domain in an interval
%   mesh.  Dimension of the subdomain is 0-D (i.e. just individual vertices).
%
%   Data = obj.Get_Subdomain_0D(Vtx_Indices,STRICT);
%
%   Vtx_Indices = column vector (length M) of global vertex indices (that index
%                 into obj.Points).
%   STRICT = (boolean) true means to only accept the Subdomain if *ALL*
%            Vtx_Indices are found (otherwise it outputs an empty matrix).
%            false means to tolerate any unfound vertices, i.e. output the
%            subdomain data for the found vertices only.
%
%   Data = Mx2 matrix. First column are edge indices that refer to edges in the
%          global mesh that contain the Vtx_Indices; the rows of Data
%          corresponds to rows of Vtx_Indices.  Second column are local vertex
%          indices (either 1 or 2) within an edge that represent the global
%          vertices in Vtx_Indices.

% Copyright (c) 06-27-2012,  Shawn W. Walker

if (nargin < 3)
    STRICT = false; % default
end

% simple error checks
if (size(Vtx_Indices,2)~=1)
    error('The given subdomain must be a single column vector of vertex indices!');
end
if (min(Vtx_Indices) < 1)
    error('The given subdomain must have positive vertex indices!');
end
if (max(Vtx_Indices) > obj.Num_Vtx)
    error('The given subdomain has vertex indices that are greater than the number of vertices in the mesh!');
end

% need a cell attached to each given vertex
Edge_Ind = obj.vertexAttachments(Vtx_Indices);
Single_Edge_Indices = max(Edge_Ind,[],2);

% if any of the returned edge indices are 0,
Not_Found_Mask = (Single_Edge_Indices == 0);
if (max(Not_Found_Mask)==1)
    if STRICT
        Data = [];
        return;
    else
        % then only consider the entities that *were found*
        Vtx_Indices = Vtx_Indices(~Not_Found_Mask,:);
        Single_Edge_Indices = Single_Edge_Indices(~Not_Found_Mask,1);
        % output a message!
        disp(['Subdomain entities were not found in ', obj.Name, ' mesh...']);
        disp('          ... they will be ignored.');
    end
end

% find the local vertex index
Edge_Data = obj.ConnectivityList(Single_Edge_Indices,:);
Mask1 = (Edge_Data(:,1) == Vtx_Indices);
Mask2 = (Edge_Data(:,2) == Vtx_Indices);

% error check
TOTAL = sum(Mask1 + Mask2);
if (TOTAL ~= length(Vtx_Indices))
    error('Not all local vertices were found!');
end

Data = [Single_Edge_Indices, 0*Single_Edge_Indices];
Data(Mask1,2) = 1;
Data(Mask2,2) = 2;

end