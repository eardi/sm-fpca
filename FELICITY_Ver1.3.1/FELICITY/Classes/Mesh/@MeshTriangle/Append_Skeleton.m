function obj = Append_Skeleton(obj,Plus_Name,Minus_Name)
%Append_Skeleton
%
%   This appends the mesh "skeleton" data for a 2-D mesh, i.e. how *all*
%   the edges are embedded in the mesh.  Moreover, we separate the +/-
%   sides of each edge.  This is useful for computing "jump" terms.
%
%   obj = obj.Append_Skeleton(Plus_Name,Minus_Name);
%
%   Plus_Name, Minus_Name:
%          Strings representing the names of the sub-domains for the +/-
%          sides of the mesh skeleton.

% Copyright (c) 03-29-2018,  Shawn W. Walker

[Sk_Plus, Sk_Minus] = obj.Get_Skeleton();

obj = obj.Create_Subdomain(Plus_Name,1,Sk_Plus);
obj = obj.Create_Subdomain(Minus_Name,1,Sk_Minus);

end