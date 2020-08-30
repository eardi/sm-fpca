function Data = Get_Subdomain_1D(obj,Oriented_Edges,STRICT)
%Get_Subdomain_1D
%
%   This sets up a data structure for representing a sub-domain in an interval
%   mesh.  Dimension of the subdomain is 1-D (i.e. cells in the mesh).
%
%   Data = obj.Get_Subdomain_1D(Oriented_Edges,STRICT);
%
%   Oriented_Edges = Mx2 matrix of oriented edge data (indexes into obj.Points).
%   STRICT = (boolean) true means to only accept the Subdomain if *ALL*
%            Oriented_Edges are found (otherwise it outputs an empty matrix).
%            false means to tolerate any unfound edges, i.e. output the
%            subdomain data for the found edges only.
%
%   Data = Mx1 vector of edge indices that refer to edges in the
%          global mesh that correspond to the Oriented_Edges.
%
%   Data = obj.Get_Subdomain_1D(Edge_Indices);
%
%   Edge_Indices = Mx1 vector of edge indices that refer to edges in the
%                  global mesh.
%
%   Data = Edge_Indices.

% Copyright (c) 06-27-2012,  Shawn W. Walker

if (nargin < 3)
    STRICT = false; % default
end

if (size(Oriented_Edges,2)==2) % if we are given actual edges
    % find the global cell index
    [TF1, LOC1] = ismember(Oriented_Edges,obj.ConnectivityList,'rows');
    Data = LOC1(TF1);
    if (length(Data)~=size(Oriented_Edges,1))
        if STRICT
            Data = [];
            return;
        else
            % some edges were not found
            % output a message!
            disp(['Subdomain cells were not found in ', obj.Name, ' mesh...']);
            disp('          ... they will be ignored.');
        end
    end
elseif (size(Oriented_Edges,2)==1) % they must just be edge indices
    Data = Oriented_Edges;
else
    disp('ERROR: The given subdomain must either be an Mx2 matrix of vertex indices, where each row represents an oriented edge,');
    disp('ERROR:               or it must be an Mx1 vector of edge indices, where each row indexes an edge in the mesh!');
    error('Make sure you are passing the correct subdomain data and that the topological dimension is correct!');
end

% simple error checks
if (min(Data) < 1)
    error('The given subdomain must have positive edge indices!');
end
if (max(Data) > obj.Num_Cell)
    error('The given subdomain has edge indices that are greater than the number of edges in the mesh!');
end

end