function Data = Get_Subdomain_1D(obj,Oriented_Edges,STRICT)
%Get_Subdomain_1D
%
%   This sets up a data structure for representing a sub-domain in a tetra
%   mesh.  Dimension of the subdomain is 1-D (i.e. oriented edges in the mesh).
%
%   Data = obj.Get_Subdomain_1D(Oriented_Edges,STRICT);
%
%   Oriented_Edges = Mx2 matrix of oriented edge data (indexes into obj.Points).
%   STRICT = (boolean) true means to only accept the Subdomain if *ALL*
%            Oriented_Edges are found (otherwise it outputs an empty matrix).
%            false means to tolerate any unfound edges, i.e. output the
%            subdomain data for the found edges only.
%
%   Data = Mx2 matrix. First column are tetra indices that refer to tetrahedra
%          in the global mesh that contain the Oriented_Edges; the rows of Data
%          corresponds to rows of Oriented_Edges.  Second column are local edge
%          indices (either +/- 1, ..., 6) within a tetrahedron that represent
%          the global edges in Oriented_Edges.

% Copyright (c) 06-27-2012,  Shawn W. Walker

if (nargin < 3)
    STRICT = false; % default
end

% simple error checks
if (size(Oriented_Edges,2)~=2)
    error('The given subdomain must be an Mx2 matrix of vertex indices, where each row represents an oriented edge!');
end

% need a cell attached to each given edge
Tet_Ind = obj.edgeAttachments(Oriented_Edges);
TH = @mycellfunc;
Single_Tet_Indices = cellfun(TH, Tet_Ind(:,1));

% if any of the returned tet indices are 0,
Not_Found_Mask = (Single_Tet_Indices == 0);
if (max(Not_Found_Mask)==1)
    if STRICT
        Data = [];
        return;
    else
        % then only consider the entities that *were found*
        Oriented_Edges = Oriented_Edges(~Not_Found_Mask,:);
        Single_Tet_Indices = Single_Tet_Indices(~Not_Found_Mask,1);
        % output a message!
        disp(['Subdomain entities were not found in ', obj.Name, ' mesh...']);
        disp('          ... they will be ignored.');
    end
end

% find the local edge index
Tet_Data = obj.ConnectivityList(Single_Tet_Indices,:);

% POSITIVE orientation: find the (local) edge that corresponds to the given edge
P_Mask1 = min(Tet_Data(:,[1 2]) == Oriented_Edges,[],2);
P_Mask2 = min(Tet_Data(:,[1 3]) == Oriented_Edges,[],2);
P_Mask3 = min(Tet_Data(:,[1 4]) == Oriented_Edges,[],2);
P_Mask4 = min(Tet_Data(:,[2 3]) == Oriented_Edges,[],2);
P_Mask5 = min(Tet_Data(:,[3 4]) == Oriented_Edges,[],2);
P_Mask6 = min(Tet_Data(:,[4 2]) == Oriented_Edges,[],2);

% NEGATIVE orientation: find the (local) edge that corresponds to the given edge
N_Mask1 = min(Tet_Data(:,[2 1]) == Oriented_Edges,[],2);
N_Mask2 = min(Tet_Data(:,[3 1]) == Oriented_Edges,[],2);
N_Mask3 = min(Tet_Data(:,[4 1]) == Oriented_Edges,[],2);
N_Mask4 = min(Tet_Data(:,[3 2]) == Oriented_Edges,[],2);
N_Mask5 = min(Tet_Data(:,[4 3]) == Oriented_Edges,[],2);
N_Mask6 = min(Tet_Data(:,[2 4]) == Oriented_Edges,[],2);

% error check
TOTAL = sum(P_Mask1 + P_Mask2 + P_Mask3 + P_Mask4 + P_Mask5 + P_Mask6 + ...
            N_Mask1 + N_Mask2 + N_Mask3 + N_Mask4 + N_Mask5 + N_Mask6);
if (TOTAL ~= size(Oriented_Edges,1))
    error('Not all local edges were found!');
end

Data = [Single_Tet_Indices, 0*Single_Tet_Indices];
Data(P_Mask1,2) = 1;
Data(P_Mask2,2) = 2;
Data(P_Mask3,2) = 3;
Data(P_Mask4,2) = 4;
Data(P_Mask5,2) = 5;
Data(P_Mask6,2) = 6;
%--------
Data(N_Mask1,2) = -1;
Data(N_Mask2,2) = -2;
Data(N_Mask3,2) = -3;
Data(N_Mask4,2) = -4;
Data(N_Mask5,2) = -5;
Data(N_Mask6,2) = -6;

end

% this pick out the first triangle index
function c_out = mycellfunc(c_in)

if (~isempty(c_in))
    c_out = c_in(1,1);
else
    c_out = 0;
end

end