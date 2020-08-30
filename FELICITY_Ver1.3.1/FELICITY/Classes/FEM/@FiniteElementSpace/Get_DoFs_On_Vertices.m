function Global_Vtx_DoFs = Get_DoFs_On_Vertices(obj,Mesh)
%Get_DoFs_On_Vertices
%
%   This returns the DoF indices attached to the vertices of the mesh.
%
%   Global_Vtx_DoFs = Get_DoFs_On_Vertices(obj,Mesh);
%
%   Mesh = (FELICITY mesh) this is the mesh that the FE space is defined on.
%
%   Global_Vtx_DoFs = VxM matrix of DoF indices (positive integers), where
%                     V is the number of vertices in the *sub-domain* mesh
%                     on which the FE space is defined, and M is the
%                     number of DoFs attached to a single vertex (usually,
%                     M = 1, but you could have more exotic FE spaces).
%
%   Note: the DoFs indices here refer to the FIRST component of a tuple
%   valued FE space!

% Copyright (c) 02-12-2020,  Shawn W. Walker

% get a self-contained mesh for the sub-domain on which the FE space is
% defined
Subdomain_Name = obj.Mesh_Info.SubName;
SubMesh = Mesh.Output_Subdomain_Mesh(Subdomain_Name);

% get a cell that contains each vertex
Vtx2Cell_TEMP = SubMesh.vertexAttachments;
Vtx2Cell = cellfun(@(CC) CC(1), Vtx2Cell_TEMP);

% order the cells based on the vertex
Ordered_Cells = SubMesh.ConnectivityList(Vtx2Cell,:);
% get ordered list of vertex indices
VI = (1:1:SubMesh.Num_Vtx())';
% determine the local vertex indicex
[~, Vtx_Local_Index_in_Cell] = max(VI==Ordered_Cells,[],2);

% find which local DoFs are attached to each local vertex
Local_Vtx_DoFs = obj.RefElem.Get_Nodes_On_Topological_Entity(0);
% then map that to the global vertices
GlobalVtx2LocalDoFs = Local_Vtx_DoFs(Vtx_Local_Index_in_Cell,:);

% initialize
Global_Vtx_DoFs = zeros(SubMesh.Num_Vtx(),size(Local_Vtx_DoFs,2));

% order the DoFmap according to the vertices
V2D = obj.DoFmap(Vtx2Cell,:);

% convert to output format
for jj = 1:size(Global_Vtx_DoFs,2)
    IND = sub2ind(size(V2D),VI,GlobalVtx2LocalDoFs(:,jj));
    Global_Vtx_DoFs(:,jj) = V2D(IND);
end

end