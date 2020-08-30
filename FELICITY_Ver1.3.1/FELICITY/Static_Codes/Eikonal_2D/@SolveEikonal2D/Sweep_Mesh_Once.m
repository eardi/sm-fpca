function u_soln = Sweep_Mesh_Once(obj,Vtx_List,u_soln)
%Sweep_Mesh_Once
%
%   This routine goes through all the vertices in the mesh.

% Copyright (c) 07-01-2009,  Shawn W. Walker

for j=1:length(Vtx_List)
    u_soln(Vtx_List(j),1) = obj.Hopf_Lax_Update(Vtx_List(j),u_soln);
end

% END %