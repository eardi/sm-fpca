function Data = Get_Subdomain_0D(obj,Vtx_Indices,STRICT)
%Get_Subdomain_0D
%
%   This sets up a data structure for representing a sub-domain in a triangle
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
%   Data = Mx2 matrix. First column are triangle indices that refer to triangles
%          in the global mesh that contain the Vtx_Indices; the rows of Data
%          corresponds to rows of Vtx_Indices.  Second column are local vertex
%          indices (either 1, 2, or 3) within a triangle that represent the
%          global vertices in Vtx_Indices.

% Copyright (c) 02-18-2013,  Shawn W. Walker

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
Tri_Ind = obj.vertexAttachments(Vtx_Indices);
TH = @mycellfunc;
Single_Tri_Indices = cellfun(TH, Tri_Ind(:,1));

% if any of the returned triangle indices are 0,
Not_Found_Mask = (Single_Tri_Indices == 0);
if (max(Not_Found_Mask)==1)
    if STRICT
        Data = [];
        return;
    else
        % then only consider the entities that *were found*
        Vtx_Indices = Vtx_Indices(~Not_Found_Mask,:);
        Single_Tri_Indices = Single_Tri_Indices(~Not_Found_Mask,1);
        % output a message!
        disp(['Subdomain entities were not found in ', obj.Name, ' mesh...']);
        disp('          ... they will be ignored.');
    end
end

% find the local vertex index
Tri_Data = obj.ConnectivityList(Single_Tri_Indices,:);
Mask1 = (Tri_Data(:,1) == Vtx_Indices);
Mask2 = (Tri_Data(:,2) == Vtx_Indices);
Mask3 = (Tri_Data(:,3) == Vtx_Indices);

% error check
TOTAL = sum(Mask1 + Mask2 + Mask3);
if (TOTAL ~= length(Vtx_Indices))
    error('Not all local vertices were found!');
end

Data = [Single_Tri_Indices, 0*Single_Tri_Indices];
Data(Mask1,2) = 1;
Data(Mask2,2) = 2;
Data(Mask3,2) = 3;

end

% this pick out the first triangle index
function c_out = mycellfunc(c_in)

if (~isempty(c_in))
    c_out = c_in(1,1);
else
    c_out = 0;
end

end