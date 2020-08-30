function obj = Refine(obj,Marked_Edges)
%Refine
%
%   This replaces the current mesh with a refined mesh.  Note: the subdomain
%   data is correctly maintained through refinement.
%
%   obj = obj.Refine(Marked_Edges);
%
%   Marked_Edges = column vector of edge (cell) indices into obj.ConnectivityList.
%                  These edges will be refined (bisected).  This argument is
%                  optional, and if it is omitted, then *all* mesh edges will
%                  be refined.

% Copyright (c) 04-13-2011,  Shawn W. Walker

if nargin < 2
    Marked_Edges = (1:1:obj.Num_Cell)';
end

% perform one mesh refinement
[Vtx, Edges, Subdomain] = Refine_Edge_Mesh_1to2(obj.Points,obj.ConnectivityList,obj.Subdomain,Marked_Edges);

% you have to create a NEW object!
obj           = MeshInterval(Edges,Vtx,obj.Name);
% store the subdomains
obj.Subdomain = Subdomain;

end